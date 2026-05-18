import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:note_keeper/app/modules/user/model/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:note_keeper/app/utils/api_constants.dart';

class UserProvider extends GetConnect {
  final box = GetStorage();
  Future<UserModel> loginUser({
    required String email,
    required String password,
  }) async {
    var data = {"email": email, "password": password};

    var response = await http.post(
      Uri.parse("${kEndpoint}auth/users/login"),
      headers: {HttpHeaders.contentTypeHeader: "application/json"},

      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var decodedData = jsonDecode(response.body);

      var data = decodedData['user'];

      await saveUserData(UserModel.fromJson(data));
      await saveUserToken(decodedData['token']);

      return UserModel.fromJson(data);
    } else {
      final decodeData = jsonDecode(response.body);
      throw decodeData['message'] ?? "An error occurred";
    }
  }

  Future<UserModel> createAccount({
    required String fullName,
    required String email,
    required String password,
  }) async {
    var data = {"fullName": fullName, "email": email, "password": password};

    var response = await http.post(
      Uri.parse("${kEndpoint}auth/users/signup"),
      headers: {HttpHeaders.contentTypeHeader: "application/json"},

      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var decodedData = jsonDecode(response.body);

      var data = decodedData['data'];

      return UserModel.fromJson(data);
    } else {
      final decodeData = jsonDecode(response.body);
      throw decodeData['message'] ?? "An error occurred";
    }
  }

  // Save user to local storage
  Future<void> saveUserData(UserModel user) async {
    try {
      final box1 = GetStorage();
      // Save user data
      await box1.write(kUserInfo, user.toJson());

      // log("Temp user data removed", name: "LOCAL_STORAGE");

      log(
        "User data  saved successfully ${user.toJson()}",
        name: "LOCAL_STORAGE",
      );
    } catch (e) {
      log("Error saving user data: $e", name: "LOCAL_STORAGE_ERROR");
      throw "Failed to save user data locally";
    }
  }

  // Get user from local storage
  UserModel? getUserFromLocalStorage() {
    if (box.hasData(kUserInfo)) {
      final userData = box.read(kUserInfo);
      return UserModel.fromJson(userData);
    }
    return null;
  }

  // Save token to local storage
  Future<void> saveUserToken(String token) async {
    // lets clear the user token  when ever we make saving the token
    // this is to avoid the token being saved multiple times
    // and to avoid the token being saved with the wrong user
    await box.remove(kUserToken);
    await box.write(kUserToken, token);

    log("Token Saved $token");
  }

  // Clear user data and token from local storage
  Future<void> clearUserData() async {
    try {
      await box.remove(kUserInfo);
      await box.remove(kUserToken);
      log("User data and token cleared successfully", name: "LOCAL_STORAGE");
    } catch (e) {
      log("Error clearing user data: $e", name: "LOCAL_STORAGE_ERROR");
    }
  }

  @override
  void onInit() {
    httpClient.baseUrl = 'YOUR-API-URL';
  }
}
