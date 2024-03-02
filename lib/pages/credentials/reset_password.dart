import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quickalert/quickalert.dart';
import 'package:quiz/custom_widget/app_text_field.dart';
import 'package:quiz/custom_widget/button.dart';
import 'package:quiz/pages/credentials/F_password_verification_code.dart';
import 'package:quiz/pages/credentials/verification_code.dart';
import 'package:quiz/services/all_services/all_services.dart';
import 'package:quiz/services/repo/repositores.dart';

GlobalKey<FormState> formKey = GlobalKey<FormState>();

class ResetPasssword extends StatefulWidget {
  static const pageName = 'resetPassword';
  const ResetPasssword({super.key});

  @override
  State<ResetPasssword> createState() => _ResetPassswordState();
}

class _ResetPassswordState extends State<ResetPasssword> {
  TextEditingController emailController = TextEditingController();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      onPressed: () {
                        Navigator.pop(context);
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
                "Reset Password",
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
              //       "Reset Password",
              //       style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500, color: Color(0xFF1D2746)),
              //     )
              //   ],
              // ),
              SizedBox(
                height: 90.h,
              ),
              Text("We need your registration email to send\nyou password reset code!",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF1D2746),
                  )),
              SizedBox(
                height: 80.h,
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        hintText: "Email",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value!.isEmpty ? "Email is Required" : null,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 80.h,
              ),
              Container(
                height: 230.h,
                alignment: Alignment.bottomCenter,
                child: _isLoading
                    ? AllService.LoadingToast()
                    : ButtonWidget(
                        height: 45.h,
                        color: Color(0xFF078669),
                        onPressed: () async {
                          final connectivityResult = await (Connectivity().checkConnectivity());
                          if (connectivityResult == ConnectivityResult.mobile ||
                              connectivityResult == ConnectivityResult.wifi ||
                              connectivityResult == ConnectivityResult.ethernet) {
                            try {
                              if (formKey.currentState!.validate()) {
                                print("aaa");
                                Map a = {"email": emailController.text};
                                setState(() {
                                  _isLoading = true;
                                });
                                Map res = await Repositores().forgetPassword(emailController.text);
                                if (res['status'] == true) {
                                  Map a = {"email": emailController.text};
                                  Navigator.pushNamed(context, ForgetPasswordVerificationPage.pageName, arguments: a);
                                  setState(() {
                                    _isLoading = false;
                                  });
                                } else {
                                  await QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.warning,
                                    text: res['message'],
                                  );

                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              }
                            } catch (e) {
                              print(e);
                            }
                          } else {
                            showDialogBox();
                          }
                        },
                        title: "Reset Password",
                      ),
              ),
              SizedBox(
                height: 15.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

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
