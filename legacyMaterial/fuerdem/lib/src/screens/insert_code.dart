import 'package:flutter/material.dart';

class InsertCode extends StatefulWidget {
  @override
  _InsertCodeState createState() => _InsertCodeState();
}

class _InsertCodeState extends State<InsertCode> {
  TextEditingController textEditingController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.qr_code,
                  size: 200,
                ),
                Text('Scan QrCode')
              ],
            ),
          ),
          Container(
            height: 20,
          ),
          Center(child: Text('Or')),
          Container(
            height: 20,
          ),
          Container(
            height: 40,
            decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: TextField(
                controller: textEditingController,
                decoration: InputDecoration(hintText: 'Insert your code here'),
              ),
            ),
          ),
          Container(
            height: 20,
          ),
          Center(child: Text('Or')),
          Container(
            height: 20,
          ),
          Container(
            child: RaisedButton(
              onPressed: () {},
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Text('Request a Code'),
            ),
          ),
          Container(
            height: 20,
          ),
          Center(child: Text('Lost code')),
          Container(
            height: 20,
          ),
          Center(child: Text('Explore anonymously')),
        ],
      ),
      appBar: AppBar(
        title: Center(child: Text('Insert Code')),
      ),
    );
}
