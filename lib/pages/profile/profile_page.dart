import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quickalert/quickalert.dart';
import 'package:quiz/bloc/userProfilebloc/profile_bloc.dart';
import 'package:quiz/pages/home_page.dart';
import 'package:quiz/pages/profile/edit_profile.dart';
import 'package:quiz/services/all_services/all_services.dart';

import 'package:quiz/services/repo/repositores.dart';
import 'package:shimmer/shimmer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart' as toast;

class ProfilePage extends StatefulWidget {
  static const pageName = 'profile';
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
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
  @override
  void initState() {
    BlocProvider.of<ProfileBloc>(context).add(ProfileGetEvent());
    super.initState();
  }

  XFile? image;

  final ImagePicker picker = ImagePicker();

  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      image = img;
    });
  }

  //show popup dialog
  void myAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              title: Text('Please choose media to select'),
              content: Container(
                height: MediaQuery.of(context).size.height / 2.5,
                child: Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF078669)),
                      //if user clicks this button, user can upload an image from the gallery
                      onPressed: () async {
                        await getImage(ImageSource.gallery);
                        setState(() {}); // Update the relevant parts of the state
                      },
                      child: Row(
                        children: [
                          Icon(Icons.image),
                          SizedBox(
                            width: 10,
                          ),
                          Text('From Gallery'),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF078669)),
                      //if the user clicks this button. the user can upload an image from the camera
                      onPressed: () async {
                        await getImage(ImageSource.camera);
                        setState(() {}); // Update the relevant parts of the state
                      },
                      child: Row(
                        children: [
                          Icon(Icons.camera),
                          SizedBox(
                            width: 10,
                          ),
                          Text('From Camera'),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    if (image != null)
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 40, // Adjust the radius as needed
                            backgroundImage: FileImage(File(image!.path)),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              _isLoading
                                  ? AllService.LoadingToast()
                                  : SizedBox(
                                      width: 100.w,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF078669),
                                        ),
                                        //if the user clicks this button. the user can upload an image from the camera
                                        onPressed: () async {
                                          setState(() {
                                            _isLoading = true;
                                          });
                                          print(File(image!.path));
                                          Map imageUpload = await Repositores().uploadImage(File(image!.path));
                                          print("Imageeeeeeeee22222222222 ${imageUpload['StatusCode'].toString()}");
                                          if (imageUpload['status'] == true) {
                                            print("Image upload succ");
                                            await QuickAlert.show(
                                              context: context,
                                              type: QuickAlertType.success,
                                              text: "Image Upload Successful",
                                            );
                                            setState(() {
                                              _isLoading = false;
                                            });
                                            Navigator.of(context).pushNamed(ProfilePage.pageName);
                                          } else if (imageUpload['StatusCode'].toString() == '413') {
                                            print("pic largeeeeeeeeeeeeeee");

                                            toast.Fluttertoast.showToast(
                                              msg: "Your current image is too large\nPlease upload a smaller image size",
                                              toastLength: toast.Toast.LENGTH_SHORT,
                                              gravity: toast.ToastGravity.TOP,
                                              timeInSecForIosWeb: 5,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0,
                                            );

                                            setState(() {
                                              _isLoading = false;
                                              image = null;
                                            });
                                          }
                                          // Update the relevant parts of the state
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Icon(Icons.add_a_photo),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text('Add'),
                                          ],
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage()), (Route<dynamic> route) => false);
        return false;
      },
      child: Scaffold(body: SingleChildScrollView(child: BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
        if (state is ProfileInitial) {
          return Container(
            height: 300,
            alignment: Alignment.center,
            child: Center(
              child: Shimmer.fromColors(
                baseColor: Colors.grey[700]!,
                highlightColor: Colors.grey[100]!,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    radius: 30.0,
                  ),
                  title: Text('Loading....', style: TextStyle(fontSize: 18.0)),
                  subtitle: Text('Profile', style: TextStyle(fontSize: 14.0)),
                ),
              ),
            ),
          );
        }
        if (state is ProfileGetState) {
          print("rrrrrrrrrrrrrrrrrrrrrrrrrr");
          print(state.UserProfile['first_name']);
          return Column(
            children: [
              SizedBox(
                height: 300.h,
                child: Stack(children: [
                  Container(
                    height: 190.h,
                    width: 375.w,
                    decoration: BoxDecoration(
                      color: Color(0xFF078669),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40.r),
                        bottomRight: Radius.circular(40.r),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50.h,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5.h, bottom: 5.h, left: 10),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
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
                                flex: 2,
                                child: SizedBox.shrink(),
                              ),
                              Expanded(
                                flex: 5,
                                child: Text(
                                  "My Profile",
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFFFFFFFF),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 170.h,
                    left: 30.w,
                    child: Container(
                      alignment: Alignment.center, // Center the contents horizontally and vertically
                      height: 120.h,
                      width: 310.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20.r),
                          bottomRight: Radius.circular(20.r),
                          topLeft: Radius.circular(20.r),
                          topRight: Radius.circular(20.r),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(flex: 5, child: SizedBox.shrink()),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(
                                state.UserProfile['first_name'] + ' ' + state.UserProfile['last_name'],
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF1D2746),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Text(
                              state.UserProfile['email'],
                              style: TextStyle(
                                fontSize: 12.7.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF6A737C),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Positioned(
                    top: 110.h,
                    left: 130.w,
                    child: state.UserProfile['profile_photo'] == null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(400.0),
                            child: Image.asset(
                              "assets/images/b.jpg",
                              height: 100.h,
                              // fit: BoxFit.cover,
                            ),
                          )
                        : SizedBox(
                            height: 100.h,
                            width: 100.w,
                            child: CachedNetworkImage(
                              imageUrl: state.UserProfile['profile_photo'],
                              imageBuilder: (context, imageProvider) => CircleAvatar(
                                radius: 40.r,
                                backgroundImage: imageProvider,
                              ),
                              placeholder: (context, url) => CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                          ),
                  ),

                  // SizedBox(
                  //     height: 100.h,
                  //     width: 100.w,
                  //     child: CircleAvatar(
                  //         radius: 40.r, // Adjust the radius as needed
                  //         backgroundImage: NetworkImage(state.UserProfile['profile_photo'])),
                  //   )),
                  //  SizedBox(
                  //     height: 100.h,
                  //     width: 100.w,
                  //     child: ClipOval(
                  //       child: CircleAvatar(
                  //           backgroundColor: Colors.transparent,
                  //           radius: 40, // Adjust the radius as needed
                  //           backgroundImage: NetworkImage(state.UserProfile['profile_photo'])),
                  //     ),
                  //   )),
                  Positioned(
                    top: 200.h,
                    left: 174.w,
                    child: GestureDetector(
                      onTap: () async {
                        final connectivityResult = await (Connectivity().checkConnectivity());
                        if (connectivityResult == ConnectivityResult.mobile ||
                            connectivityResult == ConnectivityResult.wifi ||
                            connectivityResult == ConnectivityResult.ethernet) {
                          myAlert();
                          print("internet onnnnnn");
                        } else {
                          print("internet off");
                          showDialogBox();
                        }
                        //
                      },
                      child: Image.asset(
                        "assets/icon/Camera Icon.png",
                        //fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ]),
              ),
              Container(
                height: 300.h,
                width: 320.w,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.r),
                      bottomRight: Radius.circular(20.r),
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r),
                    )),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 30.w,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Personal Information",
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF1D2746),
                              ),
                            ),
                          ),
                          Container(
                            height: 57.h,
                            width: 57.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(50.r),
                                  bottomRight: Radius.circular(0.r),
                                  topLeft: Radius.circular(0.r),
                                  topRight: Radius.circular(10.r),
                                ),
                                color: Color(0xFF078669)),
                            child: IconButton(
                              onPressed: () {
                                Navigator.pushNamed(context, EditProfile.pageName, arguments: state.UserProfile);
                              },
                              icon: Image.asset(
                                "assets/icon/Edit 2.png",
                                fit: BoxFit.contain,
                                height: 18.75.h,
                                width: 19.91.w,
                              ),
                            ),
                          ),

                          // Stack(
                          //   children: [
                          //     Image.asset(
                          //       "assets/images/Rectangle 1164.png",
                          //       //fit: BoxFit.cover,
                          //     ),
                          //     Positioned(
                          //       top: 15.h,
                          //       left: 23.w,
                          //       child: GestureDetector(
                          //         onTap: () {
                          //           Navigator.pushNamed(context, EditProfile.pageName, arguments: state.UserProfile);
                          //         },
                          //         child: Image.asset(
                          //           "assets/icon/Edit 2.png",
                          //           //fit: BoxFit.cover,
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 30.w,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 130.w,
                            child: Text(
                              "First name",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF6A737C),
                              ),
                            ),
                          ),
                          Text(":"),
                          Container(
                            width: 130.w,
                            child: Text("${state.UserProfile['first_name'].toString().isEmpty ? '' : state.UserProfile['first_name']}",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF1D2746),
                                )),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 30.w,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 130.w,
                            child: Text(
                              "Last name",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF6A737C),
                              ),
                            ),
                          ),
                          Text(":"),
                          Container(
                            width: 130.w,
                            child: Text("${state.UserProfile['last_name'].toString().isEmpty ? '' : state.UserProfile['last_name']}",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF1D2746),
                                )),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 30.w,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 130.w,
                            child: Text(
                              "Gender",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF6A737C),
                              ),
                            ),
                          ),
                          Text(":"),
                          Container(
                            width: 130.w,
                            child: Text(state.UserProfile['gender'] == null ? '' : state.UserProfile['gender'],
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF1D2746),
                                )),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 30.w,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 130.w,
                            child: Text(
                              "Country",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF6A737C),
                              ),
                            ),
                          ),
                          Text(":"),
                          Container(
                            width: 130.w,
                            child: Text("Bangladesh",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF1D2746),
                                )),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 30.w,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 130.w,
                            child: Text(
                              "Language",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF6A737C),
                              ),
                            ),
                          ),
                          Text(":"),
                          Container(
                            width: 130.w,
                            child: Text("English",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF1D2746),
                                )),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 30.w,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 130.w,
                            child: Text(
                              "City",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF6A737C),
                              ),
                            ),
                          ),
                          Text(":"),
                          Container(
                            width: 130.w,
                            child: Text('${state.UserProfile['city'] == null ? '' : state.UserProfile['city']}',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF1D2746),
                                )),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 30.w,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 130.w,
                            child: Text(
                              "Phone",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF6A737C),
                              ),
                            ),
                          ),
                          Text(":"),
                          Container(
                            width: 130.w,
                            child: Text('${state.UserProfile['phone'] == null ? '' : state.UserProfile['phone']}',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF1D2746),
                                )),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // SizedBox(
              //   width: 325.w,
              //   height: 52.h,
              //   child: ElevatedButton(
              //       style: ElevatedButton.styleFrom(
              //         backgroundColor: Color(0xFF078669),
              //       ),
              //       onPressed: () {},
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         children: [
              //           //SizedBox(width: 5),
              //           Row(
              //             children: [
              //               Text(
              //                 "Wrong information? Get help !",
              //                 style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400),
              //               ),
              //               SizedBox(
              //                 width: 5.w,
              //               ),
              //               Image.asset(
              //                 "assets/icon/Group 916.png",
              //                 height: 30.h,
              //                 width: 30.w,
              //                 fit: BoxFit.cover,
              //               ),
              //             ],
              //           )
              //         ],
              //       )),
              // )
            ],
          );
        }

        return Container();
      }))),
    );
  }
}
