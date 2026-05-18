import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:note_keeper/app/modules/home/model/notes_model.dart';
import 'package:note_keeper/app/modules/home/model/statistcs_model.dart';

import '../../../utils/events/user_events.dart';
import '../providers/home_provider.dart';

class HomeController extends GetxController {
  GetAllNotes allNotes = GetAllNotes.intial;
  GetNoteStatistics noteStatistics = GetNoteStatistics.intial;
  CreateNewNote createNote = CreateNewNote.intial;
  UpdateNote noteUpdate = UpdateNote.intial;
  DeleteNote noteDelete = DeleteNote.intial;

  List<NotesModel> notes = [];
  NoteStatisticsModel statistcs = NoteStatisticsModel();
  NotesModel newNote = NotesModel();

  Future<void> getAllNotes({
    required Function(List<NotesModel> notes) onSuccess,
    required Function(String err) onError,
  }) async {
    try {
      allNotes = GetAllNotes.loading;
      update();

      final response = await HomeProvider().getNotes();
      notes = response;
      allNotes = GetAllNotes.success;
      update();
      onSuccess(notes);
    } on TimeoutException {
      allNotes = GetAllNotes.networkError;

      update();
      onError("Please Check Your Internt Connection.");
    } on SocketException {
      allNotes = GetAllNotes.networkError;

      update();
      onError("Please Check Your Internt Connection.");
    } catch (e) {
      allNotes = GetAllNotes.error;
      update();
      onError(e.toString());
    }
  }

  // Get Note Statistcs

  Future<void> getNoteStatistics({
    required Function(NoteStatisticsModel stats) onSuccess,
    required Function(String err) onError,
  }) async {
    try {
      noteStatistics = GetNoteStatistics.loading;
      update();

      final response = await HomeProvider().getNoteStatistics();
      statistcs = response;
      noteStatistics = GetNoteStatistics.success;
      update();
      onSuccess(statistcs);
    } on TimeoutException {
      noteStatistics = GetNoteStatistics.networkError;

      update();
      onError("Please Check Your Internt Connection.");
    } on SocketException {
      noteStatistics = GetNoteStatistics.networkError;

      update();
      onError("Please Check Your Internt Connection.");
    } catch (e) {
      noteStatistics = GetNoteStatistics.error;
      update();
      onError(e.toString());
    }
  }

  Future<void> createNewNote({
    required String title,
    required String content,
    List<String> tags = const [],
    bool isPinned = false,
    required Function(NotesModel note) onSuccess,
    required Function(String err) onError,
  }) async {
    try {
      createNote = CreateNewNote.loading;
      update();

      final response = await HomeProvider().createNote(
        title: title,
        content: content,
        tags: tags,
        isPinned: isPinned,
      );

      newNote = response;
      notes.insert(0, response);
      createNote = CreateNewNote.success;
      update();
      onSuccess(response);
    } on TimeoutException {
      createNote = CreateNewNote.networkError;
      update();
      onError("Please Check Your Internt Connection.");
    } on SocketException {
      createNote = CreateNewNote.networkError;
      update();
      onError("Please Check Your Internt Connection.");
    } catch (e) {
      createNote = CreateNewNote.error;
      update();
      onError(e.toString());
    }
  }

  Future<void> updateExistingNote({
    required String id,
    required String title,
    required String content,
    List<String> tags = const [],
    bool isPinned = false,
    required Function(NotesModel note) onSuccess,
    required Function(String err) onError,
  }) async {
    try {
      noteUpdate = UpdateNote.loading;
      update();

      final response = await HomeProvider().updateNote(
        id: id,
        title: title,
        content: content,
        tags: tags,
        isPinned: isPinned,
      );

      final index = notes.indexWhere((note) => note.id == id);
      if (index != -1) {
        notes[index] = response;
      }

      noteUpdate = UpdateNote.success;
      update();
      onSuccess(response);
    } on TimeoutException {
      noteUpdate = UpdateNote.networkError;
      update();
      onError("Please Check Your Internt Connection.");
    } on SocketException {
      noteUpdate = UpdateNote.networkError;
      update();
      onError("Please Check Your Internt Connection.");
    } catch (e) {
      noteUpdate = UpdateNote.error;
      update();
      onError(e.toString());
    }
  }

  Future<void> deleteExistingNote({
    required String id,
    required Function() onSuccess,
    required Function(String err) onError,
  }) async {
    try {
      noteDelete = DeleteNote.loading;
      update();

      await HomeProvider().deleteNote(id: id);

      notes.removeWhere((note) => note.id == id);
      noteDelete = DeleteNote.success;
      update();
      onSuccess();
    } on TimeoutException {
      noteDelete = DeleteNote.networkError;
      update();
      onError("Please Check Your Internt Connection.");
    } on SocketException {
      noteDelete = DeleteNote.networkError;
      update();
      onError("Please Check Your Internt Connection.");
    } catch (e) {
      noteDelete = DeleteNote.error;
      update();
      onError(e.toString());
    }
  }
}
