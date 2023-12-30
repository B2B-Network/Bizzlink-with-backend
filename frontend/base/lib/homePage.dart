import 'package:base/profile.dart';
import 'package:flutter/material.dart';
import 'post.dart';
import 'notification.dart';
import 'postdisplaypage.dart';
import 'searchPage.dart';
import 'package:base/userid.dart';
import 'package:base/directMessagePage.dart';
import 'package:base/messages.dart';
import 'package:base/userProfilePage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int? userId;
  Map<String, dynamic> posts = {};


    @override
void initState() {
  super.initState();
  _loadUserId(context);
  _fetchPosts();
}

Future<void> _fetchPosts() async {
  try {
    userId = await UserPreferences.getUserId();
    final response = await http.get(Uri.parse('http://172.17.73.110:3000/user/loadposts/$userId'));
    if (response.statusCode == 200) {
      setState(() {
        final decodedResponse = jsonDecode(response.body);
        posts = decodedResponse;
      });
    } else {
      print('Failed to load posts: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching posts: $e');
  }
}

void _handleLikeButton(int postId, int? isLiked) async {
  try {
    userId = await UserPreferences.getUserId();
    final response = await http.post(
      Uri.parse('http://172.17.73.110:3000/user/toggleLike/$postId'),
      body: {
        'isLiked': isLiked == 1 ? '0' : '1',
        'userIds': userId.toString(),
      },
    );

    if (response.statusCode == 200) {
      int postIndex = posts['posts']!.indexWhere((post) => post['postId'] == postId);

      if (postIndex != -1) {
        setState(() {
          posts['posts']![postIndex]['isLiked'] = isLiked == 1 ? 0 : 1;
        });
      } else {
        print('PostId not found in the list');
      }
    } else {
      print('Failed to toggle like: ${response.statusCode}');
    }
  } catch (e) {
    print('Error toggling like: $e');
  }
}




Future<void> _loadUserId(BuildContext context) async {
  userId = await UserPreferences.getUserId();
  setState(() {}); // Trigger a rebuild to reflect the updated userId in your UI
}


  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Color(0xFF0245A3),
      title: Text(
        "Home Page",
        style: TextStyle(
          color: Colors.grey[300],
          fontSize: 25,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            Icons.message,
            color: Colors.grey[300], // Set the color to grey[300]
          ),
          onPressed: () async {
            // Placeholder: Add logic for the message icon here
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MessagesDashboard(),
              ),
            );
          },
        ),
      ],
      leading: IconButton(
        icon: Icon(
          Icons.account_circle,
          color: Colors.grey[300],
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePage(),
            ),
          );
        },
      ),
    ),
      body: ListView.builder(
  itemCount: posts['posts']?.length ?? 0,
  itemBuilder: (context, index) {
    if (posts['posts'] == null || posts['posts']!.isEmpty) {
      // Display nothing when there are no posts
      return Container();
    }

    final post = posts['posts'][index];
    final int postId = post['postId'];
    return Column(
      children: [
        _buildPost(
          postId: postId,
          username: post['username'],
          imageUrl: post['imageurl'],
          caption: post['caption'],
          profilepicurl: post['profilepicurl'],
          isLiked:post['isLiked'],
          likeCount:post['likeCount']
        ),
        Divider(),
      ],
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

  Widget _buildPost({
  required int postId,
  required String username,
  required String imageUrl,
  required String caption,
  required String profilepicurl,
  required int? isLiked,
  required int? likeCount,
}) {
  return Padding(
    
    padding: const EdgeInsets.all(8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // User info (profile image and username) with GestureDetector
        GestureDetector(
          onTap: () {
            // Navigate to UserProfilePage when profile picture or username is tapped
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserProfilePage(username: username, profileImage: profilepicurl),
              ),
            );
          },
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                // Use a local image for the user profile
                backgroundImage: NetworkImage(profilepicurl),
              ),
              SizedBox(width: 8),
              Text(
                username,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Mplus1p',
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Text(
          caption,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Mplus1p',
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostDisplayPage(
                  postId: postId,
                  username: username,
                  imageUrl: imageUrl,
                  caption: caption,
                  profilepicurl: profilepicurl,
                  isLiked: isLiked,
                  likeCount: likeCount,
                ),
              ),
            );
          },
          child: Image.network(
            imageUrl,
            width: MediaQuery.of(context).size.width,
            height: 200.0,
            fit: BoxFit.contain,
          ),
        ),
        // Like and Message icons
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    isLiked==1 ? Icons.favorite : Icons.favorite_border,
                    color: isLiked==1 ? Colors.red : null,
                  ),
                  onPressed: () {
                   _handleLikeButton(postId, isLiked);
                  },
                ),
                SizedBox(width: 8),
                Text('Like'),
              ],
            ),
            IconButton(
                    icon: Icon(Icons.comment),
                    onPressed: () {
                      Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostDisplayPage(
                  postId: postId,
                  username: username,
                  imageUrl: imageUrl,
                  caption: caption,
                  profilepicurl: profilepicurl,
                  isLiked: isLiked,
                  likeCount: likeCount,
                ),
              ),
            );
                    },
                  ),
            IconButton(
              icon: Icon(Icons.message),
              onPressed: () {
                Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DirectMessagePage(username:username, profilepicurl:profilepicurl) ,
                      ),
                    );
              },
            ),
            
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            '${likeCount ?? 0} Likes',
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    ),
  );
}
}