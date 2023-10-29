// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:issues_tracker/helper/helper_function.dart';
import 'package:issues_tracker/screens/auth/email_verify_forget_screen.dart';
import 'package:issues_tracker/services/auth_methods.dart';
import 'package:issues_tracker/utils/constants/colors.dart';
import 'package:issues_tracker/utils/constants/sizes.dart';
import 'package:issues_tracker/utils/validators/validation.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  void sendPasswordRestLink() async {
    // validate email address before send to the firebase
    String? emailResponse = Validator.validateEmail(_emailController.text);
    if (emailResponse == null) {
      setState(() {
        isLoading = true;
      });
      String response = await AuthMethods().sendForgetPasswordEmail(
        emailAddress: _emailController.text,
      );
      setState(() {
        isLoading = false;
      });
      if (response == 'Success') {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EmailVerifyAndForgetScreen(
              emailAddress: _emailController.text,
              title: 'Password Reset Email Send',
              description:
                  'We\'ve Sent You a Password Reset Link to Safely Change Your Password and Keep Your Account Protected!',
              purpose: 'forget',
            ),
          ),
        );
      } else {
        HelperFunction().showSnackBar(
          context,
          response,
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
                Text(
                  'Forget Password',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(
                  height: AppSizes.spaceBtwItems,
                ),
                Text(
                  'Enter your email address and we will send you a password reset link.',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(
                  height: AppSizes.appBarHeight,
                ),
                Form(
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      prefixIcon: Icon(
                        Iconsax.direct_right,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: AppSizes.spaceBtwSections,
                ),
                ElevatedButton(
                  onPressed: sendPasswordRestLink,
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
                      : const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
