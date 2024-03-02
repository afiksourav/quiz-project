import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quiz/bloc/country_bloc/country_bloc.dart';
import 'package:quiz/custom_widget/button.dart';
import 'package:quiz/pages/credentials/sign%20in.dart';
import 'package:quiz/pages/credentials/verification_code.dart';
import 'package:quiz/services/all_services/all_services.dart';
import 'package:quiz/services/global.dart';
import 'package:quiz/services/repo/repositores.dart';
import 'package:quiz/services/sqflitebatabase/database_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:quickalert/quickalert.dart';

import 'package:quiz/pages/home_page.dart';

final _formKey = GlobalKey<FormState>();

class SignUpPage extends StatefulWidget {
  static const pageName = 'SignUpPage';
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confrimPasswordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  bool ischeckbox = false;
  bool _obscureText = true;
  bool _obscureTextConfrimPass = true;

  String? EmailValidator(String? email) {
    RegExp emailregex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    final isEmailvalid = emailregex.hasMatch(email ?? "");
    if (!isEmailvalid) {
      return "Please enter a valid email";
    }
    return null;
  }

  List countries = [];

  String? selectedCountryName; // Store the selected country name
  int? selectedCountryId; // Store the selected country ID

  @override
  void initState() {
    BlocProvider.of<CountryBloc>(context).add(CountryGetEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //List countries = ModalRoute.of(context)!.settings.arguments as List;
    print("aip pass$countries");
    return WillPopScope(
      onWillPop: () async {
        await Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage()), (Route<dynamic> route) => false);
        return false;
      },
      child: Scaffold(
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
              ],
            ),
          ),
          automaticallyImplyLeading: false,
          // title: Padding(
          //   padding: EdgeInsets.only(left: 70.w),
          //   child: Column(
          //     children: [
          //       SizedBox(
          //         height: 10.h,
          //       ),
          //       Text(
          //         "Leaderboard",
          //         style: TextStyle(color: Colors.black),
          //       ),
          //     ],
          //   ),
          // ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            child: Column(
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 22.w),
                      child: Text(
                        "Create an account",
                        style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(width: 5.w),
                    SvgPicture.asset(
                      "assets/icon/pencil 1.svg",
                      height: 20.h,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: firstNameController,
                        decoration: const InputDecoration(
                          hintText: "First Name",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value!.isEmpty ? "First Name Required" : null,
                      ),
                      // AppTextField(
                      //   textController: firstNameController,
                      //   labelText: 'First Name',
                      // ),
                      SizedBox(
                        height: 10.h,
                      ),
                      TextFormField(
                        controller: lastNameController,
                        decoration: const InputDecoration(
                          hintText: "last Name",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value!.isEmpty ? "Last Name Required" : null,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          hintText: "Email",
                          border: OutlineInputBorder(),
                        ),
                        validator: EmailValidator,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      TextFormField(
                        obscureText: _obscureText,
                        controller: passwordController,
                        decoration: InputDecoration(
                          hintText: "Password",
                          border: OutlineInputBorder(),
                          suffixIcon: _obscureText
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = false;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.visibility_off,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                )
                              : IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = true;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.remove_red_eye,
                                    size: 20,
                                    color: Colors.black,
                                  ),
                                ),
                        ),
                        validator: (value) => value!.isEmpty
                            ? "Password Required"
                            : value.length < 8
                                ? "Password is to short "
                                : null,
                      ),
                      // TextFormField(
                      //   controller: passwordController,
                      //   decoration: const InputDecoration(
                      //     hintText: "Password",
                      //     border: OutlineInputBorder(),
                      //   ),
                      //   validator: (value) => value!.isEmpty
                      //       ? "Password Required"
                      //       : value.length < 8
                      //           ? "Password is to short "
                      //           : null,
                      // ),
                      SizedBox(
                        height: 10.h,
                      ),
                      // TextFormField(
                      //   controller: confrimPasswordController,
                      //   decoration: const InputDecoration(
                      //     hintText: "Confirm Password",
                      //     border: OutlineInputBorder(),
                      //   ),
                      //   validator: (value) => value != passwordController.text ? "Password Dose not matched " : null,
                      // ),

                      TextFormField(
                        obscureText: _obscureTextConfrimPass,
                        controller: confrimPasswordController,
                        decoration: InputDecoration(
                          hintText: "Confirm Password",
                          border: OutlineInputBorder(),
                          suffixIcon: _obscureTextConfrimPass
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscureTextConfrimPass = false;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.visibility_off,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                )
                              : IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscureTextConfrimPass = true;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.remove_red_eye,
                                    size: 20,
                                    color: Colors.black,
                                  ),
                                ),
                        ),
                        validator: (value) => value != passwordController.text ? "Password Dose not matched " : null,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),

                      BlocBuilder<CountryBloc, CountryState>(
                        builder: (context, state) {
                          if (state is CountryInitial) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (state is CountryGetState) {
                            return DropdownButtonFormField<String>(
                              value: selectedCountryName,
                              items: state.countrylist.map((country) {
                                return DropdownMenuItem<String>(
                                  value: country["name"],
                                  child: Text(
                                    country["name"],
                                    style: TextStyle(fontSize: 13),
                                  ),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  final Map<String, int> countryNameToIdMap = {};
                                  for (var country in state.countrylist) {
                                    countryNameToIdMap[country["name"]] = country["id"];
                                  }

                                  selectedCountryName = newValue;
                                  selectedCountryId = countryNameToIdMap[newValue];

                                  // print(selectedCountryId);
                                  // print(selectedCountryName);
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'Select a country',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black), // Change to your desired color
                                ),
                              ),
                            );
                          }
                          return Container();
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  width: 315.w,
                  child: Row(
                    children: [
                      Checkbox(
                        value: ischeckbox,
                        onChanged: (bool? newValue) {
                          setState(() {
                            ischeckbox = newValue!;
                          });
                        },
                      ),
                      Text(
                        "I accept the ",
                        style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w400),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final Uri _url = Uri.parse('https://quizva.com/terms-of-service');
                          if (!await launchUrl(_url)) {
                            throw Exception('Could not launch $_url');
                          }
                        },
                        child: Text(
                          "terms and conditions",
                          style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w400, color: Color(0xFF078669)),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 180.h,
                  alignment: Alignment.bottomCenter,
                  child: Column(children: [
                    _isLoading
                        ? AllService.LoadingToast()
                        : ButtonWidget(
                            height: 45.h,
                            color: Color(0xFF078669),
                            onPressed: () async {
                              final connectivityResult = await (Connectivity().checkConnectivity());
                              if (connectivityResult == ConnectivityResult.mobile ||
                                  connectivityResult == ConnectivityResult.wifi ||
                                  connectivityResult == ConnectivityResult.ethernet) {
                                if (_formKey.currentState!.validate()) {
                                  if (ischeckbox == false) {
                                    return _showSnackBar();
                                  }
                                  String email = emailController.text;
                                  String firstName = firstNameController.text;
                                  String lastName = lastNameController.text;
                                  String password = passwordController.text;
                                  String confrimPassword = confrimPasswordController.text;
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  Map userCreste =
                                      await Repositores().SignUp(firstName, lastName, email, password, confrimPassword, selectedCountryId.toString());

                                  if (userCreste['status'] == true) {
                                    Map<String, dynamic> userData = userCreste['data']['user'];
                                    String firstName = userData['first_name'];
                                    String lastName = userData['last_name'];
                                    String email = userData['email'];

                                    String updated_at = userData['updated_at'];
                                    String created_at = userData['created_at'];
                                    int userId = userData['id'];
                                    String token = userCreste['data']['token'];
                                    g_isVerified = userData['email_verified_at'].toString();
                                    g_token = token;
                                    SqliteService().UserDataInsert(firstName, lastName, email, userData['email_verified_at'].toString(), updated_at,
                                        created_at, userId.toString(), token);
                                    //use login session insert
                                    List userLog = await SqliteService().getUserLog();
                                    if (userLog.isEmpty) {
                                      await SqliteService().userlogInsert("True");
                                    } else {
                                      await SqliteService().userlogUpdate('True');
                                    }

                                    await QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.success,
                                      text: "Account Created Successfully!",
                                    );
                                    Navigator.pushNamed(context, VerificationPage.pageName);
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  } else {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    await QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.error,
                                      text: userCreste['message'],
                                    );
                                  }
                                } else {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              } else {
                                showDialogBox();
                              }
                            },
                            title: "Sign Up",
                          ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final connectivityResult = await (Connectivity().checkConnectivity());
                            if (connectivityResult == ConnectivityResult.mobile ||
                                connectivityResult == ConnectivityResult.wifi ||
                                connectivityResult == ConnectivityResult.ethernet) {
                              Navigator.pushNamed(context, SignInPage.pageName);
                            } else {
                              showDialogBox();
                            }
                          },
                          child: Text(
                            "Sign In",
                            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400, color: Color(0xFF078669)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isSnackBarVisible = false;

  void _showSnackBar() {
    if (!isSnackBarVisible) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Click the checkbox if you agree to the terms and conditions"),
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
                Navigator.pop(context, 'Cancel');
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
}
