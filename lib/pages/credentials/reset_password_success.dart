import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quickalert/quickalert.dart';
import 'package:quiz/custom_widget/button.dart';

import 'package:quiz/pages/credentials/sign%20in.dart';
import 'package:quiz/services/all_services/all_services.dart';
import 'package:quiz/services/repo/repositores.dart';

GlobalKey<FormState> formKey = GlobalKey<FormState>();

class ResetPassowrdSuccess extends StatefulWidget {
  static const pageName = 'ResetPassowrdSuccess';
  const ResetPassowrdSuccess({super.key});

  @override
  State<ResetPassowrdSuccess> createState() => _ResetPassowrdSuccessState();
}

class _ResetPassowrdSuccessState extends State<ResetPassowrdSuccess> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController NewpasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true;
  bool _obscureTextConfrimPass = true;
  @override
  Widget build(BuildContext context) {
    Map? data = ModalRoute.of(context)!.settings.arguments as Map;
    print("tttttttttttttt $data");
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
                "New Password",
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
              SizedBox(
                height: 90.h,
              ),
              Text("Enter your password below\nto reset your password !",
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
                      obscureText: _obscureText,
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: "Enter your new Password",
                        border: OutlineInputBorder(),
                        suffixIcon: _obscureText
                            ? IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscureText = false;
                                  });
                                },
                                icon: const Icon(
                                  Icons.visibility_off,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                              )
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscureText = true;
                                  });
                                },
                                icon: const Icon(
                                  Icons.remove_red_eye,
                                  size: 20,
                                  color: Colors.black,
                                ),
                              ),
                      ),
                      validator: (value) => value!.isEmpty
                          ? "Password Required"
                          : value.length < 8
                              ? "Password is to short "
                              : null,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    TextFormField(
                      obscureText: _obscureTextConfrimPass,
                      controller: NewpasswordController,
                      decoration: InputDecoration(
                        hintText: "Confirm new Password",
                        border: OutlineInputBorder(),
                        suffixIcon: _obscureTextConfrimPass
                            ? IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscureTextConfrimPass = false;
                                  });
                                },
                                icon: const Icon(
                                  Icons.visibility_off,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                              )
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscureTextConfrimPass = true;
                                  });
                                },
                                icon: const Icon(
                                  Icons.remove_red_eye,
                                  size: 20,
                                  color: Colors.black,
                                ),
                              ),
                      ),
                      validator: (value) => value != passwordController.text ? "Password Dose not matched " : null,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 80.h,
              ),
              _isLoading
                  ? AllService.LoadingToast()
                  : ButtonWidget(
                      height: 45.h,
                      color: Color(0xFF078669),
                      onPressed: () async {
                        try {
                          final connectivityResult = await (Connectivity().checkConnectivity());
                          if (connectivityResult == ConnectivityResult.mobile ||
                              connectivityResult == ConnectivityResult.wifi ||
                              connectivityResult == ConnectivityResult.ethernet) {
                            if (formKey.currentState!.validate()) {
                              String email = data['email'].toString();
                              String code = data['code'].toString();
                              String password = passwordController.text;
                              String passwordConfirmation = NewpasswordController.text;
                              setState(() {
                                _isLoading = true;
                              });
                              Map res = await Repositores().forgetPasswordSucess(email, password, passwordConfirmation, code);
                              print("rrrrrrrrrrrrrrrrrr");
                              print(res);
                              if (res['status'] == true) {
                                await QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.success,
                                  text: "Your Password Changed Successfully!",
                                );
                                await Navigator.of(context)
                                    .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => SignInPage()), (Route<dynamic> route) => false);

                                setState(() {
                                  _isLoading = false;
                                });
                              } else {
                                await QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.warning,
                                  text: res['message'],
                                );
                                //await Toast.warning(context: context, text: res['message']);
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            }
                          } else {
                            showDialogBox();
                          }
                        } catch (e) {
                          print(e);
                        }
                      },
                      title: "Reset Password",
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
