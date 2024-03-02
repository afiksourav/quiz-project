import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quickalert/quickalert.dart';
import 'package:quiz/custom_widget/button.dart';
import 'package:quiz/pages/profile/profile_page.dart';
import 'package:quiz/services/all_services/all_services.dart';
import 'package:quiz/services/repo/repositores.dart';

class EditProfile extends StatefulWidget {
  static const pageName = 'edit_profile';
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool _isLoading = false;
  String? selectedGender;
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
  Widget build(BuildContext context) {
    Map profileInfo = ModalRoute.of(context)!.settings.arguments as Map;
    print("profile einfoooooo");

    print(profileInfo['gender']);
    TextEditingController firstNameController = TextEditingController(text: profileInfo['first_name']);
    TextEditingController lastNameController = TextEditingController(text: profileInfo['last_name']);
    TextEditingController phoneController = TextEditingController(text: profileInfo['phone'].toString().isEmpty ? '' : profileInfo['phone']);
    TextEditingController genderController = TextEditingController(text: profileInfo['gender'].toString().isEmpty ? '' : profileInfo['gender']);
    // TextEditingController aboutController = TextEditingController(text: profileInfo['about'].toString().isEmpty ? '' : profileInfo['about']);
    TextEditingController cityController = TextEditingController(text: profileInfo['city'].toString().isEmpty ? '' : profileInfo['city']);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 50.h,
              ),
              Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
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
                  SizedBox(
                    width: 60.w,
                  ),
                  Text(
                    "Edit Profile",
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500, color: Color(0xFF1D2746)),
                  )
                ],
              ),
              SizedBox(
                height: 50.h,
              ),
              Column(
                children: [
                  TextFormField(
                    controller: firstNameController,
                    decoration: const InputDecoration(
                      hintText: "First Name",
                      border: OutlineInputBorder(),
                    ),
                    //validator: (value) => value!.isEmpty ? "Last Name Required" : null,
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  TextFormField(
                    controller: lastNameController,
                    decoration: const InputDecoration(
                      hintText: "Last Name",
                      border: OutlineInputBorder(),
                    ),
                    //validator: (value) => value!.isEmpty ? "Last Name Required" : null,
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  // TextFormField(
                  //   controller: genderController,
                  //   decoration: const InputDecoration(
                  //     hintText: "Gender",
                  //     border: OutlineInputBorder(),
                  //   ),
                  //   //validator: (value) => value!.isEmpty ? "Last Name Required" : null,
                  // ),

                  Container(
                    width: double.infinity,
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: selectedGender,
                      // hint: Text('Choose Gender'),
                      onChanged: (String? value) {
                        setState(() {
                          // if (profileInfo['gender'] == null || profileInfo['gender'] == 'null') {
                          //   selectedGender = value;
                          //   print("qqq");
                          // } else {
                          //   print("111");
                          //   selectedGender = profileInfo['gender'].toString();
                          // }
                          selectedGender = value;
                        });
                      },
                      items: <String>['Male', 'Female']
                          .map((String gender) => DropdownMenuItem<String>(
                                value: gender,
                                child: Text(gender),
                              ))
                          .toList(),
                      decoration: InputDecoration(
                        labelText: profileInfo['gender'] == null || profileInfo['gender'] == 'null' ? 'Choose Gender' : profileInfo['gender'],
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black), // Change to your desired color
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     // Add form submission logic here
                  //     // For example, you can use Form.of(context).save() to save form data
                  //     print('Form submitted. Selected gender: $selectedGender');
                  //   },
                  //   child: Text('$selectedGender'),
                  // ),
                  TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      hintText: "Phone",
                      border: OutlineInputBorder(),
                    ),
                    //validator: (value) => value!.isEmpty ? "Last Name Required" : null,
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  TextFormField(
                    controller: cityController,
                    decoration: const InputDecoration(
                      hintText: "City",
                      border: OutlineInputBorder(),
                    ),
                    //validator: (value) => value!.isEmpty ? "Last Name Required" : null,
                  ),
                ],
              ),
              SizedBox(
                height: 50.h,
              ),
              _isLoading
                  ? AllService.LoadingToast()
                  : ButtonWidget(
                      height: 52.h,
                      width: 325.w,
                      color: Color(0xFF078669),
                      onPressed: () async {
                        final connectivityResult = await (Connectivity().checkConnectivity());
                        if (connectivityResult == ConnectivityResult.mobile ||
                            connectivityResult == ConnectivityResult.wifi ||
                            connectivityResult == ConnectivityResult.ethernet) {
                          String firstName = firstNameController.text;
                          String lastname = lastNameController.text;
                          // String gender = genderController.text;
                          String phone = phoneController.text;
                          String city = cityController.text;
                          print("eeeeeeeeeeeeeeeeeeeeeee  ${selectedGender}");
                          if (selectedGender.toString() == "null") {
                            print("LLLLLLLLLLLL");
                            selectedGender = profileInfo['gender'];
                          }

                          setState(() {
                            _isLoading = true;
                          });
                          Map EditProfile = await Repositores().EditProfile(firstName, lastname, selectedGender.toString(), phone, city);
                          if (EditProfile['status'] == true) {
                            await QuickAlert.show(
                              context: context,
                              type: QuickAlertType.success,
                              text: 'Edit Profile Successful',
                            );
                            setState(() {
                              _isLoading = false;
                            });
                            Navigator.of(context).pushNamedAndRemoveUntil(ProfilePage.pageName, (Route<dynamic> route) => false);
                          } else {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                          print("internet onnnnnn");
                        } else {
                          print("internet off");
                          showDialogBox();
                        }
                      },
                      title: "Save Change",
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
