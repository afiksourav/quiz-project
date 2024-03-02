import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quiz/bloc/country_bloc/country_bloc.dart';
import 'package:quiz/bloc/topicOfQuestions/topic_of_questions_bloc.dart';
import 'package:quiz/bloc/topicOfSubjectBloc/topic_of_subject_bloc.dart';
import 'package:quiz/pages/leaderboard/leaderboardPage.dart';
import 'package:quiz/pages/try/try.dart';
import 'package:quiz/services/route/pageRoute.dart';
import 'package:quiz/bloc/userProfilebloc/profile_bloc.dart';

import 'pages/quize_page/quizSubmitPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (context) => CountryBloc()),
    BlocProvider(create: (context) => TopicOfSubjectBloc()),
    BlocProvider(create: (context) => TopicOfQuestionsBloc()),
    BlocProvider(create: (context) => ProfileBloc()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(370, 710),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              routes: pageRoute(context),

              //home: tryAPp(),
            ),
          );
        });
  }
}
