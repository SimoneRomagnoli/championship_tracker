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
  NbaHeadCoach? headCoach;
  List<NbaPlayer> players;

  FantaTeam(this.name, this.coachId, this.headCoach, this.players);

  FantaTeam.fromJson(Map<String, dynamic> json) : this(
    json["name"],
    json["coachId"],
    json["headCoach"] == null ? null : NbaHeadCoach.fromJson(json["headCoach"]),
    [for (Map<String, dynamic> p in (json["players"] as List)) NbaPlayer.fromJson(p)]
  );

  FantaTeam.empty() : this("", "", null, []);

  void addPlayer(NbaPlayer p) {
    players.add(p);
  }

  void removePlayer(String personId) {
    players = players.where((p) => p.personId != personId).toList();
  }

  void addHeadCoach(NbaHeadCoach coach) {
    headCoach = coach;
  }

  void removeHeadCoach() {
    headCoach = null;
  }
}