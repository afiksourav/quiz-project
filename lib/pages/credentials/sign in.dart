import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quickalert/quickalert.dart';

import 'package:quiz/custom_widget/button.dart';
import 'package:quiz/pages/credentials/reset_password.dart';
import 'package:quiz/pages/credentials/sign_up_page.dart';

import 'package:quiz/pages/home_page.dart';
import 'package:quiz/services/all_services/all_services.dart';
import 'package:quiz/services/global.dart';
import 'package:quiz/services/repo/repositores.dart';
import 'package:quiz/services/sqflitebatabase/database_service.dart';

class SignInPage extends StatefulWidget {
  static const pageName = 'SignInPage';
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true;
  GlobalKey<FormState> _homeKey = GlobalKey<FormState>(debugLabel: '_homeScreenkey');
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage()), (Route<dynamic> route) => false);
        return false;
      },
      child: Scaffold(
        // resizeToAvoidBottomInset: true,
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
                          await Navigator.of(context)
                              .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage()), (Route<dynamic> route) => false);
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
          // title: Padding(
          //   padding: EdgeInsets.only(left: 70.w),
          //   child: Column(
          //     children: [
          //       SizedBox(
          //         height: 10.h,
          //       ),
          //       Text(
          //         "Leaderboard",
          //         style: TextStyle(color: Colors.black),
          //       ),
          //     ],
          //   ),
          // ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 50.h,
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 22.w),
                      child: Text(
                        "Hello there",
                        style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(width: 5.w),
                    SvgPicture.asset(
                      "assets/icon/login hand icon.svg",
                      height: 20.h,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
                SizedBox(
                  height: 100.h,
                ),
                Form(
                  key: _homeKey,
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
                      TextFormField(
                        obscureText: _obscureText,
                        controller: passwordController,
                        decoration: InputDecoration(
                          hintText: "Password",
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
                        validator: (value) => value!.isEmpty ? "Password is Required" : null,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      GestureDetector(
                        onTap: () async {
                          final connectivityResult = await (Connectivity().checkConnectivity());
                          if (connectivityResult == ConnectivityResult.mobile ||
                              connectivityResult == ConnectivityResult.wifi ||
                              connectivityResult == ConnectivityResult.ethernet) {
                            Navigator.pushNamed(context, ResetPasssword.pageName);
                          } else {
                            showDialogBox();
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: 200.w),
                          child: Text(
                            "Forgot Password",
                            style: TextStyle(color: Color(0xFF078669)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                // SizedBox(
                //   height: 100.h,
                // ),
                Container(
                  height: 230.h,
                  alignment: Alignment.bottomCenter,
                  child: _isLoading
                      ? AllService.LoadingToast()
                      : ButtonWidget(
                          height: 45.h,
                          color: Color(0xFF078669),
                          onPressed: () async {
                            try {
                              if (_homeKey.currentState!.validate()) {
                                final connectivityResult = await (Connectivity().checkConnectivity());
                                if (connectivityResult == ConnectivityResult.mobile ||
                                    connectivityResult == ConnectivityResult.wifi ||
                                    connectivityResult == ConnectivityResult.ethernet) {
                                  String email = emailController.text;
                                  String password = passwordController.text;
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  Map signin = await Repositores().SignIn(email, password);
                                  print("yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy");
                                  print("this is bodrul ${signin}");
                                  if (signin['status'] == true) {
                                    List userLog = await SqliteService().getUserLog();
                                    if (userLog.isEmpty) {
                                      await SqliteService().userlogInsert("True");
                                    } else {
                                      await SqliteService().userlogUpdate('True');
                                    }
                                    g_isLogin = true;
                                    g_token = signin['data']['token'];
                                    g_isVerified = signin['data']['user']['email_verified_at'].toString();
                                    List userinfo = await SqliteService().getUserData();
                                    if (userinfo.isNotEmpty) {
                                      print("useprofile not empty");
                                      SqliteService().UserDataUpdate(
                                        signin['data']['user']['email_verified_at'].toString(),
                                        userinfo[0]['id'],
                                      );
                                    } else if (userinfo.isEmpty) {
                                      print("useprofile empty");
                                      SqliteService().UserDataInsert(
                                          signin['data']['user']['first_name'],
                                          signin['data']['user']['last_name'],
                                          signin['data']['user']['email'],
                                          signin['data']['user']['email_verified_at'].toString(),
                                          signin['data']['user']['updated_at'],
                                          signin['data']['user']['created_at'],
                                          signin['data']['user']['id'].toString(),
                                          signin['data']['token']);
                                    }
                                    Navigator.pushNamed(context, HomePage.pageName);
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    Navigator.pushNamed(context, HomePage.pageName);
                                  } else if (signin['status'] == false) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    await QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.error,
                                      text: signin['message'],
                                    );
                                    // await Toast.warning(context: context, text: signin['message']);
                                  }
                                } else {
                                  showDialogBox();
                                }
                              }
                            } catch (e) {
                              print(e);
                            }
                          },
                          title: "Sign In",
                        ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don’t have an account? ",
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final connectivityResult = await (Connectivity().checkConnectivity());
                        if (connectivityResult == ConnectivityResult.mobile ||
                            connectivityResult == ConnectivityResult.wifi ||
                            connectivityResult == ConnectivityResult.ethernet) {
                          Navigator.pushNamed(context, SignUpPage.pageName);
                        } else {
                          showDialogBox();
                        }
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400, color: Color(0xFF078669)),
                      ),
                    ),
                  ],
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
