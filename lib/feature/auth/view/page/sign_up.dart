import 'package:africa_beuty/core/widgets/loader.dart';
import 'package:africa_beuty/feature/auth/view/widget/auth_button.dart';
import 'package:africa_beuty/feature/auth/view/widget/custome_field.dart';
import 'package:africa_beuty/feature/auth/view_model/singup_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage( 
    {
      super.key,
    }
  ); 

  @override 
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {

  // Text input controllers, 
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  final salonNameController = TextEditingController();
  final salonEmailController = TextEditingController();
  final salonPhoneController = TextEditingController();
  final salonPasswordController = TextEditingController();

  final formKey = GlobalKey<FormState>(); // form key state management

  // Disposal of the states
  @override
  void dispose() {

    // Customer controller disposal
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();

    // Salon controller disposal
    salonNameController.dispose();
    salonEmailController.dispose();
    salonPhoneController.dispose();
    salonPasswordController.dispose();

    super.dispose();

    formKey.currentState?.validate();
  }

  @override 
  Widget build(BuildContext context) {

    final isLoading = ref.watch(signupViewModelProvider)?.isLoading == true; // loading indicatior watching

    ref.listen(
      signupViewModelProvider, 
      (_, next) {
        next?.when(
          data: (data) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    'Go to your email to verify account'
                  )
                )
              );

            Navigator.pushReplacementNamed(context, '/verify');
          }, 
          error: (error, str) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    error.toString()
                  )
                )
              );
          }, 
          loading: () {}
        );
      }
    );

    final size = MediaQuery.of(context).size;

    // Receive argument from route
   // Use null-safe casting and default to true if arguments are missing
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final bool isCustomer = arguments?['isCustomer'] ?? true;

    return isCustomer ?  // show Customer Signup page

      Scaffold(
        
        body: isLoading ? 
        
        const Loader()

        : 
        
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50,), 

                  Text(
                    'SignUp Customer', 
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
          
                  const SizedBox(height: 50,), 
              
                  CustomeField(
                    controller: nameController,
                    hintText: 'Fullname', 
                    leadingIcon: Icons.person, 
                    keyboardType: TextInputType.text, 
                    action: TextInputAction.next,
                  ),
              
                  const SizedBox(height: 15,),
              
                  CustomeField(
                    controller: emailController, 
                    hintText: 'Email', 
                    leadingIcon: Icons.mail_rounded, 
                    keyboardType: TextInputType.emailAddress, 
                    action: TextInputAction.next,
                  ),
              
                  const SizedBox(height: 20,), 
              
                  CustomeField(
                    controller: phoneController,
                    hintText: 'Phone', 
                    leadingIcon: Icons.phone, 
                    keyboardType: TextInputType.phone, 
                    action: TextInputAction.next,
                  ),
              
                  const SizedBox(height: 15,),
              
                  CustomeField(
                    controller: passwordController,
                    hintText: 'Password', 
                    leadingIcon: Icons.lock, 
                    keyboardType: TextInputType.text, 
                    action: TextInputAction.done,
                    obscure: true,
                  ),
              
                  const SizedBox(height: 20,),
              
                  SizedBox(
                    width: size.width * .95,
                    child: AuthButton(
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          await ref.read(signupViewModelProvider.notifier).signUpUser(
                            name: nameController.text,
                            email: emailController.text,
                            phone: phoneController.text,
                            password: passwordController.text,
                            role: 'customer'
                          );
                        }
                      },
                      name: 'Signup'
                    )
                  ), 
              
                  const SizedBox(height: 25,),
              
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/signin');
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account? ', 
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: [
                          TextSpan(
                            text: 'Sing In', 
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.pinkAccent[200]
                            )
                          )
                        ]
                      ),
                    ),
                  ), 
          
                  const SizedBox(height: 50,), 
          
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Divider(
                          height: 5, 
                        ),
                      ),
          
                      const Text(
                        ' Or Sign up With ',
                      ),
          
                      Expanded(
                        child: Divider(
                          height: 2, 
                        ),
                      ),
                    ],
                  ),
          
                  const SizedBox(height: 20,), 
          
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(
                          children: [
                            Brand(
                              Brands.google
                            ),
                            Text(
                              'Google', 
                              style: Theme.of(context).textTheme.titleMedium, 
                            )
                          ],
                        ),
                      ), 
                      const SizedBox(width: 20,),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(
                          children: [
                            Brand(
                              Brands.apple_logo
                            ),
                            Text(
                              'Apple', 
                              style: Theme.of(context).textTheme.titleMedium,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ) 
      
      :   // return Service Signup page
      
      Scaffold(
        
        body: isLoading ? 

        const Loader()
        
        :
        
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(18.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: size.height * .1,),
              
                  Text(
                    'SignUp Salon', 
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
              
                  const SizedBox(height: 50,), 
              
                  CustomeField(
                    hintText: 'Salon Name', 
                    leadingIcon: Icons.house_siding, 
                    keyboardType: TextInputType.text, 
                    action: TextInputAction.next, 
                    controller: salonNameController
                  ), 
              
                  const SizedBox(height: 15,), 
              
                  CustomeField(
                    hintText: 'Email', 
                    leadingIcon: Icons.mail, 
                    keyboardType: TextInputType.emailAddress, 
                    action: TextInputAction.next, 
                    controller: salonEmailController
                  ), 
              
                  const SizedBox(height: 15,), 
              
                  CustomeField(
                    hintText: 'Phone', 
                    leadingIcon: Icons.phone, 
                    keyboardType: TextInputType.phone, 
                    action: TextInputAction.next, 
                    controller: salonPhoneController 
                  ),
              
                  const SizedBox(height: 15,), 
              
                  CustomeField(
                    hintText: 'Password', 
                    leadingIcon: Icons.lock, 
                    keyboardType: TextInputType.text, 
                    action: TextInputAction.done, 
                    controller: salonPasswordController,
                    obscure: true,
                  ), 
          
                  const SizedBox(height: 20,), 
          
                  SizedBox(
                    width: size.width * .95,
                    child: AuthButton(
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          await ref.read(signupViewModelProvider.notifier).signUpUser(
                            name: salonNameController.text,
                            email: salonEmailController.text,
                            phone: salonPhoneController.text,
                            password: salonPasswordController.text,
                            role: "service",
                          );
                        }
                      },
                      name: 'Signup'
                    ),
                  ), 
          
                  const SizedBox(height: 25,),
                
                  GestureDetector(
                  onTap: () {
                      Navigator.pushReplacementNamed(context, '/signin');
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account? ', 
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: [
                          TextSpan(
                            text: 'Sing In', 
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.pinkAccent[200]
                            )
                          )
                        ]
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
