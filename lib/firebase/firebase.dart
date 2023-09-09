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

  static void logScanningBooks(bool storageGranted) {
    firebaseAnalytics.logEvent(
        name: 'scanning_books',
        parameters: {'storage_granted': storageGranted});
  }

  static void grantStorage(bool storageGranted) {
    firebaseAnalytics.logEvent(
        name: 'permission_storage',
        parameters: {'storage_granted': storageGranted});
  }

  static void translateWord(String fromLan, String toLan, bool connection) {
    firebaseAnalytics.logEvent(name: 'translate', parameters: {
      'internet_connection': connection,
      'from_lan': fromLan,
      'to_lan': toLan,
    });
  }

  static void quizProcess(QuizStatus quizStatus) {
    firebaseAnalytics.logEvent(
        name: 'quiz started', parameters: {'quizStatus': quizStatus.name});
  }

  static void flashCardCount(int count) {
    firebaseAnalytics
        .logEvent(name: 'flash_card_count', parameters: {'count': count});
  }

  static void bookScanned(int bookCount) {
    firebaseAnalytics.logEvent(
        name: 'book_scanned', parameters: {'book_scanned': bookCount});
  }

  static void shared() {}

  static void flashesImported(String ext) {}

  static void flashesExported(String ext) {}

  static void flashCreated() {}

  static void flashDeleted() {}

  
}

enum GuideStatus { started, ended, skipped }

enum QuizStatus { started, finished, breaks }
