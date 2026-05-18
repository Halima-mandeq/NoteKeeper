import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:note_keeper/app/components/custom_btn.dart';
import 'package:note_keeper/app/modules/user/controllers/user_controller.dart';
import 'package:note_keeper/app/utils/events/user_events.dart';

import '../../../components/custom_textfeild.dart';
import '../../../utils/exports.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailOrPhoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  @override
  void dispose() {
    fullNameController.dispose();
    emailOrPhoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void createAccount() {
    if (_formKey.currentState!.validate()) {
      if (confirmPasswordController.text != passwordController.text) {
        showToast(message: "Please check password don't match");
      } else {
        final userController = Get.find<UserController>();

        userController.createUserAccount(
          fullName: fullNameController.text.trim(),
          email: emailOrPhoneController.text.trim(),
          password: passwordController.text.trim(),
          onSuccess: (user) {
            // lets back to login page
            Get.back();
          },
          onError: (err) {
            showToast(message: err);
          },
        );
      }

      // Perform account creation logic here
    } else {
      showToast(message: "Please fill all feilds");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "NoteKeeper",
                      style: style(
                        fontSize: 25,
                        color: NAppColor.kTextStyleColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Gap(8),
                    Text(
                      "Create your account to get started",
                      style: style(
                        fontSize: 14,
                        color: NAppColor.kTextStyleColor.withValues(alpha: 0.7),
                      ),
                    ),
                    SizedBox(height: 50),
                    CustomTextFeilds(
                      hintText: "Enter Full Name",
                      controller: fullNameController,
                      isEmail: false,
                      iconData: Icons.email_outlined,
                    ),
                    SizedBox(height: 20),
                    CustomTextFeilds(
                      hintText: "Enter Email",
                      controller: emailOrPhoneController,
                      isEmail: true,
                      iconData: Icons.email_outlined,
                    ),
                    SizedBox(height: 20),
                    CustomTextFeilds(
                      hintText: "Enter Password",
                      controller: passwordController,
                      showPassword: _showPassword,
                      ispassword: true,
                      iconData: Icons.lock_outline,
                      onPasswordVisibilityToggle: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    CustomTextFeilds(
                      hintText: "Enter Confirm Password",
                      controller: confirmPasswordController,
                      showPassword: _showConfirmPassword,
                      ispassword: true,
                      iconData: Icons.lock_outline,
                      onPasswordVisibilityToggle: () {
                        setState(() {
                          _showConfirmPassword = !_showConfirmPassword;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    GetBuilder<UserController>(
                      builder: (user) {
                        return CustomButton(
                          btnText: '',

                          onTap:
                              user.registrationState ==
                                  RegistrationState.loading
                              ? () {}
                              : createAccount,
                          child:
                              user.registrationState ==
                                  RegistrationState.loading
                              ? Center(
                                  child: CircularProgressIndicator.adaptive(),
                                )
                              : Text(
                                  "Create Account",
                                  style: style(
                                    fontSize: 17,
                                    color: NAppColor.kbgColor2,
                                  ),
                                ),
                        );
                      },
                    ),

                    // lets add if dont have an account
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: style(
                            fontSize: 14,
                            color: NAppColor.kTextStyleColor.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Text(
                            " Sign In",
                            style: style(
                              fontSize: 14,
                              color: NAppColor.kPrimaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
