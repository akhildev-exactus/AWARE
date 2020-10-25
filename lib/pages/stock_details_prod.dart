import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'stock_Details_data.dart';

class stock_prod_details extends StatefulWidget {
  final String prin_code, prod_code, prod_name, model, pqty, puom, lqty, luom;

  const stock_prod_details(this.prin_code, this.prod_code, this.prod_name,
      this.model, this.pqty, this.puom, this.lqty, this.luom);

  @override
  _stock_prod_detailsState createState() => _stock_prod_detailsState();
}

class _stock_prod_detailsState extends State<stock_prod_details> {
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
    return MaterialApp(
        title: 'Aware APP | Stock Details',
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              title: Text(
                "Stock Details ",
                style: TextStyle(
                    fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
              ),
              backgroundColor: Color.fromRGBO(59, 87, 110, 1.0),
            ),
            body: Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _topData(),
                  SizedBox(
                    height: 15,
                  ),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      2.0,
                      0.0,
                      2.0,
                      0.0,
                    ),
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return index == 0
                            ? _headerTable(index)
                            : _dataTable(index - 1);
                      },
                      itemCount: _datas.length + 1,
                    ),
                  ))
                ],
              ),
            )));
  }

  _topData() {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.0, top: 20, left: 10, right: 15),
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
                      fontSize: 15),
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
                        fontSize: 15),
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
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _headerTable(index) {
    return Table(
      border: TableBorder.symmetric(
        inside: BorderSide(width: 0.5, color: Colors.red[300]),
        outside: BorderSide(width: 3),
      ),
      columnWidths: {
        0: FractionColumnWidth(0.20),
        1: FractionColumnWidth(0.50),
        2: FractionColumnWidth(0.25)
      },
      children: [
        TableRow(children: [
          _tablecolumns("COO"),
          _tablecolumns("LOT_NO"),
          _tablecolumns("QUANTITY"),
        ]),
        TableRow(children: [
          _tablecolumns("EXP_DATE"),
          _tablecolumns("DOC_REF"),
          _tablecolumns("CTN  \t|\t PCS"),
        ]),
      ],
    );
  }

  _dataTable(index) {
    var coo = _datas[index].org_country;
    var lot_no = _datas[index].lot_no;
    var date = _datas[index].date.toString();
    var doc_ref = _datas[index].doc_ref;
    var pqty = _datas[index].p_qty;
    var lqty = _datas[index].l_qty;
    return SingleChildScrollView(
      child: Table(
        border: TableBorder.lerp(
            TableBorder(
                verticalInside: BorderSide(width: 1, color: Colors.red),
                horizontalInside: BorderSide(width: 1, color: Colors.red),
                left: BorderSide(color: Colors.black, width: 6),
                right: BorderSide(color: Colors.black, width: 6)),
            TableBorder(
              bottom: BorderSide(width: 8, color: Colors.indigoAccent),
            ),
            0.5),
        columnWidths: {
          0: FractionColumnWidth(0.20),
          1: FractionColumnWidth(0.50),
          2: FractionColumnWidth(0.25)
        },
        children: [
          TableRow(children: [
            _tabledata(coo),
            _tabledata(lot_no),
            _tabledata(" "),
          ]),
          TableRow(children: [
            _tabledata(date),
            _tabledata(doc_ref),
            if (_datas[index].p_uom == "CTN" && _datas[index].l_uom == "PCS")
              _tabledata(pqty.toString() + "  \t\t|\t\t " + lqty.toString()),
            if (_datas[index].p_uom == "CTN" && _datas[index].l_uom == "CTN")
              _tabledata(pqty.toString() + "  \t\t|\t\t " + lqty.toString()),
            if (_datas[index].p_uom == "PCS" && _datas[index].l_uom == "CTN")
              _tabledata(lqty.toString() + "  \t\t|\t\t " + pqty.toString()),
            // if (_datas[index].p_uom == "PCS" && _datas[index].l_uom == "PCS")
            if (_datas[index].p_uom == "PCS" && _datas[index].l_uom == "PCS" ||
                _datas[index].p_uom.startsWith("PR") ||
                _datas[index].p_uom.startsWith("B"))
              _tabledata(lqty.toString() + "  \t\t|\t\t " + pqty.toString()),
          ]),
        ],
      ),
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
      ),
    );
  }

  _tablecolumns(String text) {
    return TableCell(
        child: SizedBox(
            height: 35,
            child: Center(
              child: Text(text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
            )));
  }

  _tabledata(String text) {
    return TableCell(
        child: SizedBox(
            height: 35,
            child: Center(
                child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                  color: Colors.black),
            ))));
  }
}
