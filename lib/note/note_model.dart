import 'package:get/get.dart';
import 'package:local_tl_app/note/note_utils.dart';
import 'package:local_tl_app/utils/id.dart';

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
  late final String title;
  late final String content;
  late final String id;

  bool get hasRight => right is! NoNote;
  bool get hasLeft => left is! NoNote;
  bool get hasUp => up is! NoNote;
  bool get hasDown => down is! NoNote;
  Future<void> Function(String, String) write;

  NoteBase up = const NoNote();
  NoteBase down = const NoNote();
  NoteBase left = const NoNote();
  NoteBase right = const NoNote();

  String? leftId, rightId, upId, downId;

  Map<String, dynamic> properties = {};

  Note({
    required this.title,
    required this.content,
    required this.write,
  }) : id = newId();
  // todo: add check so as this doesn't overwrite existing connections
  void connectRight(Note note) {
    note.left = this;
    right = note;

    write(id, storedData());
  }

  Note.fromStoredString({required String storedData, required this.write}) {
    final (yaml, content) = NoteUtils.splitYamlAndContent(storedData);
    final properties = NoteUtils.parseYaml(yaml);
    this.properties = properties;
    id = properties['id'];

    title = properties['title'] ?? '';
    this.content = content;
    leftId = properties['left'];
    rightId = properties['right'];
    upId = properties['up'];
    downId = properties['down'];
  }

  void connectLeft(Note note) {
    note.right = this;
    left = note;

    write(id, storedData());
  }

  void connectUp(Note note) {
    note.down = this;
    up = note;

    write(id, storedData());
  }

  void connectDown(Note note) {
    note.up = this;
    down = note;

    write(id, storedData());
  }

  List<NoteBase> get neighbors => [up, down, left, right];
  List<Note> get validNeighbors => neighbors.whereType<Note>().toList();

  @override
  String toString() {
    return "$id";
  }

  String storedData() {
    final properties = NoteUtils.mapToYAML({
      'id': id,
      'title': title,
      'date': DateTime.now().toIso8601String(),
      'left': left is NoNote ? null : (left as Note).id,
      'right': right is NoNote ? null : (right as Note).id,
      'up': up is NoNote ? null : (up as Note).id,
      'down': down is NoNote ? null : (down as Note).id,
    });
    final propertiesStr = "---\n$properties---\n\n";
    return propertiesStr + content;
  }
}

class NoteFactory extends GetxController {
  static NoteFactory get to => Get.find();

  Future<void> Function(String, String) write;
  NoteFactory(this.write);

  Note newNote({
    required String title,
    required String content,
  }) {
    return Note(
      title: title,
      content: content,
      write: write,
    );
  }

  Note fromStoredString(String storedData) {
    return Note.fromStoredString(
      storedData: storedData,
      write: write,
    );
  }
}
