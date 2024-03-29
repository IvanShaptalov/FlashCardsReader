import 'dart:async';
// import 'dart:ffi';
import 'dart:io';

import 'package:device_information/device_information.dart';
import 'package:flashcards_reader/constants.dart';
import 'package:flashcards_reader/database/core/table_methods.dart';
import 'package:flashcards_reader/firebase/firebase.dart';
import 'package:flashcards_reader/model/entities/reader/book_parser/epub.dart';
import 'package:flashcards_reader/model/entities/reader/book_parser/pdf.dart';
import 'package:flashcards_reader/model/entities/reader/book_parser/txt.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/util/checker.dart';
import 'package:flashcards_reader/views/overlay_notification.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'book_model.dart';

class BookScanner {
  static Future<void> init() async {
    getStatus();
  }

  static ValueNotifier<double> scanPercent = ValueNotifier(0);
  static double scanStep = 0;

  static Future<void> getStatus() async {
    if (await getApiVersion() >= 29) {
      manageStorage.value =
          await Permission.manageExternalStorage.status.isGranted;
    } else {
      manageStorage.value = await Permission.storage.status.isGranted;
    }
  }

  static ValueNotifier<bool> manageStorage = ValueNotifier(false);

  /// check app/src/AndroidManifest.xml to explanation
  static Future<int> getApiVersion() async {
    int apiLevel = 30;
    try {
      apiLevel = await DeviceInformation.apiLevel;
    } catch (e) {
      debugPrintIt('error while checkApiVersion -> book_scanner.dart');
    }
    return apiLevel;
  }

  static Future<bool> getFilePermission() async {
    PermissionStatus status;
    int apiLevel = await getApiVersion();
    // https://pub.dev/packages/permission_handler
    // Starting from Android SDK 29 (Android 10) the READ_EXTERNAL_STORAGE and
    // WRITE_EXTERNAL_STORAGE permissions have been marked deprecated and have
    // been fully removed/ disabled since Android SDK 33 (Android 13).

    if (apiLevel >= 29) {
      debugPrintIt('>= 29 api scenario');
      status = await Permission.manageExternalStorage.status;
      if (!status.isGranted) {
        await Permission.manageExternalStorage.request();
      }
      manageStorage.value = status.isGranted;
    } else {
      debugPrintIt('< 29 api scenario');

      status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
      manageStorage.value = status.isGranted;
    }

    FireBaseAnalyticsService.grantStorage(status.isGranted.toString());
    return status.isGranted;
  }

  static Future<void> scan() async {
    OverlayNotificationProvider.showOverlayNotification('scanning start ...',
        status: NotificationStatus.info);

    try {
      Directory dir = Directory(androidBasePath);
      var files = await dirContents(dir);
      // set scanPercent to 0
      scanStep = 1 / files.length;
      scanPercent.value = 0;
      if (await getFilePermission()) {
        // here we should bind books to the database
        bindBooks(files).then((value) =>
            OverlayNotificationProvider.showOverlayNotification(
                'new files: $value',
                status: NotificationStatus.info));
        FireBaseAnalyticsService.logScanningBooks('true');
      } else {
        FireBaseAnalyticsService.logScanningBooks('false');
      }
    } catch (e) {
      debugPrintIt('Error while scanning: $e');
    }
  }

  static Future<List<FileSystemEntity>> dirContents(Directory dir) {
    var files = <FileSystemEntity>[];
    var completer = Completer<List<FileSystemEntity>>();
    var lister = dir.list(recursive: true);
    lister.listen((file) {
      try {
        if (file is File) {
          String extension = Checker.getExtension(file.path);
          if (file.path.contains('Download')) {
            // debugPrintIt('Download');
          }
          // debugPrintIt(file.path + ' --- ' + extension);
          if (allowedBookExtensions.contains(extension)) {
            files.add(file);
          }
        }
      } catch (e) {
        debugPrintIt(e);
      }
    },
        // should also register onError
        onDone: () => completer.complete(files));
    return completer.future;
  }

  static Future<void> progressScan() async {
    if (scanStep > 0.01) {
      for (int i = 0; i < 50; i++) {
        scanPercent.value += scanStep / 50;
        await Future.delayed(const Duration(milliseconds: 1));
      }
    } else {
      scanPercent.value += scanStep;
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  static Future<void> regressScan() async {
    scanPercent.value = 1;
    for (int i = 0; i < 50; i++) {
      scanPercent.value -= 0.02;
      await Future.delayed(const Duration(milliseconds: 1));
    }
    scanPercent.value = 0;
  }

  static Future<void> setTo100() async {
    scanPercent.value = 1;
  }

  static Future<int> bindBooks(List<FileSystemEntity> files) async {
    debugPrintIt('Binding books to the database');
    int counter = 0;

    for (var fileEntity in files) {
      await progressScan();

      File file = File(fileEntity.path);
      String extension = Checker.getExtension(file.path);
      BookModel? model;
      switch (extension) {
        case '.epub':
          try {
            model = await BinderEpub().bind(file);
          } catch (e) {
            debugPrintIt('$e error in epub');
          }

          break;

        case '.pdf':
          try {
            model = await BinderPdf.bind(file);
          } catch (e) {
            debugPrintIt('$e error in pdf');
          }
          break;

        case '.txt':
          try {
            model = await BinderTxt.bind(file);
          } catch (e) {
            debugPrintIt('$e error in txt');
          }
          break;
        default:
          break;
      }
      if (model != null &&
          !BookDatabaseProvider.getAll()
              .map((e) => e.id())
              .contains(model.id())) {
        BookDatabaseProvider.writeEditAsync(model);
        counter++;
      }
    }

    await Future.delayed(const Duration(seconds: 1));
    await regressScan();
    debugPrintIt('================book models');
    debugPrintIt(BookDatabaseProvider.getAll());
    debugPrintIt(BookDatabaseProvider.getAll().length);
    return counter;
  }
}
