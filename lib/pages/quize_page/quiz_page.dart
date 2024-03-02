import 'dart:async';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quiz/custom_widget/button.dart';
import 'package:quiz/pages/quize_page/quizSubmitPage.dart';
import 'package:quiz/services/all_services/all_services.dart';
import 'package:quiz/services/models/quiz_models.dart';
import 'package:quiz/services/repo/repositores.dart';
import 'package:quiz/services/sqflitebatabase/database_service.dart';
import 'package:shimmer/shimmer.dart';

class QuizPage extends StatefulWidget {
  final String slug;

  const QuizPage({super.key, required this.slug});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List quizData = [];
  String? id;
  String? ans;
  Map quizAll = {};
  bool _isLoading = false;
  bool isLoadingdata = true;
  QuizModel? quizModel;
  String? currentChar;
  int? selectedOption;
  List<bool> selectedButton = [];
  List options = [];
  int optionIndexTry = 0;

  Future<void> quizDetails() async {
    var Quiz = await Repositores().quizDetails(widget.slug);
    quizModel = Quiz;
    options = quizModel!.data!.questions[currentQuestionIndex].options;

    selectedButton = List.generate(options.length, (index1) => false); //
    setState(() {
      isLoadingdata = false;
    });
  }

  @override
  void initState() {
    quizDetails();
    startTimer();
    // TODO: implement initState
    super.initState();
  }

  int currentQuestionIndex = 0;

  void nextQuestion() {
    if (currentQuestionIndex < quizModel!.data!.questions.length - 1) {
      //options = quizModel!.data!.questions[currentQuestionIndex + 1].options;
      currentQuestionIndex++;
      setState(() {
        selectedButton = List.generate(
          quizModel!.data!.questions[currentQuestionIndex].options.length,
          (index1) => false,
        );
      });
    } else {
      // Quiz is completed, handle accordingly
    }
  }

