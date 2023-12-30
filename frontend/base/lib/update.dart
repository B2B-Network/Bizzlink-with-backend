import 'package:flutter/material.dart';
import 'dart:async';
import 'package:base/profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:base/userid.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UpdatePage extends StatefulWidget {
  const UpdatePage({super.key});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  int? userId;
  File? image;
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  Future<void> _getImage() async {
  final pickedFile =
      await ImagePicker().pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    setState(() {
      image = File(pickedFile.path);
    });
  }
}

Future<String> _uploadImage() async {
  try {
    if (image != null && userId != null) {
      firebase_storage.Reference ref = storage.ref().child('profile_pictures/$userId.jpg');

      await ref.putFile(image!);

      // Get the download URL for the uploaded image
      String downloadURL = await ref.getDownloadURL();
      return downloadURL;
    }
  } catch (e) {
    print('Error uploading image to Firebase Storage: $e');
    return ''; // Return an empty string if there's an error
  }
  return ''; // Return an empty string if there's no image or user ID
}

  bool changeButton = false;
  Service service = Service();

  TextEditingController usernameController = TextEditingController();
TextEditingController firstNameController = TextEditingController();
TextEditingController lastNameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController countryController = TextEditingController();
TextEditingController stateController = TextEditingController();
TextEditingController cityController = TextEditingController();
TextEditingController countryCodeController = TextEditingController();
TextEditingController mobileNumberController = TextEditingController();
TextEditingController dateOfBirthController = TextEditingController();
TextEditingController categoryController = TextEditingController();
TextEditingController bioController = TextEditingController();
TextEditingController servicesController = TextEditingController();
TextEditingController businessNameController = TextEditingController();
TextEditingController twitterurlController = TextEditingController();
TextEditingController igurlController = TextEditingController();
TextEditingController linkedinurlController = TextEditingController();

      List<String> categories = [
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
  String selectedCategory = 'Technology';
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateOfBirthController.text = "${picked.year}-${picked.month}-${picked.day}";
      });
    }
  }

      @override
void initState() {
  super.initState();
  _loadUserId();
}

