class message {
  String? msgid;
  String? Sender;
  String? msg;
  bool? seen;
  DateTime? toime;

  message({this.msgid,this.Sender, this.msg, this.seen, this.toime});

  message.fromMap(Map<String, dynamic> map) {
    msgid = map["msgid"];
    Sender = map["Sender"];
    msg = map["msg"];
    seen = map["seen"];
    toime = map["toime"].toDate();

   
    }
     Map<String, dynamic> tomap() {
      return {"msgid":msgid ,"Sender": Sender, "msg": msg, "seen": seen, "toime": toime};
  }
}
