//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/classmod/LoginHelper.dart';
import 'package:myapp/classmod/UserModel.dart';
import 'package:myapp/firebase_options.dart';
import 'package:myapp/pages/Homepage.dart';
import 'package:myapp/pages/login.dart';
import 'package:uuid/uuid.dart';
//import 'package:myapp/pages/login.dart';
//import 'package:myapp/pages/signup.dart';
var uuid = Uuid();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  User? currUser = FirebaseAuth.instance.currentUser;

  if (currUser != null) {
    UserModel? thisuserModel = await LoginHelper.getUserId(currUser.uid);
    if (thisuserModel != null) {
      runApp(UserLoggedIn(userModel: thisuserModel, FirebaseUser: currUser));
    } else {
      runApp(MyApp());
    }
  } else {
    runApp(MyApp());
  }
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat App',
        home: LoginPage());
  }
}

class UserLoggedIn extends StatelessWidget {
  final UserModel userModel;
  final User FirebaseUser;

   UserLoggedIn({Key? key, required this.userModel, required this.FirebaseUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      home: HomePage(userModel  : userModel, user: FirebaseUser),
    );
  }
}

