import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quiz/pages/quize_page/introduction.dart';
import 'package:quiz/services/repo/repositores.dart';
import 'package:shimmer/shimmer.dart';

class TopicPage extends StatefulWidget {
  static const pageName = 'topic';
  final String slug;
  const TopicPage({super.key, required this.slug});

  @override
  State<TopicPage> createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
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

  @override
  void initState() {
    super.initState();
    internetcheck();
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

    Map a = await Repositores().topicsOfSubject(widget.slug, currentPage);
    List response = a['data']['data'];
    print(a['data']['data']);
    setState(() {
      posts.addAll(response);
      print("topicsOfSubject");
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
        title: Column(
          children: [
            Text(
              "Topic",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              controller: _scrollController,
              itemCount: posts.length + 1,
              itemBuilder: (context, index) {
                if (index < posts.length) {
                  final post = posts[index];
                  return GestureDetector(
                    onTap: () async {
                      final connectivityResult = await (Connectivity().checkConnectivity());
                      if (connectivityResult == ConnectivityResult.mobile ||
                          connectivityResult == ConnectivityResult.wifi ||
                          connectivityResult == ConnectivityResult.ethernet) {
                        await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                          return IntroductionPage(slug: posts[index]['slug']);
                        }));
                      } else {
                        print("internet off");
                        showDialogBox();
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 80.h,
                          width: 340.w,
                          child: Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(right: 10.w, left: 10.w),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: SizedBox(
                                      height: 58.h,
                                      width: 58.w,
                                      child: ClipRRect(
                                        // borderRadius: BorderRadius.only(),
                                        child: Image.network(
                                          posts[index]['profile_photo'],
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      // child: CircleAvatar(
                                      //   backgroundColor: Colors.transparent,
                                      //   backgroundImage: NetworkImage(posts[index]['profile_photo']),

                                      // ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            posts[index]['name'],
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Questions ${posts[index]['questions_count']}",
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
                                              "Quizzers ${posts[index]['quizzes_count']}",
                                              style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w400, color: Color(0xFF6A737C)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child: Container(
                                        // height: 40.h,
                                        // width: 50.w,
                                        decoration: BoxDecoration(color: Color.fromARGB(255, 213, 231, 227), borderRadius: BorderRadius.circular(25)),
                                        child: Image.asset("assets/icon/Vector (1).png"),
                                      )
                                      // child: IconButton(
                                      //     onPressed: () {
                                      //       Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                      //         return IntroductionPage(slug: posts[index]['slug']);
                                      //       }));
                                      //     },
                                      //     icon: Icon(Icons.arrow_forward))),
                                      ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (isLoading) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[700]!,
                    highlightColor: Colors.grey[100]!,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        radius: 30.0.sp,
                      ),
                      title: Text('Loading...', style: TextStyle(fontSize: 14.0.sp)),
                      subtitle: Text('Topics', style: TextStyle(fontSize: 12.0.sp)),
                    ),
                  );
                } else {
                  //return SizedBox(height: 20, child: Center(child: Text("no data")));
                  return SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
