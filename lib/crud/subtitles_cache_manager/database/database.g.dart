// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorSubtitlesDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$SubtitlesDatabaseBuilder databaseBuilder(String name) =>
      _$SubtitlesDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$SubtitlesDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$SubtitlesDatabaseBuilder(null);
}

class _$SubtitlesDatabaseBuilder {
  _$SubtitlesDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$SubtitlesDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$SubtitlesDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<SubtitlesDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$SubtitlesDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$SubtitlesDatabase extends SubtitlesDatabase {
  _$SubtitlesDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  VideoDao? _videoDaoInstance;

  SubtitlesInfoDao? _subtitlesInfoDaoInstance;

  SubtitlesDao? _subtitlesDaoInstance;

  SubtitlesSourceDao? _subtitlesSourceDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `videos` (`videoId` TEXT NOT NULL, PRIMARY KEY (`videoId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `subtitlesInfo` (`infoId` INTEGER PRIMARY KEY AUTOINCREMENT, `videoId` TEXT NOT NULL, `language` TEXT NOT NULL, `captionsType` TEXT NOT NULL, `createdAt` TEXT, FOREIGN KEY (`videoId`) REFERENCES `videos` (`videoId`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `subtitles` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `infoId` INTEGER NOT NULL, `subtitles` TEXT NOT NULL, FOREIGN KEY (`infoId`) REFERENCES `subtitlesInfo` (`infoId`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `subtitlesSource` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `infoId` INTEGER NOT NULL, `subtitles_source` TEXT NOT NULL, FOREIGN KEY (`infoId`) REFERENCES `subtitlesInfo` (`infoId`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
        await database.execute(
            'CREATE UNIQUE INDEX `index_subtitlesInfo_videoId_language_captionsType` ON `subtitlesInfo` (`videoId`, `language`, `captionsType`)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  VideoDao get videoDao {
    return _videoDaoInstance ??= _$VideoDao(database, changeListener);
  }

  @override
  SubtitlesInfoDao get subtitlesInfoDao {
    return _subtitlesInfoDaoInstance ??=
        _$SubtitlesInfoDao(database, changeListener);
  }

  @override
  SubtitlesDao get subtitlesDao {
    return _subtitlesDaoInstance ??= _$SubtitlesDao(database, changeListener);
  }

  @override
  SubtitlesSourceDao get subtitlesSourceDao {
    return _subtitlesSourceDaoInstance ??=
        _$SubtitlesSourceDao(database, changeListener);
  }
}

class _$VideoDao extends VideoDao {
  _$VideoDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _videoInsertionAdapter = InsertionAdapter(database, 'videos',
            (Video item) => <String, Object?>{'videoId': item.videoId});

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Video> _videoInsertionAdapter;

  @override
  Future<Video?> retrieveById(String videoId) async {
    return _queryAdapter.query('SELECT * FROM videos WHERE videoId = ?1',
        mapper: (Map<String, Object?> row) => Video(row['videoId'] as String),
        arguments: [videoId]);
  }

  @override
  Future<void> deleteByIdd(String videoId) async {
    await _queryAdapter.queryNoReturn('DELETE FROM videos WHERE videoId = ?1',
        arguments: [videoId]);
  }

  @override
  Future<void> add(Video video) async {
    await _videoInsertionAdapter.insert(video, OnConflictStrategy.abort);
  }
}

class _$SubtitlesInfoDao extends SubtitlesInfoDao {
  _$SubtitlesInfoDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _subtitlesInfoInsertionAdapter = InsertionAdapter(
            database,
            'subtitlesInfo',
            (SubtitlesInfo item) => <String, Object?>{
                  'infoId': item.infoId,
                  'videoId': item.videoId,
                  'language': item.language,
                  'captionsType':
                      _captionsTypeStrigifier.encode(item.captionsType),
                  'createdAt': _dateTimeStrigifier.encode(item.createdAt)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SubtitlesInfo> _subtitlesInfoInsertionAdapter;

  @override
  Future<List<SubtitlesInfo>> retrieveAll() async {
    return _queryAdapter.queryList(
        'SELECT * FROM subtitlesInfo ORDER BY createdAt ASC',
        mapper: (Map<String, Object?> row) => SubtitlesInfo(
            infoId: row['infoId'] as int?,
            videoId: row['videoId'] as String,
            language: row['language'] as String,
            captionsType:
                _captionsTypeStrigifier.decode(row['captionsType'] as String),
            createdAt: _dateTimeStrigifier.decode(row['createdAt'] as String)));
  }

  @override
  Future<List<SubtitlesInfo>> retrieveByVideoId(String videoId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM subtitlesInfo WHERE videoId = ?1 ORDER BY createdAt ASC',
        mapper: (Map<String, Object?> row) => SubtitlesInfo(
            infoId: row['infoId'] as int?,
            videoId: row['videoId'] as String,
            language: row['language'] as String,
            captionsType:
                _captionsTypeStrigifier.decode(row['captionsType'] as String),
            createdAt: _dateTimeStrigifier.decode(row['createdAt'] as String)),
        arguments: [videoId]);
  }

  @override
  Future<SubtitlesInfo?> retrieveByInfoId(int infoId) async {
    return _queryAdapter.query(
        'SELECT * FROM subtitlesInfo WHERE infoId = ?1 ORDER BY createdAt ASC',
        mapper: (Map<String, Object?> row) => SubtitlesInfo(
            infoId: row['infoId'] as int?,
            videoId: row['videoId'] as String,
            language: row['language'] as String,
            captionsType:
                _captionsTypeStrigifier.decode(row['captionsType'] as String),
            createdAt: _dateTimeStrigifier.decode(row['createdAt'] as String)),
        arguments: [infoId]);
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM subtitlesInfo');
  }

  @override
  Future<void> deleteByInfoId(int infoId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM subtitlesInfo WHERE infoId = ?1',
        arguments: [infoId]);
  }

  @override
  Future<void> deleteByVideoId(String videoId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM subtitlesInfo WHERE videoId = ?1',
        arguments: [videoId]);
  }

  @override
  Future<void> add(SubtitlesInfo subtitlesInfo) async {
    await _subtitlesInfoInsertionAdapter.insert(
        subtitlesInfo, OnConflictStrategy.abort);
  }
}

class _$SubtitlesDao extends SubtitlesDao {
  _$SubtitlesDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _subtitlesInsertionAdapter = InsertionAdapter(
            database,
            'subtitles',
            (Subtitles item) => <String, Object?>{
                  'id': item.id,
                  'infoId': item.infoId,
                  'subtitles': item.subtitles
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Subtitles> _subtitlesInsertionAdapter;

  @override
  Future<List<Subtitles>> retrieveByInfoId(int infoId) async {
    return _queryAdapter.queryList('SELECT * FROM subtitles WHERE infoId = ?1',
        mapper: (Map<String, Object?> row) => Subtitles(
            id: row['id'] as int?,
            infoId: row['infoId'] as int,
            subtitles: row['subtitles'] as String),
        arguments: [infoId]);
  }

  @override
  Future<List<Subtitles>> retrieveAll() async {
    return _queryAdapter.queryList('SELECT * FROM subtitles',
        mapper: (Map<String, Object?> row) => Subtitles(
            id: row['id'] as int?,
            infoId: row['infoId'] as int,
            subtitles: row['subtitles'] as String));
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM subtitles');
  }

  @override
  Future<void> deleteByInfoId(int infoId) async {
    await _queryAdapter.queryNoReturn('DELETE FROM subtitles WHERE infoId = ?1',
        arguments: [infoId]);
  }

  @override
  Future<void> add(Subtitles subtitles) async {
    await _subtitlesInsertionAdapter.insert(
        subtitles, OnConflictStrategy.abort);
  }
}

class _$SubtitlesSourceDao extends SubtitlesSourceDao {
  _$SubtitlesSourceDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _subtitlesSourceInsertionAdapter = InsertionAdapter(
            database,
            'subtitlesSource',
            (SubtitlesSource item) => <String, Object?>{
                  'id': item.id,
                  'infoId': item.infoId,
                  'subtitles_source': item.subtitlesSource
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SubtitlesSource> _subtitlesSourceInsertionAdapter;

  @override
  Future<List<SubtitlesSource>> retrieveByInfoId(int infoId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM subtitlesSource WHERE infoId = ?1',
        mapper: (Map<String, Object?> row) => SubtitlesSource(
            id: row['id'] as int?,
            infoId: row['infoId'] as int,
            subtitlesSource: row['subtitles_source'] as String),
        arguments: [infoId]);
  }

  @override
  Future<List<SubtitlesSource>> retrieveAll() async {
    return _queryAdapter.queryList('SELECT * FROM subtitlesSource',
        mapper: (Map<String, Object?> row) => SubtitlesSource(
            id: row['id'] as int?,
            infoId: row['infoId'] as int,
            subtitlesSource: row['subtitles_source'] as String));
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM subtitlesSource');
  }

  @override
  Future<void> deleteByInfoId(int infoId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM subtitlesSource WHERE infoId = ?1',
        arguments: [infoId]);
  }

  @override
  Future<void> add(SubtitlesSource subtitlesSource) async {
    await _subtitlesSourceInsertionAdapter.insert(
        subtitlesSource, OnConflictStrategy.abort);
  }
}

// ignore_for_file: unused_element
final _dateTimeStrigifier = DateTimeStringifier();
final _captionsTypeStrigifier = CaptionsTypeStringifier();
