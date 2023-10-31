// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:issues_tracker/helper/helper_function.dart';
import 'package:issues_tracker/screens/auth/email_verify_forget_screen.dart';
import 'package:issues_tracker/services/auth_methods.dart';
import 'package:issues_tracker/utils/constants/colors.dart';
import 'package:issues_tracker/utils/constants/sizes.dart';
import 'package:issues_tracker/utils/validators/validation.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool displayPassword = true;
  bool remember = true;
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void signInAccount() async {
    // validate all user input before send to the firebase
    // 1. validate email address
    String? emailResponse = Validator.validateEmail(_emailController.text);
    if (emailResponse == null) {
      // 2. validate password
      String? passwordResponse =
          Validator.validatePassword(_passwordController.text);
      if (passwordResponse == null) {
        setState(() {
          isLoading = true;
        });
        // send user inputs to the firebase function
        String response = await AuthMethods().signInMethod(
          emailAddress: _emailController.text,
          password: _passwordController.text,
        );
        setState(() {
          isLoading = false;
        });
        if (response == 'Success') {
          if (_auth.currentUser!.emailVerified) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/home', (route) => false);
          } else {
            String response = await AuthMethods().sendVerificationEmail();
            if (response != 'Success') {
              HelperFunction().showSnackBar(context, response);
            }
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EmailVerifyAndForgetScreen(
                  emailAddress: _emailController.text,
                  title: 'Verify your email address',
                  description:
                      'Congratulations! Your Account Awaits: Verify Your Email to Unlock Seamless Access to Comprehensive Issue Management.',
                  purpose: 'verify',
                ),
              ),
            );
          }
        } else {
          HelperFunction().showSnackBar(
            context,
            response,
          );
        }
      } else {
        HelperFunction().showSnackBar(
          context,
          passwordResponse,
        );
      }
    } else {
      HelperFunction().showSnackBar(
        context,
        emailResponse,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.defaultSpace,
            ).copyWith(
              bottom: AppSizes.defaultSpace,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: AppSizes.spaceBtwSections,
                ),
// header section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Image(
                      height: 100.0,
                      image: AssetImage(
                        'assets/logos/logo_empty.png',
                      ),
                    ),
                    const SizedBox(
                      height: AppSizes.md,
                    ),
                    Text(
                      'Welcome back,',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(
                      height: AppSizes.sm,
                    ),
                    Text(
                      'Unleash the Magic of Effective Issue Management, Collaboration, and Resolution.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(
                  height: AppSizes.spaceBtwSections,
                ),
// form section
                Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
// email textfield
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          prefixIcon: Icon(
                            Iconsax.direct_right,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: AppSizes.spaceBtwInputFields,
                      ),
// password textfield
                      TextField(
                        controller: _passwordController,
                        obscureText: displayPassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(
                            Iconsax.password_check,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                displayPassword = !displayPassword;
                              });
                            },
                            icon: Icon(
                              displayPassword ? Iconsax.eye_slash : Iconsax.eye,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: AppSizes.spaceBtwItems,
                ),
// forgot and remember me section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
// remember me checkbox
                        Checkbox(
                          value: remember,
                          onChanged: (value) {},
                        ),
                        const Text('Remember me'),
                      ],
                    ),
// forget password button
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/forget');
                      },
                      child: const Text('Forget Password?'),
                    ),
                  ],
                ),
                const SizedBox(
                  height: AppSizes.spaceBtwSections,
                ),
// login and create account buttons section
                ElevatedButton(
                  onPressed: signInAccount,
                  style: ElevatedButton.styleFrom(
                    padding: isLoading
                        ? const EdgeInsets.symmetric(
                            vertical: 10.0,
                          )
                        : const EdgeInsets.symmetric(
                            vertical: AppSizes.buttonHeight,
                          ),
                  ),
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.textWhite,
                          ),
                        )
                      : const Text(
                          'Sign In',
                        ),
                ),
                const SizedBox(
                  height: AppSizes.spaceBtwItems,
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      '/register',
                    );
                  },
                  child: const Text(
                    'Create Account',
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
