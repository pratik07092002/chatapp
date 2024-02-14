import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/classmod/UserModel.dart';

class PageHelper {
  static Future<UserModel?> getUsername(String name) async {
    UserModel? userModel;
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection("Users")
        .where("name", isEqualTo: name)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      userModel = UserModel.fromMap(querySnapshot.docs.first.data());
    }

    return userModel;
  }
}
