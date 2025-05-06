import 'dart:convert';
import 'package:app_chat/models/message.dart';
import 'package:http/http.dart' as http;

class MessageService {
  static Future<List<Message>> getMessages(String roomId) async {
    final url = Uri.parse('http://192.168.9.91:3000/messages?roomId=$roomId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      
      return data.map((json) => Message.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load messages');
    }
  }
}
