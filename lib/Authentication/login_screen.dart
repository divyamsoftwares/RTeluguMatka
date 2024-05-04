// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, unnecessary_string_interpolations, deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telugu_matka/Api_Calling/Data_Model/get_config_model.dart';
import 'package:telugu_matka/Api_Calling/Data_Model/login_model.dart';
import 'package:telugu_matka/Api_Calling/Networking/api_service.dart';
import 'package:telugu_matka/App_Utils/app_utils.dart';
import 'package:telugu_matka/App_Utils/color_utils.dart';
import 'package:telugu_matka/App_Utils/image_utils.dart';
import 'package:telugu_matka/Authentication/signup_screen.dart';
import 'package:telugu_matka/Home_Screen/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool passToogle = true;
  String? sessionKey;
  final bool _isDisposed = false;
  LoginData? loginData;
  bool _isLoading = false;
  GetConfig? getConfigData;

  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _loginKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    randomString();
    configData();
  }

  randomString() {
    sessionKey = getRandomString(30);
    print("<>>>>>>>>> $sessionKey");
  }

  Future<void> getLoginData() async {
    if (_isDisposed) {
      return;
    }

    loginData = await ApiServices.fetchLogindata(mobileNumberController.text,
        passwordController.text, sessionKey.toString(), context);

    if (_isDisposed) {
      return;
    }
    setState(() {});
  }

  Future<void> configData() async {
    if (mounted) {
      if (mounted) {
        getConfigData = await ApiServices.fetchGetConfigData();
        if (mounted) {}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                child: Container(
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(ImageUtils.bluebg), fit: BoxFit.cover)),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Form(
        key: _loginKey,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 80,
              ),
              Center(
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                          image: AssetImage(ImageUtils.logoRmoveBg))),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    Text(
                      "Login to Continue",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator: (value) {
                        String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                        RegExp regExp = RegExp(patttern);
                        if (value!.isEmpty) {
                          return "Enter Phone Number";
                        } else if (value.length != 10) {
                          return "Mobile Number must be of 10 digit";
                        } else if (!regExp.hasMatch(value)) {
                          return 'Please enter valid mobile number';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.number,
                      controller: mobileNumberController,
                      style: const TextStyle(
                        color: ColorUtils.closeBorder,
                        fontSize: 14,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 12),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                                color: ColorUtils.closeBorder, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              color: ColorUtils.closeBorder,
                              width: 2,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Colors.blue)),
                          hintText: "Enter Mobile Number",
                          prefixIcon: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  height: 25,
                                  width: 25,
                                  child: Image.asset(/* ImageUtils.mobile */"assets/images/mobileI.png")),
                            ],
                          ),
                          hintStyle: TextStyle(
                            color: ColorUtils.closeBorder,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            letterSpacing: 1,
                          )),
                      cursorColor: ColorUtils.closeBorder,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Password";
                        } else if (passwordController.text.length < 6) {
                          return "Password shoud minimum 6 characters";
                        } else {
                          return null;
                        }
                      },
                      controller: passwordController,
                      obscureText: passToogle,
                      style: const TextStyle(
                        color: ColorUtils.closeBorder,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      ),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(top: 15, left: 12),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                                color: ColorUtils.closeBorder, width: 2),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                                color: ColorUtils.closeBorder, width: 2),
                          ),
                          errorBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                          focusedErrorBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide:
                                  BorderSide(color: ColorUtils.closeBorder)),
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                passToogle = !passToogle;
                              });
                            },
                            child: Icon(
                              passToogle
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: ColorUtils.closeBorder,
                              size: 19,
                            ),
                          ),
                          hintText: "Enter Password",
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.black,
                          ),
                          hintStyle: const TextStyle(
                            color: ColorUtils.closeBorder,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                          )),
                      cursorColor: ColorUtils.closeBorder,
                    ),
                    SizedBox(
                      height: 19,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (_isLoading) {
                          return;
                        }
                        if (_loginKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });
                          await getLoginData();
                          setState(() {
                            _isLoading = false;
                          });
                          if (loginData != null) {
                            if (loginData!.success == "1") {
                              print("sucess");
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(loginData!.msg),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()));
                            } else {
                              print("Not sucess");
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(loginData!.msg),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          }
                        }
                      },
                      child: Container(
                        height: 40,
                        width: Get.width,
                        // margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: ColorUtils.closeBorder,
                            borderRadius: BorderRadius.circular(12)),
                        child: Center(
                            child: _isLoading
                                ? SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ))
                                : Text(
                                    "LOGIN",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  )),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Dont have account?",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUpScreen()));
                            },
                            child: Text(
                              " SignUp",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: ColorUtils.closeBorder),
                            )),
                      ],
                    ),
                    /* GestureDetector(
                        onTap: () {
                          
                        },
                        child: Container(
                          height: 40,
                          width: Get.width,
                          decoration: BoxDecoration(
                              color: ColorUtils.blue,
                              borderRadius: BorderRadius.circular(00)),
                          child: Center(
                            child: Text(
                              "REGISTER ACCOUNT",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 17),
                            ),
                          ),
                        )), */
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     Expanded(
              //         child: Divider(
              //       color: Colors.white,
              //     )),
              //     InkWell(
              //       onTap: () async {
              //         if (getConfigData!.data[18].data == "0") {
              //         } else {
              //           const countrycode = '91';
              //           String phoneNumber =
              //               '${getConfigData!.data[1].data}';
              //           print("phone number : $phoneNumber");
              //           final whatsappUrl =
              //               'https://wa.me/$countrycode$phoneNumber';
              //           if (await canLaunch(whatsappUrl)) {
              //             await launch(whatsappUrl, forceSafariVC: false);
              //           } else {
              //             ScaffoldMessenger.of(context).showSnackBar(
              //               const SnackBar(
              //                 behavior: SnackBarBehavior.floating,
              //                 content: Text(
              //                     'WhatsApp is not installed on your device.'),
              //               ),
              //             );
              //           }
              //         }
              //       },
              //       child: SizedBox(
              //         // margin: EdgeInsets.symmetric(horizontal: 20),
              //         height: 40,
              //         width: 40,
              //         child: Image.asset(ImageUtils.support),
              //         /* decoration: BoxDecoration(
              //             image: DecorationImage(
              //                 image: AssetImage(
              //                     "assets/images/icons8-whatsapp-48.png"))),*/
              //       ),
              //     ),
              //     Expanded(
              //         child: Divider(
              //       color: Colors.white,
              //     )),
              //     /*
              //     InkWell(
              //       onTap: () async {
              //         if (getConfigData!.data[18].data == "0") {
              //         } else {
              //           const countrycode = '91';
              //           String phoneNumber =
              //               '${getConfigData!.data[1].data}';
              //           print("phone number : $phoneNumber");
              //           final whatsappUrl =
              //               'https://wa.me/$countrycode$phoneNumber';
              //           if (await canLaunch(whatsappUrl)) {
              //             await launch(whatsappUrl, forceSafariVC: false);
              //           } else {
              //             ScaffoldMessenger.of(context).showSnackBar(
              //               const SnackBar(
              //                 behavior: SnackBarBehavior.floating,
              //                 content: Text(
              //                     'WhatsApp is not installed on your device.'),
              //               ),
              //             );
              //           }
              //         }
              //       },
              //       child: Text(
              //         "Contact Admin 919694334171",
              //         style: TextStyle(
              //             color: Colors.white,
              //             fontSize: 15,
              //             fontWeight: FontWeight.bold),
              //       ),
              //     )
              //
              //
              //   ],
              // ),
              // SizedBox(
              //   height: 30,
              // ),
              // Column(
              //   children: [
              //     Text(
              //       "By Logging in you are agree to these",
              //       style: TextStyle(
              //           color: Colors.white,
              //           fontWeight: FontWeight.w400,
              //           fontSize: 16),
              //     ),
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Text(
              //           "Terms & Conditions",
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontWeight: FontWeight.w500,
              //             decoration: TextDecoration.underline,
              //             decorationColor: Colors
              //                 .white, // Change this color to the desired underline color
              //             fontSize: 16,
              //           ),
              //         ),
              //         SizedBox(
              //           width: 5,
              //         ),
              //         Text(
              //           "&",
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontWeight: FontWeight.w500,
              //             // Change this color to the desired underline color
              //             fontSize: 16,
              //           ),
              //         ),
              //         SizedBox(
              //           width: 5,
              //         ),
              //         Text(
              //           "Privacy Policy",
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontWeight: FontWeight.w500,
              //             decoration: TextDecoration.underline,
              //             decorationColor: Colors.white,
              //             // Change this color to the desired underline color
              //             fontSize: 16,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ],
              // ),*/
              //     SizedBox(
              //       height: 40,
              //     ),
              //     /*SizedBox(
              //   height: 10,
              // ),
              // GestureDetector(
              //    onTap: () async {
              //                   if (getConfigData!.data[18].data == "0") {
              //                   } else {
              //                     playSound();
              //                     launch("tel:${getConfigData!.data[1].data}");
              //                   }
              //                 },
              //   child: Container(
              //       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              //       decoration: BoxDecoration(
              //           color: ColorUtils.orange,
              //           borderRadius: BorderRadius.circular(12)),
              //       child: Text(
              //         "Join Our Community",
              //         style: TextStyle(
              //             fontWeight: FontWeight.w500,
              //             color: Colors.white,
              //             fontSize: 12),
              //       )),
              // ),*/
              //   ],
              // ),
            ]),
      ),
    ))));
  }
}
