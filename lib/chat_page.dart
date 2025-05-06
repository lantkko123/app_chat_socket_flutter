import 'dart:async';
import 'package:app_chat/api/message_api.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketChatPage extends StatefulWidget {
  final String roomId;
  final String Username;

  SocketChatPage({required this.roomId, required this.Username});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<SocketChatPage> {
  late IO.Socket socket;
  List<Map<String, String>> messages = [];
  final TextEditingController _controller = TextEditingController();
  Timer? _typingTimer;
  bool isSomeoneTyping = false;
  String typingUser = "";

  @override
  void initState() {
    super.initState();
    connectToServer();
  }

  void getallmessages() async {
    try {
      final response = await MessageService.getMessages(widget.roomId);
      setState(() {
        messages = response.map((msg) {
          return {
            "msg": msg.message,
            "userID": msg.id,
            "sender": msg.sender,
          };
        }).toList();
      });
    } catch (e) {
      debugPrint('Error fetching messages: $e');
    }
  }

  void connectToServer() {
    socket = IO.io('http://192.168.9.91:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();
    socket.onConnect((_) {
      debugPrint('connected to server ${socket.id}');
      socket.emit('join_room', widget.roomId);
      debugPrint('joined room: ${widget.roomId}');
      
      getallmessages();
    });

    socket.on('user_typing', (data) {
      setState(() {
        isSomeoneTyping = true;
        typingUser = data['sender'];
      });
      debugPrint('user typing: ${data['sender']}');
    });

    socket.on('user_stop_typing', (data) {
      setState(() {
        isSomeoneTyping = false;
        typingUser = "";
      });
    });

    socket.on('receive_message', (data) {
      setState(() {
        messages.add({
          "msg": data["message"],
          "userID": data["userID"],
          "sender": data["sender"]
        });
      });
      debugPrint('message received: ${data["userID"]} ${data["message"]} from ${data["sender"]}');
    });
  }

  void sendMessage() async {
    if (_controller.text.trim().isEmpty) return;
    socket.emit('send_message', {
      'roomId': widget.roomId,
      'userID': socket.id,
      'message': _controller.text,
      'sender': widget.Username,
    });
    _controller.clear();
  }

  @override
  void dispose() {
    socket.disconnect();
    _controller.dispose();
    super.dispose();
  }

  Widget _buildMessage(Map<String, String> message, bool isUserid) {
    final alignment = isUserid ? Alignment.centerRight : Alignment.centerLeft;
    final color = isUserid ? Colors.blue[100] : Colors.grey[300];
    final textColor = isUserid ? Colors.black87 : Colors.black87;
    
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Column(
        crossAxisAlignment: isUserid ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isUserid) 
            Text(
              message["sender"] ?? "Unknown",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          Container(
            margin: EdgeInsets.only(top: 2),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              message["msg"] ?? "",
              style: TextStyle(color: textColor),
            ),
          ),
        ],
      ),
      alignment: alignment,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Group Chat: ${widget.roomId}')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return _buildMessage(messages[index], messages[index]["userID"] == socket.id);
              },
            ),
          ),
          if (isSomeoneTyping)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('$typingUser is typing...'),
              ),
            ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (_controller) {
                      socket.emit('typing', {
                        'roomId': widget.roomId,
                        'sender': widget.Username,
                      });
                      _typingTimer?.cancel();
                      _typingTimer = Timer(Duration(seconds: 2), () {
                        socket.emit('stop_typing', {
                          'roomId': widget.roomId,
                          'sender': widget.Username,
                        });
                      });
                    },
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Enter message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => sendMessage(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
