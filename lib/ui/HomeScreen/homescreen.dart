import 'package:blockbill/ui/RequestScreen/request_screen.dart';
import 'package:blockbill/utils/widgets/transaction_button.dart';
import 'package:flutter/material.dart';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart' as stellarSdk;
import 'package:intl/intl.dart';

import 'balance_widget.dart';

class HomeScreen extends StatefulWidget {

  final String accountId;
  HomeScreen({this.accountId});

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
    if(widget.accountId != null)
    accountId = widget.accountId;
    setState(() => isLoading = true);
    balanceWidget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BalanceWidget(isLoading: isLoading, bal: bal),
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
                text: 'Request \nPayment',
                textColor: Colors.black,
                icon: Icons.archive_outlined,
                color: Colors.white,
                onPressed: () =>  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => RequestScreen(bal: bal))),
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
    if(widget.accountId != null){
      account = await sdk.accounts.account(stellarSdk.KeyPair.fromSecretSeed(widget.accountId).accountId);
    }
    else account = await sdk.accounts.account(accountId);
    print("sequence number: ${account.sequenceNumber}");
    for (stellarSdk.Balance balance in account.balances) {
      if(balance.assetType == stellarSdk.Asset.TYPE_NATIVE)
        balances['Stellar Lumens'] = '${balance.balance} XLM';
      else balances[balance.assetCode] = balances[balance.balance];
    }
    bal = "${double.parse(account.balances[0].balance).toStringAsFixed(5)} XLM";
    setState(() => isLoading = false);
  }
}