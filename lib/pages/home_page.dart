import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quiz/custom_widget/app_drawer.dart';
import 'package:quiz/pages/quize_page/quiz_page.dart';
import 'package:quiz/pages/searchResult/searchQuestions.dart';
import 'package:quiz/pages/searchResult/searchQuiz.dart';
import 'package:quiz/pages/subject/subject_all.dart';
import 'package:quiz/pages/topic_page/topic.dart';
import 'package:quiz/services/global.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:quiz/services/repo/repositores.dart';
import 'package:intl/intl.dart';
import 'package:quiz/services/sqflitebatabase/database_service.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  static const pageName = 'home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> posts = [];
  List<dynamic> subject = [];
  int currentPage = 1;
  int r_currentPage = 1;
  bool isLoading = false;
  String keyword = '';
  bool searchkey = false;
  int _currentIndex = 0;

  Map Userinfo = {'Unauthenticated': 'Unauthenticated.'};

  ScrollController _scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();

  Future<void> subjectSlideAPi() async {
    Map subjectApi = await Repositores().subjectApi(currentPage);
    print("WWWWWWWWWWW$subjectApi");
    setState(() {
      subject = subjectApi['data']['data'];
    });
  }

  Future<void> _randomQuiz() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    Map a = await Repositores().randomQuiz(r_currentPage);
    List response = a['data']['data'];
    setState(() {
      posts.addAll(response);
      print("tttttttttttttttttt");
      print(posts);
      currentPage++;
      isLoading = false;
    });
  }

  Future<Map> userProfileGet() async {
    Map userProfile = await Repositores().GetProfile();
    if (userProfile['status'] == true) {
      print("User 111111111 Profilettttttttt$userProfile ");

      Userinfo = {
        'Photo': userProfile['data']['user']['profile_photo'],
        'email': userProfile['data']['user']['email'],
        'name': userProfile['data']['user']['first_name'] + ' ' + userProfile['data']['user']['last_name'],
      };
      setState(() {});
      return Userinfo;
    } else {
      print("User Profile else message > ${userProfile['message']} ");
      Userinfo = {'Unauthenticated': 'Unauthenticated.'};
      setState(() {});
      return Userinfo;
    }
  }

  Future<void> internetcheck() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.ethernet) {
      print("intenrt on");
    } else {
      print("internet off");
      showDialogBox();
    }
  }

  @override
  void initState() {
    super.initState();
    internetcheck();
    subjectSlideAPi();
    _randomQuiz();
    userProfileGet();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _randomQuiz();
      }
    });
  }

  ScrollController _scrollController12 = ScrollController();
  FocusNode _textFieldFocusNode = FocusNode();

  var char = "abcdefghijklmnopqrxtuvwxyz".toUpperCase();
  @override
  void dispose() {
    _textFieldFocusNode.dispose();
    searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController12.hasClients) {
        _scrollController12.animateTo(_scrollController12.position.maxScrollExtent, duration: const Duration(seconds: 120), curve: Curves.linear);
      }
    });

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("Welcome to Quizva!", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22, color: Color(0xFF1D2746))),
          ],
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: SvgPicture.asset(
                "assets/icon/Vector.svg",
                width: 14.w,
                height: 12,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: DrawerHome(Userinfo: Userinfo),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: Column(
            children: [
              // ElevatedButton(
              //     onPressed: () async {
              //       // await Repositores().GetProfile();
              //       // g_token = "";
              //       // print(Userinfo);
              //       // print(g_token);
              //       // print(await SqliteService().getUserData());
              //       // setState(() {});
              //       final connectivityResult = await (Connectivity().checkConnectivity());
              //       if (connectivityResult == ConnectivityResult.mobile ||
              //           connectivityResult == ConnectivityResult.wifi ||
              //           connectivityResult == ConnectivityResult.ethernet) {
              //         print("intenrt on");
              //       } else {
              //         print("internet off");
              //         showDialogBox();
              //       }
              //     },
              //     child: Text("")),
              Padding(
                padding: EdgeInsets.only(left: 15.w, right: 15.w),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                      ],
                      color: Colors.white),
                  child: Column(
                    children: [
                      Container(
                        height: 120,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color(0xFF078669),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(left: 15, top: 15),
                              child: Text(
                                'Discover',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700,
                                  // fontFamily: 'DancingScript',
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 15, top: 5),
                              child: Text(
                                'Meet other Quizva users like you. Get answers & discover new ways to learn.',
                                style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Container(
                      //   width: double.infinity,
                      //   child: TextFormField(
                      //     controller: searchController,
                      //     textInputAction: TextInputAction.next,
                      //     textAlignVertical: TextAlignVertical.center,
                      //     decoration: InputDecoration(
                      //       hintText: 'Search',
                      //       prefixIcon: GestureDetector(
                      //           onTap: () async {
                      //             keyword = searchController.text;
                      //             await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                      //               return SearchQuestions(
                      //                 keywords: keyword,
                      //               );
                      //             }));
                      //           },
                      //           child: Icon(Icons.search)),
                      //       contentPadding: const EdgeInsets.symmetric(vertical: 15), //Imp Line
                      //       isDense: true,
                      //       border: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(5),
                      //           borderSide: BorderSide(
                      //             width: 0.5,
                      //           )),
                      //       suffixIcon: GestureDetector(
                      //         onTap: () {
                      //           _textFieldFocusNode.unfocus();
                      //           _showSimpleDialog(searchController.text);
                      //         },
                      //         child: Image.asset(
                      //           "assets/icon/Filter 5.jpg",
                      //           height: 18.h,
                      //           width: 16.w,
                      //           // fit: BoxFit.cover,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Container(
                        width: double.infinity,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                textInputAction: TextInputAction.go,
                                onSubmitted: (value) async {
                                  await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                    return SearchQuestions(
                                      keywords: value.toString(),
                                    );
                                  }));
                                },
                                textAlignVertical: TextAlignVertical.center,
                                focusNode: _textFieldFocusNode,
                                controller: searchController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  //border: InputBorder.none, // Remove the border
                                  enabledBorder: InputBorder.none,
                                  // border: OutlineInputBorder(
                                  //   borderRadius: BorderRadius.circular(5),
                                  // ),
                                  hintText: 'Search',
                                  prefixIcon: GestureDetector(
                                      onTap: () async {
                                        final connectivityResult = await (Connectivity().checkConnectivity());
                                        if (connectivityResult == ConnectivityResult.mobile ||
                                            connectivityResult == ConnectivityResult.wifi ||
                                            connectivityResult == ConnectivityResult.ethernet) {
                                          print("intenrt on");
                                          keyword = searchController.text;
                                          await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                            return SearchQuestions(
                                              keywords: keyword,
                                            );
                                          }));
                                        } else {
                                          showDialogBox();
                                        }
                                      },
                                      child: Icon(Icons.search)),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 15), //Imp Line
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      _textFieldFocusNode.unfocus();
                                      _showSimpleDialog(searchController.text);
                                    },
                                    child: Image.asset(
                                      "assets/icon/Filter 5.jpg",
                                      height: 18.h,
                                      width: 16.w,
                                      // fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: 15.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.w, right: 15.w),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Subject',
                        style: TextStyle(color: Color(0xFF1D2746), fontSize: 18.h, fontWeight: FontWeight.w500),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final connectivityResult = await (Connectivity().checkConnectivity());
                          if (connectivityResult == ConnectivityResult.mobile ||
                              connectivityResult == ConnectivityResult.wifi ||
                              connectivityResult == ConnectivityResult.ethernet) {
                            print("intenrt on");
                            _textFieldFocusNode.unfocus();
                            Navigator.of(context).pushNamed(SubjectAll.pageName);
                          } else {
                            showDialogBox();
                          }
                        },
                        child: Row(
                          children: [
                            Text(
                              'View All',
                              style: TextStyle(color: Color(0xFF078669), fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              width: 3.w,
                            ),
                            Image.asset(
                              "assets/icon/Vector.jpg",
                              height: 18.h,
                              width: 15.w,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15.h,
              ),

              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 4.2,
                child: ListView.builder(
                  controller: _scrollController12,
                  scrollDirection: Axis.horizontal,
                  itemCount: subject.length,
                  itemBuilder: (context, index) {
                    DateTime dateTime = DateTime.parse(subject[index]['updated_at']);
                    // Format the date
                    String formattedDate = DateFormat('MMM d, y').format(dateTime);

                    return GestureDetector(
                      onTap: () async {
                        final connectivityResult = await (Connectivity().checkConnectivity());
                        if (connectivityResult == ConnectivityResult.mobile ||
                            connectivityResult == ConnectivityResult.wifi ||
                            connectivityResult == ConnectivityResult.ethernet) {
                          _textFieldFocusNode.unfocus();
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                            return TopicPage(slug: subject[index]['slug']);
                          }));
                        } else {
                          print("internet off");
                          showDialogBox();
                        }
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10.0.w),
                            child: Container(
                              width: 165.w,
                              child: Card(
                                color: Colors.white,
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 5.h),
                                      child: SizedBox(
                                        // crossAxisAlignment: CrossAxisAlignment.center,
                                        height: 83.h,
                                        width: 156.w,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                                          child: Image.network(
                                            subject[index]['profile_photo'],
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 15.w, top: 5.h, right: 5.w),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 8,
                                            child: Text(
                                              subject[index]['name'],
                                              maxLines: 3,
                                              overflow: TextOverflow.fade,
                                              style: TextStyle(
                                                fontSize: 11.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          // SizedBox(
                                          //   width: 3.w,
                                          // ),
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                                height: 14.h,
                                                width: 24.w,
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFF078669),
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(8.0),
                                                    topRight: Radius.circular(8.0),
                                                    bottomLeft: Radius.circular(8),
                                                    bottomRight: Radius.circular(8),
                                                  ),
                                                ),
                                                child: Center(
                                                    child: Text(
                                                  "New",
                                                  style: TextStyle(fontSize: 11.sp, color: Colors.white),
                                                ))),
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 15.w),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Updated on ${formattedDate}",
                                          style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w400, color: Color(0xFF6A737C)),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 15.w),
                                      child: Row(
                                        children: [
                                          Text(
                                            "${subject[index]['quizzes_count']} Quizzes",
                                            style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500, color: Color(0xFF6A737C)),
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          Container(
                                            height: 5.h,
                                            width: 5.w,
                                            decoration: BoxDecoration(color: Color(0xFF078669), borderRadius: BorderRadius.circular(10)),
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          Text(
                                            "${subject[index]['questions_count']} Questions",
                                            style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500, color: Color(0xFF6A737C)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 10.h,
              ),

              Padding(
                padding: EdgeInsets.only(left: 15.w, right: 15.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Quizzes',
                      style: TextStyle(color: Color(0xFF1D2746), fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    // Row(
                    //   children: [
                    //     const Text(
                    //       'Newest',
                    //       style: TextStyle(color: Color(0xFF078669), fontSize: 15, fontWeight: FontWeight.w500),
                    //     ),
                    //     SizedBox(
                    //       width: 5.w,
                    //     ),
                    //     SvgPicture.asset(
                    //       "assets/icon/Group 724.svg",
                    //       height: 12.75.h,
                    //       width: 10.w,
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.w, right: 15.w),
                child: Column(
                  children: [
                    // SizedBox(
                    //   width: 400.w,
                    //   child: Row(
                    //     children: [
                    //       Container(
                    //         height: 86.h,
                    //         width: 115.w,
                    //         decoration: const BoxDecoration(
                    //           color: Color(0xFF078669),
                    //           borderRadius: BorderRadius.only(
                    //             bottomLeft: Radius.circular(20.0),
                    //             topLeft: Radius.circular(20.0),
                    //           ),
                    //         ),
                    //         child: Column(
                    //           crossAxisAlignment: CrossAxisAlignment.center,
                    //           children: [
                    //             Padding(
                    //               padding: EdgeInsets.only(left: 6.w, top: 20.h),
                    //               child: SvgPicture.asset(
                    //                 "assets/images/C.svg",
                    //                 height: 31.56.h,
                    //                 width: 66.w,
                    //                 fit: BoxFit.cover,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //       Padding(
                    //         padding: EdgeInsets.only(left: 10.w),
                    //         child: Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             Text(
                    //               "C Programming",
                    //               style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
                    //             ),
                    //             SizedBox(
                    //               height: 5.h,
                    //             ),
                    //             Row(
                    //               children: [
                    //                 Text(
                    //                   "Yesterday",
                    //                   style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w400, color: Color(0xFF6A737C)),
                    //                 ),
                    //                 SizedBox(
                    //                   width: 5.w,
                    //                 ),
                    //                 Container(
                    //                   height: 5.h,
                    //                   width: 5.w,
                    //                   decoration: BoxDecoration(color: Color(0xFF078669), borderRadius: BorderRadius.circular(10)),
                    //                 ),
                    //                 SizedBox(
                    //                   width: 5.w,
                    //                 ),
                    //                 Text(
                    //                   "2004 Plays",
                    //                   style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w400, color: Color(0xFF6A737C)),
                    //                 ),
                    //               ],
                    //             ),
                    //             SizedBox(
                    //               height: 5.h,
                    //             ),
                    //             Row(
                    //               children: [
                    //                 Image.asset("assets/icon/person.jpg"),
                    //                 SizedBox(
                    //                   width: 5.w,
                    //                 ),
                    //                 SizedBox(
                    //                   width: 2.w,
                    //                 ),
                    //                 Text(
                    //                   "Public",
                    //                   style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w400, color: Color(0xFF6A737C)),
                    //                 ),
                    //               ],
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // ElevatedButton(
                    //     onPressed: () async {
                    //       List userinfo = await SqliteService().getUserData();
                    //       print("object");
                    //       print(userinfo[0]['token']);
                    //     },
                    //     child: Text("aaa")),
                    ListView.builder(
                      shrinkWrap: true,
                      controller: _scrollController,
                      itemCount: posts.length + 1,
                      itemBuilder: (context, index) {
                        if (index < posts.length) {
                          final post = posts[index];
                          // print("afikeeeeeeee");
                          // print(posts[index]['profile_photo']);

                          return GestureDetector(
                            onTap: () async {
                              final connectivityResult = await (Connectivity().checkConnectivity());
                              if (connectivityResult == ConnectivityResult.mobile ||
                                  connectivityResult == ConnectivityResult.wifi ||
                                  connectivityResult == ConnectivityResult.ethernet) {
                                await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                  return QuizPage(
                                    slug: posts[index]['slug'],
                                  );
                                }));
                              } else {
                                print("internet off");
                                showDialogBox();
                              }

                              // await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                              //   return IntroductionPage(slug: posts[index]['slug']);
                              // }));
                            },
                            child: Card(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: SizedBox(
                                width: 400.w,
                                child: Row(
                                  children: [
                                    Container(
                                      height: 86.h,
                                      width: 115.w,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF078669),
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(12.0),
                                          topLeft: Radius.circular(12.0),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 6.w, top: 20.h),
                                            child: SvgPicture.asset(
                                              "assets/images/php.svg",
                                              height: 31.56.h,
                                              width: 66.w,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10.w),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            posts[index]['title'],
                                            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Yesterday",
                                                style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w400, color: Color(0xFF6A737C)),
                                              ),
                                              SizedBox(
                                                width: 5.w,
                                              ),
                                              Container(
                                                height: 5.h,
                                                width: 5.w,
                                                decoration: BoxDecoration(color: Color(0xFF078669), borderRadius: BorderRadius.circular(10)),
                                              ),
                                              SizedBox(
                                                width: 5.w,
                                              ),
                                              Text(
                                                "2004 Plays",
                                                style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w400, color: Color(0xFF6A737C)),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Row(
                                            children: [
                                              Image.asset("assets/icon/person.jpg"),
                                              SizedBox(
                                                width: 5.w,
                                              ),
                                              SizedBox(
                                                width: 2.w,
                                              ),
                                              Text(
                                                "Public",
                                                style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w400, color: Color(0xFF6A737C)),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else if (isLoading) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[700]!,
                            highlightColor: Colors.grey[100]!,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey[300],
                                radius: 30.0,
                              ),
                              title: Text('Loading....', style: TextStyle(fontSize: 18.0)),
                              subtitle: Text('Quiz', style: TextStyle(fontSize: 14.0)),
                            ),
                          );
                        } else {
                          //return SizedBox(height: 20, child: Center(child: Text("no data")));
                          return SizedBox.shrink();
                        }
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showSimpleDialog(String searchKeyword) async {
    bool isQuizChecked = false;
    bool isQuestionsChecked = false;

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              title: Center(
                child: Column(
                  children: [
                    Text(
                      'Filter your Options',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Color(0xFF1D2746),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isQuestionsChecked = false;
                          isQuizChecked = !isQuizChecked;
                        });
                      },
                      child: Row(
                        children: [
                          Checkbox(
                            value: isQuizChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                isQuestionsChecked = false;
                                isQuizChecked = value!;
                              });
                            },
                          ),
                          Text(
                            'Quiz',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isQuizChecked = false;
                          isQuestionsChecked = !isQuestionsChecked;
                        });
                      },
                      child: Row(
                        children: [
                          Checkbox(
                            value: isQuestionsChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                isQuizChecked = false;
                                isQuestionsChecked = value!;
                              });
                            },
                          ),
                          Text(
                            'Questions',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('OK'),
                  onPressed: () async {
                    final connectivityResult = await (Connectivity().checkConnectivity());
                    if (connectivityResult == ConnectivityResult.mobile ||
                        connectivityResult == ConnectivityResult.wifi ||
                        connectivityResult == ConnectivityResult.ethernet) {
                      if (isQuizChecked) {
                        await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                          return SearchQuiz(
                            keywords: searchKeyword,
                          );
                        }));

                        print("quiz");
                        // Handle Quiz option
                      }
                      if (isQuestionsChecked) {
                        await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                          return SearchQuestions(
                            keywords: searchKeyword,
                          );
                        }));

                        print("questoins");
                        // Handle Questions option
                      }
                      Navigator.of(context).pop();
                    } else {
                      print("internet off");
                      showDialogBox();
                    }
                    // Process the selected options here
                  },
                ),
              ],
            );
          },
        );
      },
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
