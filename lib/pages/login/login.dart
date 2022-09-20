import 'package:championship_tracker/pages/players/players_page.dart';
import 'package:championship_tracker/style/style.dart';
import 'package:flutter/material.dart';

import '../pattern.dart';
import '../team/team.dart';

class LoginPage extends DefaultPage {
  const LoginPage({Key? key}) : super(key: key, title: "Login");

  @override
  DefaultPageState createState() => LoginPageState();
}

class LoginPageState extends DefaultPageState {

  String username = "";

  @override
  Widget content(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
        padding: defaultPadding,
        child: TextField(
          onChanged: (newValue) {
            setState(() {
              username = newValue;
            });
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Username',
            hintText: 'Enter your username'),
          ),
        ),
        Container(
          height: 50,
          width: 250,
          decoration: defaultContainerDecoration,
          child: BasicStyledButton(
            text: "Login",
            onPressed: () {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) { return TeamPage(coachId: username); }), (_) => false);
              //Navigator.push(context, MaterialPageRoute(builder: (context) { return TeamPage(coachId: username); }));
            },
          ),
        )
      ],
    )
  );
}