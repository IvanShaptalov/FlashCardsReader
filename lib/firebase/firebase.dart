import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flashcards_reader/firebase_options.dart';
import 'package:flashcards_reader/util/error_handler.dart';

class FireBaseService {
  static FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver? firebaseAnalyticsObserver =
      FirebaseAnalyticsObserver(analytics: firebaseAnalytics);
  static Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    firebaseAnalytics.setAnalyticsCollectionEnabled(true);

    firebaseAnalytics.logEvent(name: 'analytics_initialized');

    debugPrintIt('analytics initialized');
  }

  static const String toFirebase = 'firebase ==================>';

  // done
  static void logRoute(String routeName) {
    debugPrintIt(toFirebase);
    firebaseAnalytics
        .logEvent(name: 'route', parameters: {'route_name': routeName});
  }

  static void logGuide(GuideStatus guide, int step) {
    debugPrintIt(toFirebase);
    firebaseAnalytics.logEvent(
        name: 'guide', parameters: {'status': guide.name, 'step': step});
  }

  // done
  static void logScanningBooks(bool storageGranted) {
    firebaseAnalytics.logEvent(
        name: 'scanning_books',
        parameters: {'storage_granted': storageGranted});
  }

  // done
  static void grantStorage(bool storageGranted) {
    firebaseAnalytics.logEvent(
        name: 'permission_storage',
        parameters: {'storage_granted': storageGranted});
  }

  // done
  static void translateWord(String fromLan, String toLan, bool connection) {
    firebaseAnalytics.logEvent(name: 'translate', parameters: {
      'internet_connection': connection,
      'from_lan': fromLan,
      'to_lan': toLan,
    });
  }

  // done
  static void quizProcess(QuizStatus quizStatus) {
    firebaseAnalytics.logEvent(
        name: 'quiz_started', parameters: {'quizStatus': quizStatus.name});
  }

  // done
  static void bookScanned(int bookCount) {
    firebaseAnalytics.logEvent(
        name: 'book_scanned', parameters: {'book_scanned': bookCount});
  }

  // done
  static void shared() {
    firebaseAnalytics.logEvent(name: 'shared');
  }

  // done
  static void flashesImported(String ext) {
    firebaseAnalytics
        .logEvent(name: 'flashcard_imported', parameters: {'extension': ext});
  }

  // done
  static void flashesExported(String ext) {
    firebaseAnalytics
        .logEvent(name: 'flashcard_exported', parameters: {'extension': ext});
  }

  // done
  static void flashCreated() {
    firebaseAnalytics.logEvent(
        name: 'flashcard_created',
        parameters: {'extension': DateTime.now().toIso8601String()});
  }

  // done
  static void flashDeleted() {
    firebaseAnalytics.logEvent(
        name: 'flashcard_deleted',
        parameters: {'extension': DateTime.now().toIso8601String()});
  }
}

enum GuideStatus { started, ended, skipped, continued }

enum QuizStatus { started, finished, breaks }
