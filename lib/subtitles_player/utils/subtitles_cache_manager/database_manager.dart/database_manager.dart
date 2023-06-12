import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lang_tube/subtitles_player/utils/subtitles_cache_manager/database_manager.dart/data/constants.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../subtitles_scraper/data/data_classes.dart';
import '../../subtitles_scraper/subtitles_scraper.dart';
import 'data/exceptions.dart';

@immutable
class SubtitlesDbManager {
  const SubtitlesDbManager._(this._db);
  final Database _db;
  Database get db => _db;
  static Future<SubtitlesDbManager> open(final String dbFilePath) async {
    if (Platform.isWindows) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    return SubtitlesDbManager._(
      await openDatabase(
        dbFilePath,
        version: 1,
        onCreate: (db, version) => db.execute(createSubtitlesTableCommand),
      ),
    );
  }

  Future<void> close() async {
    if (!_db.isOpen) throw const SubtitlesDataBaseIsClosedException();
    await _db.close();
  }

  Future<void> addSubtitles(final SubtitlesEntry subtitlesEntry) async {
    if (!_db.isOpen) throw const SubtitlesDataBaseIsClosedException();
    try {
      await _db.insert(subtitlesTable, {
        subtitlesColumn: subtitlesEntry.subtitles,
        isSubtitleAutoGeneratedColumn: subtitlesEntry.isAutoGenerated,
        videoIdColumn: subtitlesEntry.videoId,
        subtitlesLanguageColumn: subtitlesEntry.language,
      });
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw const SubtitlesAlreadyExistsException();
      }
    }
  }

  Future<SubtitlesBundle?> retrieveSubtitles({
    required String videoId,
    required ({String mainLanguage, String translatedLanguage}) languages,
  }) async {
    Future<SubtitlesEntry?> retriever(String language) async {
      return await _db.query(
        subtitlesTable,
        where: '$videoIdColumn = ? AND $subtitlesLanguageColumn = ?',
        whereArgs: [videoId, language],
      ).then((result) {
        return result.firstOrNull != null
            ? SubtitlesEntry.fromRow(result.first)
            : null;
      });
    }

    if (!_db.isOpen) throw const SubtitlesDataBaseIsClosedException();
    final mainLanguageSubtitles = await retriever(languages.mainLanguage);
    final translatedSubtitles = await retriever(languages.translatedLanguage);
    if (mainLanguageSubtitles != null && translatedSubtitles != null) {
      return SubtitlesBundle(
        mainSubtitles: mainLanguageSubtitles,
        translatedSubtitles: translatedSubtitles,
      );
    }
    return null;
  }

  static bool intToBool(int integer) {
    if (integer == 0) {
      return false;
    } else if (integer == 1) {
      return true;
    }
    throw UnimplementedError();
  }
}
