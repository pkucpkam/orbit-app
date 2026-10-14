import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quy_dao/core/strings/app_strings.dart';
import 'package:quy_dao/core/theme/app_tokens.dart';
import 'package:quy_dao/core/widgets/pill_button.dart';
import 'package:quy_dao/data/models/wallet.dart';
import 'package:quy_dao/data/repositories/app_providers.dart';
import 'package:quy_dao/data/repositories/auth_repository.dart';
import 'package:quy_dao/data/repositories/user_repository.dart';

/// Modal quản lý xác thực người dùng (Google, Email, Khách, Đăng xuất).
class AuthSheet extends ConsumerStatefulWidget {
  const AuthSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AuthSheet(),
    );
  }

  @override
  ConsumerState<AuthSheet> createState() => _AuthSheetState();
}

class _AuthSheetState extends ConsumerState<AuthSheet> {
  bool _isLoading = false;
  bool _showEmailForm = false;
  bool _isSignUp = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handlePostSignIn(UserCredential cred) async {
    final user = cred.user;
    if (user == null) return;

    final userRepo = ref.read(userRepositoryProvider);
    final isInitialized = await userRepo.isUserInitialized(user.uid);
    if (!isInitialized) {
      await userRepo.initializeNewUser(
        firebaseUser: user,
        firstWallet: const Wallet(
          id: '',
          name: 'Tiền mặt',
          type: 'cash',
          balance: 0,
        ),
        monthStartDay: 1,
      );
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final cred = await ref.read(authRepositoryProvider).signInWithGoogle();
      await _handlePostSignIn(cred);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = e.toString());
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInAnonymously() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final cred = await ref.read(authRepositoryProvider).signInAnonymously();
      await _handlePostSignIn(cred);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = e.toString());
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _submitEmailAuth() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final authRepo = ref.read(authRepositoryProvider);
      final cred = _isSignUp
          ? await authRepo.createWithEmail(email: email, password: password)
          : await authRepo.signInWithEmail(email: email, password: password);
      await _handlePostSignIn(cred);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = e.toString());
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signOut() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(authRepositoryProvider).signOut();
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(firebaseAuthProvider)?.currentUser;

    return Container(
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
        bottom: MediaQuery.of(context).viewInsets.bottom + AppTokens.space32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Thanh kéo
          Center(
            child: Container(
              width: 36.0,
              height: 4.0,
              margin: const EdgeInsets.only(bottom: AppTokens.space20),
              decoration: BoxDecoration(
                color: AppTokens.dustTaupe,
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),

          if (currentUser != null) ...<Widget>[
            // Đã đăng nhập: Thông tin hồ sơ & Đăng xuất
            Row(
              children: <Widget>[
                Container(
                  width: 52.0,
                  height: 52.0,
                  decoration: BoxDecoration(
                    color: AppTokens.orbitOrange,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTokens.dustTaupe, width: 1.5),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    (currentUser.displayName ?? currentUser.email ?? 'U')[0]
                        .toUpperCase(),
                    style: const TextStyle(
                      fontFamily: AppTokens.fontFamilyPrimary,
                      fontWeight: AppTokens.weightBold,
                      fontSize: 22.0,
                      color: AppTokens.white,
                    ),
                  ),
                ),
                const SizedBox(width: AppTokens.space16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        currentUser.displayName?.isNotEmpty == true
                            ? currentUser.displayName!
                            : (currentUser.isAnonymous
                                  ? 'Tài khoản Khách'
                                  : 'Người dùng'),
                        style: const TextStyle(
                          fontFamily: AppTokens.fontFamilyPrimary,
                          fontSize: 18.0,
                          fontWeight: AppTokens.weightMedium,
                          color: AppTokens.inkBlack,
                        ),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        currentUser.email ??
                            'UID: ${currentUser.uid.substring(0, 8)}...',
                        style: const TextStyle(
                          fontSize: 13.0,
                          color: AppTokens.slateGray,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTokens.space24),
            PillButton(
              label: AppStrings.signOut,
              onPressed: _isLoading ? null : _signOut,
              variant: PillButtonVariant.secondary,
              fullWidth: true,
            ),
          ] else ...<Widget>[
            // Chưa đăng nhập: Form chọn đăng nhập
            const Text(
              AppStrings.loginTitle,
              style: TextStyle(
                fontFamily: AppTokens.fontFamilyPrimary,
                fontSize: 20.0,
                fontWeight: AppTokens.weightBold,
                color: AppTokens.inkBlack,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 4.0),
            const Text(
              AppStrings.loginSubtitle,
              style: TextStyle(fontSize: 13.5, color: AppTokens.slateGray),
            ),
            const SizedBox(height: AppTokens.space20),

            if (_errorMessage != null) ...<Widget>[
              Container(
                padding: const EdgeInsets.all(AppTokens.space12),
                margin: const EdgeInsets.only(bottom: AppTokens.space16),
                decoration: BoxDecoration(
                  color: AppTokens.signalOrange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTokens.radiusButton),
                ),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(
                    fontSize: 13.0,
                    color: AppTokens.signalOrange,
                  ),
                ),
              ),
            ],

            if (!_showEmailForm) ...<Widget>[
              // Đăng nhập Google
              PillButton(
                label: AppStrings.signInWithGoogle,
                onPressed: _isLoading ? null : _signInWithGoogle,
                variant: PillButtonVariant.primary,
                icon: const Icon(Icons.g_mobiledata, size: 26.0),
                fullWidth: true,
              ),
              const SizedBox(height: AppTokens.space12),

              // Đăng nhập Email
              PillButton(
                label: AppStrings.signInWithEmail,
                onPressed: () => setState(() => _showEmailForm = true),
                variant: PillButtonVariant.secondary,
                icon: const Icon(Icons.email_outlined, size: 18.0),
                fullWidth: true,
              ),
              const SizedBox(height: AppTokens.space12),

              // Đăng nhập Khách
              PillButton(
                label: AppStrings.continueAsGuest,
                onPressed: _isLoading ? null : _signInAnonymously,
                variant: PillButtonVariant.text,
                fullWidth: true,
              ),
            ] else ...<Widget>[
              // Form nhập Email & Mật khẩu
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: AppStrings.email,
                  filled: true,
                  fillColor: AppTokens.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTokens.radiusInput),
                  ),
                ),
              ),
              const SizedBox(height: AppTokens.space12),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: AppStrings.password,
                  filled: true,
                  fillColor: AppTokens.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTokens.radiusInput),
                  ),
                ),
              ),
              const SizedBox(height: AppTokens.space16),
              PillButton(
                label: _isSignUp
                    ? AppStrings.createAccount
                    : AppStrings.signInWithEmail,
                onPressed: _isLoading ? null : _submitEmailAuth,
                variant: PillButtonVariant.primary,
                fullWidth: true,
              ),
              const SizedBox(height: AppTokens.space8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () => setState(() => _isSignUp = !_isSignUp),
                    child: Text(
                      _isSignUp
                          ? AppStrings.signInWithEmail
                          : AppStrings.createAccount,
                      style: const TextStyle(color: AppTokens.inkBlack),
                    ),
                  ),
                  TextButton(
                    onPressed: () => setState(() => _showEmailForm = false),
                    child: const Text(
                      AppStrings.cancel,
                      style: TextStyle(color: AppTokens.slateGray),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ],
      ),
    );
  }
}
