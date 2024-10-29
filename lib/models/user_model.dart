class UserModel {
  final String userId;
  final String name;
  final String email;
  final String location;
  final String myRole;
  final String phoneNumber;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.location,
    required this.myRole,
    required this.phoneNumber,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'],
      name: map['name'],
      email: map['email'],
      location: map['location'],
      myRole: map['myRole'],
      phoneNumber: map['phoneNumber'],
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
    };
  }
}
