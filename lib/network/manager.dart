import 'dart:convert';

import 'package:championship_tracker/network/db.dart';
import 'package:championship_tracker/utils/monads.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:http/http.dart' as http;

import '../models/fanta.dart';
import '../models/nba.dart';
import '../utils/tuples.dart';

const String nbaDataDomain = "data.nba.net";

const String fantaCoachCollection = "FantaCoaches";
const String fantaTeamsCollection = "FantaTeams";

const String championshipName = "name";
const String championshipNameValue = "dunkettola";

const String fantacoachesList = "fantacoaches";
const String fantateamsList = "fantateams";

/// Contains the principal api of the application.
/// It is the interface for http requests and database access.
class NetworkManager {

  static String user = "";

  static init(String username) {
    user = username;
  }

  static Future<Db> openDb() async {
    var db = await createDatabase(user);
    await db.open();
    return db;
  }

  /* READ OPERATIONS */

  /// Returns the list of fantacoaches of the championship.
  static Future<List<FantaCoach>> getFantaCoaches() async {
    var db = await openDb();
    var coaches = await db
        .collection(fantaCoachCollection)
        .findOne(where.eq(championshipName, championshipNameValue));
    return (coaches![fantacoachesList] as List)
        .map((e) => FantaCoach.fromJson(e))
        .toList();
  }

  /// Returns the fantacoach with the specified id
  static Future<FantaCoach> getFantaCoach(String coachId) async {
    List<FantaCoach> coaches = await getFantaCoaches();
    return coaches.firstWhere((fc) => fc.id == coachId);
  }

  /// Returns all the nba teams
  static Future<List<NbaTeam>> getNbaTeams() async {
    var url = Uri.https(nbaDataDomain, nbaRequestUri(NbaRequests.teams));
    var res = await http.get(url);
    var players = jsonDecode(res.body)["league"]["standard"] as List;
    return players
        .map((json) => NbaTeam(json))
        .toList()
        .where((team) => team.isNBAFranchise)
        .toList();
  }

  /// Returns all the nba players
  static Future<List<NbaPlayer>> getNbaPlayers() async {
    var url = Uri.https(nbaDataDomain, nbaRequestUri(NbaRequests.players));
    var res = await http.get(url);
    var players = jsonDecode(res.body)["league"]["standard"] as List;
    return players.map((json) => NbaPlayer.fromJson(json)).toList();
  }

  /// Returns all the nba head coaches
  static Future<List<NbaHeadCoach>> getNbaHeadCoaches() async {
    var url = Uri.https(nbaDataDomain, nbaRequestUri(NbaRequests.coaches));
    var res = await http.get(url);
    var coaches = jsonDecode(res.body)["league"]["standard"] as List;
    return coaches.where((hc) => !hc["isAssistant"]).map((json) => NbaHeadCoach.fromJson(json)).toList();
  }

  /// Gets both nba players and head coaches
  static Future<List<NbaPerson>> getNbaPlayersAndHeadCoaches() async {
    List<NbaPlayer> players = await getNbaPlayers();
    List<NbaHeadCoach> coaches = await getNbaHeadCoaches();
    List<NbaPerson> all = [];
    return all.also((it) => it.addAll(players)).also((it) => it.addAll(coaches)).also((it) => it.sort(sortNbaPlayers));
  }

  /// Encapsulates all nba players, nba teams and fanta teams in a tuple
  static Future<Tuple3<List<NbaPerson>, List<FantaTeam>, List<NbaTeam>>> getPlayersPageInfo() async {
    List<NbaPerson> players = await getNbaPlayersAndHeadCoaches();
    List<FantaTeam> fantateams = await getFantaTeams();
    List<NbaTeam> teams = await getNbaTeams();
    return Tuple3(first: players, second: fantateams, third: teams);
  }

  /// Encapsulates all nba teams and fanta teams in a tuple
  static Future<Tuple2<FantaTeam, List<NbaTeam>>> getTeamPageInfo(String coachId) async {
    List<FantaTeam> fantateams = await getFantaTeams();
    List<NbaTeam> teams = await getNbaTeams();
    return Tuple2(first: fantateams.firstWhere((t) => t.coachId == coachId), second: teams);
  }

  /// Returns all the fanta teams
  static Future<List<FantaTeam>> getFantaTeams() async {
    var db = await openDb();
    var teams = await db.collection(fantaTeamsCollection).modernFindOne(selector: where.eq(championshipName, championshipNameValue));
    return (teams![fantateamsList] as List).map((t) => FantaTeam.fromJson(t).also((t) => t.players.sort(sortNbaPlayers))).toList();
  }

  /// Returns the fanta team of the specified fantacoach
  static Future<FantaTeam> getFantaTeam(String coachId) async {
    var teams = await getFantaTeams();
    return teams.firstWhere((t) => t.coachId == coachId);
  }

  /* UPDATE OPERATIONS */

  /// Reduces the credits of the specified fanta coach
  static void spendCredits(String coachId, int amount) async {
    var db = await openDb();
    db.collection(fantaCoachCollection).modernUpdate(
        where.eq("$fantacoachesList.id", coachId),
        modify.inc("$fantacoachesList.\$.credits", -amount)
    );
  }

  /// Adds a player or head coach to the team of the specified fanta coach
  static void addToTeam(String coachId, NbaPerson p) {
    if (p is NbaPlayer) addPlayer(coachId, p);
    if (p is NbaHeadCoach) addHeadCoach(coachId, p);
  }

  /// Removes a player or head coach from the team of the specified fanta coach
  static void removeFromTeam(String coachId, NbaPerson p) {
    if (p is NbaPlayer) removePlayer(coachId, p);
    if (p is NbaHeadCoach) removeHeadCoach(coachId, p);
  }


  /// Adds a player to the team of the specified fanta coach
  static void addPlayer(String coachId, NbaPlayer player) async {
    var db = await openDb();
    db.collection(fantaTeamsCollection).modernUpdate(
        where.eq("$fantateamsList.coachId", coachId),
        modify.push("$fantateamsList.\$.players", player.toMap())
    );
  }

  /// Removes a player from the team of the specified fanta coach
  static void removePlayer(String coachId, NbaPlayer player) async {
    var db = await openDb();
    db.collection(fantaTeamsCollection).modernUpdate(
        where.eq("$fantateamsList.coachId", coachId),
        modify.pull("$fantateamsList.\$.players", { "personId" : player.personId })
    );
  }

  /// Adds a head coach to the team of the specified fanta coach
  static void addHeadCoach(String coachId, NbaHeadCoach hc) async {
    var db = await openDb();
    db.collection(fantaTeamsCollection).modernUpdate(
        where.eq("$fantateamsList.coachId", coachId),
        modify.set("$fantateamsList.\$.headCoach", hc.toMap())
    );
  }

  /// Removes a head coach from the team of the specified fanta coach
  static void removeHeadCoach(String coachId, NbaHeadCoach hc) async {
    var db = await openDb();
    db.collection(fantaTeamsCollection).modernUpdate(
        where.eq("$fantateamsList.coachId", coachId),
        modify.set("$fantateamsList.\$.headCoach", null)
    );
  }

}

int sortNbaPlayers(NbaPerson a, NbaPerson b) {
  return a.lastName.compareTo(b.lastName);
}

String nbaRequestUri(NbaRequests type) {
  return "/10s/prod/v1/2022/${type.name}.json";
}

enum NbaRequests {
  players, teams, coaches
}