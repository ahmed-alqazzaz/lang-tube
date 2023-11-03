import 'dart:developer';
import 'dart:io';

import 'package:colourful_print/colourful_print.dart';
import 'package:flutter/material.dart';
import 'package:lang_tube/subtitles_player/providers/subtitles_cache_provider/database_manager/data/cached_source_captions.dart';
import 'package:lang_tube/subtitles_player/providers/subtitles_cache_provider/database_manager/data/cached_subtitle.dart';
import 'package:lang_tube/subtitles_player/providers/subtitles_cache_provider/database_manager/data/constants.dart';
import 'package:lang_tube/subtitles_player/providers/subtitles_cache_provider/database_manager/utils/bool_to_int.dart';
import 'package:mutex/mutex.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:youtube_subtitles_scraper/youtube_subtitles_scraper.dart';
import 'data/exceptions.dart';

@immutable
class SubtitlesDbManager {
  SubtitlesDbManager._(this._db);
  final Database _db;
  final _mutex = Mutex();

  static Future<SubtitlesDbManager> open(final String dbFilePath) async {
    if (Platform.isWindows) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    if (File(dbFilePath).existsSync()) {
      printGreen("exists");
      File(dbFilePath).deleteSync();
    }
    return SubtitlesDbManager._(
      await openDatabase(
        dbFilePath,
        version: 1,
        onCreate: (db, version) async {
          await db.execute(createVideoIdTableCommand);
          await db.execute(createSubtitlesInfoTableCommand);
          await db.execute(createSubtitlesTableCommand);
          await db.execute(createSubtitlesSourceTableCommand);
        },
      ),
    );
  }

  Future<void> addVideoIdIfNotPresent(String videoId) async {
    if (!_db.isOpen) throw const SubtitlesDataBaseIsClosedException();
    try {
      await _mutex.acquire();
      // Check if videoId already exists in videoId table
      final List<Map<String, dynamic>> videoIds = await _db.query(
        videoIdTable,
        where: '$videoIdColumn = ?',
        whereArgs: [videoId],
      );

      // Insert videoId into videoId table if it doesn't exist
      if (videoIds.isEmpty) {
        await _db.insert(videoIdTable, {videoIdColumn: videoId});
      }
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw const SubtitlesAlreadyExistsException();
      }
    } finally {
      _mutex.release();
    }
  }

  // returns info id
  Future<int> insertSubtitlesInfoIfNotPresent({
    required String videoId,
    required String language,
    required bool isAutoGenerated,
  }) async {
    if (!_db.isOpen) throw const SubtitlesDataBaseIsClosedException();
    try {
      await _mutex.acquire();

      // Check if subtitles info already exists in subtitlesInfo table
      final List<Map<String, dynamic>> subtitlesInfo = await _db.query(
        subtitlesInfoTable,
        where:
            '$videoIdColumn = ? AND $subtitlesLanguageColumn = ? AND $isSubtitleAutoGeneratedColumn = ?',
        whereArgs: [videoId, language, boolToInt(isAutoGenerated)],
      );

      // If it exists, return the id of the existing info
      if (subtitlesInfo.isNotEmpty) {
        return subtitlesInfo.first[subtitlesInfoIdColumn];
      }

      return await _db.insert(subtitlesInfoTable, {
        videoIdColumn: videoId,
        subtitlesLanguageColumn: language,
        isSubtitleAutoGeneratedColumn: boolToInt(isAutoGenerated),
      });
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw const SubtitlesAlreadyExistsException();
      }
      rethrow;
    } finally {
      _mutex.release();
    }
  }

  Future<void> insertSubtitles({
    required String subtitles,
    required int subtitlesInfoId,
  }) async {
    if (!_db.isOpen) throw const SubtitlesDataBaseIsClosedException();
    try {
      await _mutex.acquire();

      // Insert subtitles into subtitles table
      await _db.insert(subtitlesTable, {
        subtitlesInfoIdColumn: subtitlesInfoId,
        subtitlesColumn: subtitles,
      });
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw const SubtitlesAlreadyExistsException();
      }
      rethrow;
    } finally {
      _mutex.release();
    }
  }

  Future<void> insertSubtitlesSource({
    required String subtitlesSource,
    required int subtitlesInfoId,
  }) async {
    if (!_db.isOpen) throw const SubtitlesDataBaseIsClosedException();
    try {
      await _mutex.acquire();

      // Insert subtitles source into subtitles source table
      await _db.insert(subtitlesSourceTable, {
        subtitlesInfoIdColumn: subtitlesInfoId,
        subtitlesSourceColumn: subtitlesSource,
      });
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw const SubtitlesAlreadyExistsException();
      }
      rethrow;
    } finally {
      _mutex.release();
    }
  }

  Future<Iterable<CachedSubtitles>> retrieveSubtitles() async {
    if (!_db.isOpen) throw const SubtitlesDataBaseIsClosedException();
    try {
      await _mutex.acquire();

      // Join the tables to retrieve the subtitles
      final result = await _db.rawQuery('''
        SELECT * FROM $subtitlesTable
        INNER JOIN $subtitlesInfoTable ON $subtitlesTable.$subtitlesInfoIdColumn = $subtitlesInfoTable.$subtitlesInfoIdColumn
       ''');

      return result.map(
        (cachedSubtitle) => CachedSubtitles.fromMap(cachedSubtitle),
      );
    } finally {
      _mutex.release();
    }
  }

  Future<Iterable<CachedSourceCaptions>> retrieveAllSources() async {
    if (!_db.isOpen) throw const SubtitlesDataBaseIsClosedException();
    try {
      await _mutex.acquire();

      // Join the tables to retrieve the subtitles
      final result = await _db.rawQuery('''
        SELECT * FROM $subtitlesSourceTable
        INNER JOIN $subtitlesInfoTable ON $subtitlesSourceTable.$subtitlesInfoIdColumn = $subtitlesInfoTable.$subtitlesInfoIdColumn
      ''');
      printPurple((await _db.rawQuery('''
        SELECT * FROM $subtitlesSourceTable
        ''')).toString());
      return result.map((cachedSourceCaptions) {
        return CachedSourceCaptions.fromMap(cachedSourceCaptions);
      });
    } finally {
      _mutex.release();
    }
  }

  Future<void> deleteAllSubtitles() async => await _db.delete(subtitlesTable);

  Future<void> deleteSubtitlesSources(
      {String? videoId, bool? isAutoGenerated}) async {
    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (videoId != null) {
      whereClause += '$videoIdColumn = ?';
      whereArgs.add(videoId);
    }

    if (isAutoGenerated != null) {
      if (whereClause.isNotEmpty) {
        whereClause += ' AND ';
      }
      whereClause += '$isSubtitleAutoGeneratedColumn = ?';
      whereArgs.add(boolToInt(isAutoGenerated));
    }

    String query = '''
        DELETE FROM $subtitlesSourceTable
        WHERE $subtitlesInfoIdColumn IN (
          SELECT $subtitlesInfoIdColumn FROM $subtitlesInfoTable
          ${whereClause.isNotEmpty ? 'WHERE $whereClause' : ''}
        )
    ''';

    await _db.rawDelete(
      query,
      whereArgs,
    );
  }

  Future<void> close() async {
    if (!_db.isOpen) throw const SubtitlesDataBaseIsClosedException();
    await _db.close();
  }
}
