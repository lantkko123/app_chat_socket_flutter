class Message {
  final String id;
  final String message;
  final String receiverId;
  final DateTime sentAt;
  Message({
    required this.id,
    required this.message,
    required this.receiverId,
    required this.sentAt,
    
  });
  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'message': message,
      'receiverId': receiverId,
      'sentAt': sentAt.toIso8601String(),
    };
  }
}
  

  

  