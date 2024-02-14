import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/classmod/Chat.dart';
//import 'package:myapp/classmod/LoginHelper.dart';
import 'package:myapp/classmod/PageHelper.dart';
import 'package:myapp/classmod/UserModel.dart';
import 'package:myapp/pages/ChatRoom.dart';

class ChatPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const ChatPage({
    Key? key,
    required this.userModel,
    required this.firebaseUser, 
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      body: SafeArea(
        child: Container(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("ChatRooms")
                .where("Members.${widget.userModel.name}", isEqualTo: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  QuerySnapshot chatRoomSnap = snapshot.data as QuerySnapshot;
                  return ListView.builder(
                    itemCount: chatRoomSnap.docs.length,
                    itemBuilder: (context, index) {
                      Chat chatMod =
                          Chat.fromMap(chatRoomSnap.docs[index].data()
                              as Map<String, dynamic>);

                      Map<String, dynamic> members = chatMod.Members!;
                      List<String> memKeys = members.keys.toList();
                      memKeys.remove(widget.userModel.name);

                      return FutureBuilder(
                        future: PageHelper.getUsername(memKeys[0]),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else {
                            UserModel user = snapshot.data as UserModel;
                            return ListTile(
                              title: Text(user.name ?? ''),
                              subtitle: Text(chatMod.lastmsg.toString()),
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(user.ProfilePicture ?? ""),
                              ),
                              onTap: () {
                                 Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatRoom(
                                      userModel: widget.userModel,
                                      resciverUser: user,
                                      firebaseUser: widget.firebaseUser,
                                      chatroom: chatMod
                                    ),
                                  ),
                                );
                              },
                              
                            );
                          }
                        },
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  return Center(
                    child: Text("No chats available"),
                  );
                }
              } else {
                return Center(
                  child: Text("Loading...")
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
