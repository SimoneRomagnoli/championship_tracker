import 'dart:convert';

import 'package:championship_tracker/utils/monads.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:http/http.dart' as http;
import '../utils/tuples.dart';
import '../models/fanta.dart';
import '../models/nba.dart';

Future<Db> openDatabase() async {
  var db = await Db.create(
      "mongodb+srv://admin:admin@championshipcluster.0lrsn8z.mongodb.net/ChampionshipDatabase?retryWrites=true&w=majority");
  await db.open();
  return db;
}

Future<List<FantaCoach>> getFantaCoaches() async {
  var db = await openDatabase();
  var coaches = await db
      .collection("FantaCoaches")
      .findOne(where.eq("name", "dunkettola"));
  return (coaches!["fantacoaches"] as List)
      .map((e) => FantaCoach.fromJson(e))
      .toList();
}

Future<FantaCoach> getFantaCoach(String coachId) async {
  List<FantaCoach> coaches = await getFantaCoaches();
  return coaches.firstWhere((fc) => fc.id == coachId);
}

Future<List<NbaTeam>> getNbaTeams() async {
  var url = Uri.https("data.nba.net", "/10s/prod/v1/2022/teams.json");
  var res = await http.get(url);
  var players = jsonDecode(res.body)["league"]["standard"] as List;
  return players
      .map((json) => NbaTeam(json))
      .toList()
      .where((team) => team.isNBAFranchise)
      .toList();
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
  return coaches.where((hc) => !hc["isAssistant"]).map((json) => NbaHeadCoach.fromJson(json)).toList();
}

Future<List<NbaPerson>> getNbaPlayersAndHeadCoaches() async {
  List<NbaPlayer> players = await getNbaPlayers();
  List<NbaHeadCoach> coaches = await getNbaHeadCoaches();
  List<NbaPerson> all = [];
  return all.also((it) => it.addAll(players)).also((it) => it.addAll(coaches)).also((it) => it.sort(sortNbaPlayers));
}

Future<Tuple3<List<NbaPerson>, List<FantaTeam>, List<NbaTeam>>> getPlayersPageInfo() async {
  List<NbaPerson> players = await getNbaPlayersAndHeadCoaches();
  List<FantaTeam> fantateams = await getFantaTeams();
  List<NbaTeam> teams = await getNbaTeams();
  return Tuple3(first: players, second: fantateams, third: teams);
}

Future<Tuple2<FantaTeam, List<NbaTeam>>> getTeamPageInfo(String coachId) async {
  List<FantaTeam> fantateams = await getFantaTeams();
  List<NbaTeam> teams = await getNbaTeams();
  return Tuple2(first: fantateams.firstWhere((t) => t.coachId == coachId), second: teams);
}

Future<List<FantaTeam>> getFantaTeams() async {
  var db = await openDatabase();
  var teams = await db.collection("FantaTeams").modernFindOne(selector: where.eq("name", "dunkettola"));
  return (teams!["fantateams"] as List).map((t) => FantaTeam.fromJson(t).also((t) => t.players.sort(sortNbaPlayers))).toList();
}

Future<FantaTeam> getFantaTeam(String coachId) async {
  var teams = await getFantaTeams();
  return teams.firstWhere((t) => t.coachId == coachId);
}

void addToTeam(String coachId, NbaPerson p) {
  if (p is NbaPlayer) addPlayer(coachId, p);
  if (p is NbaHeadCoach) addHeadCoach(coachId, p);
}

void removeFromTeam(String coachId, NbaPerson p) {
  if (p is NbaPlayer) removePlayer(coachId, p);
  if (p is NbaHeadCoach) removeHeadCoach(coachId, p);
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

void addHeadCoach(String coachId, NbaHeadCoach hc) async {
  var db = await openDatabase();
  db.collection("FantaTeams").modernUpdate(
      where.eq("fantateams.coachId", coachId),
      modify.set("fantateams.\$.headCoach", hc.toMap())
  );
}

void removeHeadCoach(String coachId, NbaHeadCoach hc) async {
  var db = await openDatabase();
  db.collection("FantaTeams").modernUpdate(
      where.eq("fantateams.coachId", coachId),
      modify.set("fantateams.\$.headCoach", null)
  );
}

int sortNbaPlayers(NbaPerson a, NbaPerson b) {
  return a.lastName.compareTo(b.lastName);
}