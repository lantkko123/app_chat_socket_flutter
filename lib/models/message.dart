class Message {
  final String id;
  final String message;
  final String sender;
  final DateTime sentAt;

  Message({
    required this.id,
    required this.message,
    required this.sender,
    required this.sentAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'room_id': id,
      'sender': sender,
      'message': message,
      'timestamp': sentAt.toIso8601String(),
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['room_id'] ?? '', 
      message: json['message'] ?? '',
      sender: json['sender'] ?? '',
      sentAt: DateTime.parse(json['timestamp']),
    );
  }
}
