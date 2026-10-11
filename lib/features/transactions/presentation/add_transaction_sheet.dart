import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:quy_dao/core/services/notification_service.dart';
import 'package:quy_dao/core/strings/app_strings.dart';
import 'package:quy_dao/core/theme/app_tokens.dart';
import 'package:quy_dao/core/utils/month_key.dart';
import 'package:quy_dao/core/widgets/category_avatar.dart';
import 'package:quy_dao/core/widgets/pill_button.dart';
import 'package:quy_dao/core/widgets/pill_chip.dart';
import 'package:quy_dao/data/models/category.dart';
import 'package:quy_dao/data/models/saving_goal.dart';
import 'package:quy_dao/data/models/transaction.dart';
import 'package:quy_dao/data/models/wallet.dart';
import 'package:quy_dao/data/providers/app_state_providers.dart';
import 'package:quy_dao/data/repositories/app_providers.dart';
import 'package:quy_dao/data/repositories/budget_repository.dart';
import 'package:quy_dao/data/repositories/goal_repository.dart';
import 'package:quy_dao/data/repositories/transaction_repository.dart';
import 'package:quy_dao/features/auth/presentation/auth_sheet.dart';
import 'package:quy_dao/features/savings/presentation/milestone_celebration_dialog.dart';

/// Modal thêm giao dịch mới (Chi, Thu, Gửi tiết kiệm, Chuyển ví).
class AddTransactionSheet extends ConsumerStatefulWidget {
  const AddTransactionSheet({
    super.key,
    this.initialType = 'expense',
    this.initialGoalId,
  });

  final String initialType;
  final String? initialGoalId;

  static Future<void> show(
    BuildContext context, {
    String initialType = 'expense',
    String? initialGoalId,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddTransactionSheet(
        initialType: initialType,
        initialGoalId: initialGoalId,
      ),
    );
  }

  @override
  ConsumerState<AddTransactionSheet> createState() =>
      _AddTransactionSheetState();
}

class _AddTransactionSheetState extends ConsumerState<AddTransactionSheet> {
  late String _selectedType;
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  Category? _selectedCategory;
  Wallet? _selectedWallet;
  Wallet? _selectedToWallet;
  SavingGoal? _selectedGoal;
  DateTime _selectedDate = DateTime.now();

  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialType;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  int _parseAmount() {
    final cleanStr = _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(cleanStr) ?? 0;
  }

