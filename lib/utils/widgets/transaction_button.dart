import 'package:flutter/material.dart';

class TransactionButton extends StatelessWidget {
  final Widget child;
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isDisabled;
  final Color color;
  final Gradient gradient;
  final Color textColor;


  const TransactionButton(
      {Key key, this.text, this.onPressed, this.textColor, this.child, this.isDisabled, this.icon, this.color = Colors.white, this.gradient})
      : assert(child != null || text != null),
        super(key: key);


  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width * 0.3,
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Color(0xff006EE0).withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 7,
              offset: Offset(0, 8), // changes position of shadow
            ),
          ],
          gradient: gradient,
          color: color,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(icon, color: textColor),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(text,style: Theme.of(context).textTheme.subtitle2.copyWith(color: textColor)),
            )
          ],
        ),
      ),
      onTap: onPressed,
    );
  }
}
