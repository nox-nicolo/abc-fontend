import 'package:africa_beuty/core/widgets/loader.dart';
import 'package:africa_beuty/feature/auth/view_model/singup_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  void _returnToAccountChoice() {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
      return;
    }

    navigator.pushReplacementNamed('/select_account');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(signupViewModelProvider)?.isLoading == true;

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final bool isCustomer = args?['isCustomer'] ?? true;

    ref.listen(signupViewModelProvider, (_, next) {
      next?.when(
        data: (_) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('Check your email to verify your account'),
              ),
            );
          Navigator.pushReplacementNamed(context, '/verify');
        },
        error: (e, _) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(e.toString())));
        },
        loading: () {},
      );
    });

    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: isLoading
          ? const Loader()
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: _returnToAccountChoice,
                        icon: const Icon(Icons.arrow_back),
                        padding: EdgeInsets.zero,
                      ),
                      const SizedBox(height: 16),

                      Text(
                        isCustomer ? 'Create account' : 'Join as a Salon Owner',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        isCustomer
                            ? 'Discover and book beauty services near you.'
                            : 'Your personal details — salon info is set up after.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 32),

                      _Field(
                        controller: _nameController,
                        label: 'Full name',
                        icon: Icons.person_outline,
                        action: TextInputAction.next,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Enter your full name'
                            : null,
                      ),
                      const SizedBox(height: 16),

                      _Field(
                        controller: _emailController,
                        label: 'Email address',
                        icon: Icons.mail_outline_rounded,
                        keyboardType: TextInputType.emailAddress,
                        action: TextInputAction.next,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Enter your email';
                          }
                          if (!RegExp(
                            r'^[^@]+@[^@]+\.[^@]+',
                          ).hasMatch(v.trim())) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      _Field(
                        controller: _phoneController,
                        label: 'Phone number',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        action: TextInputAction.next,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Enter your phone number'
                            : null,
                      ),
                      const SizedBox(height: 16),

                      _Field(
                        controller: _passwordController,
                        label: 'Password',
                        icon: Icons.lock_outline,
                        obscure: _obscurePassword,
                        action: TextInputAction.next,
                        suffix: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Enter a password';
                          }
                          if (v.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      _Field(
                        controller: _confirmController,
                        label: 'Confirm password',
                        icon: Icons.lock_outline,
                        obscure: _obscureConfirm,
                        action: TextInputAction.done,
                        suffix: IconButton(
                          icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () => setState(
                            () => _obscureConfirm = !_obscureConfirm,
                          ),
                        ),
                        validator: (v) => v != _passwordController.text
                            ? 'Passwords do not match'
                            : null,
                      ),
                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: FilledButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await ref
                                  .read(signupViewModelProvider.notifier)
                                  .signUpUser(
                                    name: _nameController.text.trim(),
                                    email: _emailController.text.trim(),
                                    phone: _phoneController.text.trim(),
                                    password: _passwordController.text,
                                    role: isCustomer ? 'customer' : 'service',
                                  );
                            }
                          },
                          child: const Text(
                            'Create account',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      Center(
                        child: GestureDetector(
                          onTap: () => Navigator.pushReplacementNamed(
                            context,
                            '/signin',
                          ),
                          child: RichText(
                            text: TextSpan(
                              text: 'Already have an account?  ',
                              style: Theme.of(context).textTheme.bodyMedium,
                              children: [
                                TextSpan(
                                  text: 'Sign in',
                                  style: Theme.of(context).textTheme.bodyMedium!
                                      .copyWith(
                                        color: scheme.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType keyboardType;
  final TextInputAction action;
  final bool obscure;
  final Widget? suffix;
  final String? Function(String?)? validator;

  const _Field({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.action = TextInputAction.next,
    this.obscure = false,
    this.suffix,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: action,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: suffix,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
    );
  }
}
