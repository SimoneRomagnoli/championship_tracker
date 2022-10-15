import 'package:mongo_dart/mongo_dart.dart';

const String connectionStringPrefix = "mongodb+srv://";
const String connectionStringSuffix = "@championshipcluster.0lrsn8z.mongodb.net/ChampionshipDatabase?retryWrites=true&w=majority";

Future<Db> createDatabase(String username) async {
  return Db.create("$connectionStringPrefix$username:$username$connectionStringSuffix");
}

Future<bool> checkAccess(String username) async {
  try {
    var db = await createDatabase(username);
    await db.open();
  } catch(e) {
    return false;
  }
  return true;
}
