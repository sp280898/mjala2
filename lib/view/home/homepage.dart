import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mjala/app_url/app_url.dart';
import 'package:mjala/view/home/controller/home_controller.dart';
import 'package:mjala/utils/roundbutton/RoundButton.dart';
import '../auth/controller/login_controller.dart';
import '../../utils/login_store.dart';
// import '../billdetails/controller/billdetails.dart';
import '../../widgets/roundbutton/RoundButton.dart';

class HomePage extends StatefulWidget {
  final String? zoneName;
  const HomePage({
    super.key,
    this.zoneName,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GetrrnumberController dataController = Get.put(GetrrnumberController());
  LoginController loginController = Get.put(LoginController());
  TextEditingController rrController = TextEditingController();

  bool isApiHit = false;
  String zoneName = GetStorage().read('zoneName') ?? '';

  String? rrNumber;

// Meter Number
  var meterNo = 'P-01';

  bool isLoading = false;

  final _form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Row(
          children: [
            Text("M JALA"),
            SizedBox(
              width: 10,
            ),
            // Text("(Govt. of Karnataka)"),
          ],
        ),
        // centerTitle: true,
        backgroundColor: Colors.blueAccent.shade100,
        actions: [
          IconButton(
              onPressed: () {
                MyPref().box.erase().then((value) => Get.offNamed('/login'));
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.lightBlue.shade100,
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                    ),
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.only(
                        top: 4, bottom: 8, left: 4, right: 4),
                    child: Column(
                      children: [
                        alignWidget(
                          color: Colors.black,
                          firstText: "User Name",
                          secondText: GetStorage().read('userName') ?? "",
                        ),
                        alignWidget(
                          color: Colors.black,
                          firstText: 'Zone',
                          secondText: GetStorage().read('zoneName') ?? '',
                        ),
                        alignWidget(
                          color: Colors.black,
                          firstText: 'Gram Panchayat (G.P)',
                          secondText: GetStorage().read('sdid') ?? '',
                        ),
                      ],
                    ),
                  ),
                  Form(
                    key: _form,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: TextFormField(
                            // initialValue: GetStorage().read('rrNumber'),
                            controller: rrController,
                            validator: (value) {
                              if (value!.length < 8) {
                                return 'Please Enter 8 digit valid RR Number';
                              }
                              return null;
                            },
                            style: const TextStyle(color: Colors.black87),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              hintText: 'Enter RR Number',
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              rrNumber = value;

                              setState(() {
                                isApiHit = false;
                              });
                            },
                          ),
                        ),
                        const Center(
                          child: Text("OR"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: TextFormField(
                            // initialValue: rrNumber,
                            style: const TextStyle(color: Colors.black87),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              hintText: 'Enter Meter Number',
                              hintStyle: const TextStyle(color: Colors.black38),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  !isApiHit
                      ? RoundButton(
                          // isLoading: isLoading.obs,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xff0E4473),
                          ),
                          height: size.height * 0.06,
                          width: size.width * 0.4,
                          text: 'Get Details',
                          onTap: () {
                            if (_form.currentState!.validate()) {
                              GetStorage().write('rrNumber', rrNumber);
                              dataController.getRRApi(
                                  // url: AppUrls.rrApi,
                                  rrnumber: rrNumber,

                                  // Meter Number
                                  meterNo: meterNo,
                                  zone: zoneName);
                              setState(() {
                                isApiHit = true;
                              });
                            }
                          },
                          // isLoading: isLoading,
                        )
                      : const SizedBox(),
                  isApiHit
                      ? Obx(() => dataController.isLoading.value
                          ? const Center(child: CircularProgressIndicator())
                          : dataController.rrDetails.isNotEmpty
                              ? _buildScreen()
                              : const Text('Data is not Available'))
                      : const SizedBox()
                ],
              ),
            ),
          ),
          if (isApiHit)
            RoundButton(
                height: size.height * 0.06,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0),
                  color: const Color(0xff0E4473),
                ),
                text: 'Next',
                onTap: () {
                  if (dataController.rrDetails.isNotEmpty) {
                    (dataController.rrDetails[0]['billstatus'] == false)
                        ? Get.toNamed('/billdetails',
                            parameters: {'rrNumber': rrNumber!})
                        :
                        // } else {
                        Get.toNamed('/billnotgenerate',
                            parameters: {'rrNumber': rrNumber!});
                    // }
                    // } else
                    //   return;
                  }
                })
          else
            const SizedBox(),
        ],
      ),
    );
  }

  Widget _buildScreen() {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dataController.rrDetails[0]['msg'].toString() ?? '',
              style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600, color: Colors.red),
            ),
          ],
        ),
      ),
      Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: const BorderRadius.all(
              Radius.circular(6),
            ),
          ),
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.only(top: 4, bottom: 8, left: 4, right: 4),
          child: Column(
            children: [
              const SizedBox(height: 5),
              const Text(
                "Basic Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 100),
                child: Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    alignWidget(
                        color: Colors.teal.shade700,
                        firstText: 'RR Number',
                        secondText: dataController.rrDetails[0]['rrnumber']
                                .toString() ??
                            ''),
                    const SizedBox(height: 5),
                    alignWidget(
                      firstText: 'Meter Number',
                      secondText: dataController.rrDetails[0]['MeterNumber']
                              .toString() ??
                          '',
                    ),
                    alignWidget(
                      firstText: 'Name',
                      secondText:
                          dataController.rrDetails[0]['name'].toString() ?? '',
                    ),

                    alignWidget(
                      firstText: 'Address',
                      secondText:
                          "${dataController.rrDetails[0]['address'].toString()} ${dataController.rrDetails[0]['address1'].toString()}" ??
                              '',
                    ),

                    alignWidget(
                      firstText: 'City and Pincode',
                      secondText:
                          '${dataController.rrDetails[0]['city'].toString()} ,${dataController.rrDetails[0]['pincode'].toString()}' ??
                              '',
                    ),

                    alignWidget(
                      firstText: 'Mobile Number ',
                      secondText:
                          dataController.rrDetails[0]['mobile'].toString() ??
                              '',
                    ),
                    alignWidget(
                      firstText: 'Reading Day',
                      secondText: dataController.rrDetails[0]['ReadingDay']
                              .toString() ??
                          '',
                    ),
                    //
                  ],
                ),
              ),
              dataController.rrDetails[0]['billstatus'] == false
                  ? Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6)),
                          ),
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.only(
                              top: 4, bottom: 8, left: 4, right: 4),
                          child: Column(
                            children: [
                              const SizedBox(height: 5),
                              const Text(
                                "Bill Details",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 100),
                                child: Divider(
                                  thickness: 1,
                                  color: Colors.grey,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    alignWidget(
                                      firstText: 'Month/Year',
                                      secondText: dataController.rrDetails[0]
                                                  ['monthyear']
                                              .toString() ??
                                          '',
                                    ),
                                    const SizedBox(height: 5),
                                    alignWidget(
                                      firstText: 'Bill Number',
                                      secondText: dataController.rrDetails[0]
                                                  ['BillNumber']
                                              .toString() ??
                                          'null',
                                    ),
                                    const SizedBox(height: 5),
                                    alignWidget(
                                      firstText: 'Bill Amount',
                                      secondText: dataController.rrDetails[0]
                                                  ['totalamount']
                                              .toString() ??
                                          'null',
                                    ),
                                    const SizedBox(height: 5),
                                    alignWidget(
                                      firstText: 'Bill Date',
                                      secondText: dataController.rrDetails[0]
                                                  ['BillDate']
                                              .toString() ??
                                          'null',
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : const SizedBox()
            ],
          ))
    ]);
  }

  Row alignWidget(
      {required String firstText,
      required String secondText,
      Color color = Colors.teal}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const SizedBox(width: 10),
        Expanded(
          flex: 1,
          child: Text(
            firstText,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
          ),
        ),
        const Text(
          ":",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 1,
          child: Text(
            secondText,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, color: color),
          ),
        ),
      ],
    );
  }
}
