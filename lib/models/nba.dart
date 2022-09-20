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

class NbaPerson {
  late String personId;
  late String firstName;
  late String lastName;
  late String pos;
  late String teamId;

  NbaPerson(this.personId, this.firstName, this.lastName, this.pos, this.teamId);

}

class NbaPlayer extends NbaPerson {
  late int jersey;

  NbaPlayer(super.personId, super.firstName, super.lastName, this.jersey, super.pos, super.teamId);

  NbaPlayer.fromJson(Map<String, dynamic> map) : this(
    map["personId"],
    map["firstName"],
    map["lastName"],
    map["jersey"] is int ? map["jersey"] : (map["jersey"] != "" ? int.parse(map["jersey"]) : 0),
    map["pos"],
    map["teamId"],
  );

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

class NbaHeadCoach extends NbaPerson {
  late String teamTricode;

  NbaHeadCoach(String personId, String firstName, String lastName, String teamId, this.teamTricode)
      : super(personId, firstName, lastName, "HC", teamId);

  NbaHeadCoach.empty() : this("", "", "", "", "");

  NbaHeadCoach.fromJson(Map<String, dynamic> map) : this(
    map["personId"],
    map["firstName"],
    map["lastName"],
    map["teamId"],
    map["teamSitesOnly"]["teamTricode"]
  );

  Map<String, dynamic> toMap() {
    return {
      "personId" : personId,
      "firstName" : firstName,
      "lastName" : lastName,
      "teamId" : teamId,
      "teamSitesOnly" : { "teamTricode" : teamTricode },
    };
  }
}