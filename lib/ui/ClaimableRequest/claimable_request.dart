
import 'package:blockbill/utils/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart' as stellarSdk;
import 'package:blockbill/utils/local_storage.dart';

class ClaimableRequest extends StatelessWidget {
  final String balance;
  final TextEditingController amountController = new TextEditingController();
  final TextEditingController addressController = new TextEditingController();
  final LocalStorage localStorage = LocalStorage();

  ClaimableRequest({this.balance});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AppBar(
              title: Text("Send Money"),
              leading: GestureDetector(
                onTap: () {  Navigator.of(context).pop(); },
                child: Icon(
                  Icons.arrow_back,  // add custom icons also
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Color(0xffececee),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: TextFormField(
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15.0),
                    hintText: 'Amount (XLM)',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.payment)),
                controller: amountController,
                keyboardType: TextInputType.number
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Color(0xffececee),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: TextField(
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15.0),
                    hintText: 'Address',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.vpn_key)),
                controller: addressController..text="GB55GX7EVYY537GVJCXYNYMYRJDPHGWM34KDCOUVZNK7K7ZWVLTSE5NW",
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                  title: 'Send Now',
                  onPressed:() =>
                  {
                   if (addressController.text.isNotEmpty && amountController.text.isNotEmpty)
                    _sendMaterialDialog(
                        context, addressController.text, amountController.text)
                  },
                ),
                CustomButton(
                    title: 'Create Claimable\nBalance',
                    onPressed: () =>  {
                      if (addressController.text.isNotEmpty && amountController.text.isNotEmpty)
                        _showClaimOptions(
                            context, addressController.text, amountController.text)
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }

  _sendMaterialDialog(context, address, amount) {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          title: new Text("Are you sure you want to send..."),
          content: new Text("The amount of " + amount + " XLM" + " to the address:" + address),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
            ,
            FlatButton(
              child: Text('Proceed'),
              onPressed: () {
                _send(context, address, amount);
                Navigator.of(context).pop();
              },
            )
          ],
        ));
  }

  _send(context, address, amount) async {
    final stellarSdk.StellarSDK sdk = stellarSdk.StellarSDK.TESTNET;
    final accountId = await localStorage.read('account_id');
    stellarSdk.KeyPair senderKeyPair = stellarSdk.KeyPair.fromSecretSeed(accountId);
    String destination = address;

    // Load sender account data from the stellar network.
    stellarSdk.AccountResponse sender = await sdk.accounts.account(senderKeyPair.accountId);

    // Build the transaction to send 100 XLM native payment from sender to destination
    stellarSdk.Transaction transaction = new stellarSdk.TransactionBuilder(sender)
        .addOperation(stellarSdk.PaymentOperationBuilder(destination, stellarSdk.Asset.NATIVE, amount).build())
        .build();

    // Sign the transaction with the sender's key pair.
    transaction.sign(senderKeyPair, stellarSdk.Network.TESTNET);

    // Submit the transaction to the stellar network.
    stellarSdk.SubmitTransactionResponse response = await sdk.submitTransaction(transaction);
    if (response.success) {
      _showPaymentSent(context, address, amount);
    }
  }

  // _createClaimMaterialDialog(context, address, amount) {
  //   showDialog(
  //       context: context,
  //       builder: (_) => new AlertDialog(
  //         title: new Text("Are you sure you want to send..."),
  //         content: new Text("The amount of " + amount + " XLM" + " to the address:" + address),
  //         actions: <Widget>[
  //           FlatButton(
  //             child: Text('Cancel'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           )
  //           ,
  //           FlatButton(
  //             child: Text('Proceed'),
  //             onPressed: () {
  //               _createClaimBalance(context, address, amount);
  //               Navigator.of(context).pop();
  //             },
  //           )
  //         ],
  //       ));
  // }

  _createClaimBalance(context, address, amount) async {
    final stellarSdk.StellarSDK sdk = stellarSdk.StellarSDK.TESTNET;
    final accountId = await localStorage.read('account_id');
    stellarSdk.KeyPair senderKeyPair = stellarSdk.KeyPair.fromSecretSeed(accountId);

    // Load sender account data from the stellar network.
    stellarSdk.AccountResponse sender = await sdk.accounts.account(senderKeyPair.accountId);
    stellarSdk.XdrClaimPredicate predicate = new stellarSdk.XdrClaimPredicate();

    List<stellarSdk.Claimant> claimants = new List();

    stellarSdk.Claimant claimant = new stellarSdk.Claimant(address, predicate);
    stellarSdk.Claimant senderClaimant = new stellarSdk.Claimant(senderKeyPair.accountId, predicate);

    claimants.add(senderClaimant);
    claimants.add(claimant);

    // Build the transaction to send 100 XLM native payment from sender to destination
    stellarSdk.Transaction transaction = new stellarSdk.TransactionBuilder(sender)
        .addOperation(stellarSdk.CreateClaimableBalanceOperationBuilder(claimants, stellarSdk.AssetTypeNative(), amount).build())
        .build();

    // Sign the transaction with the sender's key pair.
    transaction.sign(senderKeyPair, stellarSdk.Network.TESTNET);

    // Submit the transaction to the stellar network.
    stellarSdk.SubmitTransactionResponse response = await sdk.submitTransaction(transaction);
    if (response.success) {
      _showPaymentSent(context, address, amount);
    }
  }

  _showPaymentSent(context, address, amount) {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          title: new Text("Payment Sent!"),
          content: new Text("The amount of " + amount + " XLM" + " to the address:" + address),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            )
          ],
        ));
  }

  _showClaimOptions(context, address, amount) {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          title: new Text("Create Claimable Balance, select within days"),
          content: TextField(
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15.0),
                hintText: 'within days',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.calendar_today_outlined)),
            controller: addressController..text="30",
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            )
          ],
        ));
  }
}
