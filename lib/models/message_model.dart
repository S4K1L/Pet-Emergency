import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String text;
  final String sender;
  final String senderId;
  final DateTime timestamp;
  final bool isEmergency;
  final bool isFromCurrentUser;

  Message({
    required this.id,
    required this.text,
    required this.sender,
    required this.senderId,
    required this.timestamp,
    required this.isEmergency,
    required this.isFromCurrentUser,
  });

  factory Message.fromMap(String id, Map<String, dynamic> map, String currentUserId) {
    return Message(
      id: id,
      text: map['text'] ?? '',
      sender: map['sender'] ?? 'Unknown',
      senderId: map['userId'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      isEmergency: map['isEmergency'] ?? false,
      isFromCurrentUser: map['userId'] == currentUserId,
    );
  }
}