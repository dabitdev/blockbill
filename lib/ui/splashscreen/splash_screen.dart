import 'package:blockbill/ui/HomeScreen/homescreen.dart';
import 'package:blockbill/utils/local_storage.dart';
import 'package:blockbill/utils/widgets/next_button.dart';
import 'package:flutter/material.dart';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart' as stellarSdk;

class SplashScreenPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreenPage> {

  LocalStorage localStorage = LocalStorage();
  String accountId;
  bool hasAccountId = false;
  final TextEditingController addressController = new TextEditingController();
  final _key = GlobalKey<ScaffoldState>();

  final blockBill = new RichText(
    text: new TextSpan(
      children: <TextSpan>[
        new TextSpan(
            text: 'BLOCK', style: new TextStyle(color: Colors.white, fontSize: 35)),
        new TextSpan(text: '₿ILL', style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 35)),
      ],
    ),
  );

  @override
  void initState() {
    super.initState();
    getAccountId().then((value) {
      if(value != null) {
        Future.delayed(Duration(seconds: 3), () => Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext context) => HomeScreen(accountId: value))));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
        body:  SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient:  LinearGradient(
                colors: [Color(0xff006EE0), Color(0xff0038AE)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 100,
                    width: 100,
                    child: Image.asset('assets/plane.png', fit: BoxFit.contain,),
                  ),
                  blockBill,
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('A descentralized blockchain expense management system.', style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 18,color: Colors.white),textAlign: TextAlign.center,),
                  ),
                  FutureBuilder(
                    future: getAccountId(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  color: Color(0xffececee),
                                  borderRadius: BorderRadius.all(Radius.circular(15))),
                              child: TextField(
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15.0),
                                    hintText: 'Secret Key',
                                    border: InputBorder.none,
                                    prefixIcon: Icon(Icons.vpn_key)),
                                controller: addressController,
                              ),
                            ),
                            NextButton(
                                color: Colors.white,
                                iconColor: Colors.black,
                                onPressed: () {
                                  if(addressController.text.isEmpty) _key.currentState.showSnackBar(SnackBar(content: Text('Please enter a valid account id')));
                                  setAccountId(addressController.text);
                                })
                          ],
                        );
                      } else {
                        return Container();
                      }
                    },
                  )
                ],
              ),
          ),
        )
      );
  }

  getAccountId() async {
    accountId = await localStorage.read('secret_key');
    if(accountId != null) hasAccountId = true;
    return accountId;
  }

  void setAccountId(String accountId) async {
    final stellarSdk.StellarSDK sdk = stellarSdk.StellarSDK.TESTNET;
    try{
      await sdk.accounts.account(stellarSdk.KeyPair.fromSecretSeed(accountId).accountId);
      await localStorage.write('secret_key', accountId);
      Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) => HomeScreen(accountId: accountId)));
    } catch (e) {
      print(e);
      _key.currentState.showSnackBar(SnackBar(content: Text('error occurred, please check if account id is valid')));
    }
  }
}
