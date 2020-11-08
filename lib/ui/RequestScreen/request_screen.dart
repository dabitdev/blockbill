
import 'package:blockbill/ui/EnterDetails/enter_details.dart';
import 'package:blockbill/ui/homescreen/balance_widget.dart';
import 'package:blockbill/ui/scanbill/scan_bill.dart';
import 'package:blockbill/utils/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class RequestScreen extends StatelessWidget {
  final String bal;
  final TextEditingController titleController = new TextEditingController();
  final TextEditingController addressController = new TextEditingController();

  RequestScreen({this.bal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AppBar(
              title: Text("Create Payment Request"),
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
                    hintText: 'Payment title',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.payment)),
                controller: titleController,
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
                controller: addressController,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                  title: 'Scan bill/invoice',
                  onPressed:() => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => ScanBill())),
                ),
                CustomButton(
                    title: 'Enter manually',
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => EnterDetails(bal:bal))),
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
