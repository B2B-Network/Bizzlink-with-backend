import 'package:flutter/material.dart';
import 'package:base/userid.dart';
import 'package:base/directMessagePage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'post.dart';
import 'notification.dart';
import 'searchPage.dart';
import 'homePage.dart';


void main() {
  runApp(MessagesApp());
}

class MessagesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Messages Dashboard',
      home: MessagesDashboard(),
    );
  }
}

class MessagesDashboard extends StatefulWidget {
  @override
  _MessagesDashboardState createState() => _MessagesDashboardState();
}

class _MessagesDashboardState extends State<MessagesDashboard> {

int? userId;
List<Map<String, dynamic>> followingList = [];

 @override
  void initState() {
    super.initState();
    _loadUserId(context);
  }

  Future<void> _loadUserId(BuildContext context) async {
  userId = await UserPreferences.getUserId();
  _loadFollowingList(userId);
  setState(() {}); 
}



Future<void> _loadFollowingList(userId) async {
  final response = await http.get(Uri.parse('http://172.17.73.110:3000/user/following/$userId'));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final List<Map<String, dynamic>> followers = (data['followersList'] as List)
        .map((item) => {
              'username': item?['username'] ?? '',
              'profilepicurl': item?['profilepicurl'] ?? '',
            })
        .toList();

    setState(() {
      followingList = followers;
    });
  } else {
    // Handle error
  }
}

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey[300]),
        title: Text("Messages",
        style: TextStyle(
          color: Colors.grey[300],
          fontSize:25, // Set the text color to white
        ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF0245A3),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: followingList.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> user = followingList[index];

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user["profilepicurl"]),
                  ),
                  title: Text(user["username"]),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DirectMessagePage(username: user["username"], profilepicurl: user["profilepicurl"]),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Plus',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
        ],
        selectedItemColor: Color(0xFF0245A3),
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (int index) {
          // Add navigation logic for the bottom navigation items here
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchPage(),
                ),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListPage(),
                ),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationPage(),
                ),
              );
              break;
          }
        },
      ),
    );
  }
}
