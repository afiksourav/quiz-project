import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:quiz/pages/quize_page/introduction.dart';
import 'package:quiz/pages/topic_page/topic.dart';
import 'package:quiz/services/repo/repositores.dart';
import 'package:shimmer/shimmer.dart';

class SubjectAll extends StatefulWidget {
  static const pageName = 'SubjectAll';
  const SubjectAll({super.key});

  @override
  State<SubjectAll> createState() => _SubjectAllState();
}

class _SubjectAllState extends State<SubjectAll> {
  List<dynamic> posts = [];
  int currentPage = 1;
  bool isLoading = false;

  ScrollController _scrollController = ScrollController();
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
    internetcheck();
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

    Map a = await Repositores().subjectApi(currentPage);
    List response = a['data']['data'];
    print(a['data']['data']);
    setState(() {
      posts.addAll(response);
      print("tttttttttttttttttt");
      print(posts);
      currentPage++;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
        title: Column(
          children: [
            Text(
              "All Subject",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 5.0.h,
          ),
          Expanded(
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 5.0, // spacing between rows
                  crossAxisSpacing: 0, // adjust this value
                  childAspectRatio: 3 / 2.9,
                ),
                shrinkWrap: true,
                controller: _scrollController,
                itemCount: posts.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index < posts.length) {
                    final post = posts[index];
                    DateTime dateTime = DateTime.parse(post['updated_at']);
                    // Format the date
                    String formattedDate = DateFormat('MMM d, y').format(dateTime);
                    return GestureDetector(
                      onTap: () async {
                        final connectivityResult = await (Connectivity().checkConnectivity());
                        if (connectivityResult == ConnectivityResult.mobile ||
                            connectivityResult == ConnectivityResult.wifi ||
                            connectivityResult == ConnectivityResult.ethernet) {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                            return TopicPage(slug: post['slug']);
                          }));
                        } else {
                          print("internet off");
                          showDialogBox();
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 10.0.w,
                          right: 10.0.w,
                        ),
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
                                        post['profile_photo'],
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
                                          post['name'],
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
                                        "${post['quizzes_count']} Quizzes",
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
                                        "${post['questions_count']} Questions",
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
                      // child: Padding(
                      //   padding: EdgeInsets.only(left: 10, right: 10),
                      //   child: Container(
                      //     width: 165.w,
                      //     // height: MediaQuery.of(context).size.height / 4.2,
                      //     child: Card(
                      //       color: Colors.white,
                      //       elevation: 1,
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(12.0),
                      //       ),
                      //       child: Column(
                      //         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Padding(
                      //             padding: EdgeInsets.only(top: 5.h),
                      //             child: SizedBox(
                      //               // crossAxisAlignment: CrossAxisAlignment.center,
                      //               height: 83.h,
                      //               width: 160.w,
                      //               child: ClipRRect(
                      //                 borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                      //                 child: Image.network(
                      //                   post['profile_photo'],
                      //                   fit: BoxFit.contain,
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //           Padding(
                      //             padding: EdgeInsets.only(left: 15.w, top: 5.h, right: 5.w),
                      //             child: Row(
                      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //               children: [
                      //                 Expanded(
                      //                   flex: 8,
                      //                   child: Text(
                      //                     post['name'],
                      //                     maxLines: 3,
                      //                     overflow: TextOverflow.fade,
                      //                     style: TextStyle(
                      //                       fontSize: 11.sp,
                      //                       fontWeight: FontWeight.w500,
                      //                     ),
                      //                   ),
                      //                 ),
                      //                 // SizedBox(
                      //                 //   width: 3.w,
                      //                 // ),
                      //                 Expanded(
                      //                   flex: 2,
                      //                   child: Container(
                      //                       height: 14.h,
                      //                       width: 24.w,
                      //                       decoration: const BoxDecoration(
                      //                         color: Color(0xFF078669),
                      //                         borderRadius: BorderRadius.only(
                      //                           topLeft: Radius.circular(8.0),
                      //                           topRight: Radius.circular(8.0),
                      //                           bottomLeft: Radius.circular(8),
                      //                           bottomRight: Radius.circular(8),
                      //                         ),
                      //                       ),
                      //                       child: Center(
                      //                           child: Text(
                      //                         "New",
                      //                         style: TextStyle(fontSize: 11.sp, color: Colors.white),
                      //                       ))),
                      //                 ),
                      //                 SizedBox(
                      //                   width: 5.w,
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //           SizedBox(
                      //             height: 8.h,
                      //           ),
                      //           Padding(
                      //             padding: EdgeInsets.only(left: 15.w),
                      //             child: Align(
                      //               alignment: Alignment.centerLeft,
                      //               child: Text(
                      //                 "Updated on Aug 22, 2023",
                      //                 style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w400, color: Color(0xFF6A737C)),
                      //               ),
                      //             ),
                      //           ),
                      //           SizedBox(
                      //             height: 5.h,
                      //           ),
                      //           Padding(
                      //             padding: EdgeInsets.only(left: 15.w),
                      //             child: Row(
                      //               children: [
                      //                 Text(
                      //                   "34 Topic",
                      //                   style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500, color: Color(0xFF6A737C)),
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
                      //                   "96 Questions",
                      //                   style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500, color: Color(0xFF6A737C)),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //           SizedBox(
                      //             width: 10,
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // )
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
                        title: Text('Loading...', style: TextStyle(fontSize: 14.0.sp)),
                        subtitle: Text('Subject', style: TextStyle(fontSize: 12.0.sp)),
                      ),
                    );
                  } else {
                    //return SizedBox(height: 20, child: Center(child: Text("no data")));
                    return SizedBox.shrink();
                  }
                }),
          ),
        ],
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
                await Navigator.of(context).pushNamed(SubjectAll.pageName);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
}
