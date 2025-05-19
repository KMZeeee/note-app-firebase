import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference notes = FirebaseFirestore.instance.collection(
    'notes',
  );

  Future<void> addNote(String note, String userId) {
    return notes.add({
      'note': note,
      'timestamp': Timestamp.now(),
      'userId': userId,
    });
  }

  Future<void> updateNote(String noteId, String newNote) {
    return notes.doc(noteId).update({
      'note': newNote,
      'timestamp': Timestamp.now(),
    });
  }

  Future<void> deleteNote(String noteId) {
    return notes.doc(noteId).delete();
  }

  Stream<QuerySnapshot> getNotes(String userId) {
    return notes.where('userId', isEqualTo: userId).snapshots();
  }
}
