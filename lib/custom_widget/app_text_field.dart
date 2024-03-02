import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? textController;
  final String? labelText;
  Function(String)? onChanged;
  final Icon? profixIcon1;
  final double? width;
  final double? hight;
  final String? hinntText;
  bool? iscenter;
  final bool? textEnable;
  final bool? inputtype;
  bool isObscure;
  final String? errorText;

  AppTextField(
      {super.key,
      this.onChanged,
      this.inputtype = true,
      this.textEnable = true,
      this.isObscure = false,
      this.textController,
      this.labelText,
      this.profixIcon1,
      this.width = 310,
      this.hight = 45,
      this.hinntText,
      this.errorText,
      this.iscenter = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(left: 10.w, right: 20.w),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(blurRadius: 3, spreadRadius: 1, offset: Offset(1, 1), color: Colors.grey.withOpacity(0.2))]),
      child: SizedBox(
        height: hight,
        width: width,
        child: TextField(
          onChanged: onChanged,

          keyboardType: inputtype == false ? TextInputType.number : TextInputType.text,
          enabled: textEnable,
          textAlign: iscenter! ? TextAlign.center : TextAlign.start,
          obscureText: isObscure ? true : false,
          controller: textController,
          //hinntText ,border,enableBorder, profixIcon, focussedBorder/
          decoration: InputDecoration(
            hintText: hinntText,
            // hintText: hinntText,
            labelText: labelText,
            labelStyle: const TextStyle(color: Colors.black),
            prefixIcon: profixIcon1,
            errorText: errorText,

            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.sp), borderSide: BorderSide(width: 1.0.w, color: Colors.black)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(width: 1.0.w, color: Colors.black)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.sp),
            ),
          ),
        ),
      ),
    );
  }
}
