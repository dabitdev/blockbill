import 'package:blockbill/ui/homescreen/balance_widget.dart';
import 'package:blockbill/utils/widgets/next_button.dart';
import 'package:flutter/material.dart';

class EnterDetails extends StatelessWidget {
  final String bal;
  final _formKey = GlobalKey<FormState>();


  EnterDetails({this.bal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppBar(
                title: Text("Enter Details"),
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
                      hintText: 'Total',
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.list_alt)),
                  validator: formValidation,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Color(0xffececee),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: TextFormField(
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15.0),
                      hintText: 'Currency',
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.attach_money)),
                  validator: formValidation,
                ),
              ),
              Container(
                constraints: BoxConstraints(maxHeight: 120),
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                    color: Color(0xffececee),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: TextFormField(
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15.0),
                      hintText: '\n\nItems\n\n',
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.shopping_cart)),
                  maxLines: null,
                  expands: true,
                  validator: formValidation,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                constraints: BoxConstraints(maxHeight: 90),
                decoration: BoxDecoration(
                    color: Color(0xffececee),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: TextFormField(
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(15.0),

                      hintText: '\nComment\n',
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.comment)),
                  maxLines: 5,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: NextButton(
        onPressed: () => _onSubmit(),
        gradient: LinearGradient(
          colors: [Color(0xff006EE0), Color(0xff0038AE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  _onSubmit() async {
    Scaffold.of(_formKey.currentContext).removeCurrentSnackBar();
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
  }

  String formValidation(String value) {
    return value.isEmpty ? 'Field cannot be empty' : null;
  }
}
