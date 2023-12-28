import 'package:flutter/material.dart';

import 'post.dart';
import 'notification.dart';
import 'searchPage.dart';
import 'userProfilePage.dart'; // Update this import statement

class FollowerPage extends StatefulWidget {
  final List<Map<String, String>> followersList;
  const FollowerPage({Key? key, required this.followersList}) : super(key: key);

  @override
  State<FollowerPage> createState() => _FollowerPageState();
}

class _FollowerPageState extends State<FollowerPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0245A3), // Dark blue color for the entire app bar
        title: Text(
          'Followers',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey[300],
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      
      body: ListView.builder(
  itemCount: widget.followersList.length,
  itemBuilder: (context, index) {
    final username = widget.followersList[index]['username'];
    final profilepicurl = widget.followersList[index]['profilepicurl'];

    return Card(
      elevation: 3.0,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(3.0),
        leading: CircleAvatar(
          radius: 30.0,
          backgroundImage: profilepicurl != null
              ? NetworkImage(profilepicurl)
              : AssetImage("assets/images/profile.png") as ImageProvider<Object>?,
        ),
        title: Text(
          username ?? '',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        onTap: () {
          // Navigate to the follower's profile page and pass the follower data
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfilePage(
                username: username ?? '',
                profileImage: profilepicurl ?? 'assets/images/profile.png',
              ),
            ),
          );
        },
      ),
    );
  },
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