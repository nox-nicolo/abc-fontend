import 'package:africa_beuty/core/widgets/loader.dart';
import 'package:africa_beuty/feature/auth/providers/auth_repository_provider.dart';
import 'package:africa_beuty/feature/auth/view/widget/auth_button.dart';
import 'package:africa_beuty/feature/auth/view/widget/custome_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final emailController = TextEditingController();
  final resetLinkController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool linkSent = false;
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    resetLinkController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _requestResetLink() async {
    if (emailController.text.trim().isEmpty) {
      _showMessage('Email is missing');
      return;
    }

    setState(() => isLoading = true);
    final res = await ref
        .read(authRemoteRepositoryProvider)
        .forgotPassword(email: emailController.text);
    if (!mounted) return;
    setState(() => isLoading = false);

    res.match((failure) => _showMessage(failure.message), (message) {
      setState(() => linkSent = true);
      _showMessage(message);
    });
  }

  Future<void> _resetPassword() async {
    if (!formKey.currentState!.validate()) return;

    if (passwordController.text != confirmPasswordController.text) {
      _showMessage('Passwords do not match');
      return;
    }

    setState(() => isLoading = true);
    final res = await ref
        .read(authRemoteRepositoryProvider)
        .resetPassword(
          token: _tokenFromInput(resetLinkController.text),
          newPassword: passwordController.text,
        );
    if (!mounted) return;
    setState(() => isLoading = false);

    res.match((failure) => _showMessage(failure.message), (message) {
      _showMessage(message);
      Navigator.pushNamedAndRemoveUntil(context, '/signin', (_) => false);
    });
  }

  String _tokenFromInput(String value) {
    final trimmed = value.trim();
    final uri = Uri.tryParse(trimmed);
    return uri?.queryParameters['token'] ?? trimmed;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? const Loader()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: size.height * .08),
                      Text(
                        'Reset Password.',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 40),
                      CustomeField(
                        controller: emailController,
                        hintText: 'Email',
                        leadingIcon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        action: TextInputAction.next,
                      ),
                      if (linkSent) ...[
                        const SizedBox(height: 15),
                        CustomeField(
                          controller: resetLinkController,
                          hintText: 'Reset Link or Token',
                          leadingIcon: Icons.link,
                          keyboardType: TextInputType.url,
                          action: TextInputAction.next,
                        ),
                        const SizedBox(height: 15),
                        CustomeField(
                          controller: passwordController,
                          hintText: 'New Password',
                          leadingIcon: Icons.lock,
                          keyboardType: TextInputType.visiblePassword,
                          action: TextInputAction.next,
                          obscure: true,
                        ),
                        const SizedBox(height: 15),
                        CustomeField(
                          controller: confirmPasswordController,
                          hintText: 'Confirm Password',
                          leadingIcon: Icons.lock_outline,
                          keyboardType: TextInputType.visiblePassword,
                          action: TextInputAction.done,
                          obscure: true,
                        ),
                      ],
                      const SizedBox(height: 24),
                      SizedBox(
                        width: size.width * .95,
                        child: AuthButton(
                          onTap: linkSent ? _resetPassword : _requestResetLink,
                          name: linkSent ? 'Reset Password' : 'Send Reset Link',
                        ),
                      ),
                      if (linkSent) ...[
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: _requestResetLink,
                          child: const Text('Send link again'),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
