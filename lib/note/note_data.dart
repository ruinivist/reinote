// sample data to display while building ui

// up is newer in time, kind of like twitter

import 'note_model.dart';

final note1 = Note(title: 'note1', description: 'description1');
final note2 = Note(title: 'note2', description: 'description2');
final note3 = Note(title: 'note3', description: 'description3');
final note4 = Note(title: 'note4', description: 'description4');
final note5 = Note(title: 'note5', description: 'description5');

/*

note 3

note 2 -> note 4 -> note 5

note 1
*/

void connect() {
  var cur = note1;
  for (int i = 0; i < 1000; i++) {
    var next = Note(
      title: 'note${i + 6}',
      description: 'description${i + 6}',
    );
    cur.connectDown(next);
    cur = next;
  }
}

final root = note1;

// use root as the the graph starting point