import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:http/http.dart' as http;
import 'fanta.dart';
import 'nba.dart';

Future<Db> openDatabase() async {
  var db = await Db.create("mongodb+srv://admin:admin@championshipcluster.0lrsn8z.mongodb.net/ChampionshipDatabase?retryWrites=true&w=majority");
  await db.open();
  return db;
}

Future<List<FantaCoach>> getFantaCoaches() async {
  var db = await openDatabase();
  var coaches = await db.collection("FantaCoaches").findOne(where.eq("name", "dunkettola"));
  return (coaches!["fantacoaches"] as List).map((e) => FantaCoach.fromJson(e)).toList();
}

Future<List<NbaTeam>> getNbaTeams() async {
  var url = Uri.https("data.nba.net", "/10s/prod/v1/2022/teams.json");
  var res = await http.get(url);
  var players = jsonDecode(res.body)["league"]["standard"] as List;
  return players.map((json) => NbaTeam(json)).toList().where((team) => team.isNBAFranchise).toList();
}

Future<List<NbaPlayer>> getNbaPlayers() async {
  var url = Uri.https("data.nba.net", "/10s/prod/v1/2022/players.json");
  var res = await http.get(url);
  var players = jsonDecode(res.body)["league"]["standard"] as List;
  return players.map((json) => NbaPlayer.fromJson(json)).toList();
}

Future<List<NbaHeadCoach>> getNbaHeadCoaches() async {
  var url = Uri.https("data.nba.net", "/10s/prod/v1/2022/coaches.json");
  var res = await http.get(url);
  var coaches = jsonDecode(res.body)["league"]["standard"] as List;
  return coaches.map((json) => NbaHeadCoach.fromJson(json)).toList();
}

Future<FantaTeam> getFantaTeam(String coachId) async {
  var db = await openDatabase();
  var teams = await db.collection("FantaTeams").modernFindOne(selector: where.eq("name", "dunkettola"));
  var team = (teams!["fantateams"] as List).firstWhere((p) => p["coachId"] == coachId);
  return FantaTeam.fromJson(team);
}

void addPlayer(String coachId, NbaPlayer player) async {
  var db = await openDatabase();
  db.collection("FantaTeams").modernUpdate(
    where.eq("fantateams.coachId", coachId),
    modify.push("fantateams.\$.players", player.toMap())
  );
}

void removePlayer(String coachId, NbaPlayer player) async {
  var db = await openDatabase();
  db.collection("FantaTeams").modernUpdate(
      where.eq("fantateams.coachId", coachId),
      modify.pull("fantateams.\$.players", { "personId" : player.personId })
  );
}
