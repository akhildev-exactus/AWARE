class PrincipleValues {
  String princode;
  String prinname;

  PrincipleValues(this.princode, this.prinname);
  // Data(this.ccode, this.nationality);

  PrincipleValues.fromJson(Map<String, dynamic> json) {
    princode = json['code'];
    prinname = json['name'];
  }
}
