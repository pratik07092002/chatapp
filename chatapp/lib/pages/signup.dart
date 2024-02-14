import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myapp/classmod/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/pages/Homepage.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController NameController = TextEditingController();
  TextEditingController EmailController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();
  TextEditingController ConfirmPasswordController = TextEditingController();

  Future<void> ConfirmSignup() async {
    String name = NameController.text.trim();
    String email = EmailController.text.trim();
    String password = PasswordController.text.trim();
    String CPassword = ConfirmPasswordController.text.trim();
    UserCredential? usercred;

    if (name == "" || email == "" || password == "" || CPassword == "") {
      Fluttertoast.showToast(msg: "Please Enter credentials");
    } else if (password != CPassword) {
      Fluttertoast.showToast(msg: "Passwords did not match");
    } else {
      try {
        usercred = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
      } on FirebaseAuthException catch (ex) {
        Fluttertoast.showToast(msg: ex.code.toString());
      
      }

      if (usercred != null) {
        String UserId = usercred.user!.uid;
        UserModel newUser = UserModel(
            UserId: UserId, email: email, name: name, ProfilePicture: "");

        await FirebaseFirestore.instance
            .collection("Users")
            .doc(UserId)
            .set(newUser.toMap())
            .then((value) {
        //  Fluttertoast.showToast(msg: "New User Created");
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      HomePage(userModel: newUser, user: usercred!.user!)));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up' , style: TextStyle(color: Colors.white),),
        
        backgroundColor: Colors.deepPurple[400],
      ),
      backgroundColor: Colors.deepPurple,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            TextField(
              controller: NameController,
              style: TextStyle(color: Colors.white),

              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.black38,
                labelText: 'Name',
                labelStyle: TextStyle(color: Colors.white),
                
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                prefixIcon: Icon(Icons.person),
                prefixIconColor: Colors.white,
                
              ),
            ),
            SizedBox(height: 16.0), // Spacer

            
            TextField(
              style: TextStyle(color: Colors.white),

              controller: EmailController,
              decoration: InputDecoration(
                prefixIconColor: Colors.white
,
                 filled: true,
                 fillColor: Colors.black38,
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.white),
                
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 16.0), // Spacer

            // Password Text Field
            TextField(
              controller: PasswordController,
              obscureText: true,
              style: TextStyle(color: Colors.white),

            
              decoration: InputDecoration( filled: true,
              fillColor: Colors.black38,
                prefixIconColor: Colors.white,
            
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              obscureText: true,
              style: TextStyle(color: Colors.white),
              controller: ConfirmPasswordController,
              decoration: InputDecoration( filled: true,
              fillColor: Colors.black38,
                prefixIconColor: Colors.white,

                  labelText: "Confirm password",
                  
                  
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock)),
            ), 

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ConfirmSignup();
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
