import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:quiz/custom_widget/button.dart';
import 'package:quiz/pages/credentials/reset_password_success.dart';
import 'package:quiz/services/all_services/all_services.dart';

class ForgetPasswordVerificationPage extends StatefulWidget {
  static const pageName = 'ForgetPasswordVerificationPage';
  const ForgetPasswordVerificationPage({super.key});

  @override
  State<ForgetPasswordVerificationPage> createState() => _ForgetPasswordVerificationPageState();
}

class _ForgetPasswordVerificationPageState extends State<ForgetPasswordVerificationPage> {
  String code = '';
  @override
  Widget build(BuildContext context) {
    Map? email = ModalRoute.of(context)!.settings.arguments as Map;

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
                  print(" AAAAA$pin");
                  code = pin;

                  //Navigator.pushNamed(context, ResetPassowrdSuccess.pageName);
                  // Map otp = await Repositores().OtpVarificationSubmit(pin);
                  // if (otp['status'] == true) {
                  //   await Toast.success(context: context, text: "Account Varifation Success");
                  //   Navigator.pushNamed(context, SignInPage.pageName);
                  // }
                  // print("Completed: " + pin);
                },
              ),
              SizedBox(
                height: 80.h,
              ),
              ButtonWidget(
                height: 45.h,
                color: Color(0xFF078669),
                onPressed: () async {
                  print("uuuuuuuuuuuuuuuuuuuuuuuuuu");
                  print(code);
                  if (code.isNotEmpty) {
                    Map data = {"email": email['email'], "code": code};
                    Navigator.pushNamed(context, ResetPassowrdSuccess.pageName, arguments: data);
                  } else {
                    await Toast.warning(context: context, text: "Please input your Code");
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
    );
  }
}
