import 'dart:convert';
import 'dart:io';
import '../../widgets/roundbutton/RoundButton.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mjala/utils/roundbutton/RoundButton.dart';
import 'package:mjala/utils/toastmessage.dart';
import '../../app_url/app_url.dart';
import '../home/controller/home_controller.dart';
import 'controller/billnotgenerate_controller.dart';
import 'controller/lat_long.dart';
import 'controller/upload_img.dart';

class BillNotGeneratePage extends StatefulWidget {
  final String? text;
  const BillNotGeneratePage({super.key, this.text});

  @override
  State<BillNotGeneratePage> createState() => _BillNotGeneratePageState();
}

class _BillNotGeneratePageState extends State<BillNotGeneratePage> {
  bool isHitAgain = false;
  final readingController = TextEditingController();
  UploadImage uploadImage = Get.put(UploadImage());
  // LocationInput locationInput = Get.put(LocationInput());
  GetrrnumberController billDetailController = Get.put(GetrrnumberController());
  final billNotGenerateController = Get.put(BillNotGenerateController());

  String rrNumber = Get.parameters['rrNumber'].toString();
  File? file;
  File? file2;
  ImagePicker image = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final List<String> items = [
    'MNR',
    'DL',
    'WS',
    'MD',
    'GL',
    'DNV',
    'SMS',
    'TC',
    'MC',
    'M',
    'MS',
    'MMC',
    'ND',
    'NSF',
    'TP',
    'NCNR',
  ];
  String? selectedValue;
  String? reason;

  String meterNo = "P-01";

  bool isUploadDone = false;
  Uint8List decodeBase64ToBytes(String base64String) {
    // Calculate the padding length needed
    int paddingLength = 4 - (base64String.length % 4);

    // Add padding characters if needed
    String paddedBase64 = base64String + ('=' * paddingLength);

    Uint8List bytes = base64Decode(paddedBase64);
    return bytes;
  }

