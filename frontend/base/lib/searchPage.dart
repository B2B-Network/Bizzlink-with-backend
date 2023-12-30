import 'package:flutter/material.dart';
import 'homePage.dart';
import 'post.dart';
import 'notification.dart';
import 'dart:convert';
import "package:base/userid.dart";
import 'package:http/http.dart' as http;
import 'userProfilePage.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int? userId;
  final List<Map<String, dynamic>> gridMap = [];
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadUserId(context);
    _loadUsers();
  }

  Future<void> _loadUserId(BuildContext context) async {
  userId = await UserPreferences.getUserId();
  setState(() {}); 
}

Future<void> _loadUsers() async {
  userId = await UserPreferences.getUserId();
      String apiUrl = 'http://172.17.73.110:3000/user/loadsearchpageusers/$userId';
      if (selectedCategory != null) {
      apiUrl += '?category=$selectedCategory';
    }
    
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> usersJson = json.decode(response.body);
        setState(() {
          gridMap.clear();
          gridMap.addAll(usersJson.cast<Map<String, dynamic>>());
        });
      } else {
        // Handle error
        print('Failed to load users: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network or decoding errors
      print('Error loading users: $error');
    }
}

final List<String> buttonLabels = [
              'All',
              'Retail',
              'Service',
              'Manufacturing',
              'Technology',
              'Finance',
              'Healthcare',
              'Real Estate',
              'Food and Beverage',
              'Transportation',
              'Others',
            ];


Widget buildDropdown() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    margin: EdgeInsets.symmetric(horizontal: 16.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      children: [
        Icon(
          Icons.filter_list,
          color: Colors.blue,
        ),
        SizedBox(width: 8.0),
        Text(
          'Filter by Category',
          style: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacer(),
        DropdownButton<String>(
          value: selectedCategory,
          icon: Icon(Icons.arrow_drop_down, color: Colors.blue),
          iconSize: 24.0,
          elevation: 16,
          style: TextStyle(
            color: Colors.blue,
            fontSize: 16.0,
          ),
          underline: Container(
            height: 2,
            color: Colors.blue,
          ),
          onChanged: (value) {
            setState(() {
              selectedCategory = value;
            });
            _loadUsers(); // Reload users based on the selected category
          },
          items: buttonLabels.map((label) {
            return DropdownMenuItem<String>(
              value: label,
              child: Text(
                label,
                style: TextStyle(fontSize: 14.0),
              ),
            );
          }).toList(),
        ),
      ],
    ),
  );
}


Widget buildGridView() {
  return GridView.builder(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 12.0,
      mainAxisSpacing: 12.0,
      mainAxisExtent: 250,
    ),
    itemCount: gridMap.length,
    itemBuilder: (_, index) {
      return Card(
        margin: EdgeInsets.only(left: 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 4.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Color(0xFF0245A3), width: 3.0),
              ),
              child: ClipOval(
                child: gridMap.elementAt(index)['profilepicurl'] != null
                    ? Image.network(
                        "${gridMap.elementAt(index)['profilepicurl']}",
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        "assets/images/profile.png",
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${gridMap.elementAt(index)['username']}",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserProfilePage(
                            username: gridMap.elementAt(index)['username'],
                            profileImage: gridMap.elementAt(index)['profilepicurl'] ?? "",
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF0245A3),
                      onPrimary: Colors.white,
                    ),
                    child: Text(
                      "Connect",
                      style: TextStyle(
                        fontFamily: 'Mplus1p',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}


@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0245A3),
        iconTheme: IconThemeData(color: Colors.grey[300]),
        title: Text("Explore",
        style: TextStyle(
          color: Colors.grey[300],
          fontSize:25, // Set the text color to white
        ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),
            buildDropdown(),
            SizedBox(height: 16.0),
            Container(
              color: Color(0xFFF6F1F1),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 35.0,
                        child: SearchAnchor(
                          builder: (BuildContext context, SearchController controller) {
                            return SearchBar(
                              controller: controller,
                              padding: const MaterialStatePropertyAll<EdgeInsets>(
                                EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                              ),
                              onTap: () {
                                controller.openView();
                              },
                              onChanged: (value) {
                                controller.openView();
                              },
                              leading: const Icon(Icons.search),
                            );
                          },
                          suggestionsBuilder: (BuildContext context, SearchController controller) {
                            return List<ListTile>.generate(5, (int index) {
                              final String item = 'Item $index';
                              return ListTile(
                                title: Text(item),
                                onTap: () {
                                  setState(() {
                                    controller.closeView(item);
                                  });
                                },
                              );
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                  ],
                ),
              ),
            ),
            Container(
              height: 2.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  // Add your horizontal list items here if needed
                ],
              ),
            ),
            SizedBox(height: 10),
            buildGridView(), // Add the GridView.builder widget here
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
        currentIndex: 1,
        onTap: (int index) {
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
