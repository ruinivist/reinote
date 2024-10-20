import 'package:local_tl_app/note/note_utils.dart';

class Point {
  final double x;
  final double y;

  Point(this.x, this.y);
}

abstract class NoteBase {
  const NoteBase();
}

class NoNote extends NoteBase {
  const NoNote();
}

class Note extends NoteBase {
  static int _nextValidId = 0;
  static int get nextValidId => _nextValidId++;

  late final String title;
  late final String content;
  final int id;

  bool get hasRight => right is! NoNote;
  bool get hasLeft => left is! NoNote;
  bool get hasUp => up is! NoNote;
  bool get hasDown => down is! NoNote;

  NoteBase up = const NoNote();
  NoteBase down = const NoNote();
  NoteBase left = const NoNote();
  NoteBase right = const NoNote();

  Note({
    required this.title,
    required this.content,
  }) : id = nextValidId;
  // todo: add check so as this doesn't overwrite existing connections
  void connectRight(Note note) {
    note.left = this;
    right = note;
  }

  Note.fromStoredString(String storedData) : id = nextValidId {
    final (yaml, content) = NoteUtils.splitYamlAndContent(storedData);
    final properties = NoteUtils.parseYaml(yaml);

    title = properties['title'] ?? '';
    this.content = content;
  }

  void connectLeft(Note note) {
    note.right = this;
    left = note;
  }

  void connectUp(Note note) {
    note.down = this;
    up = note;
  }

  void connectDown(Note note) {
    note.up = this;
    down = note;
  }

  List<NoteBase> get neighbors => [up, down, left, right];
  List<Note> get validNeighbors => neighbors.whereType<Note>().toList();

  @override
  String toString() {
    return "$id";
  }

  String storedData() {
    final properties = NoteUtils.mapToYAML({
      'title': title,
      'date': DateTime.now().toIso8601String(),
    });
    final propertiesStr = "---\n$properties---\n\n";
    return propertiesStr + content;
  }
}
