import 'package:flutter/cupertino.dart';
import 'package:quiz/pages/credentials/F_password_verification_code.dart';
import 'package:quiz/pages/credentials/reset_password.dart';
import 'package:quiz/pages/credentials/reset_password_success.dart';
import 'package:quiz/pages/credentials/sign%20in.dart';

import 'package:quiz/pages/credentials/sign_up_page.dart';
import 'package:quiz/pages/credentials/verification_code.dart';
import 'package:quiz/pages/home_page.dart';
import 'package:quiz/pages/leaderboard/leaderboardPage.dart';
import 'package:quiz/pages/profile/edit_profile.dart';
import 'package:quiz/pages/profile/profile_page.dart';
import 'package:quiz/pages/quize_page/quizSubmitPage.dart';
import 'package:quiz/pages/searchResult/searchQuestions.dart';
import 'package:quiz/pages/searchResult/searchQuiz.dart';
import 'package:quiz/pages/splashscreen.dart';
import 'package:quiz/pages/subject/subject_all.dart';

Map<String, Widget Function(BuildContext)> pageRoute(BuildContext context) {
  return {
    '/': (context) => SplashScreen(),
    SignInPage.pageName: (context) => const SignInPage(),
    SignUpPage.pageName: (context) => const SignUpPage(),
    HomePage.pageName: (context) => const HomePage(),
    ProfilePage.pageName: (context) => const ProfilePage(),
    // TopicPage.pageName: (context) => const TopicPage(),
    // IntroductionPage.pageName: (context) => const IntroductionPage(),
    // IntroductionStartNowPage.pageName: (context) => const IntroductionStartNowPage(),
    // QuizPage.pageName: (context) => const QuizPage(),
    ResetPasssword.pageName: (context) => const ResetPasssword(),
    VerificationPage.pageName: (context) => const VerificationPage(),
    EditProfile.pageName: (context) => const EditProfile(),
    SubjectAll.pageName: (context) => SubjectAll(),
    leaderboardPage.pageName: (context) => leaderboardPage(),
    QuizSubmitPage.pageName: (context) => QuizSubmitPage(),
    ForgetPasswordVerificationPage.pageName: (context) => ForgetPasswordVerificationPage(),
    ResetPassowrdSuccess.pageName: (context) => ResetPassowrdSuccess(),
    SearchQuiz.pageName: (context) => SearchQuiz(),
  };
}
