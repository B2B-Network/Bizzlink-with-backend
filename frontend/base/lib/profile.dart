import 'package:flutter/material.dart';
import 'package:base/userid.dart';
import 'post.dart';
import 'notification.dart';
import 'searchPage.dart';
import 'homePage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:base/update.dart';
import 'package:base/followerPage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'postdisplaypage.dart';

// Replace with your actual data fetching function
Future<Map<String, dynamic>> fetchFollowCounts(int userId) async {
  //final response = await http.get(Uri.parse('http://localhost:3000/user/profile/$userId'));
  final response = await http.get(Uri.parse('http://172.17.73.110:3000/user/profile/$userId'));
  
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final int followers = data['followers'];
    final int following = data['following'];
    final String username = data['username'];
    final String firstName = data['firstName'];
    final String lastName = data['lastName'];
    final String countryCode = data['countryCode'];
    final String mobileNumber = data['mobileNumber'];
    final String email = data['email'];
    final String dateOfBirth  = data['dateOfBirth'];
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

    return {'followers': followers, 'following': following, 'username': username, 'firstName': firstName, 'lastName': lastName, 'countryCode': countryCode, 'mobileNumber': mobileNumber, 'email': email, 'dateOfBirth': dateOfBirth, 'city': city, 'state': state, 'country': country, 'businessName': businessName, 'category': category, 'services': services, 'bio': bio, 'twitterurl': twitterurl, 'igurl': igurl, 'linkedinurl': linkedinurl, 'profilepicurl': profilepicurl};
  } else {
    throw Exception('Failed to load follow counts');
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
        // Use ListView.builder for scrolling
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
        Stack(
          alignment: Alignment.topRight,
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
            PopupMenuButton<String>(
              icon: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue[900],
                ),
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
              ),
              onSelected: (value) async {
                if (value == 'delete') {
                } else if (value == 'update') {
                }
              },
              itemBuilder: (BuildContext context) {
                return ['Delete Post', 'Edit Post'].map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice.toLowerCase().replaceAll(' ', '_'),
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(post.caption),
        Divider(),
      ],
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int? userId;
  late List<Post> userPosts = [];

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController countryCodeController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController businessNameController = TextEditingController();
  TextEditingController servicesController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController countryController = TextEditingController();

  @override
void initState() {
  super.initState();
  _loadUserId(context);
}

Future<List<Post>> fetchUserPostsByUserId() async {
  try {
    userId = await UserPreferences.getUserId();
    final response = await http.get(Uri.parse('http://172.17.73.110:3000/user/loadcurrentuserposts/$userId'));
    if (response.statusCode == 200) {
      final dynamic responseData = json.decode(response.body);
      if (responseData['posts'][0]['postId'] != null) {
        final List<dynamic> postsList = responseData['posts'];
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
        return [];
      }
    } else {
      throw Exception('Failed to load posts. Status Code: ${response.statusCode}');
    }
  } catch (error) {
    print('Error fetching posts: $error');
    throw error;
  }
}


Future<void> _loadUserId(BuildContext context) async {
  userId = await UserPreferences.getUserId();
  final posts = await fetchUserPostsByUserId();
  setState(() {
    userPosts=posts;
  });
}

Future<void> logout() async {
    await UserPreferences.saveUserId(''); 
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<List<Map<String, String>>> fetchFollowersList() async {
  try {
    final response = await http.get(Uri.parse('http://172.17.73.110:3000/user/followers/$userId'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> followersList = data['followersList'];

      List<Map<String, String>> followersDataList = followersList.map<Map<String, String>>((follower) {
        final String username = follower['username'] as String;
        final String? profilepicurl = follower['profilepicurl'] as String?;

        return {
          'username': username,
          'profilepicurl': profilepicurl ?? '', // Use an empty string if profilepicurl is null
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

Future<List<Map<String, String>>> fetchFollowingList() async {
  try {
    //final response = await http.get(Uri.parse('http://localhost:3000/user/following/$userId'));
    final response = await http.get(Uri.parse('http://172.17.73.110:3000/user/following/$userId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> followingList = data['followersList'];
      List<Map<String, String>> followingDataList = followingList.map<Map<String, String>>((follower) {
        final String username = follower['username'] as String;
        final String? profilepicurl = follower['profilepicurl'] as String?;

        return {
          'username': username,
          'profilepicurl': profilepicurl ?? '', // Use an empty string if profilepicurl is null
        };
      }).toList();

      return followingDataList;
    } else {
      throw Exception('Failed to load followers. Status Code: ${response.statusCode}');
    }
  } catch (error) {
    print('Error fetching followers: $error');
    throw error;
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  backgroundColor: Color(0xFF0245A3),
  
  iconTheme: IconThemeData(color: Colors.grey[300]),
  title: Row(
    mainAxisAlignment: MainAxisAlignment.start, // Align children at the start of the row
    children: [
      Text(
        "Your Profile",
        style: TextStyle(
          color: Colors.grey[300],
          fontSize:25, // Set the text color to white
        ),
      ),
    ],
  ),
  actions: [
    Container(
      margin: EdgeInsets.only(right: 8), // Adjust the margin to the right
      child: ElevatedButton(
        onPressed: () {
          logout();
        },
        child: Text(
          "Log Out",
          style: TextStyle(
            fontFamily: 'Mplus1p',
            fontSize: 14,
            color: Colors.grey[300],
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.blue[700], // Set the background color to light blue
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    ),
  ],
  centerTitle: true, // Set to false to prevent centering the title
),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: FutureBuilder<Map<String, dynamic>>(
            future: userId != null ? fetchFollowCounts(userId!) : null,
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
                final username = snapshot.data!['username'];
                final firstName = snapshot.data!['firstName'];
                final lastName = snapshot.data!['lastName'];
                final countryCode = snapshot.data!['countryCode'];
                final mobileNumber = snapshot.data!['mobileNumber'];
                final email = snapshot.data!['email'];
                final dateOfBirth = snapshot.data!['dateOfBirth'];
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

                usernameController.text = username;
                firstNameController.text = firstName;
                lastNameController.text = lastName;
                countryCodeController.text = countryCode;
                mobileNumberController.text = mobileNumber;
                emailController.text = email;
                dateOfBirthController.text = dateOfBirth;
                cityController.text = city;
                stateController.text = state;
                countryController.text = country;
                businessNameController.text = businessName;
                categoryController.text = category;
                servicesController.text = services;
                bioController.text = bio;
                

                return Column(
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
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              // Navigate to the Following page
                              final followingList = await fetchFollowingList();
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
                            final followersList = await fetchFollowersList();
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

                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        child: Text(
                          'Username: $username',
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
                          'First Name: $firstName',
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
                          'Last Name: $lastName',
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
                          'Country Code: $countryCode',
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
                          'Mobile Number: $mobileNumber',
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
                          'Date of Birth: $dateOfBirth',
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
                          'Business Name: $businessName',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Mplus1p',
                          ),
                        ),
                      ),
                    ),Divider(),

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
                    ),Divider(),

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
                    ),Divider(),

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
                    ),Divider(),
                    Padding(
                          padding: const EdgeInsets.only(top: 10, left: 10),
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
                        ),Divider(),
                    Center(
                      child: SizedBox(
                        width: 200,
                        height: 45,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UpdatePage()));
                          },
                          child: Text(
                            "Edit Details",
                            style: TextStyle(
                              fontFamily: 'Mplus1p',
                              fontSize: 18,
                              color:Colors.indigo,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Divider(color: Colors.grey[400],thickness: 4,),
                    UserPosts(posts: userPosts),
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