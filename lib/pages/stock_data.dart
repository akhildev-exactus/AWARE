class StockVal {
  String prodcode;
  String prodname;
  var model;
  var avlstk;
  var stock;
  String puom;
  String luom;
  var pqty;
  var lqty;

  StockVal(this.prodcode, this.prodname, this.model, this.avlstk, this.stock,
      this.luom, this.puom, this.pqty, this.lqty);

  StockVal.fromJson(Map<String, dynamic> json) {
    prodcode = json['code'];
    prodname = json['name'];
    model = json['model'];
    avlstk = json['avlstock'];
    stock = json['stock'];
    luom = json['l_uom'];
    puom = json['p_uom'];
    lqty = json['lqty_avl'];
    pqty = json['pqty_avl'];
  }
}
