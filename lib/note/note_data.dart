// // sample data to display while building ui

// // up is newer in time, kind of like twitter

// import 'note_model.dart';

// final note1 = Note(title: 'note1', content: 'description1');
// final note2 = Note(title: 'note2', content: 'description2');
// final note3 = Note(title: 'note3', content: 'description3');
// final note4 = Note(title: 'note4', content: 'description4');
// final note5 = Note(title: 'note5', content: 'description5');

// /*

// note 1

// note 2 -> note 4 -> note 5

// note 3
// */

// void connect() {
//   note1.connectDown(note2);
//   note2.connectDown(note3);
//   note2.connectRight(note4);
//   note4.connectRight(note5);

//   var cur = note3;
//   for (int i = 0; i < 1000; i++) {
//     cur.connectDown(Note(title: 'note${i + 6}', content: 'description${i + 6}'));
//     cur = cur.down as Note;
//   }
// }

// final root = note1;

// // use root as the the graph starting point