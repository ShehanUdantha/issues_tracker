// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:issues_tracker/helper/helper_function.dart';
import 'package:issues_tracker/services/auth_methods.dart';
import 'package:issues_tracker/utils/constants/sizes.dart';

class EmailVerifyAndForgetScreen extends StatefulWidget {
  final String emailAddress;
  final String title;
  final String description;
  final String purpose;

  const EmailVerifyAndForgetScreen({
    super.key,
    required this.emailAddress,
    required this.title,
    required this.description,
    required this.purpose,
  });

  @override
  State<EmailVerifyAndForgetScreen> createState() =>
      _EmailVerifyAndForgetScreenState();
}

class _EmailVerifyAndForgetScreenState
    extends State<EmailVerifyAndForgetScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    setTimerForAutoRedirect();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  void setTimerForAutoRedirect() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _auth.currentUser?.reload();
      if (widget.purpose == 'verify') {
        if (_auth.currentUser!.emailVerified) {
          timer.cancel();
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/home', (route) => false);
        }
      }
    });
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Iconsax.close_circle,
                      ),
                    ),
                  ],
                ),
                Image(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.height * 0.45,
                  image: const AssetImage(
                    'assets/images/email_send.png',
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(
                      height: AppSizes.spaceBtwItems,
                    ),
                    Text(
                      widget.emailAddress,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(
                      height: AppSizes.spaceBtwItems,
                    ),
                    Text(
                      widget.description,
                      style: Theme.of(context).textTheme.labelMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(
                  height: AppSizes.spaceBtwSections,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (widget.purpose == 'verify') {
                      _auth.currentUser!.emailVerified
                          ? Navigator.of(context).pushNamedAndRemoveUntil(
                              '/home', (route) => false)
                          : Navigator.of(context).pushNamedAndRemoveUntil(
                              '/login', (route) => false);
                    }
                    if (widget.purpose == 'forget') {
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/login', (route) => false);
                    }
                  },
                  child: const Text('Continue'),
                ),
                const SizedBox(
                  height: AppSizes.spaceBtwItems,
                ),
                TextButton(
                  onPressed: () async {
                    if (widget.purpose == 'verify') {
                      String response =
                          await AuthMethods().sendVerificationEmail();
                      if (response != 'Success') {
                        HelperFunction().showSnackBar(context, response);
                      }
                    }
                    if (widget.purpose == 'forget') {
                      String response =
                          await AuthMethods().sendForgetPasswordEmail(
                        emailAddress: widget.emailAddress,
                      );
                      if (response != 'Success') {
                        HelperFunction().showSnackBar(context, response);
                      }
                    }
                  },
                  child: Text(
                    'Resend Email',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelLarge,
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
