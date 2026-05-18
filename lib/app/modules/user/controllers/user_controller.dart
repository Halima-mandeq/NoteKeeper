import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:note_keeper/app/modules/user/model/user_model.dart';
import 'package:note_keeper/app/modules/user/providers/user_provider.dart';

import '../../../utils/events/user_events.dart';

class UserController extends GetxController {
  UserState userState = UserState.intial;
  RegistrationState registrationState = RegistrationState.intial;

  UserModel user = UserModel();

  bool isEmailValid(String email) {
    String emailRegex = r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
    RegExp regExp = RegExp(emailRegex);
    return regExp.hasMatch(email);
  }

  Future<void> loginUser({
    required String email,
    required String password,
    required Function(UserModel) onSuccess,
    required Function(String) onError,
  }) async {
    userState = UserState.loading;
    update();

    try {
      // Save user data to local storage
      final response = await UserProvider().loginUser(
        email: email,
        password: password,
      );

      user = response;
      userState = UserState.success;
      update();
      onSuccess(response);
    } on SocketException {
      userState = UserState.networkError;
      update();
      onError("Please check your internet connection.");
    } on TimeoutException {
      userState = UserState.networkError;
      update();
      onError("Please check your internet connection.");
    } catch (e) {
      userState = UserState.error;
      update();
      onError(e.toString());
    }
  }

  Future<void> createUserAccount({
    required String fullName,
    required String email,
    required String password,
    required Function(UserModel) onSuccess,
    required Function(String) onError,
  }) async {
    registrationState = RegistrationState.loading;
    update();

    try {
      // Save user data to local storage
      final response = await UserProvider().createAccount(
        fullName: fullName,
        email: email,
        password: password,
      );

      user = response;
      registrationState = RegistrationState.success;
      update();
      onSuccess(response);
    } on SocketException {
      registrationState = RegistrationState.networkError;
      update();
      onError("Please check your internet connection.");
    } on TimeoutException {
      registrationState = RegistrationState.networkError;
      update();
      onError("Please check your internet connection.");
    } catch (e) {
      registrationState = RegistrationState.error;
      update();
      onError(e.toString());
    }
  }

  Future<void> logout({required Function() onSuccess}) async {
    await UserProvider().clearUserData();
    user = UserModel();
    userState = UserState.intial;
    registrationState = RegistrationState.intial;
    update();
    onSuccess();
  }
}
