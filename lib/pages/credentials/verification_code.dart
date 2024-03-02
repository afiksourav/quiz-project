import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:quickalert/quickalert.dart';
import 'package:quiz/custom_widget/button.dart';
import 'package:quiz/pages/credentials/sign%20in.dart';
import 'package:quiz/pages/home_page.dart';

import 'package:quiz/services/all_services/all_services.dart';
import 'package:quiz/services/global.dart';
import 'package:quiz/services/repo/repositores.dart';
import 'package:quiz/services/sqflitebatabase/database_service.dart';

class VerificationPage extends StatefulWidget {
  static const pageName = 'verification';
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  String otpPin = '';
  bool isSnackBarVisible = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage()), (Route<dynamic> route) => false);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: SizedBox.shrink(),
                ),
                Expanded(
                  flex: 8,
                  child: Container(
                    margin: EdgeInsets.only(top: 3.h),
                    // alignment: Alignment.center,
                    // height: 30.h,
                    // width: 30.w,

                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0, 1), // changes position of shadow
                        ),
                      ],
                      color: Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(14.r),
                        topRight: Radius.circular(14.r),
                        bottomLeft: Radius.circular(14.r),
                        bottomRight: Radius.circular(14.r),
                      ),
                    ),
                    child: Center(
                      child: IconButton(
                        color: Colors.black,
                        onPressed: () async {
                          await Navigator.of(context).pushNamed(HomePage.pageName);
                        },
                        icon: SvgPicture.asset(
                          "assets/icon/arro.svg",
                          width: 14.w,
                          height: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          automaticallyImplyLeading: false,
          title: Padding(
            padding: EdgeInsets.only(left: 50.w),
            child: Column(
              children: [
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  "Verification Code",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Text(
                //       "Verification Code",
                //       style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500, color: Color(0xFF1D2746)),
                //     )
                //   ],
                // ),
                SizedBox(
                  height: 90.h,
                ),
                Text("Check the email you'll get the code\nsubmit it!",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF1D2746),
                    )),
                SizedBox(
                  height: 80.h,
                ),
                OTPTextField(
                  length: 5,
                  width: MediaQuery.of(context).size.width,
                  fieldWidth: 60,
                  style: TextStyle(fontSize: 17),
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  fieldStyle: FieldStyle.underline,
                  onCompleted: (pin) async {
                    final connectivityResult = await (Connectivity().checkConnectivity());
                    if (connectivityResult == ConnectivityResult.mobile ||
                        connectivityResult == ConnectivityResult.wifi ||
                        connectivityResult == ConnectivityResult.ethernet) {
                      otpPin = pin;
                      print("Completedddddddddddddddddd: " + pin);
                      Map otp = await Repositores().OtpVarificationSubmit(pin);
                      print("Otp api......$otp");
                      if (otp['status'] == true) {
                        g_isLogin = true;
                        g_isVerified = otp['data']['user']['email_verified_at'].toString();
                        await SqliteService()
                            .UserDataUpdate(otp['data']['user']['email_verified_at'].toString(), otp['data']['user']['id'].toString());
                        List userLog = await SqliteService().getUserLog();
                        if (userLog.isEmpty) {
                          await SqliteService().userlogInsert("True");
                        } else {
                          await SqliteService().userlogUpdate('True');
                        }
                        await QuickAlert.show(
                          context: context,
                          type: QuickAlertType.success,
                          text: "Account Varifation Success",
                        );

                        await Navigator.of(context)
                            .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage()), (Route<dynamic> route) => false);
                      } else {
                        await QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          text: otp['message'],
                        );
                      }
                    } else {
                      showDialogBox();
                    }
                  },
                ),
                SizedBox(
                  height: 80.h,
                ),
                ButtonWidget(
                  height: 45.h,
                  color: Color(0xFF078669),
                  onPressed: () async {
                    final connectivityResult = await (Connectivity().checkConnectivity());
                    if (connectivityResult == ConnectivityResult.mobile ||
                        connectivityResult == ConnectivityResult.wifi ||
                        connectivityResult == ConnectivityResult.ethernet) {
                      Map otp = await Repositores().OtpVarificationSubmit(otpPin);
                      if (otp['status'] == true) {
                        g_isLogin = true;
                        g_isVerified = otp['data']['user']['email_verified_at'].toString();
                        await SqliteService()
                            .UserDataUpdate(otp['data']['user']['email_verified_at'].toString(), otp['data']['user']['id'].toString());
                        List userLog = await SqliteService().getUserLog();
                        if (userLog.isEmpty) {
                          await SqliteService().userlogInsert("True");
                        } else {
                          await SqliteService().userlogUpdate('True');
                        }

                        await Navigator.of(context)
                            .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage()), (Route<dynamic> route) => false);
                      } else {
                        if (!isSnackBarVisible) {
                          print("tryyyyyyyyyyyyyyyyyyyy");
                          await QuickAlert.show(
                            context: context,
                            type: QuickAlertType.error,
                            text: otp['message'],
                          );
                          setState(() {
                            isSnackBarVisible = true;
                          });

                          // You can reset the flag after a certain duration if needed
                          Future.delayed(Duration(seconds: 3), () {
                            setState(() {
                              isSnackBarVisible = false;
                            });
                          });
                        }
                      }
                    } else {
                      showDialogBox();
                    }
                  },
                  title: "Verify",
                ),
                SizedBox(
                  height: 15.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // void _showSnackBar() {
  //   if (!isSnackBarVisible) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         backgroundColor: Colors.red,
  //         content: Text("Click the checkbox if you agree to the terms and conditions"),
  //       ),
  //     );
  //     setState(() {
  //       isSnackBarVisible = true;
  //     });

  //     // You can reset the flag after a certain duration if needed
  //     Future.delayed(Duration(seconds: 3), () {
  //       setState(() {
  //         isSnackBarVisible = false;
  //       });
  //     });
  //   }
  // }

  showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('No Connection'),
          content: const Text('Please check your internet connectivity'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancel');
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
}
