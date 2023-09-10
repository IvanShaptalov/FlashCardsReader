import 'dart:io';
import 'package:flashcards_reader/firebase/firebase.dart';
import 'package:flashcards_reader/model/IO/local_manager.dart';
import 'package:flashcards_reader/model/IO/sharing_flashcards.dart';
import 'package:flashcards_reader/model/entities/flashcards/flashcards_model.dart';
import 'package:flashcards_reader/constants.dart';
import 'package:flashcards_reader/util/enums.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/util/checker.dart';
import 'package:flashcards_reader/views/overlay_notification.dart';
import 'package:flutter/widgets.dart';
import 'package:pick_or_save/pick_or_save.dart';

class SharingProvider {
  static File? file;
  static String? saveFolderPath;

  /// ============================================[Export]=========

  static Future<bool> selectPathThenSave(BuildContext context,
      List<FlashCardCollection> collections, String ext) async {
    FireBaseAnalyticsService.flashesExported(ext);
    String fileName = '';
    String filePath = '';
    String data = '';
    switch (ext) {
      /// ================[Save json collection tmp]
      case jsonExt:
        JsonShare jsonShare = JsonShare();
        jsonShare.collections = collections;
        data = jsonShare.export();
        fileName = 'ExportedFlashcards${uuid.v4()}$jsonExt';
        filePath =
            LocalManager.joinPaths([LocalManager.appDirectoryPath!, fileName]);

        break;

      /// ================[Save text collection tmp]
      case textExt:
        TextShare textShare = TextShare();
        textShare.collections = collections;
        data = textShare.export();
        fileName = 'ExportedFlashcardsText=${uuid.v4()}$textExt';
        filePath =
            LocalManager.joinPaths([LocalManager.appDirectoryPath!, fileName]);

        break;
      default:
        OverlayNotificationProvider.showOverlayNotification(
            '$ext is not supported');
        return false;
    }
    LocalManager.createFile(filePath);
    await LocalManager.writeToFile(filePath, data);

    // pick directory
    List<String>? result = await PickOrSave().fileSaver(
        params: FileSaverParams(
      saveFiles: [SaveFileInfo(filePath: filePath, fileName: fileName)],
    ));
    if (result == null || result.isEmpty) {
      OverlayNotificationProvider.showOverlayNotification('cancelled',
          status: NotificationStatus.info);
      return false;
    } else {
      // write to file

      OverlayNotificationProvider.showOverlayNotification('flashcards exported',
          status: NotificationStatus.success);
      return true;
    }
  }

  /// ============================================[Import]========

  static Future<String?> _pickFile(BuildContext context) async {
    List<String>? result = await PickOrSave().filePicker(
      params: FilePickerParams(getCachedFilePath: true),
    );
    if (result == null) {
      OverlayNotificationProvider.showOverlayNotification('No file selected',
          status: NotificationStatus.info);
      return null;
    }
    return result[0];
  }

  static Future<List<FlashCardCollection>> importCollections(
      BuildContext context) async {
    String? filePath = await _pickFile(context);
    var file = File(filePath ?? '');
    if (file.existsSync() == false) {
      OverlayNotificationProvider.showOverlayNotification('No file selected',
          status: NotificationStatus.info);
    } else {
      String ext = Checker.getExtension(filePath!);

      if (![jsonExt, textExt].contains(ext)) {
        OverlayNotificationProvider.showOverlayNotification(
            'Extension $ext not allowed');
        return [];
      }

      String fileResult = file.readAsStringSync();

      FireBaseAnalyticsService.flashesImported(ext);

      /// [import section]
      switch (ext) {
        case jsonExt:

          /// [import json collections]

          JsonShare jsonShare = JsonShare();
          jsonShare.jsonEntity = fileResult;
          List<FlashCardCollection> collections = jsonShare.import();
          debugPrintIt('start import');

          debugPrintIt('end import');

          if (collections.isEmpty) {
            OverlayNotificationProvider.showOverlayNotification(
                'No collections found',
                status: NotificationStatus.info);
            return [];
          } else {
            OverlayNotificationProvider.showOverlayNotification(
                'Imported ${collections.length} collections',
                status: NotificationStatus.success);
            return collections;
          }
        case textExt:

          /// [import text collections]

          TextShare textShare = TextShare();
          textShare.textEntity = fileResult;
          List<FlashCardCollection> collections = textShare.import();
          if (collections.isEmpty) {
            OverlayNotificationProvider.showOverlayNotification(
                'No collections found',
                status: NotificationStatus.info);
          } else {
            OverlayNotificationProvider.showOverlayNotification(
                'Imported ${collections.length} collections',
                status: NotificationStatus.success);
            return collections;
          }
          break;
        default:
          OverlayNotificationProvider.showOverlayNotification(
              'File extension $ext is not allowed',
              status: NotificationStatus.warning);
      }
    }
    return [];
  }
}
