import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {

  final Function onPressed;
  final Color color;
  final Color iconColor;
  final Gradient gradient;

  NextButton({@required this.onPressed, this.color, this.iconColor = Colors.white, this.gradient});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      height: 60,
      width: 60,
      decoration: BoxDecoration(
          gradient: gradient,
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(40))),
      child: IconButton(
        icon: Icon(Icons.arrow_forward, color: iconColor),
        onPressed: onPressed,
      ),
    );
  }
}
