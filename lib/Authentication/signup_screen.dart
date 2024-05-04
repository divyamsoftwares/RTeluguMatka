// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:telugu_matka/Api_Calling/Data_Model/get_config_model.dart';
import 'package:telugu_matka/Api_Calling/Data_Model/signup_model.dart';
import 'package:telugu_matka/Api_Calling/Networking/api_service.dart';
import 'package:telugu_matka/App_Utils/app_utils.dart';
import 'package:telugu_matka/App_Utils/color_utils.dart';
import 'package:telugu_matka/App_Utils/image_utils.dart';
import 'package:telugu_matka/Authentication/login_screen.dart';
import 'package:telugu_matka/Home_Screen/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? sessionKey;
  bool passToogle = true;
  final bool _isDisposed = false;
  bool _isLoading = false;
  SignupData? getSignupData;

  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GetConfig? getConfigData;

  final _signupKey = GlobalKey<FormState>();

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

  Future<void> signupData() async {
    if (_isDisposed) {
      return;
    }

    getSignupData = await ApiServices.signupData(
        mobileNumberController.text,
        nameController.text,
        passwordController.text,
        sessionKey.toString(),
        context);

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
              key: _signupKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 80,
                  ),
                  Center(
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.pink,
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
                          "Create a New Account",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            color: ColorUtils.closeBorder,
                            fontSize: 14,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w500,
                          ),
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
                          controller: mobileNumberController,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 12),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                    color: ColorUtils.closeBorder, width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                    color: ColorUtils.closeBorder, width: 2),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                      color: ColorUtils.closeBorder)),
                              errorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide:
                                    BorderSide(color: Colors.red, width: 2),
                              ),
                              hintText: "Mobile Number",
                              prefixIcon: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      height: 25,
                                      width: 25,
                                      child: Image.asset(ImageUtils.mobile)),
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
                          height: 15,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter user name";
                            } else {
                              null;
                            }
                            return null;
                          },
                          controller: nameController,
                          style: const TextStyle(
                            color: ColorUtils.closeBorder,
                            fontSize: 14,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(left: 12),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                    color: ColorUtils.closeBorder, width: 2),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                      color: ColorUtils.closeBorder)),
                              errorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide:
                                    BorderSide(color: Colors.red, width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                    color: ColorUtils.closeBorder, width: 2),
                              ),
                              hintText: "Enter Name",
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.black,
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
                          height: 15,
                        ),
                        /* TextFormField(
                    validator: (value) {
                      bool emailValid = RegExp(r"[a-z0-9]+@[a-z]+\.[a-z]{2,3}")
                          .hasMatch(value!);
                      if (value.isEmpty) {
                        return "Enter Email";
                      } else if (!emailValid) {
                        return "Enter Valid Email";
                      } else {
                        return null;
                      }
                    },
                    controller: emailController,
                    style: const TextStyle(
                      color: ColorUtils.amber,
                      fontSize: 14,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 12),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide:
                              BorderSide(color: ColorUtils.amber, width: 2),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(color: ColorUtils.amber)),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide:
                              BorderSide(color: ColorUtils.amber, width: 2),
                        ),
                        hintText: "Enter Email",
                        hintStyle: TextStyle(
                          color: ColorUtils.amber,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          letterSpacing: 1,
                        )),
                    cursorColor: ColorUtils.amber,
                  ),
                  const SizedBox(
                    height: 15,
                  ), */
                        TextFormField(
                          style: const TextStyle(
                            color: ColorUtils.closeBorder,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                          ),
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
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(left: 12),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                    color: ColorUtils.closeBorder, width: 2),
                              ),
                              errorBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide:
                                    BorderSide(color: Colors.red, width: 2),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                    color: ColorUtils.closeBorder, width: 2),
                              ),
                              focusedErrorBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                      color: ColorUtils.closeBorder)),
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
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (_isLoading) {
                              return;
                            }
                            if (_signupKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });
                              await signupData();
                              setState(() {
                                _isLoading = false;
                              });
                              if (getSignupData != null) {
                                if (getSignupData!.success == "1") {
                                  print("sucess");
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(getSignupData!.msg),
                                    ),
                                  );
                                  final SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setString(
                                      "signupData", jsonEncode(getSignupData));
                                  prefs.setString(
                                      "email", emailController.text);
                                  print(
                                      "savedSignupData : ${json.decode(prefs.getString("signupData")!)}");

                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomeScreen()));
                                } else {
                                  print("Not sucess");
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(getSignupData!.msg),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                }
                              }
                            }
                          },
                          child: Container(
                            height: 45,
                            width: 150,
                            decoration: BoxDecoration(
                                color: ColorUtils.closeBorder,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: _isLoading
                                    ? SizedBox(
                                        height: 30,
                                        width: 30,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ))
                                    : Text(
                                        "Signup",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      )),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()));
                                },
                                child: Text(
                                  "LOGIN",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: ColorUtils.closeBorder),
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  ),

                  /*   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                          child: Divider(
                        color: Colors.white,
                      )),
                      InkWell(
                        onTap: () async {
                          if (getConfigData!.data[18].data == "0") {
                          } else {
                            const countrycode = '91';
                            String phoneNumber =
                                getConfigData!.data[1].data;
                            print("phone number : $phoneNumber");
                            final whatsappUrl =
                                'https://wa.me/$countrycode$phoneNumber';
                            if (await canLaunch(whatsappUrl)) {
                              await launch(whatsappUrl, forceSafariVC: false);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(
                                      'WhatsApp is not installed on your device.'),
                                ),
                              );
                            }
                          }
                        },
                        child: SizedBox(
                          // margin: EdgeInsets.symmetric(horizontal: 20),
                          height: 40,
                          width: 40,
                          child: Image.asset(ImageUtils.support),
                          */ /* decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    "assets/images/icons8-whatsapp-48.png"))),*/ /*
                        ),
                      ),
                      Expanded(
                          child: Divider(
                        color: Colors.white,
                      )),
                      */ /*
                    InkWell(
                      onTap: () async {
                        if (getConfigData!.data[18].data == "0") {
                        } else {
                          const countrycode = '91';
                          String phoneNumber =
                              '${getConfigData!.data[1].data}';
                          print("phone number : $phoneNumber");
                          final whatsappUrl =
                              'https://wa.me/$countrycode$phoneNumber';
                          if (await canLaunch(whatsappUrl)) {
                            await launch(whatsappUrl, forceSafariVC: false);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                behavior: SnackBarBehavior.floating,
                                content: Text(
                                    'WhatsApp is not installed on your device.'),
                              ),
                            );
                          }
                        }
                      },
                      child: Text(
                        "Contact Admin 919694334171",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    )
          
          
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Column(
                  children: [
                    Text(
                      "By Logging in you are agree to these",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 16),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Terms & Conditions",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors
                                .white, // Change this color to the desired underline color
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "&",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            // Change this color to the desired underline color
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Privacy Policy",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                            // Change this color to the desired underline color
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),*/ /*
                      SizedBox(
                        height: 40,
                      ),
                      */ /*SizedBox(
                  height: 10,
                ),
                GestureDetector(
                   onTap: () async {
                                  if (getConfigData!.data[18].data == "0") {
                                  } else {
                                    playSound();
                                    launch("tel:${getConfigData!.data[1].data}");
                                  }
                                },
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                          color: ColorUtils.orange,
                          borderRadius: BorderRadius.circular(12)),
                      child: Text(
                        "Join Our Community",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 12),
                      )),
                ),*/ /*
                    ],
                  ),*/
                  /* Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Expanded(
                      //     child: Divider(
                      //   color: Colors.grey,
                      // )),
                      InkWell(
                        onTap: () async {
                             if (getConfigData!.data[18].data == "0") {
                          } else {
                            const countrycode = '91';
                            String phoneNumber = '${getConfigData!.data[1].data}';
                            print("phone number : $phoneNumber");
                            final whatsappUrl =
                                'https://wa.me/$countrycode$phoneNumber';
                            if (await canLaunch(whatsappUrl)) {
                              await launch(whatsappUrl, forceSafariVC: false);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(
                                      'WhatsApp is not installed on your device.'),
                                ),
                              );
                            }
                          }
                        },
                        child: Container(
                          // margin: EdgeInsets.symmetric(horizontal: 20),
                          height: 40,
                          width: 40,
                          // child: Image.asset(ImageUtils.support),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/icons8-whatsapp-48.png"))),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          if (getConfigData!.data[18].data == "0") {
                          } else {
                            const countrycode = '91';
                            String phoneNumber =
                                '${getConfigData!.data[1].data}';
                            print("phone number : $phoneNumber");
                            final whatsappUrl =
                                'https://wa.me/$countrycode$phoneNumber';
                            if (await canLaunch(whatsappUrl)) {
                              await launch(whatsappUrl, forceSafariVC: false);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(
                                      'WhatsApp is not installed on your device.'),
                                ),
                              );
                            }
                          }
                        },
                        child: Text(
                          "Contact Admin 919694334171",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      )
          
                      // Expanded(
                      //     child: Divider(
                      //   color: Colors.grey,
                      // )),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    children: [
                      Text(
                        "By Logging in you are agree to these",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 16),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Terms & Conditions",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors
                                  .white, // Change this color to the desired underline color
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "&",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              // Change this color to the desired underline color
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Privacy Policy",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.white,
                              // Change this color to the desired underline color
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account ? ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                          child: Text(
                            "LOGIN",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Divider(
                        color: Colors.grey,
                      )),
                      InkWell(
                        onTap: () async {
                          if (getConfigData!.data[18].data == "0") {
                          } else {
                            const countrycode = '91';
                            String phoneNumber =
                                '${getConfigData!.data[1].data}';
                            print("phone number : $phoneNumber");
                            final whatsappUrl =
                                'https://wa.me/$countrycode$phoneNumber';
                            if (await canLaunch(whatsappUrl)) {
                              await launch(whatsappUrl, forceSafariVC: false);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(
                                      'WhatsApp is not installed on your device.'),
                                ),
                              );
                            }
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          height: 50,
                          width: 50,
                          child: Image.asset(ImageUtils.support),
                        ),
                      ),
                      Expanded(
                          child: Divider(
                        color: Colors.grey,
                      )),
                    ],
                  ),*/
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
