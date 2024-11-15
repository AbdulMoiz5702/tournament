class UserModel {
  final String userId;
  final String name;
  final String email;
  final String location;
  final String myRole;
  final String phoneNumber;
  final String token;
  final bool isOnline;
  final String imageLink;
  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.location,
    required this.myRole,
    required this.phoneNumber,
    required this.token,
    required this.isOnline,
    required this.imageLink,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'],
      name: map['name'],
      email: map['email'],
      location: map['location'],
      myRole: map['myRole'],
      phoneNumber: map['phoneNumber'],
      token: map['token'],
      isOnline: map['is_online'],
      imageLink: map['imageLink'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'location': location,
      'myRole': myRole,
      'phoneNumber': phoneNumber,
      'token':token,
      'is_online':isOnline,
      'imageLink':imageLink
    };
  }
}
