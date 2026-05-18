import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:note_keeper/app/routes/app_pages.dart';
import '../../../utils/exports.dart';

class GetStartBtn extends StatefulWidget {
  const GetStartBtn({super.key, required this.size});

  final Size size;

  @override
  State<GetStartBtn> createState() => _GetStartBtnState();
}

class _GetStartBtnState extends State<GetStartBtn> {
  bool isLoading = false;
  final box = GetStorage();
  void loadingHandler() {
    box.write(kOnboarding, true);

    log("The Value of onboarding is ${box.read(kOnboarding)}");
    setState(() {
      isLoading = true;
      Future.delayed(const Duration(seconds: 3)).then((value) {
        isLoading = false;
        Get.offNamed(Routes.USER);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loadingHandler,
      child: Container(
        margin: const EdgeInsets.only(top: 60),
        width: widget.size.width / 1.5,
        height: widget.size.height / 15,
        decoration: BoxDecoration(
          color: NAppColor.kPrimaryColor,
          borderRadius: BorderRadius.circular(NSizes.borderRadiusLg),
        ),
        child: Center(
          child: isLoading
              ? LoadingAnimationWidget.staggeredDotsWave(
                  size: 35,
                  color: NAppColor.kbgColor,
                )
              : Text(
                  // lets translate this to somali
                  "Get Started now",
                  style: style(fontSize: 17, color: NAppColor.kbgColor),
                ),
        ),
      ),
    );
  }
}

class SkipBtn extends StatelessWidget {
  const SkipBtn({super.key, required this.size, required this.onTap});

  final Size size;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 60),
      width: size.width / 1.5,
      height: size.height / 15,
      decoration: BoxDecoration(
        border: Border.all(color: NAppColor.kPrimaryColor, width: 2),
        borderRadius: BorderRadius.circular(NSizes.borderRadiusLg),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(NSizes.borderRadiusLg),
        onTap: onTap,
        splashColor: NAppColor.kPrimaryColor,
        child: Center(
          child: Text(
            "Skip",
            style: style(fontSize: 17, color: NAppColor.kPrimaryColor),
          ),
        ),
      ),
    );
  }
}
