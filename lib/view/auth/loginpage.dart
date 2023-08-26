import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mjala/view/auth/controller/login_controller.dart';
import 'package:mjala/utils/toastmessage.dart';
import '../../utils/roundbutton/RoundButton.dart';
import '../../widgets/roundbutton/RoundButton.dart';
// import '../../utils/login_store.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // MyPref myPref = MyPref();
  LoginController dataController = Get.find<LoginController>();
  final List<String> items = [
    'BAGALKOT',
    'BENGALURU URBAN',
    'BENGALURU RURAL',
    'BELAGAVI',
    'BALLARI',
    'BIDAR',
    'CHAMARAJANAGAR',
    'CHIKBALLAPUR',
    'CHIKKAMAGALURU',
    'CHITRADURGA',
    'DAKSHINA KANNADA',
    'DAVANAGERE',
    'DHARWAD',
    'GADAG',
    'HASSAN',
    'HAVERI',
    'KALABURAGI',
    'KODAGU',
    'KOLAR',
    'KOPPAL',
    'MANDYA',
    'MYSURU',
    'RAICHUR',
    'RAMANAGARA',
    'SHIVAMOGGA',
    'TUMAKURU',
    'UDUPI',
    'UTTARA KANNADA',
    'VIJAYAPUR',
    'YADGIR',
  ];
  String? zonename;
  String? sdid;
  String? username;

  String? selectedValue;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isHiddenPassword = true;
  final _formKey = GlobalKey<FormState>();
  bool isLoggedIn = false;

  bool emptyField = false;

  @override
  void initState() {
    // loadSharedPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      // Image.asset(
                      //   './images/nic.png',
                      //   width: 70,
                      // ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                          ),
                          Center(
                            child: Text(
                              "MJALA",
                              style: TextStyle(
                                  fontSize: 40, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Center(
                            child: Text(
                              'KARNATAKA',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // Center(
                          //   child: Text(
                          //     '( ಇ-ಜಲ ಕರ್ನಾಟಕ )',
                          //     style: TextStyle(
                          //       fontSize: 40,
                          //       fontWeight: FontWeight.w400,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      const SizedBox(
                        height: 150,
                      ),
                      buildSelectzone(),
                      const SizedBox(
                        height: 15,
                      ),
                      buildUserName(),
                      // buildPassword(),
                      const SizedBox(
                        height: 40,
                      ),

                      Obx(
                        () => dataController.isLoading.value
                            ? const CircularProgressIndicator(
                                color: Colors.red,
                              )
                            : RoundButton(
                                // isLoading: isLoading.obs,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.blue.shade900),
                                height: 55,
                                width: 150,
                                color: const Color(0xff0E4473),
                                text: 'Sign In',
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    String rowUsername =
                                        usernameController.text.toString();
                                    String rowPassword =
                                        passwordController.text.toString();

                                    dataController.postLoginApi(
                                      userId: rowUsername,
                                      password: rowPassword,
                                      zone: zonename,
                                    );
                                  } else {
                                    return Utils().showToast('Enter input');
                                  }
                                },
                                // isLoading: isLoading,
                              ),
                      ),

                      const SizedBox(height: 180),
                      // const Image(
                      //   image: AssetImage(
                      //     './images/logoka.png',
                      //   ),
                      // ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Text("Powered by NIC,Karnataka"),
                          SizedBox(width: 3),
                          // Image(
                          //   image: AssetImage("./images/nic.png"),
                          //   width: 40,
                          // ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

//select section zone

  Widget buildSelectzone() {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        isExpanded: true,
        hint: const Row(
          children: [
            Icon(
              Icons.list,
              size: 16,
              color: Colors.white,
            ),
            SizedBox(
              width: 4,
            ),
            Expanded(
              child: Text(
                'Select Zone',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        items: items
            .map(
              (item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
            .toList(),
        value: selectedValue,
        onChanged: (value) {
          setState(
            () {
              selectedValue = value;
              zonename = selectedValue.toString();
            },
          );
        },
        buttonStyleData: ButtonStyleData(
          height: 60,
          width: 355,
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.black26,
            ),
            color: const Color(0xff0E4473),
          ),
          elevation: 2,
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(
            Icons.arrow_forward_ios_outlined,
          ),
          iconSize: 14,
          iconEnabledColor: Colors.white,
          iconDisabledColor: Colors.grey,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          width: 200,
          padding: null,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.black38,
          ),
          elevation: 8,
          offset: const Offset(-20, 0),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: MaterialStateProperty.all(6),
            thumbVisibility: MaterialStateProperty.all(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.only(left: 14, right: 14),
        ),
      ),
    );
  }

//get user input

  Widget buildUserName() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Row(
            children: [
              SizedBox(width: 15),
              Text(
                'User Name *',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 5),
          TextFormField(
            controller: usernameController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Enter Some Text';
              }
              return null;
            },
            style: const TextStyle(color: Colors.black87),
            decoration: const InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.blueGrey,
              ),
              hintText: 'User Name',
              hintStyle: TextStyle(color: Colors.black38),
            ),
            keyboardType: TextInputType.text,
          ),
          const Row(
            children: [
              SizedBox(width: 15),
              Text(
                'Password*',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 5),
          TextFormField(
            controller: passwordController,
            obscureText: isHiddenPassword,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Enter Some Text';
              }
              return null;
            },
            style: const TextStyle(color: Colors.black87),
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              contentPadding: const EdgeInsets.only(top: 14),
              prefixIcon: const Icon(
                Icons.password,
                color: Colors.blueGrey,
              ),
              hintText: 'Password',
              suffixIcon: InkWell(
                  onTap: _togglePasswordView,
                  child: const Icon(
                    Icons.visibility,
                    color: Colors.grey,
                  )),
              hintStyle: const TextStyle(color: Colors.black38),
            ),
            keyboardType: TextInputType.text,
          ),
        ],
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }
}
