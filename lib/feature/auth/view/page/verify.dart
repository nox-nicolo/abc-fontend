import 'package:africa_beuty/core/widgets/loader.dart';
import 'package:africa_beuty/feature/auth/view/widget/auth_button.dart';
import 'package:africa_beuty/feature/auth/view/widget/custome_field.dart';
import 'package:africa_beuty/feature/auth/view_model/code_renew.dart';
import 'package:africa_beuty/feature/auth/view_model/verify_veiwmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Verify extends ConsumerStatefulWidget {
  const Verify({super.key});

  @override
  ConsumerState<Verify> createState() => _VerifyState();
}

class _VerifyState extends ConsumerState<Verify> {
  final codeController = TextEditingController();

  final formKey = GlobalKey<FormState>(); // form key

  // Disposal of the state
  @override
  void dispose() {
    codeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(verifyVeiwModelProvider)?.isLoading == true;

    ref.listen(verifyVeiwModelProvider, (_, next) {
      if (!context.mounted) return;

      next?.when(
        data: (data) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Set up your profile')),
            );
          Navigator.pushReplacementNamed(context, '/set_profile');
        },
        error: (error, str) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(error.toString())));
        },
        loading: () {},
      );
    });

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? const Loader()
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 50),
                Center(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Text(
                          'Verify Screen',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        Text('Code is sent to your email address'),
                        const SizedBox(height: 20),

                        CustomeField(
                          hintText: 'Code',
                          leadingIcon: Icons.code,
                          keyboardType: TextInputType.text,
                          action: TextInputAction.done,
                          controller: codeController,
                        ),

                        const SizedBox(height: 10),

                        SizedBox(
                          width: size.width * .99,
                          child: AuthButton(
                            onTap: () async {
                              if (formKey.currentState!.validate()) {
                                await ref
                                    .read(verifyVeiwModelProvider.notifier)
                                    .verifyUser(
                                      code: codeController.text.trim(),
                                    );
                              }
                            },
                            name: 'Verify',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 20,
                  ),
                  margin: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () async {
                      // update the code right..
                      if (formKey.currentState!.validate()) {
                        await ref
                            .read(codeRenewViewModelProvider.notifier)
                            .getNewCode(code: codeController.text.trim());
                      }
                    },
                    child: const Text('Get new Code'),
                  ),
                ),
              ],
            ),
    );
  }
}
