import 'package:blockbill/utils/widgets/transaction_button.dart';
import 'package:flutter/material.dart';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart' as stellarSdk;
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final stellarSdk.StellarSDK sdk = stellarSdk.StellarSDK.TESTNET;
  String accountId = "GBIWJ2CY7KCT2HU56TG62THEXSYWHBKGNSOVBDATHHINOWMXYWW2LC2B";
  //String accountId = "GCG6LFUSPOHGV4BECL6TJBJO66KYAN5FPO6ZCW3PTPM364DJEGXLTULF";
  stellarSdk.AccountResponse account;
  final formatter = NumberFormat.currency(locale: 'en-ca', symbol: "\$", decimalDigits: 2);
  Map<String, String> balances = {};
  bool isLoading;
  String bal = '';

  @override
  void initState() {
    super.initState();
    setState(() => isLoading = true);
    balanceWidget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
                  padding: const EdgeInsets.symmetric(horizontal:15.0, vertical: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset('assets/plane.png'),
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
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TransactionButton(
                text: 'Send \nMoney',
                textColor: Colors.white,
                icon: Icons.unarchive_outlined,
                gradient: LinearGradient(
                  colors: [Color(0xff006EE0), Color(0xff0038AE)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              TransactionButton(
                text: 'Receive \nMoney',
                textColor: Colors.black,
                icon: Icons.archive_outlined,
                color: Colors.white
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text('Balance Assets', style: Theme.of(context).textTheme.headline6),
          ),
          Expanded(
            child: isLoading ?
              Center(child: CircularProgressIndicator())
            : ListView.separated(
                shrinkWrap: true,
                //physics: NeverScrollableScrollPhysics(),
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(),
                itemCount: balances.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(balances.keys.toList()[index] ?? ''),
                    trailing: Text(balances.values.toList()[index] ?? ''),
                  );
                }),
          )
        ],
      ),
    );
  }

  Future balanceWidget() async {
    account = await sdk.accounts.account(accountId);
    print("sequence number: ${account.sequenceNumber}");
    for (stellarSdk.Balance balance in account.balances) {
      if(balance.assetType == stellarSdk.Asset.TYPE_NATIVE)
        balances['Stellar Lumens'] = '${balance.balance} XLM';
      else balances[balance.assetCode] = balances[balance.balance];
    }
    //print(stellarSdk.KeyPair.fromSecretSeed("SAIV4NA2CSC26XDYYDQXC4ZGX77IRC3HH6T4OJ5AJSEJA3QUG3OULHRU").accountId);
    bal = "${double.parse(account.balances[0].balance).toStringAsFixed(5)} XLM";
    setState(() => isLoading = false);
  }
}