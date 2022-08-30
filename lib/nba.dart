// import 'db.dart';

class FantaCoach {
  String id;
  String firstName;
  String lastName;
  int credits = 200;

  FantaCoach(this.id, this.firstName, this.lastName);

  FantaCoach.fromJson(Map<String, dynamic> json) : this(json["id"], json["firstName"], json["lastName"]);

  FantaCoach spend(int amount) {
    if (amount < credits) {
      credits -= amount;
    }
    return this;
  }
}

class NbaTeam {
  late String teamId;
  late String city;
  late String nickname;
  late String urlName;
  late String fullName;
  late String tricode;

  NbaTeam(Map<String, dynamic> map) {
    teamId = map["teamId"];
    city = map["city"];
    nickname = map["nickname"];
    urlName = map["urlName"];
    fullName = map["fullName"];
    tricode = map["tricode"];
  }
}

class NbaPlayer {
  late String personId;
  late String firstName;
  late String lastName;
  late int jersey;
  late String pos;
  late String teamId;
  // late NbaTeam team;

  NbaPlayer(Map<String, dynamic> map) {
    personId = map["personId"];
    firstName = map["firstName"];
    lastName = map["lastName"];
    jersey = map["jersey"] != "" ? int.parse(map["jersey"]) : 0;
    pos = map["pos"];
    teamId = map["teamId"];
    // team = ...
  }
}