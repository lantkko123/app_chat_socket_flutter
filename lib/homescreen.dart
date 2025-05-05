import 'package:app_chat/chat_page.dart';
import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat App'),
      ),
      body: Center(
        
        child: SizedBox(
          height: 300,
          width: 400,
          
          child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            
            const Text(
              'Enter your username to join a chat room',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(hintText: 'Enter your username',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Colors.blue, width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              ),
              
              
            ),
             ElevatedButton(
              onPressed: () {
                if(_controller.text != '') {Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SocketChatPage(roomId: 'room1', Username: _controller.text,),
                  ),
                );} 
              },
              child: const Text('Join Chat Room'),
            ),
          ],
        ),) 
      ),
    );
  }
}