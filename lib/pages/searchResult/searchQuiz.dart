import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:quiz/pages/home_page.dart';
import 'package:quiz/pages/quize_page/quiz_page.dart';
import 'package:quiz/services/repo/repositores.dart';
import 'package:shimmer/shimmer.dart';

class SearchQuiz extends StatefulWidget {
  static const pageName = 'searchQuiz';
  final String? keywords;
  const SearchQuiz({
    super.key,
    this.keywords,
  });

  @override
  State<SearchQuiz> createState() => _SearchQuizState();
}

class _SearchQuizState extends State<SearchQuiz> {
  List<dynamic> posts = [];
  int currentPage = 1;
  bool isLoading = false;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchPosts();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _fetchPosts();
      }
    });
  }

  Future<void> _fetchPosts() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    Map quiz = await Repositores().SearchQuiz(currentPage, widget.keywords!);
    List quiztry = quiz['data']['quizzes']['data'];
    if (quiztry.isEmpty) {
      setState(() {
        isLoading = false;
      });
      return;
    } else {
      setState(() {
        posts.addAll(quiztry);
        print("topicsOfSubject");
        print(posts);
        currentPage++;
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage()), (Route<dynamic> route) => false);
        return false;
      },
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: 122.h,
              width: 375.w,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF220F4D), Color(0xFF37165C)],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  stops: [0.4, 0.7],
                  tileMode: TileMode.repeated,
                ),
                //color: Color(0xFF220F4D),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 50.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.w, right: 20.w),
                    child: Row(
                      children: [
                        Container(
                          height: 37.h,
                          width: 37.w,
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
                        SizedBox(
                          width: 85.w,
                        ),
                        Text(
                          "Search Results",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            isLoading == false
                ? posts.isEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 300,
                          ),
                          Text("No Results Found"),
                        ],
                      )
                    : Container()
                : Container(),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                controller: _scrollController,
                itemCount: posts.length + 1,
                itemBuilder: (context, index) {
                  if (index < posts.length) {
                    final post = posts[index];
                    return Padding(
                      padding: EdgeInsets.only(left: 10.w, right: 10.w),
                      child: SizedBox(
                        height: 83.h,
                        child: GestureDetector(
                          onTap: () async {
                            // await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                            //   return QuizPage(
                            //     slug: posts[index]['slug'],
                            //   );
                            // }));
                          },
                          child: Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 5.w,
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Image.asset(
                                    "assets/images/oo.png",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(
                                  width: 40.w,
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        posts[index]['title'],
                                        style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w500, color: Color(0xFF1D2746)),
                                      ),
                                      SizedBox(
                                        height: 7.h,
                                      ),
                                      Row(
                                        children: [
                                          Image.asset(
                                            "assets/icon/back-in-time 5.png",
                                            fit: BoxFit.cover,
                                          ),
                                          Text(
                                            " ${posts[index]['total_time'].toString()}",
                                            style: TextStyle(
                                              fontSize: 10.sp,
                                              color: Color(0xFF6A737C),
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          Image.asset(
                                            "assets/icon/back-in-time 1.png",
                                            fit: BoxFit.cover,
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          Text(
                                            " ${posts[index]['total_score'].toString()}",
                                            style: TextStyle(
                                              fontSize: 10.sp,
                                              color: Color(0xFF6A737C),
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                // SizedBox(
                                //   width: 20.w,
                                // ),
                                Expanded(
                                  flex: 3,
                                  child: SizedBox(
                                    height: 38.h,
                                    width: 76.w,
                                    child: TextButton(
                                        onPressed: () async {
                                          await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                            return QuizPage(
                                              slug: posts[index]['slug'],
                                            );
                                          }));
                                        },
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: Color(0xFF078669), // Background Color
                                        ),
                                        child: Text(
                                          "Start Now",
                                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400),
                                        )),
                                  ),
                                ),
                                SizedBox(
                                  width: 20.w,
                                ),
                              ],
                            ),
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
            ),
            // FutureBuilder<dynamic>(
            //   future: QuizTopic(),
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return Center(child: CircularProgressIndicator());
            //     } else if (snapshot.hasError) {
            //       return Center(child: Text('Error: ${snapshot.error}'));
            //     } else {
            //       final data = snapshot.data;
            //       print("future dataaaaaaaa ");
            //       return Container(
            //         height: 500,
            //         child: ListView.builder(
            //           itemCount: data!.length,
            //           itemBuilder: (context, index) {
            //             // print(data['data']['quizzes']['data'][index]['title']);
            //             return Padding(
            //               padding: EdgeInsets.only(left: 15.w, right: 15.w),
            //               child: Row(
            //                 // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                 children: [
            //                   Expanded(
            //                     flex: 2,
            //                     child: Image.asset(
            //                       "assets/images/oo.png",
            //                       fit: BoxFit.cover,
            //                     ),
            //                   ),
            //                   SizedBox(
            //                     width: 20.w,
            //                   ),
            //                   Expanded(
            //                     flex: 5,
            //                     child: Column(
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       children: [
            //                         Text(
            //                           data['data']['quizzes']['data'][index]['title'],
            //                           style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w500, color: Color(0xFF1D2746)),
            //                         ),
            //                         SizedBox(
            //                           height: 7.h,
            //                         ),
            //                         Row(
            //                           children: [
            //                             Image.asset(
            //                               "assets/icon/back-in-time 5.png",
            //                               fit: BoxFit.cover,
            //                             ),
            //                             Text(
            //                               " ${data['data']['quizzes']['data'][index]['total_time'].toString()}",
            //                               style: TextStyle(
            //                                 fontSize: 10.sp,
            //                                 color: Color(0xFF6A737C),
            //                                 fontWeight: FontWeight.w400,
            //                               ),
            //                             ),
            //                             SizedBox(
            //                               width: 5.w,
            //                             ),
            //                             SizedBox(
            //                               width: 5.w,
            //                             ),
            //                             Image.asset(
            //                               "assets/icon/back-in-time 1.png",
            //                               fit: BoxFit.cover,
            //                             ),
            //                             SizedBox(
            //                               width: 5.w,
            //                             ),
            //                             Text(
            //                               " ${data['data']['quizzes']['data'][index]['total_score'].toString()}",
            //                               style: TextStyle(
            //                                 fontSize: 10.sp,
            //                                 color: Color(0xFF6A737C),
            //                                 fontWeight: FontWeight.w400,
            //                               ),
            //                             ),
            //                             SizedBox(
            //                               width: 5.w,
            //                             ),
            //                           ],
            //                         )
            //                       ],
            //                     ),
            //                   ),
            //                   // SizedBox(
            //                   //   width: 20.w,
            //                   // ),
            //                   Expanded(
            //                     flex: 3,
            //                     child: SizedBox(
            //                       height: 35.h,
            //                       width: 76.w,
            //                       child: TextButton(
            //                           onPressed: () {
            //                             Navigator.pushNamed(context, QuizPage.pageName);
            //                           },
            //                           style: TextButton.styleFrom(
            //                             foregroundColor: Colors.white,
            //                             backgroundColor: Color(0xFF078669), // Background Color
            //                           ),
            //                           child: Text(
            //                             "Start Nowwww",
            //                             style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w400),
            //                           )),
            //                     ),
            //                   )
            //                 ],
            //               ),
            //             );
            //           },
            //         ),
            //       );
            //     }
            //   },
            // ),
            SizedBox(height: 25.h),
          ],
        ),
      ),
    );
  }
}