Future<void> _loadUserId() async {
  userId = await UserPreferences.getUserId();
  var userDetails = await service.getUserDetails(userId!);
  setState(() {
    usernameController.text = userDetails['username'];
    firstNameController.text = userDetails['firstName'];
    lastNameController.text = userDetails['lastName'];
    emailController.text = userDetails['email'];
    countryController.text = userDetails['country'];
    stateController.text = userDetails['state'];
    cityController.text = userDetails['city'];
    countryCodeController.text = userDetails['countryCode'];
    mobileNumberController.text = userDetails['mobileNumber'];
    dateOfBirthController.text = userDetails['dateOfBirth'];
    categoryController.text = userDetails['category'];
    bioController.text = userDetails['bio'];
    servicesController.text = userDetails['services'];
    businessNameController.text = userDetails['businessName'];
    twitterurlController.text = userDetails['twitterurl'];
    igurlController.text = userDetails['igurl'];
    linkedinurlController.text = userDetails['linkedinurl'];
  }); 
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF0245A3),
          title: Text("Edit Profile Details",
        style: TextStyle(
          color: Colors.grey[300],
          fontSize:25, // Set the text color to white
        ),
        ),leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); 
            },
          ),
        ),
        body: Align(
          alignment: Alignment.topLeft,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Name
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 15),
                  child: Container(
                    child: Text(
                      'User Name',
                      style: TextStyle(
                        fontFamily: 'Mplus1p',
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Container(
                    child: TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(),
                    ),
                  ),
                ),

                // First Name
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 15),
                  child: Container(
                    child: Text(
                      'First Name',
                      style: TextStyle(
                        fontFamily: 'Mplus1p',
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Container(
                    child: TextFormField(
                      controller: firstNameController,
                      decoration: InputDecoration(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                // Last Name
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 15),
                  child: Container(
                    child: Text(
                      'Last Name',
                      style: TextStyle(
                        fontFamily: 'Mplus1p',
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Container(
                    child: TextFormField(
                      controller: lastNameController,
                      decoration: InputDecoration(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 15),
                  child: Container(
                    child: Text(
                      'Update Profile Picture',
                      style: TextStyle(
                        fontFamily: 'Mplus1p',
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: GestureDetector(
                    onTap: () async {
                      await _getImage();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: image == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt),
                                SizedBox(width: 8),
                                Text('Select Image'),
                              ],
                            )
                          : kIsWeb
                              ? Image.network(image!.path, height: 100, width: 100, fit: BoxFit.cover)
                              : Image.file(image!, height: 100, width: 100, fit: BoxFit.cover),
                      padding: EdgeInsets.all(12),
                    ),
                  ),
                ),


                // Email
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 15),
                  child: Container(
                    child: Text(
                      'Email',
                      style: TextStyle(
                        fontFamily: 'Mplus1p',
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Container(
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                // Country
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 15),
                  child: Container(
                    child: Text(
                      'Country',
                      style: TextStyle(
                        fontFamily: 'Mplus1p',
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Container(
                    child: TextFormField(
                      controller: countryController,
                      decoration: InputDecoration(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                // State
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 15),
                  child: Container(
                    child: Text(
                      'State',
                      style: TextStyle(
                        fontFamily: 'Mplus1p',
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Container(
                    child: TextFormField(
                      controller: stateController,
                      decoration: InputDecoration(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                // City
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 15),
                  child: Container(
                    child: Text(
                      'City',
                      style: TextStyle(
                        fontFamily: 'Mplus1p',
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Container(
                    child: TextFormField(
                      controller: cityController,
                      decoration: InputDecoration(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                // City
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 15),
                  child: Container(
                    child: Text(
                      'Country Code',
                      style: TextStyle(
                        fontFamily: 'Mplus1p',
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Container(
                    child: TextFormField(
                      controller: countryCodeController,
                      decoration: InputDecoration(),
                    ),
                  ),
                ),

                // Mobile Number
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 15),
                  child: Container(
                    child: Text(
                      'Mobile Number',
                      style: TextStyle(
                        fontFamily: 'Mplus1p',
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Container(
                    child: TextFormField(
                      controller: mobileNumberController,
                      decoration: InputDecoration(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                // Date of Birth
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 15),
                  child: Container(
                    child: Text(
                      'Date of Birth',
                      style: TextStyle(
                        fontFamily: 'Mplus1p',
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Container(
                    child: InkWell(
                      onTap: () => _selectDate(context),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          hintText: 'Select Date',
                          errorText: dateOfBirthController.text.isEmpty
                              ? 'Please select a date'
                              : null,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              selectedDate != null
                                  ? "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}"
                                  : 'Select Date',
                            ),
                            Icon(Icons.calendar_today),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                // Category
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 15),
                  child: Container(
                    child: Text(
                      'Category',
                      style: TextStyle(
                        fontFamily: 'Mplus1p',
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Container(
                    child: DropdownButtonFormField(
                      value: selectedCategory,
                      items: categories.map((String category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedCategory = value ?? 'Retail';
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                // Bio
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 15),
                  child: Container(
                    child: Text(
                      'Bio',
                      style: TextStyle(
                        fontFamily: 'Mplus1p',
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Container(
                    child: TextFormField(
                      controller: bioController,
                      decoration: InputDecoration(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                // Services
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 15),
                  child: Container(
                    child: Text(
                      'Services',
                      style: TextStyle(
                        fontFamily: 'Mplus1p',
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Container(
                    child: TextFormField(
                      controller: servicesController,
                      decoration: InputDecoration(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                // Business Name
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 15),
                  child: Container(
                    child: Text(
                      'Business Name',
                      style: TextStyle(
                        fontFamily: 'Mplus1p',
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Container(
                    child: TextFormField(
                      controller: businessNameController,
                      decoration: InputDecoration(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 15),
                  child: Container(
                    child: Text(
                      'Twitter url',
                      style: TextStyle(
                        fontFamily: 'Mplus1p',
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Container(
                    child: TextFormField(
                      controller: twitterurlController,
                      decoration: InputDecoration(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 15),
                  child: Container(
                    child: Text(
                      'Instagram url',
                      style: TextStyle(
                        fontFamily: 'Mplus1p',
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Container(
                    child: TextFormField(
                      controller: igurlController,
                      decoration: InputDecoration(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 15),
                  child: Container(
                    child: Text(
                      'LinkedIn url',
                      style: TextStyle(
                        fontFamily: 'Mplus1p',
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Container(
                    child: TextFormField(
                      controller: linkedinurlController,
                      decoration: InputDecoration(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),

                // Done Button
                Center(
                  child: SizedBox(
                    width: 150,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    
                      onPressed: () async {
                        String downloadURL = await _uploadImage();
                      var response = await service.updateUser(
                          firstNameController.text,
                          lastNameController.text,
                          emailController.text,
                          countryCodeController.text,
                          mobileNumberController.text,
                          usernameController.text,
                          cityController.text,
                          stateController.text,
                          countryController.text,
                          dateOfBirthController.text,
                          categoryController.text,
                          servicesController.text,
                          businessNameController.text,
                          bioController.text,
                          twitterurlController.text,
                          igurlController.text,
                          linkedinurlController.text,
                          downloadURL,
                          userId!,

                      );
                      if (response.statusCode == 200) {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfilePage()));
                      } else {
                        print("Registration failed. Status code: ${response.statusCode}");
                      }
                    },
                    
                      child: Text(
                        "Update",
                        style: TextStyle(
                          fontFamily: 'Mplus1p',
                          fontSize: 18,
                          color: Colors.indigo,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      );
  }
}

class Service {

  Future<Map<String, dynamic>> getUserDetails(int userId) async {
    //var uri = Uri.parse("http://localhost:3000/user/profile/$userId");
    var uri = Uri.parse("http://172.17.73.110:3000/user/profile/$userId");

    try {
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        // Successful response, parse and return user details
        return json.decode(response.body);
      } else {
        // Handle other status codes (e.g., 404 for user not found)
        throw Exception('Failed to load user details');
      }
    } catch (e) {
      // Handle network or other errors
      throw Exception('Failed to load user details');
    }
  }

  Future<http.Response> updateUser(
      String firstName,
      String lastName,
      String email,
      String countryCode,
      String mobileNumber,
      String username,
      String city,
      String state,
      String country,
      String dateOfBirth,
      String category,
      String services,
      String businessName,
      String bio,
      String twitterurl,
      String igurl,
      String linkedinurl,
      String profilePicUrl,
      int userId,

      ) async {
    // Create uri
    //var uri = Uri.parse("http://localhost:3000/user/update/$userId");
    var uri = Uri.parse("http://172.17.73.110:3000/user/update/$userId");

    Map<String, String> headers = {"Content-Type": "application/json"};
    Map<String, dynamic> data = {
      'firstName': '$firstName',
      'lastName': '$lastName',
      'email': '$email',
      'countryCode': '$countryCode',
      'mobileNumber': '$mobileNumber',
      'username': '$username',
      'city': '$city',
      'state': '$state',
      'country': '$country',
      'dateOfBirth': '$dateOfBirth',
      'bio': '$bio',
      'services': '$services',
      'category': '$category',
      'businessName': '$businessName',
      'twitterurl': '$twitterurl',
      'igurl': '$igurl',
      'linkedinurl': '$linkedinurl',
      'profilepicurl' : '$profilePicUrl',
      'userId':'$userId',
    };

    var body = json.encode(data);

    var response = await http.post(uri, headers: headers, body: body);
    return response;
  }
}