  int minutes = 1;
  int seconds = 0;
  late Timer timer;
  bool isTimerRunning = false;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    timer = Timer.periodic(oneSec, (Timer t) {
      setState(() {
        if (minutes == 0 && seconds == 0) {
          t.cancel(); // Timer finished
        } else if (seconds == 0) {
          minutes--;
          seconds = 59;
        } else {
          seconds--;
        }
      });
    });
  }

  void handleStartButton() {
    startTimer();
    isTimerRunning = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: isLoadingdata
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
                              radius: 30.r,
                            ),
                            title: Text('Loading...', style: TextStyle(fontSize: 14.0.sp)),
                            subtitle: Text('Question', style: TextStyle(fontSize: 12.0.sp)),
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
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
                                          '$minutes:${seconds.toString().padLeft(2, '0')}',
                                          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Center(
                                      child: Text(
                                        '${quizModel!.data!.questions[currentQuestionIndex].title}',
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
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.7),
                                      spreadRadius: 2,
                                      blurRadius: 4,
                                      offset: Offset(0, 3), // changes position of shadow
                                    ),
                                  ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Center(
                                  child: Text(
                                    "Q: ${currentQuestionIndex + 1}",
                                    style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500, color: Color(0xFF078669)),
                                  ),
                                ),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Container(
                          child: Column(
                        children: [
                          SizedBox(
                            height: 2.h,
                          ),
                          ...List.generate(quizModel!.data!.questions[currentQuestionIndex].options.length, (optionsindex) {
                            print("titleeeeeeeeeeee");
                            optionIndexTry = optionsindex;
                            // print(selectedButton);
                            // currentChar = "a";
                            var currentChar = String.fromCharCode('A'.codeUnitAt(0) + optionsindex as int);

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
                                      for (int i = 0; i < selectedButton.length; i++) {
                                        selectedButton[i] = i == optionsindex;
                                        print(selectedButton);
                                      }

                                      print(selectedButton);
                                      setState(() {});
                                      print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
                                      id = quizModel!.data!.questions[currentQuestionIndex].id.toString();
                                      ans = quizModel!.data!.questions[currentQuestionIndex].options[optionsindex].id.toString();
                                    },
                                    child: Container(
                                      width: 325.w,
                                      height: 46.h,
                                      decoration: BoxDecoration(
                                        color: selectedButton[optionsindex] == true ? Color(0xFF078669) : Colors.white,
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
                                                  color: selectedButton[optionsindex] == true
                                                      ? Color.fromARGB(255, 4, 117, 91)
                                                      : Color.fromARGB(255, 197, 226, 219),
                                                  borderRadius: BorderRadius.circular(40.r),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    '$currentChar',
                                                    style: TextStyle(
                                                        fontSize: 15.sp,
                                                        fontWeight: FontWeight.w500,
                                                        color: selectedButton[optionsindex] == true ? Colors.white : Color(0xFF078669)),
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
                                              "${quizModel!.data!.questions[currentQuestionIndex].options[optionsindex].title}",
                                              style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: selectedButton[optionsindex] == true ? Colors.white : Color(0xFF6A737C)),
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
                          // ElevatedButton(
                          //     onPressed: () async {
                          //       //  await SqliteService().deleteQuizData();
                          //       print(await SqliteService().getQuizData());
                          //     },
                          //     child: Text("aa")),
                          currentQuestionIndex == quizModel!.data!.questions.length - 1
                              ? Container()
                              : Visibility(
                                  visible: !isTimerRunning,
                                  child: ButtonWidget(
                                    onPressed: () async {
                                      if (selectedButton.contains(true)) {
                                        print(id);
                                        print("rrrr$ans");
                                        print(selectedButton);

                                        print(ans);
                                        if (seconds > 0) {
                                          nextQuestion();
                                        }
                                        if (!isTimerRunning && minutes == 0 && seconds == 0) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(backgroundColor: Colors.red, content: Text("Time is Up")));
                                        }
                                        if (id != null && ans != null && currentQuestionIndex <= quizModel!.data!.questions.length) {
                                          print("input");

                                          await SqliteService().quizdataInsert(id.toString(), ans.toString());
                                        }
                                      } else {
                                        _showSnackBar();
                                      }
                                    },
                                    //  title: !isTimerRunning && minutes == 0 && seconds == 0 ? "Submit Your Quiz Quiz" : "Next Quesiton",
                                    title: "Next Quesiton ",
                                    color: Color(0xFF078669),
                                    height: 52.h,
                                    width: 325.w,
                                  ),
                                ),
                          Visibility(
                            visible: currentQuestionIndex == quizModel!.data!.questions.length - 1,
                            child: _isLoading
                                ? const SizedBox(
                                    width: 48,
                                    height: 48,
                                    child: CircularProgressIndicator(
                                      backgroundColor: Color(0xFF078669),
                                      strokeWidth: 6,
                                    ),
                                  )
                                : ButtonWidget(
                                    onPressed: () async {
                                      final connectivityResult = await (Connectivity().checkConnectivity());
                                      if (connectivityResult == ConnectivityResult.mobile ||
                                          connectivityResult == ConnectivityResult.wifi ||
                                          connectivityResult == ConnectivityResult.ethernet) {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        if (!isTimerRunning && minutes == 0 && seconds == 0) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(backgroundColor: Colors.red, content: Text("Time is Up")));
                                        }
                                        Map<String, dynamic> result = {};
                                        // selectedButton[0] = false;
                                        // selectedButton[1] = false;
                                        // selectedButton[2] = false;
                                        // selectedButton[3] = false;
                                        print("ID ${id}  ans ${ans}");
                                        // if (id != null && ans != null && currentQuestionIndex <= quizData.length) {
                                        if (id != null && ans != null) {
                                          await SqliteService().quizdataInsert(id.toString(), ans.toString());
                                        }

                                        List inputData = await SqliteService().getQuizData();
                                        if (inputData.isEmpty) {
                                          print("use emtpty quizzzzzzzzz");
                                          result = {"answers": []};
                                        } else {
                                          print("last input    $inputData");
                                          List<Map<String, dynamic>> outputData = [];
                                          for (var item in inputData) {
                                            Map<String, dynamic> newItem = {"id": int.parse(item["id"]), "ans": int.parse(item["ans"])};
                                            print("rafsasssssssssssssn  $newItem");
                                            outputData.add(newItem);
                                          }

                                          result = {"answers": outputData};
                                          print("abubokkkkkkkkkkkkkkkkkkor");
                                          print(result);
                                        }

                                        if (!isTimerRunning && minutes == 0 && seconds == 0) {
                                          return ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(backgroundColor: Colors.red, content: Text("Time is Up")));
                                        }

                                        Map quizSubmit = await Repositores().quizSubmit(widget.slug, result);
                                        print("ererererr ssssss $quizSubmit");
                                        if (quizSubmit['status'] == true) {
                                          print("succces");
                                          await SqliteService().deleteQuizData();
                                          setState(() {
                                            _isLoading = false;
                                          });
                                          await _showSimpleDialog(quizSubmit);
                                          // await Navigator.of(context).pushNamed(QuizSubmitPage.pageName, arguments: quizSubmit);
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        } else {
                                          await Toast.warning(context: context, text: quizSubmit['message']);
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        }
                                      } else {
                                        print("internet off");
                                        showDialogBox();
                                      }
                                    },
                                    //  title: !isTimerRunning && minutes == 0 && seconds == 0 ? "Submit Your Quiz Quiz" : "Next Quesiton",
                                    title: "Submit Answer!",
                                    color: Color(0xFF078669),
                                    height: 52.h,
                                    width: 325.w,
                                  ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          currentQuestionIndex < quizModel!.data!.questions.length - 1
                              ? SizedBox(
                                  height: 52.h,
                                  width: 325.w,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(side: BorderSide(color: Color(0xFF078669))),
                                        backgroundColor: Colors.white,
                                      ),
                                      onPressed: () {
                                        if (seconds > 0) {
                                          nextQuestion();
                                        }
                                        if (!isTimerRunning && minutes == 0 && seconds == 0) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(backgroundColor: Colors.red, content: Text("Time is Up")));
                                        }
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: const [
                                          Center(
                                            child: Text(
                                              "Skip Question",
                                              style: TextStyle(fontSize: 15, color: Color(0xFF078669), fontWeight: FontWeight.w400),
                                            ),
                                          )
                                        ],
                                      )))
                              : Container()
                        ],
                      ))
                    ],
                  )));
  }

  Future<void> _showSimpleDialog(Map quizSubmit) async {
    Map quizzz = quizSubmit;

    await showDialog<void>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
              // <-- SEE HERE
              title: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/Group 1042.png",
                      height: 166.56.h,
                      width: 193.w,
                      fit: BoxFit.cover,
                    ),
                    Text(
                      'Congratulations! ',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 24.sp,
                        color: Color(0xFF1D2746),
                      ),
                    ),
                  ],
                ),
              ),

              content: SizedBox(
                height: 100.h,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Text(
                      //       'Your got the',
                      //       style: TextStyle(
                      //         fontWeight: FontWeight.w600,
                      //         fontSize: 13.sp,
                      //         color: Color(0xFF6A737C),
                      //       ),
                      //     ),
                      //     Text(
                      //       ' 1st',
                      //       style: TextStyle(
                      //         fontWeight: FontWeight.w600,
                      //         fontSize: 13.sp,
                      //         color: Color(0xFF078669),
                      //       ),
                      //     ),
                      //     Text(
                      //       ' place in 25098',
                      //       style: TextStyle(
                      //         fontWeight: FontWeight.w600,
                      //         fontSize: 13.sp,
                      //         color: Color(0xFF6A737C),
                      //       ),
                      //     ),
                      //   ],
                      // ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Your Score is ',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp,
                              color: Color(0xFF1D2746),
                            ),
                          ),
                          Text(
                            '${quizzz['data']['score']}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp,
                              color: Color(0xFF078669),
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            await Navigator.of(context).pushNamed(QuizSubmitPage.pageName, arguments: quizSubmit);
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                          child: Text(
                            "See Answers",
                            style: TextStyle(color: Color(0xFF078669)),
                          ))
                    ],
                  ),
                ),
              ),

              // SimpleDialogOption(
              //   onPressed: () {
              //     print("aaa");
              //     Navigator.of(context).pop();
              //   },
              //   child: const Text(''),
              // ),
            ),
          );
        });
  }

  bool isSnackBarVisible = false;

  void _showSnackBar() {
    if (!isSnackBarVisible) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Must be select option"),
        ),
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

  showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('No Connection'),
          content: const Text('Please check your internet connectivity'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                setState(() {});
                Navigator.pop(context, 'Cancel');
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
}
