import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:note_keeper/app/utils/exports.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  final box = GetStorage();
  box.writeIfNull(kOnboarding, false);

  bool isIntro = box.read(kOnboarding);
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "NoteKeeper",
      initialRoute: !isIntro
          ? Routes.ONBOARDING
          : box.hasData(kUserInfo)
          ? AppPages.initial
          : Routes.USER,
      getPages: AppPages.routes,

      theme: ThemeData().copyWith(scaffoldBackgroundColor: NAppColor.kbgColor2),
    ),
  );
}
