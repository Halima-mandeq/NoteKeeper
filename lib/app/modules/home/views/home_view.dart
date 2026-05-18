import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';
import 'package:note_keeper/app/components/error_message.dart';
import 'package:note_keeper/app/components/notes_card.dart';
import 'package:note_keeper/app/components/search_text_feild.dart';
import 'package:note_keeper/app/modules/user/controllers/user_controller.dart';
import 'package:note_keeper/app/routes/app_pages.dart';
import 'package:note_keeper/app/utils/events/user_events.dart';

import '../../../components/summer_card.dart';
import '../../../utils/exports.dart';
import '../controllers/home_controller.dart';
import '../model/notes_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with AfterLayoutMixin<HomeView> {
  final TextEditingController _searchController = TextEditingController();
  String? _error;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: NAppColor.kbgColor2,
          automaticallyImplyLeading: false,
          titleSpacing: NSizes.md,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Notes',
                style: style(
                  color: NAppColor.kTextStyleColor,
                  fontWeight: FontWeight.w600,
                  fontSize: NSizes.fontSizeLg,
                ),
              ),
              Text(
                'Capture ideas before they fade.',
                style: style(
                  color: NAppColor.kTextStyleColorGray,
                  fontSize: NSizes.fontSizeSm,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: NSizes.sm),
              decoration: BoxDecoration(
                color: NAppColor.kbgColor2,
                borderRadius: BorderRadius.circular(NSizes.cardRadiusMd),
                border: Border.all(color: NAppColor.borderSecondary),
              ),
              child: IconButton(
                tooltip: 'Refresh notes',
                color: NAppColor.kSecondColor,
                onPressed: refreshNotes,
                icon: const Icon(Icons.refresh_rounded),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: NSizes.md),
              decoration: BoxDecoration(
                color: NAppColor.kSecondColor,
                borderRadius: BorderRadius.circular(NSizes.cardRadiusMd),
              ),
              child: IconButton(
                tooltip: 'Logout',
                color: Colors.white,
                onPressed: _confirmLogout,
                icon: const Icon(Icons.logout_rounded),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: NAppColor.kPrimaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
          onPressed: () async {
            await _showCreateNoteDialog();
          },
          child: const Icon(Icons.add_rounded),
        ),
        body: SafeArea(
          child: GetBuilder<HomeController>(
            builder: (controller) {
              final visibleCount = _filteredNotes(controller.notes).length;

              return RefreshIndicator(
                color: NAppColor.kPrimaryColor,
                onRefresh: refreshNotes,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              Gap(NSizes.spaceBtwSections),
                              SearchField(
                                controller: _searchController,
                                onChanged: (value) {
                                  setState(() => _query = value.trim());
                                },
                              ),
                              const Gap(NSizes.md),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: SummaryCard(
                                          title: 'Total Notes',
                                          value:
                                              '${controller.statistcs.totalNotes ?? 0}',
                                          icon: Icons.sticky_note_2_rounded,
                                          color: NAppColor.kPrimaryColor,
                                        ),
                                      ),
                                      const Gap(NSizes.sm),
                                      Expanded(
                                        child: SummaryCard(
                                          title: 'Pinned',
                                          value:
                                              '${controller.statistcs.pinnedNotes ?? 0}',
                                          icon: Icons.push_pin_rounded,
                                          color: const Color(0xff16a085),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Gap(NSizes.sm),
                                  SummaryCard(
                                    title: 'UnPinned',
                                    value:
                                        '${controller.statistcs.unpinnedNotes ?? 0}',
                                    icon: Icons.push_pin_rounded,
                                    color: const Color(0xff16a085),
                                  ),
                                ],
                              ),
                              const Gap(NSizes.lg),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _query.isEmpty
                                        ? 'Recent Notes'
                                        : 'Search Results',
                                    style: style(
                                      fontSize: NSizes.fontSizeLg,
                                      color: NAppColor.kTextStyleColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '$visibleCount shown',
                                    style: style(
                                      fontSize: NSizes.fontSizeSm,
                                      color: NAppColor.kTextStyleColorGray,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Gap(NSizes.spaceBtwItems),

                              GetBuilder<HomeController>(
                                builder: (note) {
                                  switch (note.allNotes) {
                                    case GetAllNotes.loading:
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: 1,
                                        itemBuilder: (context, index) => Center(
                                          child:
                                              const CircularProgressIndicator.adaptive(),
                                        ),
                                      );
                                    case GetAllNotes.networkError:
                                      return MessageState(
                                        icon: Icons.cloud_off_rounded,
                                        title: 'Please Check Your Internet.',
                                        message: _error!,
                                      );

                                    case GetAllNotes.error:
                                      return MessageState(
                                        icon: Icons.cloud_off_rounded,
                                        title: 'Could not load notes',
                                        message: _error!,
                                      );
                                    case GetAllNotes.success:
                                      final visibleNotes = _filteredNotes(
                                        note.notes,
                                      );
                                      if (visibleNotes.isEmpty) {
                                        return MessageState(
                                          icon: Icons.note_add_rounded,
                                          title: _query.isEmpty
                                              ? 'No notes yet'
                                              : 'No matches found',
                                          message: _query.isEmpty
                                              ? 'Tap the add button when you are ready to create one.'
                                              : 'Try searching by title, content, or tag.',
                                        );
                                      } else {
                                        return ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: visibleNotes.length,
                                          itemBuilder: (context, index) {
                                            final notes = visibleNotes[index];
                                            return GestureDetector(
                                              onTap: () async {
                                                await _showNoteDialog(
                                                  note: notes,
                                                );
                                              },
                                              child: NoteCard(
                                                note: notes,
                                                accentColor:
                                                    noteColors[index %
                                                        noteColors.length],
                                                onEdit: () async {
                                                  await _showNoteDialog(
                                                    note: notes,
                                                  );
                                                },
                                                onDelete: () async {
                                                  await _confirmDeleteNote(
                                                    notes,
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                        );
                                      }
                                    default:
                                      return SizedBox.shrink();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List<NotesModel> _filteredNotes(List<NotesModel> notes) {
    if (_query.isEmpty) return notes;

    final query = _query.toLowerCase();
    return notes.where((note) {
      final title = note.title?.toLowerCase() ?? '';
      final content = note.content?.toLowerCase() ?? '';
      final tags = (note.tags ?? []).join(' ').toLowerCase();
      return title.contains(query) ||
          content.contains(query) ||
          tags.contains(query);
    }).toList();
  }

  Future<void> getAllNotes() async {
    final notes = Get.find<HomeController>();

    await notes.getAllNotes(
      onSuccess: (_) {
        if (!mounted) return;
        setState(() => _error = null);
      },
      onError: (error) {
        if (!mounted) return;
        debugPrint('Error loading notes: $error');
        setState(() => _error = error);
      },
    );
  }

  Future<void> getNoteStatistics() async {
    final stats = Get.find<HomeController>();

    await stats.getNoteStatistics(
      onSuccess: (_) {
        if (!mounted) return;
        // setState(() => _error = null);
      },
      onError: (error) {
        if (!mounted) return;
        debugPrint('Error loading notes: $error');
        // setState(() => _error = error);
      },
    );
  }

  Future<void> refreshNotes() async {
    await Future.wait([getAllNotes(), getNoteStatistics()]);
  }

  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: NAppColor.kbgColor2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(NSizes.cardRadiusMd),
          ),
          title: Text(
            'Logout',
            style: style(
              fontSize: NSizes.fontSizeLg,
              color: NAppColor.kTextStyleColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: style(
              fontSize: NSizes.fontSizeMd,
              color: NAppColor.kSecondColor.withValues(alpha: 0.72),
              height: 1.45,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'No',
                style: style(
                  fontSize: NSizes.fontSizeMd,
                  color: NAppColor.kTextStyleColorGray,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: NAppColor.kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.pop(context, true),
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true || !mounted) return;

    final user = Get.find<UserController>();
    await user.logout(
      onSuccess: () {
        Get.offAllNamed(Routes.USER);
      },
    );
  }

  Future<void> _showCreateNoteDialog() async {
    await _showNoteDialog();
  }

  Future<void> _confirmDeleteNote(NotesModel note) async {
    final id = note.id;
    if (id == null) {
      showToast(message: 'Note id is missing');
      return;
    }

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: NAppColor.kbgColor2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(NSizes.cardRadiusMd),
          ),
          title: Text(
            'Delete Note',
            style: style(
              fontSize: NSizes.fontSizeLg,
              color: NAppColor.kTextStyleColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'Delete "${note.title ?? 'this note'}"?',
            style: style(
              fontSize: NSizes.fontSizeMd,
              color: NAppColor.kSecondColor.withValues(alpha: 0.72),
              height: 1.45,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'Cancel',
                style: style(
                  fontSize: NSizes.fontSizeMd,
                  color: NAppColor.kTextStyleColorGray,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: NAppColor.kCheckOutActiveTextColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.pop(context, true),
              icon: const Icon(Icons.delete_rounded),
              label: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true || !mounted) return;

    final controller = Get.find<HomeController>();
    await controller.deleteExistingNote(
      id: id,
      onSuccess: () async {
        if (!mounted) return;
        showToast(message: 'Note deleted');
        await refreshNotes();
      },
      onError: (error) {
        showToast(message: error);
      },
    );
  }

  Future<void> _showNoteDialog({NotesModel? note}) async {
    final isEditing = note != null;
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController(text: note?.title ?? '');
    final contentController = TextEditingController(text: note?.content ?? '');
    final tagsController = TextEditingController(
      text: (note?.tags ?? []).join(', '),
    );
    bool isPinned = note?.isPinned ?? false;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: NAppColor.kbgColor2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(NSizes.cardRadiusMd),
              ),
              title: Text(
                isEditing ? 'Edit Note' : 'New Note',
                style: style(
                  fontSize: NSizes.fontSizeLg,
                  color: NAppColor.kTextStyleColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: titleController,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Title is required';
                          }
                          return null;
                        },
                      ),
                      const Gap(NSizes.md),
                      TextFormField(
                        controller: contentController,
                        minLines: 4,
                        maxLines: 6,
                        decoration: const InputDecoration(
                          labelText: 'Content',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Content is required';
                          }
                          return null;
                        },
                      ),
                      const Gap(NSizes.md),
                      TextFormField(
                        controller: tagsController,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          labelText: 'Tags',
                          hintText: 'work, ideas',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const Gap(NSizes.sm),
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Pinned',
                          style: style(
                            fontSize: NSizes.fontSizeMd,
                            color: NAppColor.kTextStyleColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        value: isPinned,
                        activeThumbColor: NAppColor.kPrimaryColor,
                        onChanged: (value) {
                          setDialogState(() => isPinned = value);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                if (isEditing)
                  GetBuilder<HomeController>(
                    builder: (controller) {
                      final deleting =
                          controller.noteDelete == DeleteNote.loading;

                      return IconButton(
                        tooltip: 'Delete note',
                        color: Colors.red,
                        onPressed: deleting
                            ? null
                            : () async {
                                final id = note.id;
                                if (id == null) {
                                  showToast(message: 'Note id is missing');
                                  return;
                                }

                                await controller.deleteExistingNote(
                                  id: id,
                                  onSuccess: () async {
                                    if (!mounted) return;
                                    Navigator.pop(context);
                                    showToast(message: 'Note deleted');
                                    await refreshNotes();
                                  },
                                  onError: (error) {
                                    showToast(message: error);
                                  },
                                );
                              },
                        icon: deleting
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.delete_rounded),
                      );
                    },
                  ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: style(
                      fontSize: NSizes.fontSizeMd,
                      color: NAppColor.kTextStyleColorGray,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                GetBuilder<HomeController>(
                  builder: (controller) {
                    final loading = isEditing
                        ? controller.noteUpdate == UpdateNote.loading
                        : controller.createNote == CreateNewNote.loading;

                    return FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: NAppColor.kPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: loading
                          ? null
                          : () async {
                              if (!formKey.currentState!.validate()) return;

                              final tags = tagsController.text
                                  .split(',')
                                  .map((tag) => tag.trim())
                                  .where((tag) => tag.isNotEmpty)
                                  .toList();

                              if (isEditing) {
                                final id = note.id;
                                if (id == null) {
                                  showToast(message: 'Note id is missing');
                                  return;
                                }

                                await controller.updateExistingNote(
                                  id: id,
                                  title: titleController.text.trim(),
                                  content: contentController.text.trim(),
                                  tags: tags,
                                  isPinned: isPinned,
                                  onSuccess: (_) async {
                                    if (!mounted) return;
                                    Navigator.pop(context);
                                    showToast(message: 'Note updated');
                                    await refreshNotes();
                                  },
                                  onError: (error) {
                                    showToast(message: error);
                                  },
                                );
                              } else {
                                await controller.createNewNote(
                                  title: titleController.text.trim(),
                                  content: contentController.text.trim(),
                                  tags: tags,
                                  isPinned: isPinned,
                                  onSuccess: (_) async {
                                    if (!mounted) return;
                                    Navigator.pop(context);
                                    showToast(message: 'Note saved');
                                    await refreshNotes();
                                  },
                                  onError: (error) {
                                    showToast(message: error);
                                  },
                                );
                              }
                            },
                      icon: loading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save_rounded),
                      label: Text(isEditing ? 'Update' : 'Save'),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );

    titleController.dispose();
    contentController.dispose();
    tagsController.dispose();
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    refreshNotes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
