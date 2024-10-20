import 'package:yaml/yaml.dart';

import '../../utils/log.dart';

class NoteUtils {
  static (String, String) splitYamlAndContent(String markdownContent) {
    // Regular expression to match the YAML frontmatter
    final yamlPattern = RegExp(
      r'^---\s*\n([\s\S]+?)\n---\s*\n([\s\S]*)',
      multiLine: true,
    );

    // Use the regex to extract the YAML part and the content
    final match = yamlPattern.firstMatch(markdownContent);

    // If there's a match, extract YAML and content
    if (match != null) {
      String yaml = match.group(1)?.trim() ?? '';
      String content = match.group(2)?.trim() ?? '';
      return (yaml, content);
    }

    // If there's no match, return empty YAML and the whole content
    return ('', markdownContent);
  }

  static Map<String, dynamic> parseYaml(String yamlString) {
    if (yamlString.isEmpty) {
      return {};
    }

    final yamlMap = loadYaml(yamlString);
    return Map<String, dynamic>.from(yamlMap);
  }

  static String mapToYAML(Map<String, String> map) {
    final yamlMap = YamlMap.wrap(map);
    String yamlString = '';
    for (final key in yamlMap.keys) {
      yamlString += '$key: ${yamlMap[key]}\n';
    }
    return yamlString;
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
