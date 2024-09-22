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
  final NoteBase next;

  bool get hasNext => next is! NoNote;

  Note({
    required this.title,
    required this.description,
    this.next = const NoNote(),
  });
}

Note _someNext = Note(
  title: 'Some next',
  description: 'Some next description',
  next: NoNote(),
);

Note root = Note(
  title: 'Root',
  description: 'Root description',
  next: _someNext,
);
