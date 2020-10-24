import 'package:aware_app/pages/stock_details_prod.dart';
import 'stock_data.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class StockReport extends StatefulWidget {
  final String _prin_code;
  final String _prin_name;
  const StockReport(this._prin_code, this._prin_name);
  @override
  StockReportState createState() => StockReportState();
}

class StockReportState extends State<StockReport> {
  @override
  void initState() {
    fetchDatas(widget._prin_code).then((value) {
      setState(() {
        _datas.addAll(value);
        _datasForDisplay = _datas;

        if (_datas.isEmpty) {
          _alert("No Records Found", Colors.red);
        }
      });
    });
    super.initState();
  }

  List<StockVal> _datas = List<StockVal>();
  List<StockVal> _datasForDisplay = List<StockVal>();

  Future<List<StockVal>> fetchDatas(String pcode) async {
    var url = 'http://exactusnet.dyndns.org:4005/api/StockReport/$pcode';
    var response = await http.get(url);

    var datas = List<StockVal>();
    if (response.statusCode == 200) {
      Object datasJson = json.decode(response.body.substring(0));
      for (var dataJson in datasJson) {
        datas.add(StockVal.fromJson(dataJson));
      }
    }
    return datas;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget._prin_name,
            style: TextStyle(
                fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color.fromRGBO(59, 87, 110, 1.0),
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return index == 0 ? _searchBar() : _listItem(index - 1);
          },
          itemCount: _datasForDisplay.length + 1,
        ));
  }

  _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(hintText: 'Search...'),
        onChanged: (text) {
          text = text.toUpperCase();
          setState(() {
            _datasForDisplay = _datas.where((ls_data) {
              var dataProd = ls_data.prodname.toUpperCase();
              return dataProd.contains(text);
            }).toList();
          });
        },
      ),
    );
  }

  _listItem(index) {
    String pqty = _datasForDisplay[index].pqty.toString();
    String puom = _datasForDisplay[index].puom;
    String lqty = _datasForDisplay[index].lqty.toString();
    String luom = _datasForDisplay[index].luom;
    String model = _datasForDisplay[index].model;
    String prodcode = _datasForDisplay[index].prodcode;
    String prodname = _datasForDisplay[index].prodname;
    return Card(
      child: ListTile(
        title: Text(
          prodname,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          children: <Widget>[
            new Align(
              alignment: Alignment.centerLeft,
              child: Text(
                prodcode,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            if (model != null)
              new Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  model.toString(),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                _align(
                  pqty + " ",
                ),
                _align(
                  puom + "  ",
                ),
                if (puom != luom)
                  _align(
                    lqty.toString() + " ",
                  ),
                if (puom != luom)
                  _align(
                    luom,
                  ),
              ],
            ),
          ],
        ),
        trailing: Icon(
          Icons.receipt,
          color: Colors.green,
        ),
        onTap: () {
          Navigator.push(
              context,
              // MaterialPageRoute(
              //     builder: (context) => stockDetailsReport(widget._prin_code,
              //         prodcode, prodname, model, pqty, puom, lqty, luom)));
              MaterialPageRoute(
                  builder: (context) => stock_detail_prod(widget._prin_code,
                      prodcode, prodname, model, pqty, puom, lqty, luom)));
        },
      ),
    );
  }

  _align(var _text) {
    return new Align(
      child: Text(
        _text,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _alert(String _msg, clr) {
    Widget okButton = FlatButton(
      child: Text("OK",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          )),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(
        _msg,
        style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: clr[700]),
      ),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
