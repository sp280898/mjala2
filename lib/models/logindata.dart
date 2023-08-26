// ignore_for_file: public_member_api_docs, sort_constructors_first
class LoginData {
  String? username;
  int? userid;
  int? role;
  String? sdid;
  String? distname;
  String? zone;
  bool? logStatus;
  String? msg;

  LoginData(
      {this.username,
      this.userid,
      this.role,
      this.sdid,
      this.distname,
      this.zone,
      this.logStatus,
      this.msg});

  LoginData.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    userid = json['userid'];
    role = json['role'];
    sdid = json['sdid'];
    distname = json['distname'];
    zone = json['zone'];
    logStatus = json['log_status'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['userid'] = this.userid;
    data['role'] = this.role;
    data['sdid'] = this.sdid;
    data['distname'] = this.distname;
    data['zone'] = this.zone;
    data['log_status'] = this.logStatus;
    data['msg'] = this.msg;
    return data;
  }
}

// class LoginModel {
//   int? status;
//   List<LoginData>? loginData;
//   LoginModel({
//     this.status,
//     this.loginData,
//   });

//   LoginModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     if (json["loginData"] is List) {
//       loginData = json["loginData"] == null
//           ? null
//           : (json["LoginData"] as List)
//               .map((e) => LoginData.fromJson(e))
//               .toList();
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     data['status'] = this.status;
//     if (loginData != null) {
//       data["banner"] = loginData?.map((e) => e.toJson()).toList();
//     }
//     return data;
//   }
// }
