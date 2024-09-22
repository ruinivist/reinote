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
  final String title;
  final String description;

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
    required this.description,
  });

  // todo: add check so as this doesn't overwrite existing connections
  void connectRight(Note note) {
    note.left = this;
    right = note;
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
}
