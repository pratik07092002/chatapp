import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myapp/classmod/UserModel.dart';
import 'package:myapp/pages/Homepage.dart';
import 'package:myapp/pages/signup.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void checklogin() async {
    String email = _emailController.text.trim();
    String Password = _passwordController.text.trim();
    UserCredential? usercred;

    if (email == "" || Password == "") {
      Fluttertoast.showToast(msg: "Please enter credentials");
    } else {
      try {
        usercred = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: Password);
      } on FirebaseAuthException catch (ex) {
        Fluttertoast.showToast(msg: ex.code.toString());
      }

      if (usercred != null) {
        String UserId = usercred.user!.uid;
        DocumentSnapshot UserData = await FirebaseFirestore.instance
            .collection("Users")
            .doc(UserId)
            .get();

        UserModel FetchMap =
            UserModel.fromMap(UserData.data() as Map<String, dynamic>);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    HomePage(userModel: FetchMap, user: usercred!.user!)));
        Fluttertoast.showToast(msg: "Logged in Successfully");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login' , style: TextStyle(color: Colors.white),),
        backgroundColor : Colors.deepPurple[400]
      ),
      backgroundColor: Colors.deepPurple,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email Text Field
            TextField(
              style: TextStyle(color: Colors.white),
              
              controller: _emailController,
              decoration: InputDecoration(
                filled: true,
                labelStyle: TextStyle(color: Colors.white),
              fillColor: Colors.black38,
                labelText: 'Email',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: Icon(Icons.email , color: Colors.white,),

              ),
            ),
            SizedBox(height: 16.0), // Spacer

            // Password Text Field
            TextField(
              controller: _passwordController,
              obscureText: true,
              style: TextStyle(color: Colors.white),
              
              decoration: InputDecoration(
                
                labelText: 'Password' ,
                labelStyle: TextStyle(color: Colors.white),
                hoverColor: Colors.white,
                filled: true,
                fillColor: Colors.black38,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock , color: Colors.white,),
                focusColor: Colors.white
              ),
              
            ),
            SizedBox(height: 16.0), 

            
            ElevatedButton(
              onPressed: () {
                
                checklogin();
              
              },
              child: Text('Login'),
            ),
            SizedBox(height: 16),
  ElevatedButton(onPressed: (){
    
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return SignupPage();
    }));
  }, child: Text("Don't have an Account ? Sign up"))


          ],
        ),
      ),
    );
  }
}
