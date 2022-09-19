import 'nba.dart';

class FantaCoach {
  String id;
  String firstName;
  String lastName;
  String teamName;
  int credits = 200;

  FantaCoach(this.id, this.firstName, this.lastName, this.teamName, this.credits);

  FantaCoach.empty() : this("", "", "", "", 0);

  FantaCoach.fromJson(Map<String, dynamic> json) : this(
      json["id"],
      json["firstName"],
      json["lastName"],
      json["teamName"],
      json["credits"]
  );

  FantaCoach spend(int amount) {
    if (amount < credits) {
      credits -= amount;
    }
    return this;
  }
}

class FantaTeam {
  String name;
  String coachId;
  NbaTeam headCoach;
  List<NbaPlayer> guards;
  List<NbaPlayer> forwards;
  List<NbaPlayer> centers;

  FantaTeam(this.name, this.coachId, this.headCoach, this.guards, this.forwards, this.centers);

  FantaTeam.fromJson(Map<String, dynamic> json) : this(
    json["name"],
    json["coachId"],
    NbaTeam(json["headCoach"]),
    [for (Map<String, dynamic> p in json["guards"]) NbaPlayer(p)],
    [for (Map<String, dynamic> p in json["forwards"]) NbaPlayer(p)],
    [for (Map<String, dynamic> p in json["centers"]) NbaPlayer(p)]
  );

  FantaTeam.empty() : this("", "", NbaTeam.empty(), [], [], []);

  void addPlayer(NbaPlayer p) {
    if (p.pos.contains("G")) {
      guards.add(p);
    } else if (p.pos.contains("F")) {
      forwards.add(p);
    } else if (p.pos.contains("C")) {
      centers.add(p);
    }
  }
}