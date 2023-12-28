import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:base/userid.dart';

void main() {
  runApp(MessagesApp());
}

class MessagesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Direct Messages',
    );
  }
}

class DirectMessagePage extends StatefulWidget {
  final String username;
  final String profilepicurl;
  DirectMessagePage({required this.username, required this.profilepicurl});
  
  @override
  _DirectMessagePageState createState() => _DirectMessagePageState();
}

class _DirectMessagePageState extends State<DirectMessagePage> {

  int? userId;
  int? receiverId;

  @override
void initState() {
  super.initState();
  _loadUserIdFromUsername(widget.username);
  _loadUserId(context);
}

Future<void> _loadUserId(BuildContext context) async {
  userId = await UserPreferences.getUserId();
  setState(() {}); 
}

Future<void> _loadUserIdFromUsername(String username) async {
  final response = await http.get(Uri.parse('http://192.168.1.9:3000/user/loaduseridfromusername/$username'));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    receiverId = data['receiverId'][0]['userId'];
    userId = await UserPreferences.getUserId();
    _loadMessages(userId,receiverId);
    setState(() {
    });
  } else {
    // Handle error
  }
}

void _sendMessage() async {
  String messageText = _messageController.text.trim();
  if (messageText.isNotEmpty) {
    final response = await http.post(
      Uri.parse('http://192.168.1.9:3000/user/sendmessage'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userId': userId,
        'receiverId': receiverId,
        'messageText': messageText,
      }),
    );

    if (response.statusCode == 201) {
      // Do not insert the message here, it will be added after loading messages
      _messageController.clear();

      // Call _loadMessages here to fetch the updated messages
      await _loadMessages(userId, receiverId);
    } else {
    }
  }
}



Future<void> _loadMessages(userId, receiverId) async {
    final response = await http.get(
        Uri.parse('http://192.168.1.9:3000/user/loadmessages/$userId/$receiverId'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      userId = await UserPreferences.getUserId();
      final List<Message> fetchedMessages = (data['messages'] as List)
          .map((item) => Message(text: item['messageText'],receiverId:item['receiverId'], userId:userId))
          .toList();
      setState(() {
        messages = fetchedMessages;
      });
    } else {
      // Handle error
    }
  }


  final TextEditingController _messageController = TextEditingController();
  List<Message> messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey[300]),
        title: Text(widget.username + " 's DM",
        style: TextStyle(
          color: Colors.grey[300],
          fontSize:25, // Set the text color to white
        ),
        ),
        backgroundColor: Color(0xFF0245A3),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[100],
              child: ListView.builder(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return ChatBubble(message: messages[index]);
                },
              ),
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300]!,
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              style: TextStyle(color: Colors.black),
            ),
          ),
          SizedBox(width: 8.0),
          GestureDetector(
            onTap: () {
              _sendMessage();
            },
            child: Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.blue[800], // Change to your preferred navy blue shade
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class Message {
  final String text;
  final int receiverId;
  final int userId;
  Message({required this.text, required this.receiverId, required this.userId});
}

class ChatBubble extends StatelessWidget {
  final Message message;

  ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isSentByCurrentUser = message.receiverId == message.userId;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: isSentByCurrentUser
            ? Alignment.centerLeft
            : Alignment.centerRight,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: isSentByCurrentUser ? Color(0xFF0245A3) : Colors.grey[300],
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Text(
            message.text,
            style:isSentByCurrentUser ? TextStyle(color: Colors.white) : TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}