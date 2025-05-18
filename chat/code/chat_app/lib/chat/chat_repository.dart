import 'package:cloud_firestore/cloud_firestore.dart';

// Repository for handling chat operations
class ChatRepository {
  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Send a message to Firestore
  Future<void> sendMessage(String text, String senderId, String senderEmail) async {
    try {
      await _firestore.collection('messages').add({
        'text': text,
        'senderId': senderId,
        'senderEmail': senderEmail,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  // Stream of messages from Firestore, ordered by timestamp
  Stream<QuerySnapshot> getMessages() {
    return _firestore
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}