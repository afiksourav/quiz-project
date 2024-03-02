import 'dart:async';

import 'package:flutter/material.dart';

class AllService {
  static Widget LoadingToast() {
    return const SizedBox(
      width: 48,
      height: 48,
      child: CircularProgressIndicator(
        backgroundColor: Color(0xFF078669),
        strokeWidth: 6,
      ),
    );
  }


// --- Button Widget --- //

}

class Toast {
  static Future<void> success({required BuildContext context, required String text, int duration = 1, int? fontSize}) {
    return showDialog(
      context: context,
      builder: (context) {
        Timer.periodic(Duration(seconds: duration), (timer) {
          timer.cancel();
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        });
        return AlertDialog(
          backgroundColor: Color(0xFF078669),
          content: Container(
            decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(150))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  text,
                  style: const TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const Icon(
                  Icons.check_box_outlined,
                  size: 60,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<void> warning({required BuildContext context, required String text, int duration = 1}) {
    return showDialog(
      context: context,
      builder: (context) {
        Timer.periodic(Duration(seconds: duration), (timer) {
          timer.cancel();
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        });
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 124, 45, 39),
          content: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  text,
                  style: const TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const Icon(
                  Icons.warning_amber_rounded,
                  size: 60,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
