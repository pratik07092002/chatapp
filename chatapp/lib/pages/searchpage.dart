
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:myapp/classmod/Chat.dart';
import 'package:myapp/classmod/UserModel.dart';
import 'dart:core';
import 'package:flutter/src/painting/image_provider.dart';
import 'package:myapp/main.dart';
//import 'package:myapp/main.dart';
import 'package:myapp/pages/ChatRoom.dart';

class SearchPro extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const SearchPro({Key? key, required this.userModel, required this.firebaseUser}) : super(key: key);

  @override
  State<SearchPro> createState() => _SearchProState();
}

class _SearchProState extends State<SearchPro> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(

                labelText: "Search for Users",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
           suffixIcon: IconButton(
  onPressed: () {
    setState(() {});
  },
  icon: Icon(Icons.search),
),

                
              ),
            ),
            SizedBox(height: 15),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Users")
                    .where("name", isGreaterThanOrEqualTo: _searchController.text.trim())
                    .where("name", isLessThanOrEqualTo: _searchController.text.trim() + 'z')
                    .orderBy("name")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: Text("Loading..."));
                  } else if (snapshot.hasError) {
                    return Text("An error occurred.");
                  } else if (snapshot.hasData) {
                    // final List<DocumentSnapshot> documents = snapshot.data!.docs;
                   // final Map<String,dynamic> SearchQuery = snapshot.data!.docs.asMap().cast<String,dynamic >();
QuerySnapshot DataSnap = snapshot.data as QuerySnapshot;
                    
                   

                    if (_searchController.text.isEmpty || DataSnap.docs.length == 0) {
                      return Text("No matching users found.");
                    }

                    return ListView.builder(

                      itemCount: DataSnap.docs.length,
                      itemBuilder: (context, index) {
                       UserModel SearchedUser = UserModel.fromMap(DataSnap.docs[index].data() as Map<String,dynamic>);

                       
                       // UserModel searchedResult = UserModel.fromMap(document.data() as Map<String, dynamic>);

                        return ListTile(
                          title: Text(SearchedUser.name.toString()),
                          subtitle: Text(SearchedUser.email.toString()),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(SearchedUser.ProfilePicture ?? ""),
                          ),
                          trailing: Icon(Icons.forward),
                          onTap: () async {
                            QuerySnapshot<Map<String, dynamic>> chatRoomQuerySnapshot = await FirebaseFirestore.instance.collection('ChatRooms')
                                .where('${'Members.${widget.userModel.name}'}'
, isEqualTo: true)
                                .where('${'Members.${SearchedUser.name}'}'
, isEqualTo: true)
                                .get()
                                .catchError((error) {
                              print('Error fetching chat room: $error');
                            });

                            if (chatRoomQuerySnapshot.docs.isNotEmpty ) {
                              DocumentSnapshot<Map<String, dynamic>> chatRoomSnapshot = chatRoomQuerySnapshot.docs.first;
                              if (chatRoomSnapshot.exists) {
                                // ignore: use_build_context_synchronously
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatRoom(
                                      userModel: widget.userModel,
                                      resciverUser: SearchedUser,
                                      firebaseUser: widget.firebaseUser,
                                      chatroom: Chat.fromMap(chatRoomSnapshot.data() as Map<String, dynamic>),
                                    ),
                                  ),
                                );
                              }
                            } else {
                              // Chat room doesn't exist, create a new chat room and navigate to ChatRoom screen
                              Chat newChatRoom = Chat(
                                Roomid: uuid.v1(),
                                Members: {
                                  widget.userModel.name.toString() : true,
                                  SearchedUser.name.toString() : true 
                                },
                                lastmsg: '',
                              );
                              // Add new chat room to Firestore/*
                              FirebaseFirestore.instance
    .collection('ChatRooms')
    .doc(newChatRoom.Roomid)
    .set(newChatRoom.tomap())
    .then((_) {
      // After the set operation is complete, you can update the Roomid
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return 
ChatRoom(userModel: widget.userModel, resciverUser: SearchedUser, firebaseUser: widget.firebaseUser, chatroom: newChatRoom );
      }));
    });

                                 
                                    
                              
                              
                           
                            }
                          },
                        );
                      },
                    );
                  } else {
                    return Text("No data available.");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
