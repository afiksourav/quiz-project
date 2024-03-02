import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quickalert/quickalert.dart';
import 'package:quiz/pages/credentials/sign%20in.dart';
import 'package:quiz/pages/credentials/sign_up_page.dart';
import 'package:quiz/pages/credentials/verification_code.dart';
import 'package:quiz/pages/home_page.dart';
import 'package:quiz/pages/leaderboard/leaderboardPage.dart';
import 'package:quiz/pages/profile/profile_page.dart';
import 'package:quiz/services/all_services/all_services.dart';
import 'package:quiz/services/global.dart';
import 'package:quiz/services/repo/repositores.dart';
import 'package:quiz/services/sqflitebatabase/database_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DrawerHome extends StatefulWidget {
  static const pageName = 'DrawerHome';
  Map? Userinfo;

  DrawerHome({super.key, required this.Userinfo});
  @override
  State<DrawerHome> createState() => _DrawerHomeState();
}

bool _isLoadingsignUp = false;
bool _isLoadingLogout = false;
bool _isLoadingsignIn = false;
bool _isProfleVarifecation = false;
String userStatus = '';
String isVerified = 'null';
List userinfo = [];

class _DrawerHomeState extends State<DrawerHome> {
  @override
  UserLog() async {
    List b = await SqliteService().getUserLog();
    print("object");
    if (b.isNotEmpty) {
      userStatus = b[0]['userStatus'].toString();
      print(b[0]['userStatus'].toString());
    }
    userinfo = await SqliteService().getUserData();
    if (userinfo.isNotEmpty) {
      isVerified = userinfo[0]['email_verified_at'];
    }
    setState(() {});
  }

