import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myjournalapp/data/journal_entry_model.dart';

class JournalEntryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // add new entry
  Future<void> addEntry(JournalEntry entry) async {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      throw Exception('User is not logged in');
    }

    try {
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('entries')
          .add(entry.toMap());
    } catch (e) {
      throw Exception('Failed to add new entry: $e');
    }
  }

  // get the entries
  Stream<List<JournalEntry>> getEntries() {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      return Stream.error(Exception('User is not logged in'));
    }

    try {
      return _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('entries')
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map((doc) => JournalEntry.fromFirestore(doc))
                .toList(),
          );
    } catch (e) {
      return Stream.error(Exception('Failed to get entries: $e'));
    }
  }

  // delete an entry
  Future<void> deleteEntry(String entryId) async {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      throw Exception('User is not logged in');
    }

    if (entryId.isEmpty) {
      throw Exception('Entry id is required');
    }

    try {
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('entries')
          .doc(entryId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete entry: $e');
    }
  }
}
