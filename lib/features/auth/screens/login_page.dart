import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_factory_qc/core/theme/app_colors.dart';
import 'package:smart_factory_qc/core/theme/app_theme.dart';
import 'package:smart_factory_qc/core/widgets/section_label.dart';

final _loginLoadingProvider = StateProvider.autoDispose<bool>((ref) => false);

/// Sign-in only. There is intentionally NO sign-up / register path:
/// accounts are provisioned server-side by administrators.
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key, required this.onSignedIn});

  final VoidCallback onSignedIn;

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    ref.read(_loginLoadingProvider.notifier).state = true;

    // TODO: replace with AuthRepository.signIn(id, password) against the API tier.
    await Future<void>.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;
    ref.read(_loginLoadingProvider.notifier).state = false;
    widget.onSignedIn();
  }

  String? _required(String? v, String message) =>
      (v == null || v.trim().isEmpty) ? message : null;

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(_loginLoadingProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.s48),
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.navy,
                    borderRadius: BorderRadius.circular(AppSpacing.radius),
                  ),
                  child: const Icon(
                    Icons.precision_manufacturing_outlined,
                    color: AppColors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(height: AppSpacing.s24),
                const Text('Smart Factory', style: AppTextStyles.title),
                const SizedBox(height: AppSpacing.s4),
                const Text('Quality & Inventory', style: AppTextStyles.caption),
                const SizedBox(height: 40),
                const SectionLabel('Employee ID or email'),
                const SizedBox(height: AppSpacing.s8),
                TextFormField(
                  controller: _idController,
                  enabled: !loading,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.username],
                  autocorrect: false,
                  style: AppTextStyles.body,
                  decoration: const InputDecoration(hintText: 'e.g. E-10482'),
                  validator: (v) => _required(v, 'Enter your employee ID or email'),
                ),
                const SizedBox(height: 20),
                const SectionLabel('Password'),
                const SizedBox(height: AppSpacing.s8),
                TextFormField(
                  controller: _passwordController,
                  enabled: !loading,
                  obscureText: _obscure,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.password],
                  onFieldSubmitted: (_) => _submit(),
                  style: AppTextStyles.body,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    suffixIcon: IconButton(
                      tooltip: _obscure ? 'Show password' : 'Hide password',
                      icon: Icon(
                        _obscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.slate500,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  validator: (v) => _required(v, 'Enter your password'),
                ),
                const SizedBox(height: AppSpacing.s24),
                SizedBox(
                  width: double.infinity,
                  height: AppSpacing.primaryButtonHeight,
                  child: FilledButton(
                    onPressed: loading ? null : _submit,
                    child: loading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: AppColors.white,
                            ),
                          )
                        : const Text('Sign in'),
                  ),
                ),
                const SizedBox(height: AppSpacing.s24),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.s16),
                  decoration: BoxDecoration(
                    color: AppColors.slate50,
                    borderRadius: BorderRadius.circular(AppSpacing.radius),
                    border: Border.all(color: AppColors.slate200),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, size: 20, color: AppColors.slate500),
                      SizedBox(width: AppSpacing.s12),
                      Expanded(
                        child: Text(
                          'Accounts are created by your site administrator. '
                          'Contact IT support if you need access or a password reset.',
                          style: AppTextStyles.caption,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.s24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
