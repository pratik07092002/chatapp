import 'dart:io';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/classmod/UserModel.dart';
import 'package:myapp/pages/CloseFriend.dart';
import 'package:myapp/pages/chatpagelist.dart';
import 'package:myapp/pages/login.dart';
import 'package:myapp/pages/searchpage.dart';

class HomePage extends StatefulWidget {
  final UserModel userModel;
  final User user;

  HomePage({Key? key, required this.userModel, required this.user}) : super(key: key);


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? imageFile; // Changed from late File ImageFile to File? imageFile

  void selectImage(ImageSource source) async {
    XFile? pickedImg = await ImagePicker().pickImage(source: source);
    if (pickedImg != null) {
      cropImage(pickedImg);
    }
  }

  void cropImage(XFile file) async {
  CroppedFile? croppedImg = await ImageCropper().cropImage(sourcePath: file.path , 
  compressQuality: 20
  );

  if (croppedImg != null) {
    setState(() {
      imageFile = File(croppedImg.path);
    });

    // Call uploadData after setting imageFile
    uploadData();
  }
}


  void displayDialogue() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Choose an option"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                trailing: Icon(Icons.album_sharp),
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.gallery);
                
                },
                title: Text("Select from Gallery"),
              ),
              ListTile(
                trailing: Icon(Icons.camera_alt),
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.camera);
                  
                },
                title: Text("Click by Camera"),
              ),
            ],
          ),
        );
      },
      
    );
    
  }

  void uploadData() async {
 /*
 final path = 'files/img';
 final file = File(imageFile!.path);
 final ref = FirebaseStorage.instance.ref().child(path);
 ref.putFile(file);
 
*/ 

  UploadTask uploadTask = FirebaseStorage.instance.ref("ProfilePictures").child(widget.user.uid).putFile(imageFile!);
  TaskSnapshot snapshot = await uploadTask;
  String? imgUrl = await snapshot.ref.getDownloadURL();

  widget.userModel.ProfilePicture = imgUrl;
  
  FirebaseFirestore.instance.collection("Users").doc(widget.userModel.UserId).set(widget.userModel.toMap());

}




  int currentIndex = 0;

  List<Widget> pages = [];

  void switchPageMethod(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    pages = [
      ChatPage(userModel: widget.userModel, firebaseUser: widget.user),
      SearchPro(userModel: widget.userModel, firebaseUser: widget.user),
      CloseFriends(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home Page',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple[400],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple[400],
              ),
              child: Column(
                
                children: [
                  CupertinoButton(
                    
  child: CircleAvatar(
    radius: 35,
    
    backgroundImage: (widget.userModel.ProfilePicture != null)
        ? NetworkImage(widget.userModel.ProfilePicture!)
        : AssetImage('assets/default_profile_picture.jpg') as ImageProvider<Object>?,
  ),
  onPressed: () {
    displayDialogue();
  },
),

                  Text(
                    widget.userModel.name ?? 'DefaultName',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text('User Profile'),
              onTap: () {},
              trailing: Icon(Icons.account_box),
            ),
            ListTile(
              title: Text('Lists'),
              onTap: () {},
              trailing: Icon(Icons.list),
            ),
            ListTile(
              title: Text("Settings"),
              onTap: () {},
              trailing: Icon(Icons.settings),
            ),
            ListTile(
              title: Text("About"),
              onTap: () {},
              trailing: Icon(Icons.info),
            ),
            ListTile(
              title: Text("Logout"),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                  return LoginPage();
                }));
              },
              trailing: Icon(Icons.logout),
            )
          ],
        ),
      ),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.deepPurple[200],
        backgroundColor: Colors.deepPurple,
        selectedIconTheme: IconThemeData(size: 30),
        unselectedIconTheme: IconThemeData(size: 15),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat, color: Colors.white),
            label: "chat",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search, color: Colors.white), label: "search"),
          BottomNavigationBarItem(icon: Icon(Icons.people, color: Colors.white), label: "Close Friends"),
        ],
        currentIndex: currentIndex,
        onTap: switchPageMethod,
      ),
    );
  }
}
