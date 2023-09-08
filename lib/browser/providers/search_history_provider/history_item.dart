// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

@immutable
final class BrowserHistoryItem {
  final String searchTerm;
  final DateTime timeStamp;
  const BrowserHistoryItem({
    required this.searchTerm,
    required this.timeStamp,
  });

  BrowserHistoryItem copyWith({
    String? searchTerm,
    DateTime? timeStamp,
  }) {
    return BrowserHistoryItem(
      searchTerm: searchTerm ?? this.searchTerm,
      timeStamp: timeStamp ?? this.timeStamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'searchTerm': searchTerm,
      'timeStamp': timeStamp.millisecondsSinceEpoch,
    };
  }

  factory BrowserHistoryItem.fromMap(Map<String, dynamic> map) {
    return BrowserHistoryItem(
      searchTerm: map['searchTerm'] as String,
      timeStamp: DateTime.fromMillisecondsSinceEpoch(map['timeStamp'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory BrowserHistoryItem.fromJson(String source) =>
      BrowserHistoryItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'BrowserHistoryItem(searchTerm: $searchTerm, timeStamp: $timeStamp)';

  @override
  bool operator ==(covariant BrowserHistoryItem other) {
    if (identical(this, other)) return true;

    return other.searchTerm == searchTerm && other.timeStamp == timeStamp;
  }

  @override
  int get hashCode => searchTerm.hashCode ^ timeStamp.hashCode;
}
