import 'package:flutter/material.dart';

EdgeInsetsGeometry defaultPadding = const EdgeInsets.all(10.0);

class BasicStyledButton extends ClipRRect {
  BasicStyledButton({Key? key, required String text, required Function() onPressed}) : super(
    key: key,
    borderRadius: BorderRadius.circular(4),
    child: Stack(
      children: <Widget>[
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Color(0xFF0D47A1),
                  Color(0xFF1976D2),
                  Color(0xFF42A5F5),
                ],
              ),
            ),
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.all(16.0),
            textStyle: const TextStyle(fontSize: 20, color: Colors.white),
          ),
          onPressed: onPressed,
          child: Text(text, style: const TextStyle(fontSize: 20, color: Colors.white)),
        ),
      ],
    ),
  );
}

class BlackColor extends TextStyle {
  const BlackColor(): super(
    color: Colors.black
  );
}

class WhiteColor extends TextStyle {
  const WhiteColor(): super(
      color: Colors.white
  );
}
class BlueColor extends TextStyle {
  const BlueColor(): super(
      color: Colors.blue
  );
}
