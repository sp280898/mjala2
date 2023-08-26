
class Savemeterpicdata {
  String? status;
  String? msg;

  Savemeterpicdata({this.status, this.msg});

  Savemeterpicdata.fromJson(Map<String, dynamic> json) {
    if(json["status"] is String) {
      status = json["status"];
    }
    if(json["msg"] is String) {
      msg = json["msg"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["status"] = status;
    _data["msg"] = msg;
    return _data;
  }
}