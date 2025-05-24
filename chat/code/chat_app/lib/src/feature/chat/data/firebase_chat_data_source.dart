import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import '../../../core/error/exceptions.dart';
import '../domain/message.dart';

class FirebaseChatDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String content, String senderId) async {
    try {
      if (content.isEmpty || senderId.isEmpty) {
        throw ServerException('Content or senderId cannot be empty');
      }
      await _firestore.collection('messages').add({
        'senderId': senderId,
        'content': content,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Stream<List<Message>> getMessages() {
    try {
      return _firestore
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .asMap()
              .entries
              .map((entry) {
                final index = entry.key;
                final doc = entry.value;
                final data = doc.data();
                final senderId = data['senderId'];
                final content = data['content'];

                // Skip documents with null or non-string fields
                if (senderId is! String || content is! String) {
                  debugPrint(
                      'Skipping invalid document at index $index: '
                      'senderId=$senderId, content=$content, docId=${doc.id}');
                  return null;
                }

                return Message(
                  id: doc.id,
                  senderId: senderId,
                  content: content,
                  timestamp: (data['timestamp'] as Timestamp?)?.toDate() ??
                      DateTime.now(),
                );
              })
              .where((message) => message != null)
              .cast<Message>()
              .toList());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}