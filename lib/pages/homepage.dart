import './principal_list.dart';
import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  final String _userid;
  const Menu(this._userid);
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Menu",
          style:
              TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
        ),
        elevation: .1,
        backgroundColor: Color.fromRGBO(59, 87, 110, 1.0),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: GridView.count(
          crossAxisCount: 2,
          //padding: EdgeInsets.all(13.0),
          children: <Widget>[
            //--------------------------PRINCIPLE REPORT-------------------------
            Card(
              margin: EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              principleList(widget._userid.toUpperCase())))
                },
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.account_balance_wallet,
                          size: 70.0, color: Colors.red),
                      Text("Stock Report", style: new TextStyle(fontSize: 17))
                    ],
                  ),
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () => {
                  // Navigator.push(
                  //     context, MaterialPageRoute(builder: (context) => null))
                },
                splashColor: Colors.brown,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.assignment,
                          size: 70.0, color: Colors.lightBlue),
                      Text("GRN Report", style: new TextStyle(fontSize: 17))
                    ],
                  ),
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {},
                splashColor: Colors.red,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.account_balance,
                          size: 70.0, color: Colors.brown),
                      Text("Transaction Report",
                          style: new TextStyle(fontSize: 17))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
