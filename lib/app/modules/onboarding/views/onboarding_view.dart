import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../utils/exports.dart';
import '../controllers/onboarding_controller.dart';
import '../widgets/skip_get_started_.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: GetBuilder<OnboardingController>(
        builder: (onb) {
          return SafeArea(
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: PageView.builder(
                      controller: onb.pageController,
                      onPageChanged: (index) => onb.updateCurrentPage(index),
                      itemCount: onb.onboardings.length,

                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (_, int index) {
                        return SizedBox(
                          width: size.width,
                          height: size.height,
                          child: Column(
                            children: [
                              /// IMG
                              Container(
                                margin: const EdgeInsets.fromLTRB(
                                  15,
                                  40,
                                  15,
                                  10,
                                ),
                                width: size.width,
                                decoration: BoxDecoration(),
                                height: size.height / 2.5,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    onb.onboardings[index].img,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),

                              /// TITLE TEXT
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 25,
                                  bottom: 15,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: kPadding,
                                  ),
                                  child: Text(
                                    onb.onboardings[index].title,
                                    textAlign: TextAlign.center,
                                    style: style(
                                      fontSize: kPadding + 2,
                                      color: NAppColor.kTextStyleColor,
                                    ),
                                  ),
                                ),
                              ),

                              /// SUBTITLE TEXT
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: kPadding,
                                ),
                                child: Text(
                                  onb.onboardings[index].subTitle,
                                  textAlign: TextAlign.center,
                                  style: style(
                                    fontSize: 14,
                                    color: NAppColor.kTextStyleColor.withValues(
                                      alpha: 0.65,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /// PAGE INDICATOR
                        SmoothPageIndicator(
                          controller: onb.pageController,
                          count: onb.onboardings.length,
                          effect: ExpandingDotsEffect(
                            spacing: 6.0,
                            radius: 10.0,
                            dotWidth: 10.0,
                            dotHeight: 5.0,
                            expansionFactor: 3.8,
                            dotColor: Colors.grey,
                            activeDotColor: NAppColor.kSecondColor,
                          ),
                          onDotClicked: (index) => onb.onDotClicked(index),
                        ),
                        onb.currentPage == 2
                            /// GET STARTED BTN
                            ? GetStartBtn(size: size)
                            /// SKIP BTN
                            : SkipBtn(
                                size: size,
                                onTap: () => onb.skipButton(),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
