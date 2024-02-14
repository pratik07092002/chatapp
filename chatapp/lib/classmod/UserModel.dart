class UserModel {
  String? email;
  String? name;
  String? ProfilePicture;
  String? UserId;

  UserModel(
      { this.UserId,
       this.email,
       this.name,
       this.ProfilePicture});

  UserModel.fromMap(Map<String, dynamic> map) {
    UserId = map["UserId"];
    name = map["name"];
    ProfilePicture = map["ProfilePicture"];
    email = map["email"];
  }

  Map<String, dynamic> toMap() {
    return {
      "UserId": UserId,
      "name": name,
      "ProfilePicture": ProfilePicture,
      "email": email
    };
  }
}
