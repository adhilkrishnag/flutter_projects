import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class ChatRepository {
  final CollectionReference _messagesCollection;

  ChatRepository()
      : _messagesCollection =
            FirebaseFirestore.instance.collection('messages') {
    try {
      debugPrint('Initializing ChatRepository');
      FirebaseFirestore.instance.settings =
          const Settings(persistenceEnabled: true);
      debugPrint('Firestore settings applied successfully');
    } catch (e) {
      debugPrint('Firestore settings initialization failed: $e');
      rethrow;
    }
  }

  // One-time fetch (unchanged)
  Future<List<QueryDocumentSnapshot>> getMessages() async {
    try {
      debugPrint('Fetching messages from Firestore');
      final snapshot = await _messagesCollection
          .orderBy('timestamp', descending: true)
          .get();
      debugPrint('Messages fetched successfully: ${snapshot.docs.length}');
      return snapshot.docs;
    } catch (e) {
      debugPrint('Failed to get messages: $e');
      rethrow;
    }
  }

  // Real-time stream
  Stream<List<QueryDocumentSnapshot>> getMessagesStream() {
    try {
      debugPrint('Starting messages stream');
      return _messagesCollection
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) {
        debugPrint('Received stream update: ${snapshot.docs.length} messages');
        return snapshot.docs;
      });
    } catch (e) {
      debugPrint('Failed to start messages stream: $e');
      rethrow;
    }
  }

  Future<void> sendMessage({
    required String text,
    required String senderId,
    required String senderEmail,
  }) async {
    try {
      debugPrint('Sending message: $text');
      await _messagesCollection.add({
        'text': text,
        'senderId': senderId,
        'senderEmail': senderEmail,
        'timestamp': FieldValue.serverTimestamp(),
      });
      debugPrint('Message sent successfully');
    } catch (e) {
      debugPrint('Failed to send message: $e');
      rethrow;
    }
  }
}
