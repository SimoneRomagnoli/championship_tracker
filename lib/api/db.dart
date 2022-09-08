import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:http/http.dart' as http;
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
  return players.map((json) => NbaPlayer(json)).toList();
}