import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:note_keeper/app/modules/home/model/notes_model.dart';
import 'package:note_keeper/app/modules/home/model/statistcs_model.dart';
import 'package:http/http.dart' as http;
import 'package:note_keeper/app/utils/api_constants.dart';

class HomeProvider extends GetConnect {
  Map<String, String> get _authorizedHeaders {
    final token = box.read(kUserToken);

    return {
      HttpHeaders.contentTypeHeader: "application/json",
      if (token != null) HttpHeaders.authorizationHeader: "Bearer $token",
    };
  }

  Future<List<NotesModel>> getNotes() async {
    var response = await http.get(
      Uri.parse("${kEndpoint}notes"),
      headers: _authorizedHeaders,
    );

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);

      final List notes = decodedData['notes'] ?? decodedData['data'] ?? [];

      log("All Notes : $notes");

      return notes.map((notes) => NotesModel.fromJson(notes)).toList();
    } else {
      final decodedData = jsonDecode(response.body);

      throw decodedData['message'] ?? "Something went wrong";
    }
  }

  // Get All Note Statistcs

  Future<NoteStatisticsModel> getNoteStatistics() async {
    var response = await http.get(
      Uri.parse("${kEndpoint}notes/stats"),
      headers: _authorizedHeaders,
    );

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);

      var stats = decodedData['stats'] ?? decodedData['data'] ?? {};

      log("All Statistcs : $stats");

      return NoteStatisticsModel.fromJson(stats);
      // return stats.map((notes) => NoteStatisticsModel.fromJson(notes)).toList();
    } else {
      final decodedData = jsonDecode(response.body);

      throw decodedData['message'] ?? "Something went wrong";
    }
  }

  Future<NotesModel> createNote({
    required String title,
    required String content,
    List<String> tags = const [],
    bool isPinned = false,
  }) async {
    final data = {
      "title": title,
      "content": content,
      "tags": tags,
      "isPinned": isPinned,
    };

    final response = await http.post(
      Uri.parse("${kEndpoint}notes"),
      headers: _authorizedHeaders,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decodedData = jsonDecode(response.body);
      final note = decodedData['note'] ?? decodedData['data'] ?? decodedData;

      log("Created Note : $note");

      return NotesModel.fromJson(note);
    } else {
      final decodedData = jsonDecode(response.body);

      throw decodedData['message'] ?? "Something went wrong";
    }
  }

  Future<NotesModel> updateNote({
    required String id,
    required String title,
    required String content,
    List<String> tags = const [],
    bool isPinned = false,
  }) async {
    final data = {
      "title": title,
      "content": content,
      "tags": tags,
      "isPinned": isPinned,
    };

    final response = await http.patch(
      Uri.parse("${kEndpoint}notes/$id"),
      headers: _authorizedHeaders,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decodedData = jsonDecode(response.body);
      final note = decodedData['note'] ?? decodedData['data'] ?? decodedData;

      log("Updated Note : $note");

      return NotesModel.fromJson(note);
    } else {
      final decodedData = jsonDecode(response.body);

      throw decodedData['message'] ?? "Something went wrong";
    }
  }

  Future<void> deleteNote({required String id}) async {
    final response = await http.delete(
      Uri.parse("${kEndpoint}notes/$id"),
      headers: _authorizedHeaders,
    );

    if (response.statusCode == 200 ||
        response.statusCode == 202 ||
        response.statusCode == 204) {
      log("Deleted Note : $id");
      return;
    } else {
      final decodedData = jsonDecode(response.body);

      throw decodedData['message'] ?? "Something went wrong";
    }
  }

  @override
  void onInit() {
    httpClient.baseUrl = 'YOUR-API-URL';
  }
}
