class Tournament {
  final String id;
  final String name;
  final String organizerName;
  final String tournamentOvers;
  final String organizerPhoneNumber;
  final String location;
  final String tournamentFee;
  final String isCompleted;
  final String tournmentStartDate;
  final String organizerId ;
  final int totalTeam ;
  final int registerTeams;
  final String imagePath;
  Tournament(
      {required this.id,
      required this.name,
      required this.organizerName,
      required this.tournamentOvers,
      required this.isCompleted,
      required this.location,
      required this.organizerPhoneNumber,
      required this.tournamentFee,
        required this.tournmentStartDate,
        required this.organizerId,
        required this.totalTeam,
        required this.registerTeams,
        required this.imagePath,
      });
}

class Team {
  final String id;
  final String name;
  final String tournamentId;
  final String teamLeaderName;
  final String teamLeaderPhoneNumber;
  final String teamResult ;
  final String teamLocation;
  final String teamId;
  final String imageLink;
  final String roundsQualify;
  Team({
    required this.id,
    required this.name,
    required this.tournamentId,
  required this.teamLeaderName,
    required this.teamLeaderPhoneNumber,
    required this.teamResult,
    required this.teamLocation,
    required this.teamId,
    required this.imageLink,
    required this.roundsQualify,
  });
}
class UserModel {
  final String userId;
  final String name;
  final String email;
  final String phoneNumber;
  final String myRole;
  final String location;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.myRole,
    required this.location,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'],
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      myRole: map['myRole'],
      location:  map['location'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'myRole': myRole,
      'location':location,
    };
  }
}
