import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String senderId;
  final String content;
  final DateTime timestamp;
  final String? documentId; 

  Chat({
    required this.senderId,
    required this.content,
    required this.timestamp,
    this.documentId, 
  });

  factory Chat.fromMap(Map<String, dynamic> map, String documentId) {
    return Chat(
      senderId: map['senderId'],
      content: map['content'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      documentId: documentId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'content': content,
      'timestamp': timestamp,
    };
  }
}
