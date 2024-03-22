import 'dart:async';
import 'package:floor/floor.dart';
import 'package:lang_tube/crud/subtitles_cache_manager/dao/video_dao.dart';
import 'package:lang_tube/crud/subtitles_cache_manager/type_converters/captions_type_stringifier.dart';
import 'package:lang_tube/crud/subtitles_cache_manager/type_converters/datetime_stringifier.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../dao/subtitles_dao.dart';
import '../dao/subtitles_info_dao.dart';
import '../dao/subtitles_source_dao.dart';
import '../entity/subtitles.dart';
import '../entity/subtitles_info.dart';
import '../entity/subtitles_source.dart';
import '../entity/video.dart';

part 'database.g.dart'; // the generated code will be there

@TypeConverters([DateTimeStringifier, CaptionsTypeStringifier])
@Database(
  version: 1,
  entities: [
    Video,
    SubtitlesInfo,
    Subtitles,
    SubtitlesSource,
  ],
)
abstract class SubtitlesDatabase extends FloorDatabase {
  SubtitlesDatabase();
  static Future<SubtitlesDatabase> open({required String storageDir}) async =>
      await $FloorSubtitlesDatabase
          .databaseBuilder(storageDir + databaseName)
          .build();
  VideoDao get videoDao;
  SubtitlesInfoDao get subtitlesInfoDao;
  SubtitlesDao get subtitlesDao;
  SubtitlesSourceDao get subtitlesSourceDao;

  static const String databaseName = 'subtitles_cacheee.db';

  // Table names
  static const String videosTable = 'videos';
  static const String subtitlesTable = 'subtitles';
  static const String subtitlesSourceTable = 'subtitlesSource';
  static const String subtitlesInfoTable = 'subtitlesInfo';

  // Column names
  static const String videoIdColumn = 'videoId';
  static const String infoIdColumn = 'infoId';
  static const String subtitlesColumn = 'subtitles';
  static const String subtitlesSourceColumn = 'subtitles_source';
  static const String languageColumn = 'language';
  static const String sourceCreatedAtColumn = 'createdAt';
  static const String captionsTypeColumn = 'captionsType';
}
