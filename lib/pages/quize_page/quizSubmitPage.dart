import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quiz/pages/home_page.dart';
import 'package:shimmer/shimmer.dart';

class QuizSubmitPage extends StatefulWidget {
  static const pageName = 'QuizSubmit';
  const QuizSubmitPage({
    super.key,
  });
  @override
  State<QuizSubmitPage> createState() => _QuizSubmitPageState();
}

class _QuizSubmitPageState extends State<QuizSubmitPage> {
  List quizData = [];
  String? id;
  String? ans;
  Map quizAll = {};

  @override
  Widget build(BuildContext context) {
    Map quizsubmit = ModalRoute.of(context)!.settings.arguments as Map;
    quizData = quizsubmit['data']["quiz"]['questions'];
    log('data: $quizData');
    quizAll = quizsubmit['data'];

    return WillPopScope(
      onWillPop: () async {
        await Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage()), (Route<dynamic> route) => false);
        return false;
      },
      child: Scaffold(
          body: SingleChildScrollView(
        child: quizData.isEmpty
            ? Column(
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Center(
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[700]!,
                      highlightColor: Colors.grey[100]!,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          radius: 30.0,
                        ),
                        title: Text('Loading....', style: TextStyle(fontSize: 18.0)),
                        subtitle: Text('Question', style: TextStyle(fontSize: 14.0)),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  SizedBox(
                    height: 30.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.h, bottom: 5.h, left: 15),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(
                              top: 5.0.h,
                              right: 3.0.w,
                              left: 3.0.w,
                            ),
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
                        Expanded(
                          flex: 1,
                          child: SizedBox.shrink(),
                        ),
                        Expanded(
                          flex: 5,
                          child: Text(
                            "Quiz Submit Result",
                            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500, color: Colors.black),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 600.h,
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 10),
                      itemCount: quizData.length,
                      itemBuilder: (context, index) {
                        // bool correctAnswerA = quizData[index]['options'][0]['correct_ans'] == 1;
                        // bool correctAnswer_A_red = quizData[index]['options'][0]['user_input'] == true && !correctAnswerA;

                        // bool correctAnswerB = quizData[index]['options'][1]['correct_ans'] == 1;
                        // bool correctAnswer_B_red = quizData[index]['options'][1]['user_input'] == true && !correctAnswerB;

                        // bool correctAnswerC = quizData[0]['options'][2]['correct_ans'] == 1;
                        // print("daaaaaaaaaaaaaaaaa");
                        // print(quizData[0]['options'][2]['user_input']);
                        // bool correctAnswer_C_red = quizData[0]['options'][2]['user_input'] == true && quizData[0]['options'][2]['correct_ans'] == 0;
                        // print("fuckkkkkkkkkk");
                        // print(correctAnswerC);
                        // print(correctAnswer_C_red);
                        // bool correctAnswerD = quizData[index]['options'][3]['correct_ans'] == 1;
                        // bool correctAnswer_D_red = quizData[index]['options'][3]['user_input'] == true && !correctAnswerD;

                        return Column(
                          children: [
                            Stack(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 1.w, right: 1.w),
                                  child: Image.asset(
                                    "assets/images/Ellipse 63.png",
                                    height: 320.h,
                                    width: double.infinity,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Column(
                                  children: [
                                    SizedBox(
                                      height: 110.h,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 60.w, right: 40.w),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            width: 85.w,
                                          ),
                                          Container(
                                            height: 28.h,
                                            width: 58.w,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF078669),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(12.r),
                                                topRight: Radius.circular(12.r),
                                                bottomLeft: Radius.circular(12.r),
                                                bottomRight: Radius.circular(12.r),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                '20',
                                                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400, color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Center(
                                            child: Text(
                                              '${quizData[index]['title']}',
                                              //"The term PHP is an acronym \n  for PHP:----------.",
                                              style: TextStyle(
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFFFFFFFF),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Positioned(
                                    top: 285.h,
                                    left: 160.w,
                                    child: Container(
                                      height: 58.h,
                                      width: 56.w,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20.r),
                                          topRight: Radius.circular(20.r),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Q: ${index + 1}",
                                          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500, color: Color(0xFF078669)),
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            ...List.generate(quizData[index]["options"].length, (optionsIndex) {
                              print("afikkkkkkkkkkkkkkkkkkkkkkkk");
                              var currentChar = String.fromCharCode('A'.codeUnitAt(0) + optionsIndex as int);

                              print(quizData[index]["options"][optionsIndex]['title']);
                              return Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          spreadRadius: 2,
                                          blurRadius: 4,
                                          offset: Offset(0, 1),
                                        ),
                                      ],
                                      color: Color(0xFFFFFFFF),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20.r),
                                        topRight: Radius.circular(20.r),
                                        bottomLeft: Radius.circular(20.r),
                                        bottomRight: Radius.circular(20.r),
                                      ),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        // selectedButton[0] = true;
                                        // selectedButton[1] = false;
                                        // selectedButton[2] = false;
                                        // selectedButton[3] = false;
                                        // print(selectedButton);
                                        // id = quizData[currentQuestionIndex]["options"][0]["id"].toString();
                                        // ans = quizData[currentQuestionIndex]['id'].toString();
                                        // setState(() {});
                                      },
                                      child: Container(
                                        width: 325.w,
                                        height: 46.h,
                                        decoration: BoxDecoration(
                                          color: quizData[index]['options'][optionsIndex]['correct_ans'] == 1
                                              ? Color(0xFF078669)
                                              : quizData[index]['options'][optionsIndex]['user_input'] == true &&
                                                      quizData[index]['options'][optionsIndex]['correct_ans'] == 0
                                                  ? Colors.red
                                                  : Colors.white,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20.r),
                                              topRight: Radius.circular(20.r),
                                              bottomLeft: Radius.circular(20.r),
                                              bottomRight: Radius.circular(20.r)),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Padding(
                                                padding: EdgeInsets.only(left: 3.w),
                                                child: Container(
                                                  height: 38.h,
                                                  width: 38.w,
                                                  decoration: BoxDecoration(
                                                    color: quizData[index]['options'][optionsIndex]['correct_ans'] == 1
                                                        ? Color.fromARGB(255, 4, 117, 91)
                                                        : Colors.white,
                                                    borderRadius: BorderRadius.circular(40.r),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      currentChar,
                                                      style: TextStyle(
                                                          fontSize: 15.sp,
                                                          fontWeight: FontWeight.w500,
                                                          color: quizData[index]['options'][optionsIndex]['correct_ans'] == 1
                                                              ? Colors.white
                                                              : Color(0xFF078669)),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                            Expanded(
                                              flex: 11,
                                              child: Text(
                                                "${quizData[index]["options"][optionsIndex]["title"]}",
                                                style: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: quizData[index]['options'][optionsIndex]['correct_ans'] == 1
                                                        ? Colors.white
                                                        : quizData[index]['options'][optionsIndex]['user_input'] == true &&
                                                                quizData[index]['options'][optionsIndex]['correct_ans'] == 0
                                                            ? Colors.white
                                                            : Color(0xFF6A737C)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              );
                            }),
                            // Container(
                            //   child: Column(
                            //     children: [
                            //       Container(
                            //         decoration: BoxDecoration(
                            //           boxShadow: [
                            //             BoxShadow(
                            //               color: Colors.grey.withOpacity(0.3),
                            //               spreadRadius: 2,
                            //               blurRadius: 4,
                            //               offset: Offset(0, 1),
                            //             ),
                            //           ],
                            //           color: Color(0xFFFFFFFF),
                            //           borderRadius: BorderRadius.only(
                            //             topLeft: Radius.circular(20.r),
                            //             topRight: Radius.circular(20.r),
                            //             bottomLeft: Radius.circular(20.r),
                            //             bottomRight: Radius.circular(20.r),
                            //           ),
                            //         ),
                            //         child: GestureDetector(
                            //           onTap: () {
                            //             // selectedButton[0] = true;
                            //             // selectedButton[1] = false;
                            //             // selectedButton[2] = false;
                            //             // selectedButton[3] = false;
                            //             // print(selectedButton);
                            //             // id = quizData[currentQuestionIndex]["options"][0]["id"].toString();
                            //             // ans = quizData[currentQuestionIndex]['id'].toString();
                            //             // setState(() {});
                            //           },
                            //           child: Container(
                            //             width: 325.w,
                            //             height: 46.h,
                            //             decoration: BoxDecoration(
                            //               color: quizData[index]['options'][0]['correct_ans'] == 1
                            //                   ? Color(0xFF078669)
                            //                   : quizData[index]['options'][0]['user_input'] == true &&
                            //                           quizData[index]['options'][0]['correct_ans'] == 0
                            //                       ? Colors.red
                            //                       : Colors.white,
                            //               borderRadius: BorderRadius.only(
                            //                   topLeft: Radius.circular(20.r),
                            //                   topRight: Radius.circular(20.r),
                            //                   bottomLeft: Radius.circular(20.r),
                            //                   bottomRight: Radius.circular(20.r)),
                            //             ),
                            //             child: Row(
                            //               children: [
                            //                 Expanded(
                            //                   flex: 2,
                            //                   child: Padding(
                            //                     padding: EdgeInsets.only(left: 3.w),
                            //                     child: Container(
                            //                       height: 38.h,
                            //                       width: 38.w,
                            //                       decoration: BoxDecoration(
                            //                         color: quizData[index]['options'][0]['correct_ans'] == 1
                            //                             ? Color.fromARGB(255, 4, 117, 91)
                            //                             : Colors.white,
                            //                         borderRadius: BorderRadius.circular(40.r),
                            //                       ),
                            //                       child: Center(
                            //                         child: Text(
                            //                           "a",
                            //                           style: TextStyle(
                            //                               fontSize: 15.sp,
                            //                               fontWeight: FontWeight.w500,
                            //                               color:
                            //                                   quizData[index]['options'][0]['correct_ans'] == 1 ? Colors.white : Color(0xFF078669)),
                            //                         ),
                            //                       ),
                            //                     ),
                            //                   ),
                            //                 ),
                            //                 SizedBox(
                            //                   width: 10.w,
                            //                 ),
                            //                 Expanded(
                            //                   flex: 11,
                            //                   child: Text(
                            //                     "${quizData[index]["options"][0]["title"]}",
                            //                     style: TextStyle(
                            //                         fontSize: 12.sp,
                            //                         fontWeight: FontWeight.w400,
                            //                         color: quizData[index]['options'][0]['correct_ans'] == 1
                            //                             ? Colors.white
                            //                             : quizData[index]['options'][0]['user_input'] == true &&
                            //                                     quizData[index]['options'][0]['correct_ans'] == 0
                            //                                 ? Colors.white
                            //                                 : Color(0xFF6A737C)),
                            //                   ),
                            //                 ),
                            //               ],
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //       SizedBox(
                            //         height: 20.h,
                            //       ),
                            //       Container(
                            //         decoration: BoxDecoration(
                            //           boxShadow: [
                            //             BoxShadow(
                            //               color: Colors.grey.withOpacity(0.3),
                            //               spreadRadius: 2,
                            //               blurRadius: 4,
                            //               offset: Offset(0, 1), // changes position of shadow
                            //             ),
                            //           ],
                            //           color: Color(0xFFFFFFFF),
                            //           borderRadius: BorderRadius.only(
                            //             topLeft: Radius.circular(20.r),
                            //             topRight: Radius.circular(20.r),
                            //             bottomLeft: Radius.circular(20.r),
                            //             bottomRight: Radius.circular(20.r),
                            //           ),
                            //         ),
                            //         child: GestureDetector(
                            //           onTap: () {
                            //             // setState(() {
                            //             //   selectedButton[1] = !selectedButton[1];

                            //             //   selectedButton[0] = false;
                            //             //   selectedButton[2] = false;
                            //             //   selectedButton[3] = false;
                            //             //   print(selectedButton);
                            //             // });
                            //             // id = quizData[currentQuestionIndex]["options"][1]["id"].toString();
                            //             // ans = quizData[currentQuestionIndex]['id'].toString();
                            //           },
                            //           child: Container(
                            //             width: 325.w,
                            //             height: 46.h,
                            //             decoration: BoxDecoration(
                            //               color: quizData[index]['options'][1]['correct_ans'] == 1
                            //                   ? Color(0xFF078669)
                            //                   : quizData[index]['options'][1]['user_input'] == true &&
                            //                           quizData[index]['options'][1]['correct_ans'] == 0
                            //                       ? Colors.red
                            //                       : Colors.white,
                            //               borderRadius: BorderRadius.only(
                            //                   topLeft: Radius.circular(20.r),
                            //                   topRight: Radius.circular(20.r),
                            //                   bottomLeft: Radius.circular(20.r),
                            //                   bottomRight: Radius.circular(20.r)),
                            //             ),
                            //             child: Row(
                            //               children: [
                            //                 Expanded(
                            //                   flex: 2,
                            //                   child: Padding(
                            //                     padding: EdgeInsets.only(left: 3.w),
                            //                     child: Container(
                            //                       height: 38.h,
                            //                       width: 38.w,
                            //                       decoration: BoxDecoration(
                            //                         color: quizData[index]["options"][1]["correct_ans"] == 1
                            //                             ? Color.fromARGB(255, 4, 117, 91)
                            //                             : Colors.white,
                            //                         borderRadius: BorderRadius.circular(40.r),
                            //                       ),
                            //                       child: Center(
                            //                         child: Text(
                            //                           "b",
                            //                           style: TextStyle(
                            //                               fontSize: 15.sp,
                            //                               fontWeight: FontWeight.w500,
                            //                               color:
                            //                                   quizData[index]["options"][1]["correct_ans"] == 1 ? Colors.white : Color(0xFF078669)),
                            //                         ),
                            //                       ),
                            //                     ),
                            //                   ),
                            //                 ),
                            //                 SizedBox(
                            //                   width: 10.w,
                            //                 ),
                            //                 Expanded(
                            //                   flex: 11,
                            //                   child: Text(
                            //                     "${quizData[index]["options"][1]["title"]}",
                            //                     style: TextStyle(
                            //                         fontSize: 12.sp,
                            //                         fontWeight: FontWeight.w400,
                            //                         color: quizData[index]["options"][1]["correct_ans"] == 1
                            //                             ? Colors.white
                            //                             : quizData[index]['options'][1]['user_input'] == true &&
                            //                                     quizData[index]['options'][1]['correct_ans'] == 0
                            //                                 ? Colors.white
                            //                                 : Color(0xFF6A737C)),
                            //                   ),
                            //                 ),
                            //               ],
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //       SizedBox(
                            //         height: 20.h,
                            //       ),
                            //       Container(
                            //         decoration: BoxDecoration(
                            //           boxShadow: [
                            //             BoxShadow(
                            //               color: Colors.grey.withOpacity(0.3),
                            //               spreadRadius: 2,
                            //               blurRadius: 4,
                            //               offset: Offset(0, 1), // changes position of shadow
                            //             ),
                            //           ],
                            //           color: Color(0xFFFFFFFF),
                            //           borderRadius: BorderRadius.only(
                            //             topLeft: Radius.circular(20.r),
                            //             topRight: Radius.circular(20.r),
                            //             bottomLeft: Radius.circular(20.r),
                            //             bottomRight: Radius.circular(20.r),
                            //           ),
                            //         ),
                            //         child: GestureDetector(
                            //           onTap: () {
                            //             setState(() {});
                            //             // selectedButton[2] = !selectedButton[2];

                            //             // selectedButton[0] = false;
                            //             // selectedButton[1] = false;
                            //             // selectedButton[3] = false;
                            //             // id = quizData[currentQuestionIndex]["options"][2]["id"].toString();
                            //             // ans = quizData[currentQuestionIndex]['id'].toString();
                            //           },
                            //           child: Container(
                            //             width: 325.w,
                            //             height: 46.h,
                            //             decoration: BoxDecoration(
                            //               //color: Color(0xFF078669),
                            //               color: quizData[index]['options'][2]['correct_ans'] == 1
                            //                   ? Color(0xFF078669)
                            //                   : quizData[index]['options'][2]['user_input'] == true &&
                            //                           quizData[index]['options'][2]['correct_ans'] == 0
                            //                       ? Colors.red
                            //                       : Colors.white,
                            //               borderRadius: BorderRadius.only(
                            //                   topLeft: Radius.circular(20.r),
                            //                   topRight: Radius.circular(20.r),
                            //                   bottomLeft: Radius.circular(20.r),
                            //                   bottomRight: Radius.circular(20.r)),
                            //             ),
                            //             child: Row(
                            //               children: [
                            //                 Expanded(
                            //                   flex: 2,
                            //                   child: Padding(
                            //                     padding: EdgeInsets.only(left: 3.w),
                            //                     child: Container(
                            //                       height: 40.h,
                            //                       width: 40.w,
                            //                       decoration: BoxDecoration(
                            //                         color: quizData[index]["options"][2]["correct_ans"] == 1
                            //                             ? Color.fromARGB(255, 4, 117, 91)
                            //                             : Colors.white,
                            //                         borderRadius: BorderRadius.circular(40.r),
                            //                       ),
                            //                       child: Center(
                            //                         child: Text(
                            //                           "c",
                            //                           style: TextStyle(
                            //                               fontSize: 15.sp,
                            //                               fontWeight: FontWeight.w500,
                            //                               color:
                            //                                   quizData[index]["options"][2]["correct_ans"] == 1 ? Colors.white : Color(0xFF078669)),
                            //                         ),
                            //                       ),
                            //                     ),
                            //                   ),
                            //                 ),
                            //                 SizedBox(
                            //                   width: 10.w,
                            //                 ),
                            //                 Expanded(
                            //                   flex: 11,
                            //                   child: Text(
                            //                     "${quizData[index]["options"][2]["title"]}",
                            //                     style: TextStyle(
                            //                         fontSize: 12.sp,
                            //                         fontWeight: FontWeight.w400,
                            //                         color: quizData[index]["options"][2]["correct_ans"] == 1
                            //                             ? Colors.white
                            //                             : quizData[index]['options'][2]['user_input'] == true &&
                            //                                     quizData[index]['options'][2]['correct_ans'] == 0
                            //                                 ? Colors.white
                            //                                 : Color(0xFF6A737C)),
                            //                   ),
                            //                 ),
                            //               ],
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //       SizedBox(
                            //         height: 20.h,
                            //       ),
                            //       Container(
                            //         decoration: BoxDecoration(
                            //           boxShadow: [
                            //             BoxShadow(
                            //               color: Colors.grey.withOpacity(0.3),
                            //               spreadRadius: 2,
                            //               blurRadius: 4,
                            //               offset: Offset(0, 1), // changes position of shadow
                            //             ),
                            //           ],
                            //           color: Color(0xFFFFFFFF),
                            //           borderRadius: BorderRadius.only(
                            //             topLeft: Radius.circular(20.r),
                            //             topRight: Radius.circular(20.r),
                            //             bottomLeft: Radius.circular(20.r),
                            //             bottomRight: Radius.circular(20.r),
                            //           ),
                            //         ),
                            //         child: GestureDetector(
                            //           onTap: () {
                            //             // selectedButton[3] = !selectedButton[3];

                            //             // selectedButton[0] = false;
                            //             // selectedButton[1] = false;
                            //             // selectedButton[2] = false;
                            //             // id = quizData[currentQuestionIndex]["options"][3]["id"].toString();
                            //             // ans = quizData[currentQuestionIndex]['id'].toString();

                            //             // setState(() {});
                            //           },
                            //           child: Container(
                            //             width: 325.w,
                            //             height: 46.h,
                            //             decoration: BoxDecoration(
                            //               color: quizData[index]['options'][3]['correct_ans'] == 1
                            //                   ? Color(0xFF078669)
                            //                   : quizData[index]['options'][3]['user_input'] == true &&
                            //                           quizData[index]['options'][3]['correct_ans'] == 0
                            //                       ? Colors.red
                            //                       : Colors.white,
                            //               borderRadius: BorderRadius.only(
                            //                   topLeft: Radius.circular(20.r),
                            //                   topRight: Radius.circular(20.r),
                            //                   bottomLeft: Radius.circular(20.r),
                            //                   bottomRight: Radius.circular(20.r)),
                            //             ),
                            //             child: Row(
                            //               children: [
                            //                 Expanded(
                            //                   flex: 2,
                            //                   child: Padding(
                            //                     padding: EdgeInsets.only(left: 3.w),
                            //                     child: Container(
                            //                       height: 38.h,
                            //                       width: 38.w,
                            //                       decoration: BoxDecoration(
                            //                         color: quizData[index]["options"][3]["correct_ans"] == 1
                            //                             ? Color.fromARGB(255, 4, 117, 91)
                            //                             : Colors.white,
                            //                         borderRadius: BorderRadius.circular(40.r),
                            //                       ),
                            //                       child: Center(
                            //                         child: Text(
                            //                           "d",
                            //                           style: TextStyle(
                            //                               fontSize: 15.sp,
                            //                               fontWeight: FontWeight.w500,
                            //                               color:
                            //                                   quizData[index]["options"][3]["correct_ans"] == 1 ? Colors.white : Color(0xFF078669)),
                            //                         ),
                            //                       ),
                            //                     ),
                            //                   ),
                            //                 ),
                            //                 SizedBox(
                            //                   width: 10.w,
                            //                 ),
                            //                 Expanded(
                            //                   flex: 11,
                            //                   child: Text(
                            //                     "${quizData[index]["options"][3]["title"]}",
                            //                     style: TextStyle(
                            //                         fontSize: 12.sp,
                            //                         fontWeight: FontWeight.w400,
                            //                         color: quizData[index]["options"][3]["correct_ans"] == 1
                            //                             ? Colors.white
                            //                             : quizData[index]['options'][3]['user_input'] == true &&
                            //                                     quizData[index]['options'][3]['correct_ans'] == 0
                            //                                 ? Colors.white
                            //                                 : Color(0xFF6A737C)),
                            //                   ),
                            //                 ),
                            //               ],
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //       SizedBox(
                            //         height: 10.w,
                            //       ),

                            //     ],
                            //   ),
                            // ),
                            SizedBox(
                              height: 20.h,
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
      )),
    );
  }
}
