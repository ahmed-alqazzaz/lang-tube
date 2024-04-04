// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:floor/floor.dart';
import 'package:flutter/material.dart';

import '../database/database.dart';
import 'subtitles_info.dart';

@immutable
@Entity(tableName: SubtitlesDatabase.subtitlesSourceTable, foreignKeys: [
  ForeignKey(
    childColumns: [SubtitlesDatabase.infoIdColumn],
    parentColumns: [SubtitlesDatabase.infoIdColumn],
    entity: DatabaseSubtitlesInfo,
  ),
], indices: [
  Index(value: [SubtitlesDatabase.infoIdColumn], unique: true)
])
class DatabaseSubtitlesSource {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  @ColumnInfo(name: SubtitlesDatabase.infoIdColumn)
  final int infoId;

  @ColumnInfo(name: SubtitlesDatabase.subtitlesSourceColumn)
  final String subtitlesSource;

  const DatabaseSubtitlesSource(
      {this.id, required this.infoId, required this.subtitlesSource});
}
