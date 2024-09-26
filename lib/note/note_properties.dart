import 'dart:convert';
import 'package:crypto/crypto.dart';

class NoteProperties {
  final String filename; // the filename
  final String path;
  final String? leftPath;
  final String? rightPath;
  final String? upPath;
  final String? downPath;

  NoteProperties({
    required this.filename,
    required this.path,
    this.leftPath,
    this.rightPath,
    this.upPath,
    this.downPath,
  });

  // Getter for id that computes a hash of the path
  String get id => sha256.convert(utf8.encode(path)).toString();

  // Copy constructor with optional parameter overrides
  NoteProperties copyWith({
    String? filename,
    String? path,
    String? leftPath,
    String? rightPath,
    String? upPath,
    String? downPath,
  }) {
    return NoteProperties(
      filename: filename ?? this.filename,
      path: path ?? this.path,
      leftPath: leftPath ?? this.leftPath,
      rightPath: rightPath ?? this.rightPath,
      upPath: upPath ?? this.upPath,
      downPath: downPath ?? this.downPath,
    );
  }

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'filename': filename,
      'path': path,
      'leftPath': leftPath,
      'rightPath': rightPath,
      'upPath': upPath,
      'downPath': downPath,
    };
  }

  // Create from Map
  factory NoteProperties.fromMap(Map<String, dynamic> map) {
    return NoteProperties(
      filename: map['filename'] as String,
      path: map['path'] as String,
      leftPath: map['leftPath'] as String?,
      rightPath: map['rightPath'] as String?,
      upPath: map['upPath'] as String?,
      downPath: map['downPath'] as String?,
    );
  }

  @override
  String toString() {
    return 'NoteProperties(filename: $filename, id: $id, path: $path, leftPath: $leftPath, rightPath: $rightPath, upPath: $upPath, downPath: $downPath)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NoteProperties &&
        other.filename == filename &&
        other.path == path &&
        other.leftPath == leftPath &&
        other.rightPath == rightPath &&
        other.upPath == upPath &&
        other.downPath == downPath;
  }

  @override
  int get hashCode {
    return filename.hashCode ^
        path.hashCode ^
        leftPath.hashCode ^
        rightPath.hashCode ^
        upPath.hashCode ^
        downPath.hashCode;
  }
}