  void saveBytesAsImage(Uint8List bytes, String outputPath) async {
    File file = File(outputPath);
    await file.writeAsBytes(bytes);
    print('Image saved at: $outputPath');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("M JALA"),
        backgroundColor: const Color(0xff0E4473),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Obx(
                    () => billDetailController.isLoading.value
                        ? const Stack(children: [
                            Center(child: CircularProgressIndicator()),
                          ])
                        : Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(6),
                              ),
                            ),
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.only(
                                top: 4, bottom: 8, left: 4, right: 4),
                            child: Column(
                              children: [
                                const SizedBox(height: 5),
                                const Text(
                                  "Basic Details",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 100),
                                  child: Divider(
                                    thickness: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      alignWidget(
                                        firstText: 'RR Numbar',
                                        secondText: billDetailController
                                                .rrDetails[0]['rrnumber']
                                                .toString() ??
                                            '',
                                      ),
                                      const SizedBox(height: 5),
                                      alignWidget(
                                        firstText: 'Name',
                                        secondText: billDetailController
                                                .rrDetails[0]['name']
                                                .toString() ??
                                            '',
                                      ),
                                      const SizedBox(height: 5),
                                      alignWidget(
                                        firstText: 'Address',
                                        secondText:
                                            "${billDetailController.rrDetails[0]['address'].toString()}, ${billDetailController.rrDetails[0]['address1'].toString()}" ??
                                                '',
                                      ),
                                      const SizedBox(height: 5),
                                      alignWidget(
                                        firstText: 'City and Pincode',
                                        secondText:
                                            "${billDetailController.rrDetails[0]['city'].toString()} , ${billDetailController.rrDetails[0]['pincode'].toString()}" ??
                                                '',
                                      ),
                                      const SizedBox(height: 5),
                                      alignWidget(
                                        firstText: 'Mobile Number',
                                        secondText: billDetailController
                                                .rrDetails[0]['mobilenumber']
                                                .toString() ??
                                            '',
                                      ),
                                      const SizedBox(height: 5),
                                      alignWidget(
                                        firstText: 'Reading Day',
                                        secondText: billDetailController
                                                .rrDetails[0]['ReadingDay']
                                                .toString() ??
                                            '',
                                      ),
                                      const SizedBox(height: 5),
                                      alignWidget(
                                        firstText: 'Previous Reading',
                                        secondText: billDetailController
                                            .rrDetails[0]["LastavailReading"]
                                            .toString(),
                                      ),
                                      const SizedBox(height: 5),
                                      alignWidget(
                                        firstText: 'Previous Reason',
                                        secondText: billDetailController
                                                .rrDetails[0]['reasonid']
                                                .toString() ??
                                            '',
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xff0E4473),
                                      ),
                                      onPressed: () {
                                        Get.bottomSheet(
                                          Container(
                                            height: 140,
                                            width: double.infinity,
                                            color: Colors.white,
                                            child: Column(children: [
                                              GestureDetector(
                                                onTap: () {
                                                  getCam();
                                                  Get.back();
                                                },
                                                child: const Card(
                                                  color: Colors.teal,
                                                  child: ListTile(
                                                    title: Center(
                                                        child: Text(
                                                            'Capture camera Image')),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  getGallery();
                                                  Get.back();
                                                },
                                                child: const Card(
                                                  color: Colors.teal,
                                                  child: ListTile(
                                                    title: Center(
                                                        child: Text(
                                                            'Gallery Image')),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                          ),
                                          elevation: 0,
                                          isDismissible: true,
                                          enableDrag: true,
                                        );
                                      },
                                      child: const Text(
                                        "METER IMAGE",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    //*****##############***************************** */
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xff0E4473),
                                      ),
                                      onPressed: () async {
                                        print(uploadImage.isDone);
                                        if (file == null)
                                          return Utils().showToast(
                                              'Please Capture image');
                                        //

                                        String base64Image = file!
                                            .path; // Replace with your Base64 encoded image string
                                        String outputPath =
                                            'output_image.jpg'; // Replace with the desired output path

                                        Uint8List imageBytes =
                                            decodeBase64ToBytes(base64Image);
                                        saveBytesAsImage(
                                            imageBytes, outputPath);

                                        //
                                        // List<int> imageBytes =
                                        // file!.readAsBytesSync();
                                        // String base64Image =
                                        // base64Encode(imageBytes);

                                        // locationInput
                                        //     .getCurrentLocation()
                                        //     .then((value) {
                                        // UploadImage().uploadImageApi(
                                        //   url: AppUrls.saveMeterApi,
                                        //   imgValue: base64Image,
                                        //   rrNumber: rrNumber,
                                        //   meterNo: meterNo,
                                        //   zone: GetStorage().read('zoneName'),
                                        // lat: locationInput
                                        //     .locationData!.latitude
                                        //     .toString(),
                                        // long: locationInput
                                        //     .locationData!.longitude
                                        //     .toString()
                                        // );
                                        // });
                                        // uploadImage.isUploaded();
                                      },
                                      child: const Text(
                                        "UPLOAD METER IMAGE",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                                // ElevatedButton(
                                //   style: ElevatedButton.styleFrom(
                                //     backgroundColor: const Color(0xff0E4473),
                                //   ),
                                //   onPressed: () {
                                //     // Get.to(MyApp());
                                //   },
                                //   child: const Text(
                                //     "ENTER PRESENT READING",
                                //     style: TextStyle(fontSize: 12),
                                //   ),
                                // ),
                                Form(
                                  key: _formKey,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        // LengthLimitingTextInputFormatter(8),
                                        FilteringTextInputFormatter
                                            .singleLineFormatter
                                      ],
                                      controller: readingController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return ("Present Reading Can't be Empty");
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            width: 20,
                                            style: BorderStyle.solid,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        hintText: "Enter Present Reading",
                                      ),
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('OR'),
                                ),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton2<String>(
                                    isExpanded: true,
                                    hint: const Row(
                                      children: [
                                        Icon(
                                          Icons.list,
                                          size: 16,
                                          color: Colors.black,
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Select Reason Here',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    items: items
                                        .map((String item) =>
                                            DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(
                                                item,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ))
                                        .toList(),
                                    value: selectedValue,
                                    onChanged: (String? value) {
                                      setState(() {
                                        selectedValue = value;
                                      });
                                    },
                                    buttonStyleData: ButtonStyleData(
                                      height: 50,
                                      width: 375,
                                      padding: const EdgeInsets.only(
                                          left: 19, right: 14),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: Colors.black26,
                                        ),
                                        color: Colors.grey.shade300,
                                      ),
                                      elevation: 2,
                                    ),
                                    iconStyleData: const IconStyleData(
                                      icon: Icon(
                                        Icons.arrow_forward_ios_outlined,
                                      ),
                                      iconSize: 14,
                                      iconEnabledColor: Colors.black,
                                      iconDisabledColor: Colors.grey,
                                    ),
                                    dropdownStyleData: DropdownStyleData(
                                      maxHeight: 200,
                                      width: 200,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        color: Colors.grey.shade300,
                                      ),
                                      offset: const Offset(-20, 0),
                                      scrollbarTheme: ScrollbarThemeData(
                                        radius: const Radius.circular(40),
                                        thickness:
                                            MaterialStateProperty.all<double>(
                                                6),
                                        thumbVisibility:
                                            MaterialStateProperty.all<bool>(
                                                true),
                                      ),
                                    ),
                                    menuItemStyleData: const MenuItemStyleData(
                                      height: 40,
                                      padding:
                                          EdgeInsets.only(left: 14, right: 14),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Obx(() => uploadImage.isLoading.value
                                    ? CircularProgressIndicator()
                                    : file == null
                                        ? const SizedBox()
                                        : Visibility(
                                            visible: uploadImage.isDone.value,
                                            child: SizedBox(
                                                height: 200,
                                                width: 300,
                                                child: Image.file(
                                                  file!,
                                                  fit: BoxFit.cover,
                                                )),
                                          ))
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
          RoundButton(
              text: 'Generate Bill',
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                color: const Color(0xff0E4473),
              ),
              onTap: () {
                // print('rrNumber:$rrNumber');
                if (_formKey.currentState!.validate()) {
                  billNotGenerateController
                      .generateBillApi(
                    url: AppUrls.generateBillApi,
                    readingDay: '1',
                    // reasonId: '',
                    sdId: '101',
                    mrId: "1",
                    userId: '25',
                    presentReading: readingController.text.toString(),
                    rrNumber: rrNumber,
                    zoneName: GetStorage().read('zoneName'),
                  )
                      .then((value) {
                    Get.toNamed('/billdetails',
                        arguments: {'rrNumber': rrNumber});
                    // print('refresh done');
                    // Get.offNamed('/billdetails');
                  });
                }
              })
        ],
      ),
    );
  }

  getCam() async {
    var img = await image.pickImage(source: ImageSource.camera);
    if (img == null) return;
    setState(() {
      file = File(img.path);
    });
  }

  getGallery() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    if (img == null) return;
    setState(() {
      file = File(img.path);
    });
  }

  Row alignWidget(
      {required String firstText,
      required String secondText,
      Color color = Colors.teal}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // const SizedBox(width: 10),
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
