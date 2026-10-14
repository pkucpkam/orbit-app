import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:quy_dao/core/strings/app_strings.dart';
import 'package:quy_dao/core/theme/app_tokens.dart';
import 'package:quy_dao/core/widgets/pill_button.dart';
import 'package:quy_dao/data/models/saving_goal.dart';
import 'package:quy_dao/data/repositories/app_providers.dart';
import 'package:quy_dao/data/repositories/goal_repository.dart';
import 'package:quy_dao/features/auth/presentation/auth_sheet.dart';

/// Modal tạo mục tiêu tiết kiệm mới (SAV-1).
class AddGoalSheet extends ConsumerStatefulWidget {
  const AddGoalSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddGoalSheet(),
    );
  }

  @override
  ConsumerState<AddGoalSheet> createState() => _AddGoalSheetState();
}

class _AddGoalSheetState extends ConsumerState<AddGoalSheet> {
  final _nameController = TextEditingController();
  final _targetController = TextEditingController();

  DateTime _selectedDeadline = DateTime.now().add(
    const Duration(days: 90),
  ); // Mặc định 3 tháng
  String _selectedIcon = '🎯';

  static const List<String> _suggestedIcons = [
    '🎯',
    '🏖️',
    '💻',
    '🏍️',
    '🏠',
    '✈️',
    '💍',
    '🚗',
    '📚',
    '🎒',
    '📱',
    '🎁',
  ];

  bool _isSaving = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  int _parseTargetAmount() {
    final cleanStr = _targetController.text.replaceAll(RegExp(r'[^0-9]'), '');
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

    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _errorMessage = 'Vui lòng nhập tên mục tiêu.');
      return;
    }

    final target = _parseTargetAmount();
    if (target <= 0) {
      setState(() => _errorMessage = AppStrings.pleaseEnterAmount);
      return;
    }

    if (_selectedDeadline.isBefore(DateTime.now())) {
      setState(() => _errorMessage = 'Thời hạn phải sau ngày hôm nay.');
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      final goal = SavingGoal(
        id: '', // Sẽ sinh ID trong repository
        name: name,
        targetAmount: target,
        savedAmount: 0,
        startDate: DateTime.now(),
        targetDate: _selectedDeadline,
        icon: _selectedIcon,
        colorToken: 'signalOrange',
        status: 'active',
        milestonesReached: const [],
      );

      await ref.read(goalRepositoryProvider).createGoal(uid, goal);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã tạo mục tiêu tiết kiệm!'),
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
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
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
              AppStrings.newGoal,
              style: TextStyle(
                fontFamily: AppTokens.fontFamilyPrimary,
                fontSize: 20.0,
                fontWeight: AppTokens.weightBold,
                color: AppTokens.inkBlack,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: AppTokens.space16),

            // Chọn Icon
            SizedBox(
              height: 48.0,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _suggestedIcons.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(width: AppTokens.space8),
                itemBuilder: (context, index) {
                  final icon = _suggestedIcons[index];
                  final isSelected = icon == _selectedIcon;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedIcon = icon),
                    child: Container(
                      width: 44.0,
                      height: 44.0,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTokens.white
                            : AppTokens.dustTaupe.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? AppTokens.orbitOrange
                              : Colors.transparent,
                          width: 2.0,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(icon, style: const TextStyle(fontSize: 20.0)),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppTokens.space20),

            // Tên mục tiêu
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: AppStrings.goalName,
                filled: true,
                fillColor: AppTokens.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppTokens.space16,
                  vertical: 14.0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTokens.radiusInput),
                  borderSide: const BorderSide(color: AppTokens.dustTaupe),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTokens.radiusInput),
                  borderSide: const BorderSide(color: AppTokens.dustTaupe),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTokens.radiusInput),
                  borderSide: const BorderSide(
                    color: AppTokens.inkBlack,
                    width: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppTokens.space16),

            // Số tiền mục tiêu
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
                      controller: _targetController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                          _targetController.value = TextEditingValue(
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

            // Hạn mục tiêu (Deadline)
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDeadline,
                  firstDate: DateTime.now().add(const Duration(days: 1)),
                  lastDate: DateTime.now().add(const Duration(days: 3650)),
                );
                if (picked != null) {
                  setState(() => _selectedDeadline = picked);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTokens.space16,
                  vertical: 14.0,
                ),
                decoration: BoxDecoration(
                  color: AppTokens.white,
                  borderRadius: BorderRadius.circular(AppTokens.radiusInput),
                  border: Border.all(color: AppTokens.dustTaupe, width: 1.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          AppStrings.deadline,
                          style: TextStyle(
                            fontSize: 12.0,
                            color: AppTokens.slateGray,
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          dateFormat.format(_selectedDeadline),
                          style: const TextStyle(
                            fontSize: 15.0,
                            fontWeight: AppTokens.weightMedium,
                            color: AppTokens.inkBlack,
                          ),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 20.0,
                      color: AppTokens.slateGray,
                    ),
                  ],
                ),
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
