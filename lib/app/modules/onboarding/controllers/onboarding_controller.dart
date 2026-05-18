import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/exports.dart';
import '../models/onboarding_model.dart';

class OnboardingController extends GetxController {
  PageController pageController = PageController();

  int currentPage = 0;

  final List<OnBoardingModel> onboardings = [
    OnBoardingModel(
      title: NTexts.onboardingTitle1,
      img: NImages.onboardingImage1,
      subTitle: NTexts.onboardingDesc1,
    ),
    OnBoardingModel(
      title: NTexts.onboardingTitle2,
      img: NImages.onboardingImage2,
      subTitle: NTexts.onboardingDesc2,
    ),
    OnBoardingModel(
      title: NTexts.onboardingTitle3,
      img: NImages.onboardingImage3,
      subTitle: NTexts.onboardingDesc3,
    ),
  ];

  // Update current page index
  Future<void> updateCurrentPage(int index) async {
    currentPage = index;
    update();
  }

  // onDotClicked

  void onDotClicked(int index) {
    currentPage = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
    update();
  }

  // Skip button action
  Future<void> skipButton() async {
    await pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    update();
  }
}
