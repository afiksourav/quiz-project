// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';

// class tryAPp extends StatefulWidget {
//   const tryAPp({super.key});

//   @override
//   State<tryAPp> createState() => _tryAPpState();
// }

// class _tryAPpState extends State<tryAPp> {
//   @override
//   Widget build(BuildContext context) {
//     var char = "abcdefghijklmnopqrxtuvwxyz".toUpperCase();

//     return Scaffold(
//       appBar: AppBar(),
//       body: Column(
//         children: [
//           Expanded(
//             child: Container(
//               padding: EdgeInsets.all(8),
//               child: GridView.count(
//                 physics: NeverScrollableScrollPhysics(),
//                 crossAxisCount: 4,
//                 children: char.split("").map((e) {
//                   return ElevatedButton(onPressed: () {}, child: Text(e));
//                 }).toList(),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
