import 'package:africa_beuty/core/providers/user_provider.dart';
import 'package:africa_beuty/core/widgets/loader.dart';
import 'package:africa_beuty/feature/auth/view/widget/auth_button.dart';
import 'package:africa_beuty/feature/auth/view/widget/custome_field.dart';
import 'package:africa_beuty/feature/auth/view_model/signin_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  // Text input controllers,
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>(); // form key state management

  // Disposal of the states
  @override
  void dispose() {
    // Customer controller disposal
    usernameController.dispose();
    passwordController.dispose();

    super.dispose();

    formKey.currentState?.validate();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isLoading = ref.watch(signinViewModelProvider)?.isLoading == true;

    ref.listen(signinViewModelProvider, (_, next) {
      next?.when(
        data: (data) {
          final user = ref.read(currentUserProvider);
          final username = user?.username;

          if (context.mounted) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    username == null ? 'Welcome back' : 'Welcome $username',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                  backgroundColor: colorScheme.primary,
                  behavior:
                      SnackBarBehavior.floating, // Makes it float above bottom
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  margin: EdgeInsets.only(bottom: 0, right: 0, left: 0),
                  elevation: 10,
                  duration: Duration(seconds: 5),
                ),
              );
            Navigator.pushNamedAndRemoveUntil(context, '/page0', (_) => false);
          }
        },
        error: (error, str) {
          final bool notVerified =
              error.toString() == 'Account is not verified';
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: notVerified
                    ? GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/verify');
                        },
                        child: Text(
                          '${error.toString()}, Click here to verify',
                        ),
                      )
                    : Text(error.toString()),
              ),
            );
        },
        loading: () {},
      );
    });

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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: size.height * .1),

                      Text(
                        'LogIn.',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),

                      const SizedBox(height: 50),

                      CustomeField(
                        controller: usernameController,
                        hintText: 'Username',
                        leadingIcon: Icons.person,
                        keyboardType: TextInputType.text,
                        action: TextInputAction.next,
                      ),

                      const SizedBox(height: 15),

                      CustomeField(
                        controller: passwordController,
                        hintText: 'Password',
                        leadingIcon: Icons.lock,
                        keyboardType: TextInputType.text,
                        action: TextInputAction.done,
                        obscure: true,
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: size.width * .95,
                        child: AuthButton(
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              await ref
                                  .read(signinViewModelProvider.notifier)
                                  .signInUser(
                                    email: usernameController.text,
                                    password: passwordController.text,
                                  );
                            }
                          },
                          name: 'Login',
                        ),
                      ),

                      const SizedBox(height: 25),

                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/select_account');
                        },
                        child: RichText(
                          text: TextSpan(
                            text: 'Don\'t have an account? ',
                            style: Theme.of(context).textTheme.bodyMedium,
                            children: [
                              TextSpan(
                                text: 'Sing Up',
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(color: colorScheme.primary),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 50),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child: Divider(height: 5)),

                          const Text(' Or Sign In With '),

                          Expanded(child: Divider(height: 2)),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 10,
                            ),
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Brand(Brands.google),
                                Text(
                                  'Google',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 10,
                            ),
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Brand(Brands.apple_logo),
                                Text(
                                  'Apple',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
