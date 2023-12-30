import 'package:flutter/material.dart';
import 'post.dart';
import 'package:base/userid.dart';
import 'package:base/profile.dart';
import 'notification.dart';
import 'searchPage.dart';
import 'homePage.dart';
import 'directMessagePage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:base/followerPage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'postdisplaypage.dart';

Future<Map<String, dynamic>> fetchuserprofile(String username) async {
  
  //final response = await http.get(Uri.parse('http://localhost:3000/user/userprofile/$username'));
  final response = await http.get(Uri.parse('http://172.17.73.110:3000/user/userprofile/$username'));
  
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final int followers = data['followers'];
    final int following = data['following'];
    final String firstName = data['firstName'];
    final String lastName = data['lastName'];
    final String fullName = firstName + " " + lastName;
    final String email = data['email']; 
    final String city = data['city'];
    final String state = data['state'];
    final String country = data['country'];
    final String businessName = data['businessName'];
    final String category = data['category'];
    final String services = data['services'];
    final String bio = data['bio'];
    final String twitterurl = data['twitterurl'];
    final String igurl = data['igurl'];
    final String linkedinurl = data['linkedinurl'];
    final String profilepicurl = data['profilepicurl'];
    final int userId = data['userId'];
    return {'followers': followers, 'following': following, 'fullName': fullName,'email': email, 'city': city, 'state': state, 'country': country, 'businessName': businessName, 'category': category, 'services': services, 'bio': bio, 'twitterurl': twitterurl, 'igurl': igurl, 'linkedinurl': linkedinurl, 'profilepicurl': profilepicurl, 'userId' : userId};
  } else {
    throw Exception('Failed to load follow counts');
  }
}

Future<List<Map<String, String>>> fetchFollowersList(username) async {
  try {
    //final response = await http.get(Uri.parse('http://localhost:3000/user/userprofilefollowers/$username'));
    final response = await http.get(Uri.parse('http://172.17.73.110:3000/user/userprofilefollowers/$username'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> followersList = data['followersList'];
      List<Map<String, String>> followersDataList = followersList.map<Map<String, String>>((follower) {
        return {
          'username': follower['username'] as String,
          'profilepicurl': follower['profilepicurl'] as String,
        };
      }).toList();
      return followersDataList;
    } else {
      throw Exception('Failed to load followers. Status Code: ${response.statusCode}');
    }
  } catch (error) {
    print('Error fetching followers: $error');
    throw error;
  }
}

Future<List<Map<String, String>>> fetchFollowingList(username) async {
  try {
    //final response = await http.get(Uri.parse('http://localhost:3000/user/userprofilefollowing/$username'));
    final response = await http.get(Uri.parse('http://172.17.73.110:3000/user/userprofilefollowing/$username'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> followingList = data['followersList'];
      List<Map<String, String>> followingDataList = followingList.map<Map<String, String>>((follower) {
        return {
          'username': follower['username'] as String,
          'profilepicurl': follower['profilepicurl'] as String,
        };
      }).toList();
      print(followingDataList);
      return followingDataList;
    } else {
      throw Exception('Failed to load followers. Status Code: ${response.statusCode}');
    }
  } catch (error) {
    print('Error fetching followers: $error');
    throw error;
  }
}

class Post {
  final int postId;
  final String username;
  final String imageUrl;
  final String caption;
  final String profilepicurl;
  final int isLiked;
  final int likeCount;

  Post({required this.postId, required this.username, required this.imageUrl, required this.caption, required this.profilepicurl, required this.isLiked, required this.likeCount});
}

class UserPosts extends StatelessWidget {
  final List<Post> posts;

  UserPosts({required this.posts});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          '  Posts',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: PostItem(post: posts[index]),
            );
          },
        ),
      ],
    );
  }
}

class PostItem extends StatelessWidget {
  final Post post;

  PostItem({required this.post});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostDisplayPage(
                    postId: post.postId,
                    username: post.username,
                    imageUrl: post.imageUrl,
                    caption: post.caption,
                    profilepicurl: post.profilepicurl,
                    isLiked: post.isLiked,
                    likeCount: post.likeCount,
                  ),
                  ),
                );
          },
          child: Image.network(
            post.imageUrl,
            width: MediaQuery.of(context).size.width, 
            height: 200.0, 
            fit: BoxFit.contain, 
          ),
        ),
        SizedBox(height: 8),
        Text(post.caption),
        Divider(),
      ],
    );
  }
}

