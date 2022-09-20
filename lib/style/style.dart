import 'package:flutter/material.dart';

const double defaultFontSize = 15.0;
const TextStyle titlesTextStyle = TextStyle(fontSize: defaultFontSize * 1.5, fontWeight: FontWeight.bold);
const TextStyle defaultButtonTextStyle = TextStyle(fontSize: defaultFontSize, color: Colors.white);
const EdgeInsetsGeometry defaultPadding = EdgeInsets.all(5.0);

BoxDecoration defaultContainerDecoration = BoxDecoration();

class BasicStyledButton extends ClipRRect {
  BasicStyledButton(
      {Key? key, required String text, required Function() onPressed})
      : super(
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
              Center(
                  child: TextButton(
                style: TextButton.styleFrom(
                  padding: defaultPadding,
                ),
                onPressed: onPressed,
                child: Text(
                  text,
                  style: defaultButtonTextStyle,
                ),
              )),
            ],
          ),
        );
}
