import 'package:flutter/material.dart';

class BalanceWidget extends StatelessWidget {

  final String bal;
  final bool isLoading;

  BalanceWidget({this.bal, this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(40)),
        boxShadow: [
          BoxShadow(
            color: Color(0xff006EE0).withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 7,
            offset: Offset(0, 8), // changes position of shadow
          ),
        ],
        gradient: LinearGradient(
          colors: [Color(0xff006EE0), Color(0xff0038AE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0,65.0,15.0,30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(height:70, width: 70, child: Image.asset('assets/plane.png')),
                CircleAvatar(backgroundColor: Colors.white.withOpacity(0.8), radius: 25, child: Icon(Icons.person_outline),),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:15.0, vertical: 8.0),
            child: isLoading ? CircularProgressIndicator() :
            Text(bal, style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.white),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text('Your Balance', style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white)),
          )
        ],
      ),
    );
  }
}
