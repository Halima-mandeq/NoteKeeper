import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:note_keeper/app/components/custom_btn.dart';
import 'package:note_keeper/app/utils/events/user_events.dart';

import '../../../components/custom_textfeild.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/exports.dart';
import '../controllers/user_controller.dart';
import 'create_account.dart';

class UserView extends StatefulWidget {
  const UserView({super.key});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  final TextEditingController emailOrPhoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _showPassword = false;

  @override
  void dispose() {
    super.dispose();

    emailOrPhoneController.dispose();
    passwordController.dispose();
  }

  void loginUser() async {
    if (_formKey.currentState!.validate()) {
      final userControler = Get.find<UserController>();

      await userControler.loginUser(
        email: emailOrPhoneController.text.trim(),
        password: passwordController.text.trim(),
        onSuccess: (user) {
          Get.offAllNamed(Routes.HOME);
        },
        onError: (err) {
          showToast(message: err);
        },
      );
    } else {
      showToast(message: "Email and password is required ");
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
                      "Sign in to your account",
                      style: style(
                        fontSize: 14,
                        color: NAppColor.kTextStyleColor.withValues(alpha: 0.7),
                      ),
                    ),
                    SizedBox(height: 50),
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
                    GetBuilder<UserController>(
                      builder: (user) {
                        return CustomButton(
                          btnText: '',

                          onTap: user.userState == UserState.loading
                              ? () {}
                              : loginUser,
                          child: user.userState == UserState.loading
                              ? Center(
                                  child: CircularProgressIndicator.adaptive(),
                                )
                              : Text(
                                  "Sign In",
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
                          "Don't have an account?",
                          style: style(
                            fontSize: 14,
                            color: NAppColor.kTextStyleColor.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            //Get.to(() => const CreateAccount());
                            goScreen(context: context, screen: CreateAccount());
                          },
                          child: Text(
                            " Create Account",
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
