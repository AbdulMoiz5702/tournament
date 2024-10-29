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

