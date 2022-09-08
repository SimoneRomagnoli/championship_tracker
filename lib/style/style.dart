import 'package:flutter/material.dart';

const double defaultFontSize = 15.0;
const TextStyle defaultButtonTextStyle = TextStyle(fontSize: defaultFontSize, color: Colors.white);
const EdgeInsetsGeometry defaultPadding = EdgeInsets.all(10.0);

BoxDecoration defaultContainerDecoration = BoxDecoration(
    border: Border.all(
        color: Colors.black,
        width: 1.0
    ),
    borderRadius: BorderRadius.circular(3.0)
);


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
            padding: defaultPadding,
          ),
          onPressed: onPressed,
          child: Text(text, style: defaultButtonTextStyle,),
        ),
      ],
    ),
  );
}

