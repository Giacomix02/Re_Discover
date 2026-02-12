
import 'package:re_discover/data/repositories/repository_hub.dart';
import 'package:re_discover/domain/models/app_skin.dart';
import 'package:re_discover/domain/models/badge.dart' as ReDiscover;
import 'package:re_discover/domain/models/cosmetic.dart';
import 'package:re_discover/domain/models/hint.dart';
import 'package:re_discover/domain/models/poi.dart';
import 'package:re_discover/domain/models/city.dart';
import 'package:re_discover/domain/models/position.dart';
import 'package:re_discover/domain/models/quiz.dart';
import 'package:re_discover/domain/models/user.dart';
import 'package:re_discover/domain/models/visit.dart';

RepositoryHub hub = RepositoryHub();

void main() async{
  List<City> a = await hub.cities;
  List<POI> b = await hub.pois;
  List<ReDiscover.Badge> c = await hub.badges;
  List<Cosmetic> d = await hub.cosmetics;
  List<AppSkin> e = await hub.appSkins;
  List<Quiz> f = await hub.quizzes;
  List<Hint> g = await hub.hints;
  List<Position> h = await hub.positions;
  List<User> i = await hub.users;
  List<Visit> j = await hub.visits;

  print("$a[0] \n$b[0], \n$c[0], \n$d[0], \n$e[0], \n$f[0], \n$g[0], \n$h[0], \n$i[0], \n$j[0]");
}