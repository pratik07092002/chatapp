class Chat {
  String? Roomid;
  Map<String,dynamic>? Members;
  String? lastmsg;

Chat({this.Roomid,this.Members,this.lastmsg});


  Chat.fromMap(Map<String, dynamic> map) {
    Roomid = map["Roomid"];
    Members = map["Members"];
    lastmsg = map["lastmsg"];
  }

  Map<String, dynamic> tomap() {
    return {"Roomid": Roomid, "Members": Members , "lastmsg" : lastmsg};
  }
}
