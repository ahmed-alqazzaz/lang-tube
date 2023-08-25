const String sourceTabsTable = 'source_tabs';
const String sourceTabsIdColumn = 'id';
const String sourceTabsSourceTabColumn = 'source_tab';

const String createSourceTabsTableCommand =
    '''CREATE TABLE IF NOT EXISTS $sourceTabsTable(
   $sourceTabsIdColumn INTEGER PRIMARY KEY,
   $sourceTabsSourceTabColumn TEXT NOT NULL UNIQUE
)''';

const String recommendedVideoTable = 'recommended_video';
const String recommendedVideoIdColumn = 'video_id';
const String recommendedVideoSourceTabIdColumn = 'source_tab_id';
const String recommendedVideoTitleColumn = 'title';
const String recommendedVideoChannelIconUrlColumn = 'channel_icon_url';
const String recommendedVideoThumbnailUrlColumn = 'thumbnail_url';
const String recommendedVideoSubtitlesComplexityLixIndexColumn =
    'subtitles_complexity_lix_index';
const String recommendedVideoSubtitlesComplexityRixIndexColumn =
    'subtitles_complexity_rix_index';
const String recommendedVideoSubtitlesComplexityFleschReadingEaseColumn =
    'subtitles_complexity_flesch_reading_ease';
const String
    recommendedVideoSubtitlesComplexityAutomatedReadabilityIndexColumn =
    'subtitles_complexity_automated_readability_index';
const String recommendedVideoSubtitlesComplexityColemanLiauIndexColumn =
    'subtitles_complexity_coleman_liau_index';
const String recommendedVideoSyllablesPerMillisecondColumn =
    'syllables_per_millisecond';
const String recommendedVideoCefrColumn = 'cefr';

const String createRecommendedVideoTableCommand =
    '''CREATE TABLE IF NOT EXISTS $recommendedVideoTable(
   $recommendedVideoIdColumn TEXT NOT NULL PRIMARY KEY,
   $recommendedVideoSourceTabIdColumn INTEGER NOT NULL,
   $recommendedVideoTitleColumn TEXT NOT NULL,
   $recommendedVideoChannelIconUrlColumn TEXT NOT NULL,
   $recommendedVideoThumbnailUrlColumn TEXT NOT NULL,
   $recommendedVideoSubtitlesComplexityLixIndexColumn REAL NOT NULL,
   $recommendedVideoSubtitlesComplexityRixIndexColumn REAL NOT NULL,
   $recommendedVideoSubtitlesComplexityFleschReadingEaseColumn REAL NOT NULL,
   $recommendedVideoSubtitlesComplexityAutomatedReadabilityIndexColumn REAL NOT NULL,
   $recommendedVideoSubtitlesComplexityColemanLiauIndexColumn REAL NOT NULL,
   $recommendedVideoSyllablesPerMillisecondColumn REAL NOT NULL,
   $recommendedVideoCefrColumn TEXT NOT NULL,
   FOREIGN KEY ($recommendedVideoSourceTabIdColumn) REFERENCES $sourceTabsTable($sourceTabsIdColumn)
)''';

const String badgesTable = 'badges';
const String badgesIdColumn = 'id';
const String badgesVideoIdColumn = 'video_id';
const String badgesNameColumn = 'name';

const String createBadgesTableCommand =
    '''CREATE TABLE IF NOT EXISTS $badgesTable(
   $badgesIdColumn INTEGER PRIMARY KEY,
   $badgesVideoIdColumn TEXT NOT NULL,
   $badgesNameColumn TEXT NOT NULL,
   FOREIGN KEY ($badgesVideoIdColumn) REFERENCES $recommendedVideoTable($recommendedVideoIdColumn)
)''';
