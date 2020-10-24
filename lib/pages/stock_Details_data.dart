class Stock_details_data {
  String com_code;
  String org_country;
  String lot_no;
  String doc_ref;
  var date;
  String p_uom;
  String l_uom;
  var stock;
  var avl_stock;
  var p_qty;
  var l_qty;

  Stock_details_data(
      this.com_code,
      this.org_country,
      this.lot_no,
      this.doc_ref,
      this.date,
      this.p_uom,
      this.l_uom,
      this.stock,
      this.avl_stock,
      this.p_qty,
      this.l_qty);

  Stock_details_data.fromJson(Map<String, dynamic> json) {
    com_code = json['company_code'];
    org_country = json['origin_country'];
    lot_no = json['lot_no'];
    doc_ref = json['doc_ref'];
    date = json['exp_date'];
    p_uom = json['p_uom'];
    l_uom = json['l_uom'];
    stock = json['stock'];
    avl_stock = json['avlstock'];
    p_qty = json['pqty_avl'];
    l_qty = json['lqty_avl'];
  }
}
