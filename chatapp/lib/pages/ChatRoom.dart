import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:myapp/classmod/Chat.dart';
import 'package:myapp/classmod/Message.dart';
import 'package:myapp/classmod/UserModel.dart';
import 'package:myapp/main.dart';

class ChatRoom extends StatefulWidget {
  final UserModel userModel;
  final UserModel resciverUser;
  final User firebaseUser;
  final Chat chatroom;

  const ChatRoom({super.key, required this.userModel, required this.resciverUser, required this.firebaseUser, required this.chatroom});
  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController MessageController = TextEditingController();

  void MessageSender() async{

    String Messagemsg = MessageController.text.trim();
    MessageController.clear();
  if(Messagemsg.isNotEmpty){
message NewMsg = message(msgid: uuid.v1(),
msg: Messagemsg ,
 toime: DateTime.now(),
 seen: false,
Sender: widget.userModel.name);

FirebaseFirestore.instance.collection("ChatRooms").doc(widget.chatroom.Roomid).collection("MessagesHistory").doc(NewMsg.msgid).set(NewMsg.tomap());
 
 widget.chatroom.lastmsg = Messagemsg;
FirebaseFirestore.instance.collection("ChatRooms").doc(widget.chatroom.Roomid).
set(widget.chatroom.tomap());

  }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
  backgroundColor: Colors.deepPurple,
  title : 
  Row(children: [
    CircleAvatar(
       backgroundImage: NetworkImage(widget.resciverUser.ProfilePicture ?? ""),
    ),
    SizedBox(width: 10),

    Text(widget.resciverUser.name.toString())


  ],)
),
body: SafeArea(child: Container(

  decoration: BoxDecoration(
    image: DecorationImage(image: AssetImage('assets/ChatRoomImage.jpg'), 
    fit: BoxFit.cover
    ),
    
  ),
  child: Column(
    children: [Expanded(child: Container(

      child: StreamBuilder(stream: FirebaseFirestore.instance.collection("ChatRooms").doc(widget.chatroom.Roomid).collection("MessagesHistory").orderBy("toime",descending: true).snapshots(),
       builder: ((context, snapshot) {
        if(snapshot.connectionState == ConnectionState.active){
if(snapshot.hasData){
QuerySnapshot datasnap = snapshot.data as QuerySnapshot;

return ListView.builder(
  reverse: true,
  itemCount: datasnap.docs.length,
itemBuilder :(context, index) {
  message Newmsg = message.fromMap(datasnap.docs[index].data() as Map<String,dynamic>);

  return Row(
    mainAxisAlignment: Newmsg.Sender == widget.userModel.name ? MainAxisAlignment.end : MainAxisAlignment.start ,
    children: [
      
      Container(
        margin: EdgeInsets.symmetric(vertical: 3),
        padding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10
        ),
        decoration: BoxDecoration(
          color: (Newmsg.Sender == widget.userModel.name) ? Colors.teal : Colors.yellow,
          borderRadius: BorderRadius.circular(8)
        ),
        child: Text(Newmsg.msg.toString())),
    ],
  );
},
);
}else if(snapshot.hasError){
return Text("Chek error");
}
else{
  return Text("Check data");
}
        }
        else{
          return CircularProgressIndicator();
        }
       }
      
       )),
      
    ),
    ),
    Container(padding: EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 5
    ),
    child: Row(
      children: [
        Flexible(child: TextField(
          
          controller: MessageController,
          maxLines: null,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),hintText: "Enter Message"),)),
      IconButton(onPressed: (){
        MessageSender();
      }, icon: Icon(Icons.send), style: ButtonStyle(iconColor: MaterialStateProperty.all(Colors.teal)))
      ],
    ),
    ),
    ],
  ),
)),

    );
  }
}

