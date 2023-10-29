// ignore_for_file: use_build_context_synchronously

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:issues_tracker/helper/helper_function.dart';
import 'package:issues_tracker/screens/auth/email_verify_forget_screen.dart';
import 'package:issues_tracker/services/auth_methods.dart';
import 'package:issues_tracker/utils/constants/colors.dart';
import 'package:issues_tracker/utils/constants/sizes.dart';
import 'package:issues_tracker/utils/validators/validation.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool displayPassword = true;
  bool displayConfirmPassword = true;
  bool agree = true;
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  void createAccount() {
    // validate all user input before send to the firebase

    // 1. validate user name empty or not
    if (_nameController.text.isNotEmpty) {
      // 2. validate email address
      String? emailResponse = Validator.validateEmail(_emailController.text);
      if (emailResponse == null) {
        // 3. validate mobile number
        String? mobileResponse =
            Validator.validatePhoneNumber(_mobileController.text);
        if (mobileResponse == null) {
          // 4. validate password
          String? passwordResponse =
              Validator.validatePassword(_passwordController.text);
          if (passwordResponse == null) {
            // 5. validate confirm password
            if (_confirmPasswordController.text.isNotEmpty) {
              // 6. validate confirm password equal to the password
              if (_confirmPasswordController.text == _passwordController.text) {
                // 7. check user agree with our policies
                if (agree) {
                  // send user inputs to the firebase function
                  createUserInFirebase();
                } else {
                  HelperFunction().showSnackBar(context,
                      'Please agree with our privacy policies and terms.');
                }
              } else {
                HelperFunction().showSnackBar(
                    context, 'Confirm password must be match with password.');
              }
            } else {
              HelperFunction()
                  .showSnackBar(context, 'Confirm password is required.');
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
            mobileResponse,
          );
        }
      } else {
        HelperFunction().showSnackBar(
          context,
          emailResponse,
        );
      }
    } else {
      HelperFunction().showSnackBar(context, 'Full name is required.');
    }
  }

  void createUserInFirebase() async {
    setState(() {
      isLoading = true;
    });
    String response = await AuthMethods().signUpMethod(
      fullName: _nameController.text,
      emailAddress: _emailController.text,
      mobileNumber: _mobileController.text,
      password: _passwordController.text,
    );
    setState(() {
      isLoading = false;
    });
    if (response != 'Success') {
      HelperFunction().showSnackBar(context, response);
    } else {
      String response = await AuthMethods().sendVerificationEmail();
      if (response != 'Success') {
        HelperFunction().showSnackBar(context, response);
      }
      // navigate to the email verification screen
      if (context.mounted) {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
// headline section
                Text(
                  'Let\'s create your account',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(
                  height: AppSizes.spaceBtwSections,
                ),
// form section
                Form(
                  child: Column(
                    children: [
// full name textfield
                      TextField(
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: Icon(
                            Iconsax.user,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: AppSizes.spaceBtwInputFields,
                      ),
// email address textfield
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
// mobile number textfield
                      TextField(
                        controller: _mobileController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          prefixIcon: Icon(
                            Iconsax.call,
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
                      const SizedBox(
                        height: AppSizes.spaceBtwInputFields,
                      ),
// confirm password textfield
                      TextField(
                        controller: _confirmPasswordController,
                        obscureText: displayConfirmPassword,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          prefixIcon: const Icon(
                            Iconsax.password_check,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                displayConfirmPassword =
                                    !displayConfirmPassword;
                              });
                            },
                            icon: Icon(
                              displayConfirmPassword
                                  ? Iconsax.eye_slash
                                  : Iconsax.eye,
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
// privacy policy section
                Row(
                  children: [
                    Checkbox(
                      value: agree,
                      onChanged: (value) {
                        setState(() {
                          agree = value!;
                        });
                      },
                    ),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: ' I agree to ',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            TextSpan(
                              recognizer: TapGestureRecognizer()..onTap = () {},
                              text: 'Privacy policy',
                              style:
                                  Theme.of(context).textTheme.bodyMedium!.apply(
                                        color: AppColors.textPrimary,
                                        decoration: TextDecoration.underline,
                                      ),
                            ),
                            TextSpan(
                              text: ' and ',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            TextSpan(
                              recognizer: TapGestureRecognizer()..onTap = () {},
                              text: 'Terms.',
                              style:
                                  Theme.of(context).textTheme.bodyMedium!.apply(
                                        color: AppColors.textPrimary,
                                        decoration: TextDecoration.underline,
                                      ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: AppSizes.spaceBtwSections,
                ),
// create account button
                ElevatedButton(
                  onPressed: createAccount,
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
                      : const Text('Create Account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
