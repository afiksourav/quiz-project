import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quiz/pages/home_page.dart';
import 'package:quiz/services/global.dart';
import 'package:quiz/services/repo/repositores.dart';
import 'package:quiz/services/sqflitebatabase/database_helper.dart';
import 'package:quiz/services/sqflitebatabase/database_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<bool> awaitFnc() async {
    await SqliteHelper().openSqlDatabase();
    List userinfo = await SqliteService().getUserData();
    if (userinfo.isNotEmpty) {
      g_isVerified = userinfo[0]['email_verified_at'];
      g_token = userinfo[0]['token'];
    }
    return true;
  }

  void initState() {
    super.initState();
    awaitFnc();

    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => HomePage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF1D2746),
        body: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/group2.svg",
              width: 400.w,
              fit: BoxFit.cover,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(flex: 2, child: SizedBox.shrink()),
                Expanded(
                  flex: 8,
                  child: SvgPicture.asset(
                    "assets/images/ss.svg",
                    width: 220.w,
                    height: 180.h,
                    fit: BoxFit.contain,
                  ),
                ),
                Expanded(flex: 1, child: SizedBox.shrink()),
                Expanded(
                  flex: 1,
                  child: Text(
                    "Version - v1.0.0",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ],
        ));

    //  Column(
    //   crossAxisAlignment: CrossAxisAlignment.center,
    //   children: [
    //     SvgPicture.asset(
    //       "assets/images/Group 2.svg",
    //       height: 180,
    //       // fit: BoxFit.cover,
    //     ),
    //   ],
  }
}
