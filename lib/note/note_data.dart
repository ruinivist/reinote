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
  note1.connectUp(note2);
  note2.connectUp(note3);
  note2.connectRight(note4);
  note4.connectRight(note5);
}

final root = note1;

// use root as the the graph starting point