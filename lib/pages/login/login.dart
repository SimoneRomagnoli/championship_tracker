import 'package:championship_tracker/network/db.dart';
import 'package:championship_tracker/network/manager.dart';
import 'package:championship_tracker/pages/players/players_page.dart';
import 'package:championship_tracker/style/style.dart';
import 'package:flutter/material.dart';

import '../pattern.dart';

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
                checkAccess(username).then((res) {
                  if (res) {
                    NetworkManager.init(username);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => PlayersPage(coachId: username,))),
                            (route) => false);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Invalid username"))
                    );
                  }
                });
              },
            ),
          )
        ],
      ));
}
