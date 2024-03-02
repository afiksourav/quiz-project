import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String title;
  final Function() onPressed;
  final double? width;
  final double? height;
  final Color? color;
  final Color? textcolor;
  final IconData? icon;
  final bool? isIcon;
  ButtonWidget(
      {super.key,
      required this.onPressed,
      required this.title,
      this.isIcon = false,
      this.width = 310,
      this.height = 40,
      this.textcolor,
      this.color = const Color.fromARGB(255, 31, 155, 93),
      this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              isIcon!
                  ? Icon(
                      icon,
                      color: Colors.green,
                      size: 30,
                    )
                  : Container(),
              //SizedBox(width: 5),
              Center(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 13, color: textcolor, fontWeight: FontWeight.w400),
                ),
              )
            ],
          )),
    );
  }
}
