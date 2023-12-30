import 'package:flutter/material.dart';
import 'package:base/directMessagePage.dart';
import 'package:http/http.dart' as http;
import 'package:base/userid.dart';
import 'dart:convert';
import 'post.dart';
import 'notification.dart';
import 'homePage.dart';
import 'searchPage.dart';
import 'package:base/userProfilePage.dart';

class PostDisplayPage extends StatefulWidget {
  final int postId;
  final String username;
  final String imageUrl;
  final String caption;
  final String profilepicurl;
  final int? isLiked;
  final int? likeCount;

  PostDisplayPage({
    required this.postId,
    required this.username,
    required this.imageUrl,
    required this.caption,
    required this.profilepicurl,
    required this.isLiked,
    required this.likeCount,
  });

  @override
  _PostDisplayPageState createState() => _PostDisplayPageState();
}

class _PostDisplayPageState extends State<PostDisplayPage> {
  int? userId;
  int? _isLiked;
  List<Comment> comments = [];
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserId(context);
    _isLiked = widget.isLiked;
    _fetchComments();
  }

  Future<void> _loadUserId(BuildContext context) async {
    userId = await UserPreferences.getUserId();
    setState(() {});
  }

Future<void> _fetchComments() async {
  try {
    final response = await http.get(
      Uri.parse('http://172.17.73.110:3000/user/loadcomments/${widget.postId}'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonComments = jsonDecode(response.body);
      setState(() {
        comments = List<Comment>.from(
          jsonComments.map((comment) => Comment.fromJson(comment)),
        );
      });
    } else {
      print('Failed to fetch comments: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching comments: $e');
  }
}


  void _handleLikeButton() async {
    try {
      final response = await http.post(
        Uri.parse('http://172.17.73.110:3000/user/toggleLike/${widget.postId}'),
        body: {
          'isLiked': _isLiked == 1 ? '0' : '1',
          'userIds': userId.toString(),
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _isLiked = _isLiked == 1 ? 0 : 1;
        });
      } else {
        print('Failed to toggle like: ${response.statusCode}');
      }
    } catch (e) {
      print('Error toggling like: $e');
    }
  }

void _postComment() async {
  String commentText = commentController.text.trim();
  if (commentText.isNotEmpty) {
    try {
      final response = await http.post(
        Uri.parse('http://172.17.73.110:3000/user/postcomment'),
        body: {
          'userId': userId.toString(),
          'postId': widget.postId.toString(),
          'commentText': commentText,
        },
      );
      if (response.statusCode == 200) {
        // Reload comments after successfully posting
        _fetchComments();
        setState(() {});
      } else {
        print('Failed to post comment: ${response.statusCode}');
      }
    } catch (e) {
      print('Error posting comments: $e');
    }
    commentController.clear();
  }
}


void _deleteComment(commentId) async {
  try {
    final response = await http.post(
      Uri.parse('http://172.17.73.110:3000/user/deletecomment/$commentId'),
    );

    if (response.statusCode == 200) {
      setState(() {
        comments.removeWhere((comment) => comment.commentId == commentId);
      });
    } else {
      print('Failed to delete comment: ${response.statusCode}');
    }
  } catch (e) {
    print('Error deleting comment: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey[300]),
        title: Text(
          "${widget.username}'s post",
          style: TextStyle(
            color: Colors.grey[300],
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF0245A3),
      ),
      body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfilePage(
                      username: widget.username,
                      profileImage: widget.profilepicurl,
                    ),
                  ),
                );
              },
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(widget.profilepicurl),
                  ),
                  SizedBox(width: 8),
                  Text(
                    widget.username,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Mplus1p',
                    ),
                  ),
                ],
              ),
            ),
          ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.caption,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Mplus1p',
                ),
              ),
            ),
            Image.network(
              widget.imageUrl,
              width: MediaQuery.of(context).size.width,
              height: 200.0,
              fit: BoxFit.contain,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          _isLiked == 1
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: _isLiked == 1 ? Colors.red : null,
                        ),
                        onPressed: () {
                          _handleLikeButton();
                        },
                      ),
                      SizedBox(width: 8),
                      Text('Like'),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.comment),
                    onPressed: () {

                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.message),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DirectMessagePage(
                            username: widget.username,
                            profilepicurl: widget.profilepicurl,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                '${widget.likeCount ?? 0} Likes',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Comments Section',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: commentController,
                            decoration: InputDecoration(
                              hintText: 'Add a comment...',
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.send),
                          onPressed: _postComment,
                        ),
                      ],
                    ),
                  ),


            ListView.builder(
  shrinkWrap: true,
  itemCount: comments.length,
  itemBuilder: (context, index) {
    Comment comment = comments[index];
    int? commentuserId = int.tryParse(comment.commentuserIds);
    bool isCurrentUserComment = commentuserId == userId;

    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(comment.profilePicUrl),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${comment.username} : ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              comment.commentText,
              textAlign: TextAlign.left,
            ),
          ),
          if (isCurrentUserComment)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _deleteComment(comment.commentId);
              },
            ),
        ],
      ),
      subtitle: Text(
        comment.commentDate,
        textAlign: TextAlign.right,
        style: TextStyle(
          fontSize: 12,
        ),
      ),
    );
  },
),

          ],
        ),
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

class Comment {
  final int commentId;
  final String username;
  final String profilePicUrl;
  final String commentText;
  final String commentDate;
  final String commentuserIds;

  Comment({
    required this.commentId,
    required this.username,
    required this.profilePicUrl,
    required this.commentText,
    required this.commentDate,
    required this.commentuserIds,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentId: json['commentId'],
      username: json['username'],
      profilePicUrl: json['profilepicurl'],
      commentText: json['commentText'],
      commentDate: json['commentDate'],
      commentuserIds: json['userId'].toString(),
    );
  }
}
