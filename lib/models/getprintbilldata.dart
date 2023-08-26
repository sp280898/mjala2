class PrintBillDetails {
  int? userid;
  String? billNumber;
  String? mrDate;
  String? billDate;
  String? rrNumber;
  int? consumerId;
  int? totalamount;
  int? watercharges;
  int? arrears;
  int? intonArrears;
  int? otherCharges;
  int? consumption;
  int? adjamount;
  int? writeoff;
  String? remarks;
  int? monthyear;
  String? dueDate;
  String? billperiod;
  String? prevreading;
  String? genStatus;
  String? consumerid;
  String? name;
  String? address;
  String? address1;
  String? city;
  String? pincode;
  String? tariff;
  String? meterstatus;
  String? mobile;
  String? sdid;
  String? mrid;
  String? meternumber;
  String? readingday;
  String? reason;
  String? presentreading;
  String? lastavailreading;
  String? msg;
  String? billstatus;
  String? conncharge;

  PrintBillDetails(
      {this.userid,
      this.billNumber,
      this.mrDate,
      this.billDate,
      this.rrNumber,
      this.consumerId,
      this.totalamount,
      this.watercharges,
      this.arrears,
      this.intonArrears,
      this.otherCharges,
      this.consumption,
      this.adjamount,
      this.writeoff,
      this.remarks,
      this.monthyear,
      this.dueDate,
      this.billperiod,
      this.prevreading,
      this.genStatus,
      this.consumerid,
      this.name,
      this.address,
      this.address1,
      this.city,
      this.pincode,
      this.tariff,
      this.meterstatus,
      this.mobile,
      this.sdid,
      this.mrid,
      this.meternumber,
      this.readingday,
      this.reason,
      this.presentreading,
      this.lastavailreading,
      this.msg,
      this.billstatus,
      this.conncharge});

  PrintBillDetails.fromJson(Map<String, dynamic> json) {
    if (json["Userid"] is int) {
      userid = json["Userid"];
    }
    if (json["BillNumber"] is String) {
      billNumber = json["BillNumber"];
    }
    if (json["MRDate"] is String) {
      mrDate = json["MRDate"];
    }
    if (json["BillDate"] is String) {
      billDate = json["BillDate"];
    }
    if (json["RRNumber"] is String) {
      rrNumber = json["RRNumber"];
    }
    if (json["ConsumerID"] is int) {
      consumerId = json["ConsumerID"];
    }
    if (json["totalamount"] is int) {
      totalamount = json["totalamount"];
    }
    if (json["watercharges"] is int) {
      watercharges = json["watercharges"];
    }
    if (json["Arrears"] is int) {
      arrears = json["Arrears"];
    }
    if (json["intonArrears"] is int) {
      intonArrears = json["intonArrears"];
    }
    if (json["OtherCharges"] is int) {
      otherCharges = json["OtherCharges"];
    }
    if (json["consumption"] is int) {
      consumption = json["consumption"];
    }
    if (json["adjamount"] is int) {
      adjamount = json["adjamount"];
    }
    if (json["writeoff"] is int) {
      writeoff = json["writeoff"];
    }
    if (json["remarks"] is String) {
      remarks = json["remarks"];
    }
    if (json["monthyear"] is int) {
      monthyear = json["monthyear"];
    }
    if (json["DueDate"] is String) {
      dueDate = json["DueDate"];
    }
    if (json["Billperiod"] is String) {
      billperiod = json["Billperiod"];
    }
    if (json["prevreading"] is String) {
      prevreading = json["prevreading"];
    }
    if (json["gen_status"] is String) {
      genStatus = json["gen_status"];
    }
    if (json["consumerid"] is String) {
      consumerid = json["consumerid"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["address"] is String) {
      address = json["address"];
    }
    if (json["address1"] is String) {
      address1 = json["address1"];
    }
    if (json["city"] is String) {
      city = json["city"];
    }
    if (json["pincode"] is String) {
      pincode = json["pincode"];
    }
    if (json["tariff"] is String) {
      tariff = json["tariff"];
    }
    if (json["meterstatus"] is String) {
      meterstatus = json["meterstatus"];
    }
    if (json["mobile"] is String) {
      mobile = json["mobile"];
    }
    if (json["sdid"] is String) {
      sdid = json["sdid"];
    }
    if (json["mrid"] is String) {
      mrid = json["mrid"];
    }
    if (json["meternumber"] is String) {
      meternumber = json["meternumber"];
    }
    if (json["readingday"] is String) {
      readingday = json["readingday"];
    }
    if (json["reason"] is String) {
      reason = json["reason"];
    }
    if (json["presentreading"] is String) {
      presentreading = json["presentreading"];
    }
    if (json["lastavailreading"] is String) {
      lastavailreading = json["lastavailreading"];
    }
    if (json["msg"] is String) {
      msg = json["msg"];
    }
    if (json["billstatus"] is String) {
      billstatus = json["billstatus"];
    }
    if (json["conncharge"] is String) {
      conncharge = json["conncharge"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["Userid"] = userid;
    _data["BillNumber"] = billNumber;
    _data["MRDate"] = mrDate;
    _data["BillDate"] = billDate;
    _data["RRNumber"] = rrNumber;
    _data["ConsumerID"] = consumerId;
    _data["totalamount"] = totalamount;
    _data["watercharges"] = watercharges;
    _data["Arrears"] = arrears;
    _data["intonArrears"] = intonArrears;
    _data["OtherCharges"] = otherCharges;
    _data["consumption"] = consumption;
    _data["adjamount"] = adjamount;
    _data["writeoff"] = writeoff;
    _data["remarks"] = remarks;
    _data["monthyear"] = monthyear;
    _data["DueDate"] = dueDate;
    _data["Billperiod"] = billperiod;
    _data["prevreading"] = prevreading;
    _data["gen_status"] = genStatus;
    _data["consumerid"] = consumerid;
    _data["name"] = name;
    _data["address"] = address;
    _data["address1"] = address1;
    _data["city"] = city;
    _data["pincode"] = pincode;
    _data["tariff"] = tariff;
    _data["meterstatus"] = meterstatus;
    _data["mobile"] = mobile;
    _data["sdid"] = sdid;
    _data["mrid"] = mrid;
    _data["meternumber"] = meternumber;
    _data["readingday"] = readingday;
    _data["reason"] = reason;
    _data["presentreading"] = presentreading;
    _data["lastavailreading"] = lastavailreading;
    _data["msg"] = msg;
    _data["billstatus"] = billstatus;
    _data["conncharge"] = conncharge;
    return _data;
  }
}
