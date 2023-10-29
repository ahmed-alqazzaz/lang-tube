const String subtitlesDbName = 'subtitles_storage.db';
const String videoIdTable = 'videoId';
const String videoIdColumn = 'video_id';
const String subtitlesInfoTable = 'subtitlesInfo';
const String subtitlesInfoIdColumn = 'id';
const String subtitlesLanguageColumn = 'language';
const String isSubtitleAutoGeneratedColumn = 'is_auto_generated';
const String subtitlesTable = 'subtitles';
const String subtitlesColumn = 'subtitles';

const String createVideoIdTableCommand =
    '''CREATE TABLE IF NOT EXISTS $videoIdTable(
   $videoIdColumn TEXT NOT NULL PRIMARY KEY
)''';

const String createSubtitlesInfoTableCommand =
    '''CREATE TABLE IF NOT EXISTS $subtitlesInfoTable(
   $subtitlesInfoIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,
   $videoIdColumn TEXT NOT NULL,
   $subtitlesLanguageColumn TEXT NOT NULL,
   $isSubtitleAutoGeneratedColumn BOOLEAN NOT NULL CHECK ($isSubtitleAutoGeneratedColumn IN (0, 1)),
   FOREIGN KEY ($videoIdColumn) REFERENCES $videoIdTable($videoIdColumn)
   CONSTRAINT unique_row UNIQUE ($videoIdColumn, $subtitlesLanguageColumn, $isSubtitleAutoGeneratedColumn)
)''';

const String createSubtitlesTableCommand =
    '''CREATE TABLE IF NOT EXISTS $subtitlesTable(
   $subtitlesInfoIdColumn INTEGER NOT NULL UNIQUE,
   $subtitlesColumn TEXT NOT NULL,
   FOREIGN KEY ($subtitlesInfoIdColumn) REFERENCES $subtitlesInfoTable($subtitlesInfoIdColumn)
)''';
