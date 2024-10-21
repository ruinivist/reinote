import 'dart:collection';
import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_tl_app/controllers/filesystem.dart';
import 'package:local_tl_app/controllers/position_controller.dart';
import 'package:local_tl_app/note/note_data.dart';
import 'package:local_tl_app/utils/log.dart';
import 'package:path/path.dart' as path;

import '../note/note_model.dart';

enum Direction { up, down, left, right, none }

class NoteController extends GetxController {
  static NoteController get to => Get.find();

  Note? _end;
  Note? _root;
  bool get hasNotes => _root != null;

  void debugInitWithOneNote(Note note) {
    _root = note;
    _end = note;
    PositionController.to.resetSource(note);
  }

  // void debugInitWithSeedNote() {
  //   _root = root;
  //   PositionController.to.resetSource(_root!, Position.zero);
  // }

  Future<void> addNote(Note note, {Direction? dir, Note? addTo, devAddAsRoot = false}) async {
    assert(dir != null && addTo != null || dir == null && addTo == null, "If dir is null, addTo must be null");

    if (devAddAsRoot || _root == null) {
      //delete all
      await deleteAllFiles();
      await createNewFile(note.title, note.storedData());

      _root = note;
      _end = _root;

      PositionController.to.resetAndMarkSelected(note);
      return;
    }

    bool baseChain = addTo == null;
    assert(_end != null, "_end cannot be null if root is not null");
    addTo ??= _end;

    Note end = addTo!;

    if (dir == Direction.up) {
      end.connectUp(note);
      note.connectDown(end);
    } else if (dir == Direction.down) {
      end.connectDown(note);
      note.connectUp(end);
    } else if (dir == Direction.left) {
      end.connectLeft(note);
      note.connectRight(end);
    } else if (dir == Direction.right) {
      end.connectRight(note);
      note.connectLeft(end);
    }

    if (baseChain) _end = note;

    PositionController.to.resetAndMarkSelected(note);
  }

  Future<void> editNote(Note oldNote, Note newNote) async {
    await deleteFile(oldNote.title);
    await createNewFile(newNote.title, newNote.storedData());

    // TODO: same connections
    // oldNote.disconnect();
    // newNote.connect(oldNote);

    if (oldNote == _root) {
      _root = newNote;
    }
    if (oldNote == _end) {
      _end = newNote;
    }

    PositionController.to.resetAndMarkSelected(newNote);
  }

  Future<Note?> buildNoteChain() async {
    final allNotes = await readAllNotes();

    if (allNotes.isEmpty) {
      return null;
    }

    final notes = <String, Note>{};
    for (final note in allNotes) {
      notes[note.id] = note;
    }

    final rootNoteId = allNotes.first.id;
    final rootNote = notes[rootNoteId]!;

    // bfs from rootNote
    final q = Queue<Note>();
    Set<String> visited = {};
    q.add(rootNote);

    while (q.isNotEmpty) {
      final cur = q.removeFirst();

      visited.add(cur.id);

      if (cur.upId != null && !visited.contains(cur.upId)) {
        final upNote = notes[cur.upId!]!;

        cur.connectUp(upNote);
        upNote.connectDown(cur);

        q.add(upNote);
      }

      if (cur.downId != null && !visited.contains(cur.downId)) {
        final downNote = notes[cur.downId!]!;
        cur.connectDown(downNote);
        downNote.connectUp(cur);

        q.add(downNote);
      }

      if (cur.leftId != null && !visited.contains(cur.leftId)) {
        final leftNote = notes[cur.leftId!]!;
        cur.connectLeft(leftNote);
        leftNote.connectRight(cur);

        q.add(leftNote);
      }

      if (cur.rightId != null && !visited.contains(cur.rightId)) {
        final rightNote = notes[cur.rightId!]!;
        cur.connectRight(rightNote);
        rightNote.connectLeft(cur);

        q.add(rightNote);
      }
    }

    return rootNote;
  }

  final localStore = GetStorage();
  final kVaultPath = 'vaultPath';

  String? _vaultPath;
  String? get vaultPath => _vaultPath;
  bool get hasVault => _vaultPath != null;

  set vaultPath(String? value) {
    _vaultPath = value;
    localStore.write(kVaultPath, value);
    lg.i('Vault path set to: $value');
    ensureVaultDirectory();
  }

  late Directory _vaultDirectory;

  @override
  void onInit() {
    super.onInit();
    _vaultPath = localStore.read<String>(kVaultPath);
    lg.i('Vault path: $_vaultPath');
    if (_vaultPath != null) {
      ensureVaultDirectory();
    }

    buildNoteChain().then((value) {
      if (value != null) {
        _root = value;

        Note cur = _root!;
        while (cur.hasUp) {
          cur = cur.up as Note;
        }
        _end = cur;

        PositionController.to.resetSource(_root!);
      }
    });
  }

  void ensureVaultDirectory() {
    if (_vaultPath == null) {
      throw Exception('Vault path is not set');
    }

    if (!Directory(_vaultPath!).existsSync()) {
      Directory(_vaultPath!).createSync(recursive: true);
    }
    _vaultDirectory = Directory(_vaultPath!);
  }

  Future<void> createNewFile(String fileName, String content) async {
    final file = File(path.join(_vaultDirectory.path, fileName));
    await file.create(exclusive: true); // throws if file already exists
    await file.writeAsString(content);
  }

  Future<List<Note>> readAllNotes() async {
    final files = await _vaultDirectory.list().toList();
    final notes = <Note>[];
    for (final file in files) {
      if (file is File) {
        final content = await file.readAsString();
        notes.add(NoteFactory.to.fromStoredString(content));
      }
    }
    return notes;
  }

  Future<void> deleteAllFiles() async {
    await _vaultDirectory.delete(recursive: true);
    await _vaultDirectory.create();
  }

  Future<void> deleteFile(String fileName) async {
    final file = File(path.join(_vaultDirectory.path, fileName));
    await file.delete();
  }

  Future<void> writeToFile(String fileName, String content) async {
    final file = File(path.join(_vaultDirectory.path, fileName));
    await file.writeAsString(content);
  }
}
