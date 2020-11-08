import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {

  final Function onPressed;

  NextButton({@required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      height: 60,
      width: 60,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff006EE0), Color(0xff0038AE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.all(Radius.circular(40))),
      child: IconButton(
        icon: Icon(Icons.arrow_forward, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}
