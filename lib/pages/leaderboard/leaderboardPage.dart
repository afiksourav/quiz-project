import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quiz/custom_widget/button.dart';
import 'package:quiz/services/repo/repositores.dart';
import 'package:shimmer/shimmer.dart';

class leaderboardPage extends StatefulWidget {
  static const pageName = 'leaderboardPage';
  const leaderboardPage({super.key});

  @override
  State<leaderboardPage> createState() => _leaderboardPageState();
}

class _leaderboardPageState extends State<leaderboardPage> {
  Map leaderBoradResult = {};
  String keyword = "daily";
  List<bool> selectedButton = [true, false, false];

  leaderBoradDetails() async {
    Map leaderBorad = await Repositores().leaderBorad();
    print("PPPPPPPPPPPPPPPPPPP");
    print(leaderBorad);

    leaderBoradResult = leaderBorad['data'];
    setState(() {});
    return leaderBorad;
  }

  @override
  void initState() {
    leaderBoradDetails();
    // TODO: implement initState
    super.initState();
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
              SizedBox(
                height: 10.h,
              ),
              Text(
                "Leaderboard",
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: leaderBoradResult.isEmpty
            ? Column(
                children: [
                  SizedBox(
                    height: 60.h,
                  ),
                  Center(
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[700]!,
                      highlightColor: Colors.grey[100]!,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          radius: 30.0.r,
                        ),
                        title: Text('Loading...', style: TextStyle(fontSize: 16.0.sp)),
                        subtitle: Text('leaderBorad', style: TextStyle(fontSize: 14.0.sp)),
                      ),
                    ),
                  ),
                ],
              )
            : Padding(
                padding: EdgeInsets.only(left: 20.0.w, right: 20.0.w),
                child: Column(children: [
                  SizedBox(height: 20),
                  Container(
                    height: 47.25.h,
                    width: 327.w,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      color: Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.r),
                        topRight: Radius.circular(12.r),
                        bottomLeft: Radius.circular(12.r),
                        bottomRight: Radius.circular(12.r),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ButtonWidget(
                            width: 100,
                            height: 50,
                            onPressed: () {
                              selectedButton[0] = true;
                              selectedButton[1] = false;
                              selectedButton[2] = false;

                              setState(() {});
                            },
                            title: "Daily",
                            color: selectedButton[0] == true ? Color(0xFF078669) : Color(0xFF0FFFFFF),
                            textcolor: selectedButton[0] == true ? Color(0xFF0FFFFFF) : Colors.black),
                        ButtonWidget(
                            width: 100,
                            height: 50,
                            onPressed: () {
                              selectedButton[0] = false;
                              selectedButton[1] = true;
                              selectedButton[2] = false;
                              print(selectedButton);
                              keyword = "weekly";
                              setState(() {});
                            },
                            title: "Weakly",
                            color: selectedButton[1] == true ? Color(0xFF078669) : Color(0xFF0FFFFFF),
                            textcolor: selectedButton[1] == true ? Color(0xFF0FFFFFF) : Colors.black),
                        ButtonWidget(
                            width: 100,
                            height: 50,
                            onPressed: () {
                              selectedButton[0] = false;
                              selectedButton[1] = false;
                              selectedButton[2] = true;

                              setState(() {});
                            },
                            title: "Monthly",
                            color: selectedButton[2] == true ? Color(0xFF078669) : Color(0xFF0FFFFFF),
                            textcolor: selectedButton[2] == true ? Color(0xFF0FFFFFF) : Colors.black)
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            leaderBoradResult[keyword][1]['profile_photo'] == null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(400.0),
                                    child: Image.asset(
                                      "assets/images/b.jpg",
                                      height: 47.h,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: NetworkImage(leaderBoradResult[keyword][1]['profile_photo']),
                                  ),
                            Text(
                              leaderBoradResult[keyword][1]['first_name'] + " " + leaderBoradResult[keyword][1]['last_name'],
                              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Color(0xFF0202244)),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Container(
                                height: 20.h,
                                width: 70.w,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 211, 236, 230),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8.0),
                                    topRight: Radius.circular(8.0),
                                    bottomLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                  ),
                                ),
                                child: Center(
                                    child: Text(
                                  "${leaderBoradResult[keyword][1]['total_score'].toString()} PT",
                                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
                                ))),
                            SizedBox(
                              height: 5.h,
                            ),
                            Image.asset(
                              "assets/images/Group 1008.png",
                              height: 80.h,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            leaderBoradResult[keyword][0]['profile_photo'] == null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(400.0),
                                    child: Image.asset(
                                      "assets/images/b.jpg",
                                      height: 47.h,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: NetworkImage(leaderBoradResult[keyword][0]['profile_photo']),
                                  ),
                            Text(
                              leaderBoradResult[keyword][0]['first_name'] + " " + leaderBoradResult[keyword][0]['last_name'],
                              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Color(0xFF0202244)),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Container(
                                height: 20.h,
                                width: 70.w,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 211, 236, 230),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8.0),
                                    topRight: Radius.circular(8.0),
                                    bottomLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                  ),
                                ),
                                child: Center(
                                    child: Text(
                                  "${leaderBoradResult[keyword][0]['total_score'].toString()} PT",
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                ))),
                            SizedBox(
                              height: 5.h,
                            ),
                            Image.asset(
                              "assets/images/Group 1006.png",
                              height: 110.h,
                              // width: 113.w,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            leaderBoradResult[keyword][2]['profile_photo'] == null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(400.0),
                                    child: Image.asset(
                                      "assets/images/b.jpg",
                                      height: 47.h,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: NetworkImage(leaderBoradResult[keyword][2]['profile_photo']),
                                  ),
                            Text(
                              leaderBoradResult[keyword][2]['first_name'] + " " + leaderBoradResult[keyword][2]['last_name'],
                              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: Color(0xFF0202244)),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Container(
                                height: 20.h,
                                width: 70.w,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 211, 236, 230),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8.0),
                                    topRight: Radius.circular(8.0),
                                    bottomLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                  ),
                                ),
                                child: Center(
                                    child: Text(
                                  "${leaderBoradResult[keyword][2]['total_score'].toString()} PT",
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                ))),
                            SizedBox(
                              height: 5.h,
                            ),
                            Image.asset(
                              "assets/images/Group 1007.png",
                              height: 80.h,
                              // width: 99.w,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: leaderBoradResult[keyword].length,
                      itemBuilder: (context, index) {
                        print("**********************$keyword");
                        print([index]);
                        int id = index + 1;

                        return SizedBox(
                          height: 65,
                          width: 400,
                          child: Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Text(id.toString()),
                                Expanded(
                                    flex: 2,
                                    child: leaderBoradResult[keyword][index]['profile_photo'] == null
                                        ? SizedBox(
                                            height: 47.h,
                                            width: 35.w,
                                            child: Image.asset(
                                              "assets/images/b.jpg",
                                              height: 76.h,
                                              width: 35.w,
                                            ),
                                          )
                                        : CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(400.0), // Adjust the radius as needed
                                              child: Image.network(
                                                leaderBoradResult[keyword][index]['profile_photo'],
                                                height: 76.h,
                                                width: 35.w,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          )),
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    leaderBoradResult[keyword][index]['first_name'] + " " + leaderBoradResult[keyword][index]['last_name'],
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Expanded(flex: 1, child: Text("${leaderBoradResult[keyword][index]['total_score'].toString()} PT"))
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ]),
              ));
  }
}
