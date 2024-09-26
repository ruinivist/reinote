import 'package:yaml/yaml.dart';

import '../../utils/log.dart';

class NoteUtils {
  static Map<String, dynamic> parseNoteProperties(String markdownContent) {
    // Regular expression to match the YAML frontmatter
    final regex = RegExp(r'^---\s*\n(.*?)\n---\s*\n', dotAll: true);

    // Try to find a match in the markdown content
    final match = regex.firstMatch(markdownContent);

    // If no match is found, return an empty map
    if (match == null) {
      return {};
    }

    // Extract the YAML content
    final yamlContent = match.group(1);

    if (yamlContent == null) {
      return {};
    }

    try {
      final yamlMap = loadYaml(yamlContent);
      return Map<String, dynamic>.from(yamlMap);
    } catch (e) {
      lg.e('Error parsing YAML: $e');
      return {};
    }
  }

  static String mapToYAML(Map<String, dynamic> map) {
    final yamlMap = YamlMap.wrap(map);
    return yamlMap.toString();
  }
}

class NoteRelations {
  String? leftPath;
  String? rightPath;
  String? upPath;
  String? downPath;
  String? rootPath;

  NoteRelations({
    this.leftPath,
    this.rightPath,
    this.upPath,
    this.downPath,
    this.rootPath,
  });

  NoteRelations.fromJson(Map<String, dynamic> json)
      : leftPath = json['leftPath'],
        rightPath = json['rightPath'],
        upPath = json['upPath'],
        downPath = json['downPath'];

  Map<String, dynamic> toJson() {
    return {
      'leftPath': leftPath,
      'rightPath': rightPath,
      'upPath': upPath,
      'downPath': downPath,
      'root': rootPath,
    };
  }
}
