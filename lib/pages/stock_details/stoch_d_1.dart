import 'package:flutter/material.dart';

class stock_d extends StatefulWidget {
  final String prin_code, prod_code, prod_name, model, pqty, puom, lqty, luom;

  const stock_d(this.prin_code, this.prod_code, this.prod_name, this.model,
      this.pqty, this.puom, this.lqty, this.luom);

  @override
  _stock_dState createState() => _stock_dState();
}

class _stock_dState extends State<stock_d> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter layout demo',
        home: Scaffold(
            appBar: AppBar(title: Text('Stock D')),
            body: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate([
                    ListTile(title: Text(widget.prod_name)),
                    ListTile(title: Text(widget.prod_code)),
                    ListTile(title: Text(widget.model)),
                    ListTile(
                        title: Text(
                      widget.pqty +
                          " " +
                          widget.puom +
                          " " +
                          widget.lqty +
                          " " +
                          widget.luom,
                      textAlign: TextAlign.end,
                    )),
                  ]),
                ),
                SliverFillRemaining(
                  // hasScrollBody: false,
                  child: Container(
                    color: Colors.lightBlue[50],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("1 \n 2"),
                            Text("1 \n 2"),
                            Text("1 \n 2"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )));
  }
}
