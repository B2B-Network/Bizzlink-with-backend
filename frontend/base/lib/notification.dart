import 'package:flutter/material.dart';
import 'package:base/userid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'post.dart';
import 'searchPage.dart';
import 'homePage.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  int? userId;
  List<NotificationData> notifications = [];

  @override
  void initState() {
    super.initState();
    _loadUserId(context);
  }

  Future<void> _loadUserId(BuildContext context) async {
    userId = await UserPreferences.getUserId();
    _loadNotifications();
    setState(() {}); // Trigger a rebuild to reflect the updated userId in your UI
  }

  Future<void> _loadNotifications() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.9:3000/user/loadnotifications/$userId'),
        // Replace with your server endpoint to fetch notifications
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        List<NotificationData> loadedNotifications =
            data.map<NotificationData>((notification) {
          return NotificationData(
            id: notification['notificationId'],
            userId: notification['userId'],
            text: notification['notificationText'],
            creationDate: DateTime.parse(notification['creationDate']),
          );
        }).toList();

        setState(() {
          notifications = loadedNotifications;
        });
      } else {
        // Handle error
        print('Failed to load notifications. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle error
      print('Error loading notifications: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0245A3),
        iconTheme: IconThemeData(color: Colors.grey[300]),
        title: Text("Notifications",
        style: TextStyle(
          color: Colors.grey[300],
          fontSize:25, // Set the text color to white
        ),
        ),
      ),
      body: Container(
        color: Colors.white, // White
        padding: EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            return _buildNotificationCard(
              notifications[index].text,
              notifications[index].creationDate,
            );
          },
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
        selectedItemColor: Colors.blue[800], // Dark Blue
        unselectedItemColor: Colors.grey,
        currentIndex: 3, // Set the index corresponding to the 'Notification' tab
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
              // Already on the NotificationPage
              break;
          }
        },
      ),
    );
  }
  }

Widget _buildNotificationCard(String message, DateTime creationDate) {
  final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(creationDate.toLocal());
  return Card(
    elevation: 3.0,
    margin: EdgeInsets.symmetric(vertical: 8.0),
    child: ListTile(
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0, // Adjust the font size as needed
            ),
          ),
          SizedBox(height: 8),
          Text(
            formattedDate,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    ),
  );
}

class NotificationData {
  final int id;
  final int userId;
  final String text;
  final DateTime creationDate;

  NotificationData({
    required this.id,
    required this.userId,
    required this.text,
    required this.creationDate,
  });
}

void main() {
  runApp(
    MaterialApp(
      home: NotificationPage(),
    ),
  );
}