class UserProfilePage extends StatefulWidget {
  final String username;
  final String profileImage;
  UserProfilePage({required this.username, required this.profileImage});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage>{
  bool isFollowing = false;
  late int userId;
  late int? currentUserId;
  late List<Post> userPosts = [];

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<List<Post>> fetchUserPostsByUsername(String username) async {
  try {
    final response = await http.get(Uri.parse('http://172.17.73.110:3000/user/loaduserposts/$username'));
    if (response.statusCode == 200) {
      final List<dynamic> postsList = json.decode(response.body)['posts'];
      List<Post> postsDataList = postsList.map<Post>((post) {
        return Post(
          postId: post['postId'],
          username: post['username'] as String,
          imageUrl: post['imageurl'] as String,
          caption: post['caption'] as String,
          profilepicurl: post['profilepicurl'],
          isLiked: post['isLiked'],
          likeCount: post['likeCount']
        );
      }).toList();
      return postsDataList;
    } else {
      throw Exception('Failed to load posts. Status Code: ${response.statusCode}');
    }
  } catch (error) {
    print('Error fetching posts: $error');
    throw error;
  }
}

Future<void> fetchUserProfile() async {
  try {
    final Map<String, dynamic> userProfile = await fetchuserprofile(widget.username);
    userId = userProfile['userId'] as int;
    currentUserId = await UserPreferences.getUserId();
    if (currentUserId == userId) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => ProfilePage(),
        ),
      );
    }
    await checkFollowingStatus(userId);
    final posts = await fetchUserPostsByUsername(widget.username);
    setState(() {
      userPosts = posts;
    });
  } catch (error) {
    print('Error fetching user profile: $error');
  }
}


  Future<void> checkFollowingStatus(int userId) async {
    try {
      final currentUserId = await UserPreferences.getUserId();
      final response = await http.get(Uri.parse('http://172.17.73.110:3000/user/checkfollowing/$currentUserId?userId=$userId'));
      if (response.statusCode == 200) {
        final String status = response.body;
        setState(() {
          isFollowing = status.toLowerCase() == 'yes';
        });
      } else {
        print('Failed to check following status. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error checking following status: $error');
    }
  }
  
  Widget build(BuildContext context) {
    
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0245A3),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.grey[300]),
        title: Text(widget.username + " 's profile",
        style: TextStyle(
          color: Colors.grey[300],
          fontSize:25, // Set the text color to white
        ),
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: FutureBuilder<Map<String, dynamic>>( 
            future: fetchuserprofile(widget.username),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData) {
                return Text('No data available');
              } else {
                final followersCount = snapshot.data!['followers'];
                final followingCount = snapshot.data!['following'];
                final fullName = snapshot.data!['fullName'];
                final email = snapshot.data!['email'];
                final city = snapshot.data!['city'];
                final state = snapshot.data!['state'];
                final country = snapshot.data!['country'];
                final businessName = snapshot.data!['businessName'];
                final category = snapshot.data!['category'];
                final services = snapshot.data!['services'];
                final bio = snapshot.data!['bio'];
                final twitterurl = snapshot.data!['twitterurl'];
                final igurl = snapshot.data!['igurl'];
                final linkedinurl = snapshot.data!['linkedinurl'];
                final profilepicurl = snapshot.data!['profilepicurl'];
                final userId = snapshot.data!['userId'];
                
                return Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Circular profile picture
                        Container(
                    margin: EdgeInsets.only(top: 20, left: 115),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.indigo,  // You can specify the color of the border here
                        width: 4.0,           // You can specify the width of the border here
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: profilepicurl != ""
                ? NetworkImage(profilepicurl)
                : AssetImage("assets/images/profile.png") as ImageProvider<Object>?,
                    ),
                  ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.username,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              // Navigate to the Following page
                              final followingList = await fetchFollowingList(widget.username);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FollowerPage(followersList: followingList),
                                ),
                              );
                            },
                          child: Container(
                            padding: EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.indigo, width: 5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Following :    ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.indigo,
                                  ),
                                ),
                                Text(
                                  '$followingCount',
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            // Navigate to the Followers page
                            final followersList = await fetchFollowersList(widget.username);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FollowerPage(followersList: followersList),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.indigo, width: 5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Followers :    ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.indigo,
                                  ),
                                ),
                                Text(
                                  '$followersCount',
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                        Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Positioned(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                  ),
                                  onPressed: () async {
                                     await checkFollowingStatus(userId);
                                      if (!isFollowing) {
                                        final currentUserId = await UserPreferences.getUserId();
                                        final response = await http.get(Uri.parse('http://172.17.73.110:3000/user/followuser/$currentUserId?userId=$userId'));
                                        if (response.body == 'yes') {
                                            Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                builder: (BuildContext context) => UserProfilePage(username: widget.username, profileImage: widget.profileImage),
                                              ),
                                            );
                                          }
                                        } else {
                                        final currentUserId = await UserPreferences.getUserId();
                                        final response = await http.get(Uri.parse('http://172.17.73.110:3000/user/unfollowuser/$currentUserId?userId=$userId'));
                                        if(response.body=='yes')
                                        {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                builder: (BuildContext context) => UserProfilePage(username: widget.username, profileImage: widget.profileImage),
                                              ),
                                            );
                                          }
                                        } 
                                  },
                                  child: Text(
                                    isFollowing ? "Unfollow" : "Follow",
                                    style: TextStyle(
                                      fontFamily: 'Mplus1p',
                                      fontSize: 18,
                                      color: Colors.indigo,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Positioned(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                  ),
                                  onPressed: () async {
    // Navigate to the DirectMessagePage and pass parameters
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DirectMessagePage(
          username: widget.username,
          profilepicurl: widget.profileImage,
        ),
      ),
    );
  },
                                  child: Text(
                                    "Message",
                                    style: TextStyle(
                                      fontFamily: 'Mplus1p',
                                      fontSize: 18,
                                      color: Colors.indigo,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Divider(),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            child: Text(
                              'Name: $fullName',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Mplus1p',
                              ),
                            ),
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            child: Text(
                              'Bio: $bio',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Mplus1p',
                              ),
                            ),
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            child: Text(
                              'Business Name: $businessName',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Mplus1p',
                              ),
                            ),
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            child: Text(
                              'Email: $email',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Mplus1p',
                              ),
                            ),
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            child: Text(
                              'City: $city',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Mplus1p',
                              ),
                            ),
                          ),
                        ),
                       Divider(),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            child: Text(
                              'State: $state',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Mplus1p',
                              ),
                            ),
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            child: Text(
                              'Country: $country',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Mplus1p',
                              ),
                            ),
                          ),
                        ),
                       Divider(),

                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            child: Text(
                              'Services: $services',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Mplus1p',
                              ),
                            ),
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            child: Text(
                              'Category: $category',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Mplus1p',
                              ),
                            ),
                          ),
                        ),
                        Divider(),

                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 20),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Social Media Accounts: ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Mplus1p',
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                SocialMediaIcon(
                                  iconAsset: 'assets/icons/linkedin.png',
                                  onTap: () {
                                    // Handle the link to the LinkedIn profile
                                    _launchSocialMedia(
                                        linkedinurl);
                                  },
                                ),
                                SizedBox(width: 10),
                                SocialMediaIcon(
                                  iconAsset: 'assets/icons/twitter.png',
                                  onTap: () {
                                    // Handle the link to the Twitter profile
                                    _launchSocialMedia(twitterurl);
                                  },
                                ),
                                SizedBox(width: 10),
                                SocialMediaIcon(
                                  iconAsset: 'assets/icons/instagram.png',
                                  onTap: () {
                                    // Handle the link to the Instagram profile
                                    _launchSocialMedia(
                                        igurl);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Divider(thickness:4, color:Colors.grey[400]),
                        UserPosts(posts: userPosts),
                      ],
                    ),
                  ],
                );
              }
            },
          ),
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

void _launchSocialMedia(String url) async {
  try {
    await launchUrl(Uri.parse(url));
  } catch (e) {
    print('Error launching URL: $e');
  }
}
}

class SocialMediaIcon extends StatelessWidget {
  final String iconAsset;
  final VoidCallback onTap;

  SocialMediaIcon({required this.iconAsset, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        iconAsset,
        width: 40,
        height: 40,
      ),
    );
  }

}