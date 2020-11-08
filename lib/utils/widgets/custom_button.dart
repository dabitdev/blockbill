import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {

  final String title;
  final Function onPressed;

  CustomButton({this.title, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width * 0.35),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff006EE0), Color(0xff0038AE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: FlatButton(
        child: Text(title, style: Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.white)),
        onPressed: onPressed,
      ),
    );
  }
}
