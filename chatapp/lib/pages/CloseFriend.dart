import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CloseFriends extends StatefulWidget {
  const CloseFriends({super.key});

  @override
  State<CloseFriends> createState() => _CloseFriendsState();
}

class _CloseFriendsState extends State<CloseFriends> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("This is your Close friend List"),),);
  }
}