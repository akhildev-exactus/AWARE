import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'stock_Details_data.dart';

class stock_detail_prod extends StatefulWidget {
  final String prin_code, prod_code, prod_name, model, pqty, puom, lqty, luom;

  const stock_detail_prod(this.prin_code, this.prod_code, this.prod_name,
      this.model, this.pqty, this.puom, this.lqty, this.luom);
  @override
  _stock_detail_prodState createState() => _stock_detail_prodState();
}

class _stock_detail_prodState extends State<stock_detail_prod> {
  List<Stock_details_data> _datas = List<Stock_details_data>();

  Future<List<Stock_details_data>> fetchDatas(
      String prin_code, prod_code) async {
    var url =
        'http://exactusnet.dyndns.org:4005/api/StockDetail/$prin_code/$prod_code';
    var response = await http.get(url);

    var datas = List<Stock_details_data>();
    if (response.statusCode == 200) {
      Object datasJson = json.decode(response.body.substring(0));
      for (var dataJson in datasJson) {
        datas.add(Stock_details_data.fromJson(dataJson));
      }
    }
    return datas;
  }

  @override
  bool get sizedByParent => true;

  @override
  void initState() {
    fetchDatas(widget.prin_code, widget.prod_code).then((value) {
      setState(() {
        _datas.addAll(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Stock Details ",
            style: TextStyle(
                fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color.fromRGBO(59, 87, 110, 1.0),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _topData(),
            SizedBox(
              height: 15,
            ),
            Expanded(
                child: ListView.builder(
              itemBuilder: (context, index) {
                return index == 0
                    ? _list_head(index)
                    : _list_details(index - 1);
              },
              itemCount: _datas.length + 1,
            ))
          ],
        ),
      ),
    );
  }

  _topData() {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.0, top: 20, left: 20, right: 20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*2*/
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    widget.prod_name,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.blue[700]),
                  ),
                ),
                Text(
                  widget.prod_code,
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.black,
                      fontSize: 16),
                ),
                SizedBox(
                  height: 10,
                ),
                if (widget.model != null)
                  Text(
                    widget.model,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.black,
                        fontSize: 16),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    _align(
                      widget.pqty + " ",
                    ),
                    _align(
                      widget.puom + "  ",
                    ),
                    if (widget.puom != widget.luom)
                      _align(
                        widget.lqty.toString() + " ",
                      ),
                    if (widget.puom != widget.luom)
                      _align(
                        widget.luom,
                      ),
                    // Text("P_qty P_uom L_qty L_uom")
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _list_head(index) {
    return SingleChildScrollView(
      child: DataTable(
        columns: <DataColumn>[
          DataColumn(label: _textFile("COO \n\nEXPDATE", 13, Colors.red)),
          DataColumn(label: _textFile("LOT NO \n\nDOC_REF", 13, Colors.red)),
          DataColumn(
              label: _textFile("Qty\n\nCTN \t\t\t\t PCS", 13, Colors.red)),
        ],
        headingRowHeight: 80.3,
        // horizontalMargin: 8,

        rows: <DataRow>[
          DataRow(cells: <DataCell>[
            DataCell(Container(
              width: 70,
              child: Text(""),
            )),
            DataCell(Container(
              width: 55,
              child: Text(""),
            )),
            DataCell(
              Text(""),
            ),
          ])
        ],
        dataRowHeight: 1.3,
        // horizontalMargin: 30,
      ),
    );
  }

  _list_details(index) {
    var coo = _datas[index].org_country;
    var lot_no = _datas[index].lot_no;
    var date = _datas[index].date.toString().split("T");
    var doc_ref = _datas[index].doc_ref;
    var pqty = _datas[index].p_qty;
    var lqty = _datas[index].l_qty;
    return SingleChildScrollView(
      child: DataTable(
        columns: <DataColumn>[
          DataColumn(label: Text("")),
          DataColumn(label: Text("")),
          DataColumn(label: Text("")),
        ],
        dividerThickness: 8,
        headingRowHeight: 5.3,
        rows: <DataRow>[
          DataRow(cells: <DataCell>[
            DataCell(Container(
              width: 61,
              child: _textFile(coo + " \n\n" + date[0], 12, Colors.black),
            )),
            DataCell(
              Container(
                width: 78,
                child: _textFile(
                    lot_no.toString() + "\n\n" + doc_ref.toString(),
                    12,
                    Colors.black),
              ),
            ),
            DataCell(_textFile(
                pqty.toString() + "\t\t\t\t\t\t\t\t\t\t\t " + lqty.toString(),
                12,
                Colors.black)),
          ])
        ],
        // horizontalMargin: 9,
        dataRowHeight: 80.3,
      ),
    );
  }

  _textFile(_text, double size, clr) {
    return Text(
      _text,
      style: TextStyle(
        // fontFamily: 'Montserrat',
        color: clr,
        fontSize: size,
      ),
      textAlign: TextAlign.center,
    );
  }

  _align(var _text) {
    return new Align(
      child: Text(
        _text,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        // textAlign: TextAlign.center,
      ),
    );
  }
}