  @override
  void initState() {
    UserLog();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      child: Drawer(
        child: Container(
          color: const Color(0xFFFFFFFF),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              SizedBox(
                height: 315.h,
                child: DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Color(0xFF078669), // Background color of the header
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10.0.h,
                      ),
                      widget.Userinfo!['Unauthenticated'] == 'Unauthenticated.'
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(400.0),
                              child: Image.asset(
                                "assets/images/b.jpg",
                                height: 100.h,
                                fit: BoxFit.cover,
                              ),
                            )
                          : widget.Userinfo!['Photo'].toString() == 'null'
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(400.0),
                                  child: Image.asset(
                                    "assets/images/b.jpg",
                                    height: 100.h,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : SizedBox(
                                  height: 100.h,
                                  width: 100.w,
                                  child: CachedNetworkImage(
                                    imageUrl: widget.Userinfo!['Photo'],
                                    imageBuilder: (context, imageProvider) => CircleAvatar(
                                      radius: 40.r,
                                      backgroundImage: imageProvider,
                                    ),
                                    placeholder: (context, url) => CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                  ),
                                ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          userinfo.isEmpty
                              ? Container()
                              : Container(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(
                                        widget.Userinfo!['Unauthenticated'] == 'Unauthenticated.' ? "" : widget.Userinfo!['name'],
                                        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                          SizedBox(
                            height: 5.h,
                          ),
                          userinfo.isEmpty
                              ? Container()
                              : Text(
                                  widget.Userinfo!['Unauthenticated'] == 'Unauthenticated.' ? "" : widget.Userinfo!['email'],
                                  style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w400, color: Colors.white),
                                ),
                          SizedBox(
                            height: 7.h,
                          ),
                          userinfo.isEmpty
                              ? ElevatedButton(
                                  onPressed: () async {
                                    final connectivityResult = await (Connectivity().checkConnectivity());
                                    if (connectivityResult == ConnectivityResult.mobile ||
                                        connectivityResult == ConnectivityResult.wifi ||
                                        connectivityResult == ConnectivityResult.ethernet) {
                                      print("afikkkkkkkkkk");
                                      Navigator.pushNamed(context, SignInPage.pageName);
                                    } else {
                                      print("internet off");
                                      showDialogBox();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(85.w, 35.h),
                                    backgroundColor: Color(0xFF2C987F),
                                  ),
                                  child: Text(
                                    "Sign in/Sign Up",
                                    style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w400, color: Colors.white),
                                  ))
                              : isVerified == 'null'
                                  ? _isProfleVarifecation
                                      ? AllService.LoadingToast()
                                      : ElevatedButton(
                                          onPressed: () async {
                                            final connectivityResult = await (Connectivity().checkConnectivity());
                                            if (connectivityResult == ConnectivityResult.mobile ||
                                                connectivityResult == ConnectivityResult.wifi ||
                                                connectivityResult == ConnectivityResult.ethernet) {
                                              setState(() {
                                                _isProfleVarifecation = true;
                                              });
                                              Map resendtoken = await Repositores().ResendVarification();
                                              if (resendtoken['status'] == true) {
                                                Navigator.pushNamed(context, VerificationPage.pageName);
                                                setState(() {
                                                  _isProfleVarifecation = false;
                                                });
                                              } else {
                                                await QuickAlert.show(
                                                  context: context,
                                                  type: QuickAlertType.error,
                                                  text: resendtoken['message'],
                                                );
                                                setState(() {
                                                  _isProfleVarifecation = false;
                                                });
                                              }
                                            } else {
                                              print("internet off");
                                              showDialogBox();
                                            }
                                            // print(g_token);
                                          },
                                          style: ElevatedButton.styleFrom(minimumSize: Size(85.w, 35.h), backgroundColor: Colors.grey[600]),
                                          child: Text(
                                            "Verify Profile",
                                            style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w400, color: Colors.white),
                                          ))
                                  : userStatus == 'True'
                                      ? ElevatedButton(
                                          onPressed: () async {
                                            final connectivityResult = await (Connectivity().checkConnectivity());
                                            if (connectivityResult == ConnectivityResult.mobile ||
                                                connectivityResult == ConnectivityResult.wifi ||
                                                connectivityResult == ConnectivityResult.ethernet) {
                                              Navigator.pushNamed(context, ProfilePage.pageName);
                                            } else {
                                              showDialogBox();
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: Size(85.w, 35.h),
                                            backgroundColor: Color(0xFF2C987F),
                                          ),
                                          child: Text(
                                            "View Profile",
                                            style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w400, color: Colors.white),
                                          ))
                                      : ElevatedButton(
                                          onPressed: () async {
                                            final connectivityResult = await (Connectivity().checkConnectivity());
                                            if (connectivityResult == ConnectivityResult.mobile ||
                                                connectivityResult == ConnectivityResult.wifi ||
                                                connectivityResult == ConnectivityResult.ethernet) {
                                              await Navigator.pushNamed(context, SignInPage.pageName);
                                            } else {
                                              showDialogBox();
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: Size(85.w, 35.h),
                                            backgroundColor: Color(0xFF2C987F),
                                          ),
                                          child: Text(
                                            "Sign in/Sign Up",
                                            style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w400, color: Colors.white),
                                          ))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // ElevatedButton(
              //     onPressed: () {
              //       print(userStatus);
              //     },
              //     child: Text("data")),
              GestureDetector(
                onTap: () async {
                  final connectivityResult = await (Connectivity().checkConnectivity());
                  if (connectivityResult == ConnectivityResult.mobile ||
                      connectivityResult == ConnectivityResult.wifi ||
                      connectivityResult == ConnectivityResult.ethernet) {
                    Navigator.of(context).pushNamed(leaderboardPage.pageName);
                  } else {
                    showDialogBox();
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 60.h,
                      width: MediaQuery.of(context).size.width / 1.6,
                      child: Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(right: 10.w, left: 10.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: EdgeInsets.all(3.h),
                                  child: Container(
                                    height: 35.h,
                                    width: 30.w,
                                    decoration: BoxDecoration(color: Color.fromARGB(255, 213, 231, 227), borderRadius: BorderRadius.circular(16.r)),
                                    child: SvgPicture.asset(
                                      "assets/icon/leaderboard 1.svg",

                                      // height: 40,
                                      // width: 40,
                                      fit: BoxFit.scaleDown,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Expanded(
                                flex: 5,
                                child: Text(
                                  "Leaderboard",
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: IconButton(
                                    onPressed: () async {
                                      final connectivityResult = await (Connectivity().checkConnectivity());
                                      if (connectivityResult == ConnectivityResult.mobile ||
                                          connectivityResult == ConnectivityResult.wifi ||
                                          connectivityResult == ConnectivityResult.ethernet) {
                                        Navigator.of(context).pushNamed(leaderboardPage.pageName);
                                      } else {
                                        showDialogBox();
                                      }

                                      //await SqliteService().quizdataInsert("88", "77");
                                      // await SqliteService().deleteQuizData();
                                      // print(await SqliteService().getQuizData());
                                      //  Navigator.pushNamed(context, PostListPage.pageName);
                                    },
                                    icon: SvgPicture.asset(
                                      "assets/icon/Vector (1).svg",
                                      fit: BoxFit.contain,
                                      height: 10,
                                      width: 3.5,
                                      // fit: BoxFit.scaleDown,
                                    )),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 3,
              ),
              GestureDetector(
                onTap: () async {
                  final connectivityResult = await (Connectivity().checkConnectivity());
                  if (connectivityResult == ConnectivityResult.mobile ||
                      connectivityResult == ConnectivityResult.wifi ||
                      connectivityResult == ConnectivityResult.ethernet) {
                    final Uri _url = Uri.parse('https://quizva.com/app/how-to-use');
                    if (!await launchUrl(_url)) {
                      throw Exception('Could not launch $_url');
                    }
                  } else {
                    showDialogBox();
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 60.h,
                      width: MediaQuery.of(context).size.width / 1.6,
                      child: Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(right: 10.w, left: 10.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: EdgeInsets.all(3.0.h),
                                  child: Container(
                                    height: 35.h,
                                    width: 30.w,
                                    decoration: BoxDecoration(color: Color.fromARGB(255, 213, 231, 227), borderRadius: BorderRadius.circular(16.r)),
                                    child: SvgPicture.asset(
                                      "assets/icon/FAQ Circle.svg",

                                      // height: 40,
                                      // width: 40,
                                      fit: BoxFit.scaleDown,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Expanded(
                                flex: 5,
                                child: Text(
                                  "How to use",
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: IconButton(
                                    onPressed: () async {
                                      final connectivityResult = await (Connectivity().checkConnectivity());
                                      if (connectivityResult == ConnectivityResult.mobile ||
                                          connectivityResult == ConnectivityResult.wifi ||
                                          connectivityResult == ConnectivityResult.ethernet) {
                                        final Uri _url = Uri.parse('https://quizva.com/app/how-to-use');
                                        if (!await launchUrl(_url)) {
                                          throw Exception('Could not launch $_url');
                                        }
                                      } else {
                                        showDialogBox();
                                      }
                                      // List b = await SqliteService().getUserLog();
                                      // print("object");
                                      // print(b[0]['userStatus'].toString());
                                      //String? a = await SqliteService().userlogUpdate('False');
                                      // String? a = await SqliteService().userlogInsert('True');

                                      //print(widget.Userinfo);
                                    },
                                    icon: SvgPicture.asset(
                                      "assets/icon/Vector (1).svg",
                                      fit: BoxFit.contain,
                                      height: 10,
                                      width: 3.5,
                                      // fit: BoxFit.scaleDown,
                                    )),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 3,
              ),
              GestureDetector(
                onTap: () async {
                  final connectivityResult = await (Connectivity().checkConnectivity());
                  if (connectivityResult == ConnectivityResult.mobile ||
                      connectivityResult == ConnectivityResult.wifi ||
                      connectivityResult == ConnectivityResult.ethernet) {
                    final Uri _url = Uri.parse('https://quizva.com/about-us');
                    if (!await launchUrl(_url)) {
                      throw Exception('Could not launch $_url');
                    }
                  } else {
                    showDialogBox();
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 60.h,
                      width: MediaQuery.of(context).size.width / 1.6,
                      child: Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(right: 10.w, left: 10.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: EdgeInsets.all(3.0.h),
                                  child: Container(
                                    height: 35.h,
                                    width: 30.w,
                                    decoration: BoxDecoration(color: Color.fromARGB(255, 213, 231, 227), borderRadius: BorderRadius.circular(16.r)),
                                    child: SvgPicture.asset(
                                      "assets/icon/Information Circle.svg",

                                      // height: 40,
                                      // width: 40,
                                      fit: BoxFit.scaleDown,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Expanded(
                                flex: 5,
                                child: Text(
                                  "About",
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: IconButton(
                                    onPressed: () async {
                                      final connectivityResult = await (Connectivity().checkConnectivity());
                                      if (connectivityResult == ConnectivityResult.mobile ||
                                          connectivityResult == ConnectivityResult.wifi ||
                                          connectivityResult == ConnectivityResult.ethernet) {
                                        final Uri _url = Uri.parse('https://quizva.com/about-us');
                                        if (!await launchUrl(_url)) {
                                          throw Exception('Could not launch $_url');
                                        }
                                      } else {
                                        showDialogBox();
                                      }
                                    },
                                    icon: SvgPicture.asset(
                                      "assets/icon/Vector (1).svg",
                                      fit: BoxFit.contain,
                                      height: 10,
                                      width: 3.5,
                                      // fit: BoxFit.scaleDown,
                                    )),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 3,
              ),
              GestureDetector(
                onTap: () async {
                  final connectivityResult = await (Connectivity().checkConnectivity());
                  if (connectivityResult == ConnectivityResult.mobile ||
                      connectivityResult == ConnectivityResult.wifi ||
                      connectivityResult == ConnectivityResult.ethernet) {
                    final Uri _url = Uri.parse('https://quizva.com/contact');
                    if (!await launchUrl(_url)) {
                      throw Exception('Could not launch $_url');
                    }
                  } else {
                    showDialogBox();
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 60.h,
                      width: MediaQuery.of(context).size.width / 1.6,
                      child: Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(right: 10.w, left: 10.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: EdgeInsets.all(3.h),
                                  child: Container(
                                    height: 35.h,
                                    width: 30.w,
                                    decoration: BoxDecoration(color: Color.fromARGB(255, 213, 231, 227), borderRadius: BorderRadius.circular(16.r)),
                                    child: SvgPicture.asset(
                                      "assets/icon/Group 902.svg",

                                      // height: 40,
                                      // width: 40,
                                      fit: BoxFit.scaleDown,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Expanded(
                                flex: 5,
                                child: Text(
                                  "Contact",
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 2,
                                  child: IconButton(
                                      onPressed: () async {
                                        final connectivityResult = await (Connectivity().checkConnectivity());
                                        if (connectivityResult == ConnectivityResult.mobile ||
                                            connectivityResult == ConnectivityResult.wifi ||
                                            connectivityResult == ConnectivityResult.ethernet) {
                                          final Uri _url = Uri.parse('https://quizva.com/contact');
                                          if (!await launchUrl(_url)) {
                                            throw Exception('Could not launch $_url');
                                          }
                                        } else {
                                          showDialogBox();
                                        }
                                      },
                                      icon: SvgPicture.asset(
                                        "assets/icon/Vector (1).svg",
                                        fit: BoxFit.contain,
                                        height: 10,
                                        width: 3.5,
                                        // fit: BoxFit.scaleDown,
                                      )))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 3,
              ),
              _isLoadingsignIn
                  ? AllService.LoadingToast()
                  : userStatus == 'True'
                      ? Container()
                      : GestureDetector(
                          onTap: () async {
                            final connectivityResult = await (Connectivity().checkConnectivity());
                            if (connectivityResult == ConnectivityResult.mobile ||
                                connectivityResult == ConnectivityResult.wifi ||
                                connectivityResult == ConnectivityResult.ethernet) {
                              setState(() {
                                _isLoadingsignIn = true;
                              });
                              Navigator.pushNamed(context, SignInPage.pageName);
                              setState(() {
                                _isLoadingsignIn = false;
                              });
                            } else {
                              showDialogBox();
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 60.h,
                                width: MediaQuery.of(context).size.width / 1.6,
                                child: Card(
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10.w, left: 10.w),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding: EdgeInsets.all(3.h),
                                            child: Container(
                                              height: 35.h,
                                              width: 30.w,
                                              decoration:
                                                  BoxDecoration(color: Color.fromARGB(255, 213, 231, 227), borderRadius: BorderRadius.circular(16.r)),
                                              child: SvgPicture.asset(
                                                "assets/icon/Group 901.svg",

                                                // height: 40,
                                                // width: 40,
                                                fit: BoxFit.scaleDown,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Text(
                                            "Sign In",
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        _isLoadingsignIn
                                            ? AllService.LoadingToast()
                                            : Expanded(
                                                flex: 2,
                                                child: IconButton(
                                                    onPressed: () async {
                                                      final connectivityResult = await (Connectivity().checkConnectivity());
                                                      if (connectivityResult == ConnectivityResult.mobile ||
                                                          connectivityResult == ConnectivityResult.wifi ||
                                                          connectivityResult == ConnectivityResult.ethernet) {
                                                        setState(() {
                                                          _isLoadingsignIn = true;
                                                        });
                                                        Navigator.pushNamed(context, SignInPage.pageName);
                                                        setState(() {
                                                          _isLoadingsignIn = false;
                                                        });
                                                      } else {
                                                        showDialogBox();
                                                      }
                                                    },
                                                    icon: SvgPicture.asset(
                                                      "assets/icon/Vector (1).svg",
                                                      fit: BoxFit.contain,
                                                      height: 10,
                                                      width: 3.5,
                                                      // fit: BoxFit.scaleDown,
                                                    )),
                                              )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
              SizedBox(
                height: 3,
              ),
              userStatus == 'True'
                  ? GestureDetector(
                      onTap: () async {
                        try {
                          // setState(() {
                          //   _isLoadingLogout = true;
                          // });
                          List b = await SqliteService().getUserLog();
                          if (b.isNotEmpty) {
                            await SqliteService().deleteUserData();
                            String? a = await SqliteService().userlogUpdate('False');
                            g_token = "";
                            print(g_token);
                            setState(() {});
                          }
                          await Navigator.of(context)
                              .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage()), (Route<dynamic> route) => false);

                          // setState(() {
                          //   _isLoadingLogout = false;
                          // });
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 60.h,
                            width: MediaQuery.of(context).size.width / 1.6,
                            child: Card(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(right: 10.w, left: 10.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: EdgeInsets.all(3.h),
                                        child: Container(
                                          height: 35.h,
                                          width: 30.w,
                                          decoration:
                                              BoxDecoration(color: Color.fromARGB(255, 213, 231, 227), borderRadius: BorderRadius.circular(16.r)),
                                          child: SvgPicture.asset(
                                            "assets/icon/Group 900.svg",

                                            // height: 40,
                                            // width: 40,
                                            fit: BoxFit.scaleDown,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Text(
                                        "Logout",
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: IconButton(
                                          onPressed: () async {
                                            try {
                                              // setState(() {
                                              //   _isLoadingLogout = true;
                                              // });
                                              List b = await SqliteService().getUserLog();
                                              if (b.isNotEmpty) {
                                                await SqliteService().deleteUserData();
                                                String? a = await SqliteService().userlogUpdate('False');
                                                g_token = "";
                                                print(g_token);
                                                setState(() {});
                                              }
                                              await Navigator.of(context).pushAndRemoveUntil(
                                                  MaterialPageRoute(builder: (context) => HomePage()), (Route<dynamic> route) => false);
                                              // setState(() {
                                              //   _isLoadingLogout = false;
                                              // });
                                            } catch (e) {
                                              print(e);
                                            }
                                          },
                                          icon: SvgPicture.asset(
                                            "assets/icon/Vector (1).svg",
                                            fit: BoxFit.contain,
                                            height: 10,
                                            width: 3.5,
                                            // fit: BoxFit.scaleDown,
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : GestureDetector(
                      onTap: () async {
                        final connectivityResult = await (Connectivity().checkConnectivity());
                        if (connectivityResult == ConnectivityResult.mobile ||
                            connectivityResult == ConnectivityResult.wifi ||
                            connectivityResult == ConnectivityResult.ethernet) {
                          try {
                            Navigator.pushNamed(
                              context,
                              SignUpPage.pageName,
                            );
                          } catch (e) {
                            print(e);
                          }
                        } else {
                          showDialogBox();
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 60.h,
                            width: MediaQuery.of(context).size.width / 1.6,
                            child: Card(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(right: 10.w, left: 10.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: EdgeInsets.all(3.h),
                                        child: Container(
                                          height: 35.h,
                                          width: 30.w,
                                          decoration:
                                              BoxDecoration(color: Color.fromARGB(255, 213, 231, 227), borderRadius: BorderRadius.circular(16.r)),
                                          child: SvgPicture.asset(
                                            "assets/icon/Group 900.svg",

                                            // height: 40,
                                            // width: 40,
                                            fit: BoxFit.scaleDown,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Text(
                                        "Sign Up",
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: IconButton(
                                          onPressed: () async {
                                            final connectivityResult = await (Connectivity().checkConnectivity());
                                            if (connectivityResult == ConnectivityResult.mobile ||
                                                connectivityResult == ConnectivityResult.wifi ||
                                                connectivityResult == ConnectivityResult.ethernet) {
                                              try {
                                                ;
                                                Navigator.pushNamed(
                                                  context,
                                                  SignUpPage.pageName,
                                                );
                                              } catch (e) {
                                                print(e);
                                              }
                                            } else {
                                              showDialogBox();
                                            }
                                          },
                                          icon: SvgPicture.asset(
                                            "assets/icon/Vector (1).svg",
                                            fit: BoxFit.contain,
                                            height: 10,
                                            width: 3.5,
                                            // fit: BoxFit.scaleDown,
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              SizedBox(
                height: 50.h,
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
