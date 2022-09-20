class NbaTeam {
  late String teamId;
  late String city;
  late String nickname;
  late String urlName;
  late String fullName;
  late String tricode;
  late bool isNBAFranchise;

  NbaTeam(Map<String, dynamic> map) {
    teamId = map["teamId"];
    city = map["city"];
    nickname = map["nickname"];
    urlName = map["urlName"];
    fullName = map["fullName"];
    tricode = map["tricode"];
    isNBAFranchise = map["isNBAFranchise"];
  }

  NbaTeam.empty() {
    teamId = "";
    city = "";
    nickname = "";
    urlName = "";
    fullName = "";
    tricode = "";
    isNBAFranchise = false;
  }
}

class NbaPlayer {
  late String personId;
  late String firstName;
  late String lastName;
  late int jersey;
  late String pos;
  late String teamId;

  NbaPlayer(this.personId, this.firstName, this.lastName, this.jersey, this.pos, this. teamId);

  NbaPlayer.fromJson(Map<String, dynamic> map) {
    personId = map["personId"];
    firstName = map["firstName"];
    lastName = map["lastName"];
    jersey = map["jersey"] is int ? map["jersey"] : (map["jersey"] != "" ? int.parse(map["jersey"]) : 0);
    pos = map["pos"];
    teamId = map["teamId"];
  }

  Map<String, dynamic> toMap() {
    return {
      "personId" : personId,
      "firstName" : firstName,
      "lastName" : lastName,
      "jersey" : jersey,
      "pos" : pos,
      "teamId" : teamId
    };
  }
}

class NbaHeadCoach {
  late String personId;
  late String firstName;
  late String lastName;
  late String teamId;
  late String teamTricode;

  NbaHeadCoach(this.personId, this.firstName, this.lastName, this.teamId, this.teamTricode);

  NbaHeadCoach.empty() : this("", "", "", "", "");

  NbaHeadCoach.fromJson(Map<String, dynamic> map) : this(
    map["personId"],
    map["firstName"],
    map["lastName"],
    map["teamId"],
    map["teamSitesOnly"]["teamTricode"]
  );
}