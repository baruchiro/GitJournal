/*
 * SPDX-FileCopyrightText: 2019-2021 Vishesh Handa <me@vhanda.in>
 *
 * SPDX-License-Identifier: AGPL-3.0-or-later
 */

import 'package:flutter/material.dart';
import 'package:gitjournal/core/folder/flattened_notes_folder.dart';
import 'package:gitjournal/core/folder/notes_folder.dart';
import 'package:gitjournal/core/folder/notes_folder_fs.dart';
import 'package:gitjournal/folder_views/folder_view.dart';
import 'package:gitjournal/l10n.dart';
import 'package:gitjournal/repository.dart';
import 'package:gitjournal/screens/cache_loading_screen.dart';
import 'package:gitjournal/settings/settings.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const routePath = '/';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotesFolder? _allNotesFolder;
  NotesFolderFS? _rootFolder;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    var root = context.watch<NotesFolderFS>();
    var spec = context.watch<Settings>().homeScreenFolderSpec;
    var repo = context.watch<GitJournalRepo>();

    // Wait for the folder tree to be loaded before trying to resolve the
    // configured home folder - until the cache is ready getFolderWithSpec()
    // can't find it, which previously made it fall back to "All Notes".
    if (!repo.fileStorageCacheReady) {
      return const CacheLoadingScreen();
    }

    // Cache the flattened "All Notes" folder; recreating it every build would
    // churn its listeners.
    if (root != _rootFolder || _allNotesFolder == null) {
      _rootFolder = root;
      _allNotesFolder = FlattenedNotesFolder(
        root,
        title: context.loc.screensHomeAllNotes,
      );
    }

    // If a home folder is configured and it exists, open straight into it.
    // Resolved on every build so it self-heals as the tree finishes loading;
    // passing the folder straight to FolderView keeps its state stable.
    NotesFolder displayedFolder = _allNotesFolder!;
    if (spec.isNotEmpty) {
      var homeFolder = root.getFolderWithSpec(spec);
      if (homeFolder != null) {
        displayedFolder = homeFolder;
      }
    }

    return FolderView(notesFolder: displayedFolder);
  }
}
