import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:quy_dao/core/strings/app_strings.dart';
import 'package:quy_dao/core/theme/app_tokens.dart';
import 'package:quy_dao/core/widgets/category_avatar.dart';
import 'package:quy_dao/core/widgets/pill_button.dart';
import 'package:quy_dao/core/widgets/pill_chip.dart';
import 'package:quy_dao/data/models/budget.dart';
import 'package:quy_dao/data/models/category.dart';
import 'package:quy_dao/data/providers/app_state_providers.dart';
import 'package:quy_dao/data/repositories/app_providers.dart';
import 'package:quy_dao/data/repositories/budget_repository.dart';
import 'package:quy_dao/features/auth/presentation/auth_sheet.dart';

/// Modal đặt ngân sách (Dự tính chi / Dự tính thu) cho một danh mục.
class SetBudgetSheet extends ConsumerStatefulWidget {
  const SetBudgetSheet({
    super.key,
    this.initialCategoryId,
    this.initialType = 'expense',
    this.initialPlannedAmount = 0,
  });

  final String? initialCategoryId;
  final String initialType;
  final int initialPlannedAmount;

  static Future<void> show(
    BuildContext context, {
    String? initialCategoryId,
    String initialType = 'expense',
    int initialPlannedAmount = 0,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SetBudgetSheet(
        initialCategoryId: initialCategoryId,
        initialType: initialType,
        initialPlannedAmount: initialPlannedAmount,
      ),
    );
  }

  @override
  ConsumerState<SetBudgetSheet> createState() => _SetBudgetSheetState();
}

class _SetBudgetSheetState extends ConsumerState<SetBudgetSheet> {
  late String _selectedType;
  final _amountController = TextEditingController();
  Category? _selectedCategory;

  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialType;
    if (widget.initialPlannedAmount > 0) {
      _amountController.text = NumberFormat(
        '#,###',
        'vi_VN',
      ).format(widget.initialPlannedAmount);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  int _parseAmount() {
    final cleanStr = _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(cleanStr) ?? 0;
  }

  Future<void> _submit() async {
    final uid = ref.read(currentUidProvider);
    if (uid == null) {
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

    final categories = ref.read(categoriesProvider);
    final category =
        _selectedCategory ?? (categories.isNotEmpty ? categories.first : null);
    if (category == null) {
      setState(() => _errorMessage = 'Vui lòng chọn danh mục.');
      return;
    }

    final monthKey = ref.read(currentMonthKeyProvider);

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      final budget = Budget(
        monthKey: monthKey,
        categoryId: category.id,
        type: _selectedType,
        plannedAmount: amount,
      );

      await ref.read(budgetRepositoryProvider).saveBudget(uid, budget);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã cập nhật ngân sách'),
            duration: Duration(seconds: 2),
          ),
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
    final filteredCategories = categories
        .where((c) => c.type == _selectedType)
        .toList();

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: AppTokens.canvasCream,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTokens.radiusSheet),
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
            const Text(
              AppStrings.setBudget,
              style: TextStyle(
                fontFamily: AppTokens.fontFamilyPrimary,
                fontSize: 20.0,
                fontWeight: AppTokens.weightBold,
                color: AppTokens.inkBlack,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: AppTokens.space16),

            // Loại ngân sách
            Row(
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
              ],
            ),
            const SizedBox(height: AppTokens.space20),

            // Nhập số tiền dự tính
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTokens.space16,
                vertical: AppTokens.space12,
              ),
              decoration: BoxDecoration(
                color: AppTokens.white,
                borderRadius: BorderRadius.circular(AppTokens.radiusInput),
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
                        fontSize: 26.0,
                        fontWeight: AppTokens.weightBold,
                        color: AppTokens.inkBlack,
                      ),
                      decoration: const InputDecoration(
                        hintText: '0',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        filled: false,
                        fillColor: Colors.transparent,
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
                      fontSize: 22.0,
                      fontWeight: AppTokens.weightBold,
                      color: AppTokens.slateGray,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTokens.space16),

            // Chọn danh mục
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
              height: 76.0,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: filteredCategories.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(width: AppTokens.space12),
                itemBuilder: (context, index) {
                  final cat = filteredCategories[index];
                  final isSelected =
                      (_selectedCategory?.id == cat.id) ||
                      (_selectedCategory == null &&
                          (widget.initialCategoryId == cat.id || index == 0));
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
                          child: CategoryAvatar(iconName: cat.icon, size: 42.0),
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
            const SizedBox(height: AppTokens.space24),

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
