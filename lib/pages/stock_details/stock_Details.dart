import '../stock_Details_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class stockDetailsReport extends StatefulWidget {
  final String prin_code, prod_code, prod_name, model, pqty, puom, lqty, luom;

  const stockDetailsReport(this.prin_code, this.prod_code, this.prod_name,
      this.model, this.pqty, this.puom, this.lqty, this.luom);

  @override
  _stockDetailsReportState createState() => _stockDetailsReportState();
}

class _stockDetailsReportState extends State<stockDetailsReport> {
  @override
  void initState() {
    fetchDatas(widget.prin_code, widget.prod_code).then((value) {
      setState(() {
        _datas.addAll(value);
      });
    });
    super.initState();
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
          "Stock Details",
          style:
              TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
        )),
        body: Container(
          padding: EdgeInsets.all(5),
          child: Stack(
            children: <Widget>[
              Container(
                // padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  // child: Form(
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      // SizedBox(height: 10),
                      _topData(),
                      SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                            itemBuilder: (context, index) {
                              return _listItem(index);
                            },
                            itemCount: _datas.length),
                      )
                    ],
                    // ),
                  ),
                ),
              ),
            ],
          ),
        ));
    //   Scaffold(
    //       appBar: AppBar(
    //           title: Text(
    //         "Stock Details",
    //         style:
    //             TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
    //       )),
    //       body: Container(
    //         padding: EdgeInsets.all(20),
    //         child: Column(
    //           children: <Widget>[
    //             SizedBox(child: _topData()),
    //             // _topData(),
    //             ListView.builder(
    //                 itemBuilder: (context, index) {
    //                   return _listItem(index);
    //                 },
    //                 itemCount: _datas.length),
    //           ],
    //         ),
    //       ));
  }

  _align(var _text) {
    return new Align(
      child: Text(
        _text,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  _topData() {
    return Row(
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                ),
              ),
              Text(
                widget.prod_code,
                style: TextStyle(color: Colors.grey[700], fontSize: 19),
              ),
              SizedBox(
                height: 10,
              ),
              if (widget.model != null)
                Text(
                  widget.model,
                  style: TextStyle(color: Colors.grey[700], fontSize: 19),
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
    );
  }

  _listItem(index) {
    String _coo = _datas[index].org_country + " ";
    String _doc_ref = _datas[index].doc_ref + " ";
    String _lot_no = _datas[index].lot_no.toString() + " ";
    String _date = _datas[index].date.toString() + " ";
    String _pqty = _datas[index].p_qty.toString();
    String _puom = _datas[index].p_uom.toString();
    String _lqty = _datas[index].l_qty.toString();
    String _luom = _datas[index].l_uom.toString();
    return Card(
      child: ListTile(
        // title: Text(
        //   "_coo",
        //   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        // ),
        subtitle: Column(
          children: <Widget>[
            // if (_doc_ref != null)
            //   new Align(
            //     alignment: Alignment.centerLeft,
            //     child: Text(
            //       _doc_ref,
            //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            //     ),
            //   ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // if (_coo != null)
                _align(
                  _coo + " ",
                ),
                // if (_doc_ref != null)
                _align(
                  _doc_ref + " ",
                ),
                // if (_lot_no != null)
                _align(
                  _lot_no + " ",
                ),
                // if (_date != null)
                _align(
                  _date + "  ",
                ),
                _align(
                  _pqty.toString() + " " + _puom + " ",
                ),
                if (_datas[index].p_uom != _datas[index].l_uom)
                  _align(
                    _lqty.toString() + " " + _luom,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
