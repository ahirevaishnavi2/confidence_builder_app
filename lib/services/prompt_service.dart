import 'package:cloud_firestore/cloud_firestore.dart';

class PromptService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetches prompts for a given type ('speech' or 'writing')
  Future<List<String>> getPrompts(String type) async {
    try {
      final doc = await _firestore.collection('prompts').doc(type).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        if (data['items'] != null) {
          return List<String>.from(data['items']);
        }
      }
    } catch (e) {
      print('Error fetching prompts for $type: $e');
    }
    return [];
  }
}
