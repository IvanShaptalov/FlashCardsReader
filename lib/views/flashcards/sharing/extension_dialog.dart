import 'package:flashcards_reader/bloc/providers/flashcard_merge_provider.dart';
import 'package:flashcards_reader/bloc/providers/sharing_provider.dart';
import 'package:flashcards_reader/bloc/providers/word_collection_provider.dart';
import 'package:flashcards_reader/util/constants.dart';
import 'package:flashcards_reader/views/overlay_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';

class ExtensionDialog {
  static showExportDialog(BuildContext context) {
    showPlatformDialog(
      context: context,
      builder: (_) => BasicDialogAlert(
        title: const Text("Select export extension"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildListItem(jsonExt, context),
              _buildListItem(textExt, context),
            ],
          ),
        ),
        actions: <Widget>[
          BasicDialogAction(
            title: const Text("Cancel"),
            onPressed: () {
              // print('pressed');
              OverlayNotificationProvider.showOverlayNotification(
                  'export cancelled');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  static Widget _buildListItem(String ext, BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            SharingProvider.selectPathThenSave(
                context, [FlashCardProvider.fc], ext);

            Navigator.pop(context);
          },
          child: SizedBox(
            height: 48,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(child: Text(ext)),
              ],
            ),
          ),
        ),
        const Divider(height: 0.5),
      ],
    );
  }

  static showBulkExportDialog(BuildContext context, Function updateCallback) {
    showPlatformDialog(
      context: context,
      builder: (_) => BasicDialogAlert(
        title: const Text("Select export extension"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildListItemBulk(jsonExt, context, updateCallback),
              _buildListItemBulk(textExt, context, updateCallback),
            ],
          ),
        ),
        actions: <Widget>[
          BasicDialogAction(
            title: const Text("Cancel"),
            onPressed: () {
              // print('pressed');
              OverlayNotificationProvider.showOverlayNotification(
                  'export cancelled');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  static Widget _buildListItemBulk(
      String ext, BuildContext context, Function updateCallback) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            SharingProvider.selectPathThenSave(
                    context,
                    List.castFrom(FlashCardCollectionProvider.flashcardsToMerge)
                      ..add(FlashCardCollectionProvider.targetFlashCard!),
                    ext)
                .then((value) =>
                    FlashCardCollectionProvider.deactivateMergeMode())
                .then((value) => updateCallback());

            Navigator.pop(context);
          },
          child: SizedBox(
            height: 48,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(child: Text(ext)),
              ],
            ),
          ),
        ),
        const Divider(height: 0.5),
      ],
    );
  }
}
