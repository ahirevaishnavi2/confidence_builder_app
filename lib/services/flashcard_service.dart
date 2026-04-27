import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/flashcard_model.dart';

class FlashcardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _uid => _auth.currentUser?.uid ?? '';

  CollectionReference get _flashcardsCollection =>
      _firestore.collection('users').doc(_uid).collection('flashcards');

  // Stream of flashcards
  Stream<List<Flashcard>> getFlashcards() {
    if (_uid.isEmpty) return Stream.value([]);
    
    return _flashcardsCollection
        .orderBy('lastReviewed', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Flashcard.fromJson({...doc.data() as Map<String, dynamic>, 'id': doc.id});
      }).toList();
    });
  }

  // Add a new flashcard
  Future<void> addFlashcard(Flashcard flashcard) async {
    if (_uid.isEmpty) return;
    await _flashcardsCollection.add(flashcard.toJson());
  }

  // Update a flashcard
  Future<void> updateFlashcard(Flashcard flashcard) async {
    if (_uid.isEmpty) return;
    await _flashcardsCollection.doc(flashcard.id).update(flashcard.toJson());
  }

  // Delete a flashcard
  Future<void> deleteFlashcard(String id) async {
    if (_uid.isEmpty) return;
    await _flashcardsCollection.doc(id).delete();
  }

  // Mark as mastered
  Future<void> markAsMastered(String id, bool isMastered) async {
    if (_uid.isEmpty) return;
    await _flashcardsCollection.doc(id).update({
      'isMastered': isMastered,
      'lastReviewed': DateTime.now().toIso8601String(),
    });
  }
}
