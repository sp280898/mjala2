// To parse this JSON data, do
//
//     final detailsData = detailsDataFromJson(jsonString);

import 'dart:convert';

List<DetailsData> detailsDataFromJson(String str) => List<DetailsData>.from(
    json.decode(str).map((x) => DetailsData.fromJson(x)));

String detailsDataToJson(List<DetailsData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DetailsData {
  int userid;
  String billNumber;
  String mrDate;
  String billDate;
  String rrNumber;
  int consumerId;
  int totalamount;
  int watercharges;
  int arrears;
  int intonArrears;
  int otherCharges;
  int consumption;
  int adjamount;
  int writeoff;
  String remarks;
  int monthyear;
  String dueDate;
  String billperiod;
  String prevreading;
  String genStatus;
  String consumerid;
  String name;
  String address;
  String address1;
  String city;
  String pincode;
  String tariff;
  String meterstatus;
  String mobile;
  String sdid;
  String mrid;
  String meternumber;
  String readingday;
  String reason;
  String presentreading;
  String lastavailreading;
  String msg;
  String billstatus;
  String conncharge;

  DetailsData({
    required this.userid,
    required this.billNumber,
    required this.mrDate,
    required this.billDate,
    required this.rrNumber,
    required this.consumerId,
    required this.totalamount,
    required this.watercharges,
    required this.arrears,
    required this.intonArrears,
    required this.otherCharges,
    required this.consumption,
    required this.adjamount,
    required this.writeoff,
    required this.remarks,
    required this.monthyear,
    required this.dueDate,
    required this.billperiod,
    required this.prevreading,
    required this.genStatus,
    required this.consumerid,
    required this.name,
    required this.address,
    required this.address1,
    required this.city,
    required this.pincode,
    required this.tariff,
    required this.meterstatus,
    required this.mobile,
    required this.sdid,
    required this.mrid,
    required this.meternumber,
    required this.readingday,
    required this.reason,
    required this.presentreading,
    required this.lastavailreading,
    required this.msg,
    required this.billstatus,
    required this.conncharge,
  });

  factory DetailsData.fromJson(Map<String, dynamic> json) => DetailsData(
        userid: json["Userid"],
        billNumber: json["BillNumber"],
        mrDate: json["MRDate"],
        billDate: json["BillDate"],
        rrNumber: json["RRNumber"],
        consumerId: json["ConsumerID"],
        totalamount: json["totalamount"],
        watercharges: json["watercharges"],
        arrears: json["Arrears"],
        intonArrears: json["intonArrears"],
        otherCharges: json["OtherCharges"],
        consumption: json["consumption"],
        adjamount: json["adjamount"],
        writeoff: json["writeoff"],
        remarks: json["remarks"],
        monthyear: json["monthyear"],
        dueDate: json["DueDate"],
        billperiod: json["Billperiod"],
        prevreading: json["prevreading"],
        genStatus: json["gen_status"],
        consumerid: json["consumerid"],
        name: json["name"],
        address: json["address"],
        address1: json["address1"],
        city: json["city"],
        pincode: json["pincode"],
        tariff: json["tariff"],
        meterstatus: json["meterstatus"],
        mobile: json["mobile"],
        sdid: json["sdid"],
        mrid: json["mrid"],
        meternumber: json["meternumber"],
        readingday: json["readingday"],
        reason: json["reason"],
        presentreading: json["presentreading"],
        lastavailreading: json["lastavailreading"],
        msg: json["msg"],
        billstatus: json["billstatus"],
        conncharge: json["conncharge"],
      );

  Map<String, dynamic> toJson() => {
        "Userid": userid,
        "BillNumber": billNumber,
        "MRDate": mrDate,
        "BillDate": billDate,
        "RRNumber": rrNumber,
        "ConsumerID": consumerId,
        "totalamount": totalamount,
        "watercharges": watercharges,
        "Arrears": arrears,
        "intonArrears": intonArrears,
        "OtherCharges": otherCharges,
        "consumption": consumption,
        "adjamount": adjamount,
        "writeoff": writeoff,
        "remarks": remarks,
        "monthyear": monthyear,
        "DueDate": dueDate,
        "Billperiod": billperiod,
        "prevreading": prevreading,
        "gen_status": genStatus,
        "consumerid": consumerid,
        "name": name,
        "address": address,
        "address1": address1,
        "city": city,
        "pincode": pincode,
        "tariff": tariff,
        "meterstatus": meterstatus,
        "mobile": mobile,
        "sdid": sdid,
        "mrid": mrid,
        "meternumber": meternumber,
        "readingday": readingday,
        "reason": reason,
        "presentreading": presentreading,
        "lastavailreading": lastavailreading,
        "msg": msg,
        "billstatus": billstatus,
        "conncharge": conncharge,
      };
}
