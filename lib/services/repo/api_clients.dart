class APIClients {
  //static const String BASE_URL = 'https://dev.quizva.com/api';
  static const String BASE_URL = 'https://quizva.com/api';

  static const String signUpApi = '${BASE_URL}/sign-up';
  static const String signInApi = '${BASE_URL}/sign-in';
  static const String countriesApi = '${BASE_URL}/countries';
  static const String otpVarificationApi = '${BASE_URL}/sign-up/email-verification';
  static const String resendOtpVarificationApi = '${BASE_URL}/sign-up/email-verification/resend';
  static const String GetProfileApi = '${BASE_URL}/profile';
  static const String quizDetailsApi = '${BASE_URL}/quizzes';
  static const String leaderBoradApi = '${BASE_URL}/leader-board';
  static const String forgetPasswordApi = '${BASE_URL}/forget-password';
  static const String forgetPasswordSucessApi = '${BASE_URL}/reset-password';
  static const String EditProfileApi = '${BASE_URL}/profile';
}