  Future<void> _submit() async {
    final uid = ref.read(currentUidProvider);
    if (uid == null) {
      // Nhắc đăng nhập nếu chưa có session
      if (mounted) {
        Navigator.of(context).pop();
        await AuthSheet.show(context);
      }
      return;
    }

    final amount = _parseAmount();
    if (amount <= 0) {
      setState(() => _errorMessage = AppStrings.pleaseEnterAmount);
      return;
    }

    final wallets = ref.read(walletsProvider);
    final wallet =
        _selectedWallet ?? (wallets.isNotEmpty ? wallets.first : null);
    if (wallet == null) {
      setState(() => _errorMessage = 'Vui lòng chọn ví.');
      return;
    }

    final startDay = ref.read(monthStartDayProvider);
    final monthKey = monthKeyFor(_selectedDate, startDay);

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      final goals = ref.read(savingGoalsProvider);
      final goalId = _selectedType == 'saving'
          ? (_selectedGoal?.id ?? widget.initialGoalId)
          : null;
      final targetGoal = goalId != null
          ? goals.where((g) => g.id == goalId).firstOrNull
          : null;

      // Tính cột mốc tiết kiệm đạt được (nếu là giao dịch saving)
      final newlyReachedMilestones =
          (_selectedType == 'saving' && targetGoal != null)
          ? calculateNewMilestonesReached(goal: targetGoal, addedAmount: amount)
          : const <int>[];
      final topMilestone = newlyReachedMilestones.isNotEmpty
          ? newlyReachedMilestones.last
          : null;

      // Kiểm tra ngưỡng cảnh báo ngân sách 80% / 100% (nếu là giao dịch expense)
      int? budgetAlertPercent;
      String? alertCategoryName;
      if (_selectedType == 'expense' && _selectedCategory != null) {
        try {
          final catId = _selectedCategory!.id;
          alertCategoryName = _selectedCategory!.name;
          final budget = await ref
              .read(budgetRepositoryProvider)
              .getBudget(uid, monthKey: monthKey, categoryId: catId);
          if (budget != null && budget.plannedAmount > 0) {
            final summary = await ref
                .read(monthSummaryRepositoryProvider)
                .getMonthSummary(uid, monthKey);
            final oldSpent = summary?.byCategory[catId] ?? 0;
            final newSpent = oldSpent + amount;
            final oldPercent = (oldSpent * 100) ~/ budget.plannedAmount;
            final newPercent = (newSpent * 100) ~/ budget.plannedAmount;

            if (oldPercent < 80 && newPercent >= 80 && newPercent < 100) {
              budgetAlertPercent = 80;
            } else if (oldPercent < 100 && newPercent >= 100) {
              budgetAlertPercent = 100;
            }
          }
        } catch (_) {
          // Bỏ qua lỗi truy vấn ngân sách để không chặn lưu giao dịch
        }
      }

      final tx = Transaction(
        id: '', // Sẽ được tự sinh id Firestore doc
        type: _selectedType,
        amount: amount,
        categoryId: _selectedCategory?.id ?? '',
        walletId: wallet.id,
        toWalletId: _selectedType == 'transfer' ? _selectedToWallet?.id : null,
        goalId: goalId,
        note: _noteController.text.trim(),
        date: _selectedDate,
        monthKey: monthKey,
      );

      await ref.read(transactionRepositoryProvider).addTransaction(uid, tx);

      // Nếu đạt cột mốc mới, cập nhật vào goal document
      if (topMilestone != null && targetGoal != null) {
        final isCompleted =
            (targetGoal.savedAmount + amount) >= targetGoal.targetAmount;
        await ref
            .read(goalRepositoryProvider)
            .updateGoalStatus(
              uid,
              targetGoal.id,
              status: isCompleted ? 'completed' : targetGoal.status,
              milestoneReached: topMilestone,
              completedAt: isCompleted ? DateTime.now() : null,
            );
      }

      // Kích hoạt cảnh báo ngân sách thông minh (nếu có)
      if (budgetAlertPercent != null && alertCategoryName != null) {
        await ref
            .read(notificationServiceProvider)
            .showBudgetAlert(
              categoryName: alertCategoryName,
              percent: budgetAlertPercent,
            );
      }

      if (!mounted) return;

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.transactionSaved),
          duration: Duration(seconds: 2),
        ),
      );

      // Hiển thị dialog chúc mừng cột mốc nếu có
      if (topMilestone != null && targetGoal != null) {
        await MilestoneCelebrationDialog.show(
          context,
          goal: targetGoal,
          milestone: topMilestone,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = e.toString());
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);
    final wallets = ref.watch(walletsProvider);
    final goals = ref.watch(savingGoalsProvider);

    // Lọc danh mục theo type
    final filteredCategories = categories.where((c) {
      if (_selectedType == 'expense') return c.type == 'expense';
      if (_selectedType == 'income') return c.type == 'income';
      return true;
    }).toList();

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      decoration: const BoxDecoration(
        color: AppTokens.canvasCream,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTokens.radiusStadium),
        ),
      ),
      padding: EdgeInsets.only(
        top: AppTokens.space24,
        left: AppTokens.space24,
        right: AppTokens.space24,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppTokens.space24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Handle bar
            Center(
              child: Container(
                width: 36.0,
                height: 4.0,
                margin: const EdgeInsets.only(bottom: AppTokens.space16),
                decoration: BoxDecoration(
                  color: AppTokens.dustTaupe,
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
            ),

            // Tiêu đề
            const Text(
              AppStrings.addTransaction,
              style: TextStyle(
                fontFamily: AppTokens.fontFamilyPrimary,
                fontSize: 20.0,
                fontWeight: AppTokens.weightBold,
                color: AppTokens.inkBlack,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: AppTokens.space16),

            // Loại giao dịch
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  PillChip(
                    label: AppStrings.expense,
                    isSelected: _selectedType == 'expense',
                    onTap: () => setState(() => _selectedType = 'expense'),
                  ),
                  const SizedBox(width: AppTokens.space8),
                  PillChip(
                    label: AppStrings.income,
                    isSelected: _selectedType == 'income',
                    onTap: () => setState(() => _selectedType = 'income'),
                  ),
                  const SizedBox(width: AppTokens.space8),
                  PillChip(
                    label: AppStrings.saving,
                    isSelected: _selectedType == 'saving',
                    onTap: () => setState(() => _selectedType = 'saving'),
                  ),
                  const SizedBox(width: AppTokens.space8),
                  PillChip(
                    label: AppStrings.transfer,
                    isSelected: _selectedType == 'transfer',
                    onTap: () => setState(() => _selectedType = 'transfer'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTokens.space20),

            // Nhập số tiền
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTokens.space16,
                vertical: AppTokens.space12,
              ),
              decoration: BoxDecoration(
                color: AppTokens.white,
                borderRadius: BorderRadius.circular(AppTokens.radiusButton),
                border: Border.all(color: AppTokens.dustTaupe, width: 1.0),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      autofocus: true,
                      style: const TextStyle(
                        fontFamily: AppTokens.fontFamilyPrimary,
                        fontSize: 28.0,
                        fontWeight: AppTokens.weightBold,
                        color: AppTokens.inkBlack,
                        letterSpacing: -0.5,
                      ),
                      decoration: const InputDecoration(
                        hintText: '0',
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: (val) {
                        if (val.isEmpty) return;
                        final num = int.tryParse(val) ?? 0;
                        final formatted = NumberFormat(
                          '#,###',
                          'vi_VN',
                        ).format(num);
                        if (formatted != val) {
                          _amountController.value = TextEditingValue(
                            text: formatted,
                            selection: TextSelection.collapsed(
                              offset: formatted.length,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const Text(
                    'đ',
                    style: TextStyle(
                      fontFamily: AppTokens.fontFamilyPrimary,
                      fontSize: 24.0,
                      fontWeight: AppTokens.weightBold,
                      color: AppTokens.slateGray,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTokens.space16),

            // Chọn danh mục (nếu là expense hoặc income)
            if (_selectedType == 'expense' ||
                _selectedType == 'income') ...<Widget>[
              const Text(
                AppStrings.category,
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: AppTokens.weightMedium,
                  color: AppTokens.slateGray,
                ),
              ),
              const SizedBox(height: AppTokens.space8),
              SizedBox(
                height: 72.0,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: filteredCategories.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: AppTokens.space12),
                  itemBuilder: (context, index) {
                    final cat = filteredCategories[index];
                    final isSelected =
                        (_selectedCategory?.id == cat.id) ||
                        (_selectedCategory == null && index == 0);
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategory = cat),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? AppTokens.orbitOrange
                                    : Colors.transparent,
                                width: 2.0,
                              ),
                            ),
                            child: CategoryAvatar(
                              iconName: cat.icon,
                              size: 42.0,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            cat.name,
                            style: TextStyle(
                              fontSize: 11.0,
                              fontWeight: isSelected
                                  ? AppTokens.weightBold
                                  : AppTokens.weightRegular,
                              color: isSelected
                                  ? AppTokens.inkBlack
                                  : AppTokens.slateGray,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppTokens.space16),
            ],

            // Chọn mục tiêu nếu là 'saving'
            if (_selectedType == 'saving') ...<Widget>[
              const Text(
                AppStrings.selectGoal,
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: AppTokens.weightMedium,
                  color: AppTokens.slateGray,
                ),
              ),
              const SizedBox(height: AppTokens.space8),
              if (goals.isEmpty)
                const Text(
                  'Chưa có mục tiêu. Hãy tạo mục tiêu ở tab Tiết kiệm.',
                  style: TextStyle(color: AppTokens.slateGray, fontSize: 13.0),
                )
              else
                DropdownButtonFormField<SavingGoal>(
                  initialValue: _selectedGoal ?? goals.first,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppTokens.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppTokens.space16,
                      vertical: AppTokens.space12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppTokens.radiusButton,
                      ),
                      borderSide: const BorderSide(color: AppTokens.dustTaupe),
                    ),
                  ),
                  items: goals
                      .map(
                        (g) => DropdownMenuItem(
                          value: g,
                          child: Text('${g.icon} ${g.name}'),
                        ),
                      )
                      .toList(),
                  onChanged: (val) => setState(() => _selectedGoal = val),
                ),
              const SizedBox(height: AppTokens.space16),
            ],

            // Chọn ví nguồn
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        AppStrings.wallet,
                        style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: AppTokens.weightMedium,
                          color: AppTokens.slateGray,
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      DropdownButtonFormField<Wallet>(
                        initialValue:
                            _selectedWallet ??
                            (wallets.isNotEmpty ? wallets.first : null),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppTokens.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppTokens.space12,
                            vertical: 10.0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppTokens.radiusButton,
                            ),
                            borderSide: const BorderSide(
                              color: AppTokens.dustTaupe,
                            ),
                          ),
                        ),
                        items: wallets
                            .map(
                              (w) => DropdownMenuItem(
                                value: w,
                                child: Text(
                                  '${w.type == 'cash' ? '💵' : (w.type == 'bank' ? '🏦' : '📱')} ${w.name}',
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (val) =>
                            setState(() => _selectedWallet = val),
                      ),
                    ],
                  ),
                ),
                if (_selectedType == 'transfer') ...<Widget>[
                  const SizedBox(width: AppTokens.space12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          AppStrings.destinationWallet,
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: AppTokens.weightMedium,
                            color: AppTokens.slateGray,
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        DropdownButtonFormField<Wallet>(
                          initialValue:
                              _selectedToWallet ??
                              (wallets.length > 1 ? wallets[1] : null),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppTokens.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppTokens.space12,
                              vertical: 10.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppTokens.radiusButton,
                              ),
                              borderSide: const BorderSide(
                                color: AppTokens.dustTaupe,
                              ),
                            ),
                          ),
                          items: wallets
                              .map(
                                (w) => DropdownMenuItem(
                                  value: w,
                                  child: Text(
                                    '${w.type == 'cash' ? '💵' : (w.type == 'bank' ? '🏦' : '📱')} ${w.name}',
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (val) =>
                              setState(() => _selectedToWallet = val),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: AppTokens.space16),

            // Ghi chú
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                hintText: AppStrings.note,
                filled: true,
                fillColor: AppTokens.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppTokens.space16,
                  vertical: 12.0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTokens.radiusButton),
                  borderSide: const BorderSide(color: AppTokens.dustTaupe),
                ),
              ),
            ),
            // Ngày giao dịch
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (picked != null) {
                  setState(() => _selectedDate = picked);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTokens.space16,
                  vertical: 12.0,
                ),
                decoration: BoxDecoration(
                  color: AppTokens.white,
                  borderRadius: BorderRadius.circular(AppTokens.radiusButton),
                  border: Border.all(color: AppTokens.dustTaupe, width: 1.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}',
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: AppTokens.weightMedium,
                        color: AppTokens.inkBlack,
                      ),
                    ),
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 18.0,
                      color: AppTokens.slateGray,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppTokens.space16),

            if (_errorMessage != null) ...<Widget>[
              Text(
                _errorMessage!,
                style: const TextStyle(
                  color: AppTokens.signalOrange,
                  fontSize: 13.0,
                ),
              ),
              const SizedBox(height: AppTokens.space12),
            ],

            // Nút Lưu
            PillButton(
              label: AppStrings.save,
              onPressed: _isSaving ? null : _submit,
              variant: PillButtonVariant.primary,
              fullWidth: true,
            ),
          ],
        ),
      ),
    );
  }
}
