import 'package:championship_tracker/api/db.dart';
import 'package:championship_tracker/api/fanta.dart';
import 'package:championship_tracker/style/style.dart';
import 'package:championship_tracker/utils/tuples.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:championship_tracker/pages/players/players_page.dart';

import '../api/nba.dart';
import '../pages/players/filters.dart';

class MyTeamV2Page extends StatefulWidget {
  const MyTeamV2Page({Key? key}) : super(key: key);

  @override
  State<MyTeamV2Page> createState() => _MyTeamV2PageState();
}

class _MyTeamV2PageState extends State<MyTeamV2Page> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: TextButton(
          child: Text('Open bottom bar'),
          onPressed: () {},
        ),
      ),
    );
  }
}
