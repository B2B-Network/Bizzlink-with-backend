import 'package:flutter/material.dart';
import 'homePage.dart';
import 'notification.dart';
import 'searchPage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:base/userid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  int? userId;
  File? image;
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  Future<void> _getImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  Future<String> _post() async {
    try {
      if (image != null && userId != null) {
        String suserid = userId.toString();
        String imageName = suserid + '_' + DateTime.now().toIso8601String() + '.jpg';
        firebase_storage.Reference ref = storage.ref().child('posts/$imageName');
        await ref.putFile(image!);
        String downloadURL = await ref.getDownloadURL();
        return downloadURL;
      }
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      return '';
    }
    return '';
  }

  TextEditingController captionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserId(context);
  }

  Future<void> _loadUserId(BuildContext context) async {
    userId = await UserPreferences.getUserId();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0245A3),
        iconTheme: IconThemeData(color: Colors.grey[300]),
        title: Text("Post on Bizzlink",
        style: TextStyle(
          color: Colors.grey[300],
          fontSize:25, // Set the text color to white
        ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upload Picture',
              style: TextStyle(
                fontFamily: 'Mplus1p',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                await _getImage();
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: image == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt, size: 20),
                              SizedBox(height: 8),
                              Text('Select Image', style: TextStyle(fontSize: 16)),
                            ],
                          )
                        : kIsWeb
                            ? Image.network(image!.path, fit: BoxFit.cover)
                            : Image.file(image!, fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Add Caption',
              style: TextStyle(
                fontFamily: 'Mplus1p',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: captionController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your caption',
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  String downloadURL = await _post();
                  var response = await post(downloadURL, captionController.text, userId!);
                  if (response.statusCode == 200) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                  } else {
                    print("Post failed. Status code: ${response.statusCode}");
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  child: Text(
                    "Upload",
                    style: TextStyle(
                      fontFamily: 'Mplus1p',
                      fontSize: 18,
                      color: Colors.blue[900],
                    ),
                  ),
                ),
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
        currentIndex: 2,
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
              break;
            case 1:
              Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage()));
              break;
            case 2:
              // Current page
              break;
            case 3:
              Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationPage()));
              break;
          }
        },
      ),
    );
  }

  Future<http.Response> post(String imageurl, String caption, int userId) async {
    var uri = Uri.parse("http://172.17.73.110:3000/user/post");
    Map<String, String> headers = {"Content-Type": "application/json"};
    Map<String, dynamic> data = {
      'imageurl': '$imageurl',
      'caption': '$caption',
      'userId': '$userId',
    };
    var body = json.encode(data);
    var response = await http.post(uri, headers: headers, body: body);
    return response;
  }
}
