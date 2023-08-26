import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mjala/models/getprintbilldata.dart';
import 'package:mjala/view/billdetails/controller/billdetails.dart';
import 'package:mjala/view/bluetoothconnection/bluetoothconnection.dart';
import '../../widgets/roundbutton/RoundButton.dart';
import '../../app_url/app_url.dart';

import '../../utils/roundbutton/RoundButton.dart';
import '../bluetoothconnection/kannada.dart/kannada_print.dart';
// import '../bluetoothconnection/kannada.dart/kannada_print.dart';
// import '../../app_url/app_url.dart';

class BillDetailsPage extends StatefulWidget {
  const BillDetailsPage({super.key});

  @override
  State<BillDetailsPage> createState() => _BillDetailsPageState();
}

class _BillDetailsPageState extends State<BillDetailsPage> {
  BillPrintController billPrintController = Get.put(BillPrintController());
  PrintBillDetails printBillDetails = PrintBillDetails();

  bool isHitAgain = false;
  String rrNumber = GetStorage().read('rrNumber');

  @override
  void initState() {
    callApi();
    super.initState();
  }

  callApi() {
    // print(rrNumber);
    billPrintController.getPrintBillApi(
      url: AppUrls.printBillApi,
      rrnumber: rrNumber,
      zone: GetStorage().read('zoneName'),
      meterNo: "P-01",
    );
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("M JALA"),
          // automaticallyImplyLeading: false,
          backgroundColor: Colors.blue.shade900,
        ),
        body: printBillDetails != null
            ? RefreshIndicator(
                onRefresh: () {
                  return Future.delayed(const Duration(seconds: 5), () {
                    callApi();
                  });
                },
                child: refreshScreen(),
              )
            : const SizedBox(
                child: Center(
                  child: Text('Data is not Available\n Refresh Page'),
                ),
              )
        // : Container(),
        );
  }

//refresh screen
  Column refreshScreen() {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            // scrollDirection: Axis.vertical,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Obx(() => billPrintController.isLoading.value
                    ? const CircularProgressIndicator()
                    : billPrintController.details.isNotEmpty
                        ? refreshData()
                        : const Text('Time Out')),
              ],
            ),
          ),
        ),
        RoundButton(
            height: size.height * 0.06,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0),
              color: const Color(0xff0E4473),
            ),
            text: 'Print Bill',
            onTap: () {
              // Get.to(() => const BluetoothConnectionPage(),
              //     arguments: {'rrNumber': rrNumber});
            })
      ],
    );
  }

//for refresh data
  Container refreshData() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: const BorderRadius.all(Radius.circular(6)),
      ),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.only(top: 4, bottom: 8, left: 4, right: 4),
      child: detailsMethod(),
    );
  }

// All details
  Column detailsMethod() {
    // var size = MediaQuery.of(context).size;
    return Column(
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
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              alignWidget(
                  firstText: "Consumer Number",
                  secondText:
                      billPrintController.details[0]['ConsumerID'].toString() ??
                          ''),
              const SizedBox(height: 5),
              alignWidget(
                  firstText: 'Meter Number',
                  secondText:
                      billPrintController.details[0]['meternumber'] ?? ''),
              const SizedBox(height: 5),
              alignWidget(
                  firstText: 'Consumer Name',
                  secondText:
                      billPrintController.details[0]['name'].toString() ?? ''),
              const SizedBox(height: 5),
              alignWidget(
                firstText: 'Address',
                secondText:
                    "${billPrintController.details[0]['address']}, ${billPrintController.details[0]['address1']}, ${billPrintController.details[0]['city']}, ${billPrintController.details[0]['pincode']}" ??
                        '',
              ),
              const SizedBox(height: 5),
              alignWidget(
                  firstText: 'Bill Number',
                  secondText:
                      billPrintController.details[0]['BillNumber'].toString() ??
                          ''),
              const SizedBox(height: 5),
              alignWidget(
                  firstText: 'Bill Date',
                  secondText:
                      billPrintController.details[0]['BillDate'].toString() ??
                          ''),
              const SizedBox(height: 5),
              alignWidget(
                  firstText: 'Tariff',
                  secondText:
                      billPrintController.details[0]['tariff'].toString() ??
                          ''),
              const SizedBox(height: 5),
              alignWidget(
                  firstText: 'Meter Status',
                  secondText: billPrintController.details[0]['meterstatus']
                          .toString() ??
                      ''),
              const SizedBox(height: 5),
              alignWidget(
                  firstText: 'Write off',
                  secondText:
                      billPrintController.details[0]['writeoff'].toString() ??
                          ''),
              const SizedBox(height: 5),
              alignWidget(
                  firstText: 'Bill Period',
                  secondText:
                      billPrintController.details[0]['Billperiod'].toString() ??
                          ''),
              const SizedBox(height: 5),
              alignWidget(
                firstText: 'Present Reading(Ltrs) ',
                secondText: billPrintController.details[0]['presentreading']
                        .toString() ??
                    '',
              ),
              const SizedBox(height: 5),
              alignWidget(
                firstText: 'Previous Reading(Ltrs)',
                secondText:
                    billPrintController.details[0]['prevreading'].toString() ??
                        '',
              ),
              const SizedBox(height: 5),
              alignWidget(
                firstText: 'Consumption(Ltrs)',
                secondText:
                    billPrintController.details[0]['consumption'].toString() ??
                        '',
              ),
              const SizedBox(height: 5),
              alignWidget(
                firstText: "Water Charge",
                secondText: billPrintController.details[0]!['watercharges']
                        .toString() ??
                    '',
              ),
              const SizedBox(height: 5),
              alignWidget(
                firstText: "Arrears",
                secondText:
                    billPrintController.details[0]['Arrears'].toString() ?? '',
              ),
              const SizedBox(height: 5),
              alignWidget(
                firstText: "Int of Arrears ",
                secondText:
                    billPrintController.details[0]['intonArrears'].toString() ??
                        '',
              ),
              const SizedBox(height: 5),
              alignWidget(
                firstText: 'Adj Amount',
                secondText:
                    billPrintController.details[0]['adjamount'].toString() ??
                        '',
              ),
              const SizedBox(height: 5),
              alignWidget(
                firstText: 'Total Amount',
                secondText:
                    billPrintController.details[0]['totalamount'].toString() ??
                        '',
              ),
              const SizedBox(height: 5),
              alignWidget(
                firstText: 'Due Date To Pay',
                secondText:
                    billPrintController.details[0]['DueDate'].toString() ?? '',
              ),
              const SizedBox(height: 5),
              alignWidget(
                firstText: 'Others Charges',
                secondText:
                    billPrintController.details[0]['OtherCharges'].toString() ??
                        '',
              ),
              const SizedBox(height: 5),
              alignWidget(
                firstText: 'Meter Reader',
                secondText:
                    billPrintController.details[0]['meternumber'].toString() ??
                        '',
              )
            ],
          ),
        ),
      ],
    );
  }

  Row alignWidget({required String firstText, required String secondText}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            firstText,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        const Text(
          ":",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            secondText,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.teal.shade500),
          ),
        ),
      ],
    );
  }
}
