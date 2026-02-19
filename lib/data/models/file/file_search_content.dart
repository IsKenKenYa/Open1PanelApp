import 'package:equatable/equatable.dart';

class FileSearchInRequest extends Equatable {
  final String path;
  final String pattern;
  final bool? caseSensitive;
  final bool? wholeWord;
  final bool? regex;
  final List<String>? fileTypes;
  final int? maxResults;

  const FileSearchInRequest({
    required this.path,
    required this.pattern,
    this.caseSensitive,
    this.wholeWord,
    this.regex,
    this.fileTypes,
    this.maxResults,
  });

  factory FileSearchInRequest.fromJson(Map<String, dynamic> json) {
    return FileSearchInRequest(
      path: json['path'] as String,
      pattern: json['pattern'] as String,
      caseSensitive: json['caseSensitive'] as bool?,
      wholeWord: json['wholeWord'] as bool?,
      regex: json['regex'] as bool?,
      fileTypes: (json['fileTypes'] as List?)?.cast<String>(),
      maxResults: json['maxResults'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'pattern': pattern,
      'caseSensitive': caseSensitive,
      'wholeWord': wholeWord,
      'regex': regex,
      'fileTypes': fileTypes,
      'maxResults': maxResults,
    };
  }

  @override
  List<Object?> get props => [path, pattern, caseSensitive, wholeWord, regex, fileTypes, maxResults];
}

class FileSearchResult extends Equatable {
  final List<FileSearchMatch> matches;
  final int totalMatches;
  final int filesSearched;

  const FileSearchResult({
    required this.matches,
    required this.totalMatches,
    required this.filesSearched,
  });

  factory FileSearchResult.fromJson(Map<String, dynamic> json) {
    return FileSearchResult(
      matches: (json['matches'] as List?)
          ?.map((item) => FileSearchMatch.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      totalMatches: json['totalMatches'] as int? ?? 0,
      filesSearched: json['filesSearched'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'matches': matches.map((item) => item.toJson()).toList(),
      'totalMatches': totalMatches,
      'filesSearched': filesSearched,
    };
  }

  @override
  List<Object?> get props => [matches, totalMatches, filesSearched];
}

class FileSearchMatch extends Equatable {
  final String filePath;
  final int lineNumber;
  final int columnNumber;
  final String line;
  final String match;

  const FileSearchMatch({
    required this.filePath,
    required this.lineNumber,
    required this.columnNumber,
    required this.line,
    required this.match,
  });

  factory FileSearchMatch.fromJson(Map<String, dynamic> json) {
    return FileSearchMatch(
      filePath: json['filePath'] as String,
      lineNumber: json['lineNumber'] as int? ?? 0,
      columnNumber: json['columnNumber'] as int? ?? 0,
      line: json['line'] as String,
      match: json['match'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'filePath': filePath,
      'lineNumber': lineNumber,
      'columnNumber': columnNumber,
      'line': line,
      'match': match,
    };
  }

  @override
  List<Object?> get props => [filePath, lineNumber, columnNumber, line, match];
}

class FilePreviewRequest extends Equatable {
  final String path;
  final int? line;
  final int? limit;

  const FilePreviewRequest({
    required this.path,
    this.line,
    this.limit,
  });

  factory FilePreviewRequest.fromJson(Map<String, dynamic> json) {
    return FilePreviewRequest(
      path: json['path'] as String,
      line: json['line'] as int?,
      limit: json['limit'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      if (line != null) 'line': line,
      if (limit != null) 'limit': limit,
    };
  }

  @override
  List<Object?> get props => [path, line, limit];
}
