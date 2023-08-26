
class Generatebilldata {
  String? billstatus;
  String? msg;

  Generatebilldata({this.billstatus, this.msg});

  Generatebilldata.fromJson(Map<String, dynamic> json) {
    if(json["billstatus"] is String) {
      billstatus = json["billstatus"];
    }
    if(json["msg"] is String) {
      msg = json["msg"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["billstatus"] = billstatus;
    _data["msg"] = msg;
    return _data;
  }
}