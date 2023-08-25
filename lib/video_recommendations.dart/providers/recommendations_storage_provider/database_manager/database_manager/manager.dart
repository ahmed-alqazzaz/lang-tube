import 'dart:io';

import 'package:lang_tube/video_recommendations.dart/providers/recommendations_storage_provider/database_manager/constants.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class RecommendationsDbManager {
  RecommendationsDbManager._(this._db);
  final Database _db;
  static Future<RecommendationsDbManager> open(final String dbFilePath) async {
    if (Platform.isWindows) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    return RecommendationsDbManager._(
      await openDatabase(
        dbFilePath,
        version: 1,
        onCreate: (db, version) async {
          db.execute(createSourceTabsTableCommand);
          db.execute(createRecommendedVideoTableCommand);
          db.execute(createBadgesTableCommand);
        },
      ),
    );
  }
}
