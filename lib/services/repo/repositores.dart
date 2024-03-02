import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as https;
import 'package:http/http.dart';
import 'package:quiz/services/all_services/all_services.dart';
import 'package:quiz/services/global.dart';
import 'package:quiz/services/models/quiz_models.dart';

import 'package:quiz/services/repo/api_clients.dart';
import 'package:quiz/services/sqflitebatabase/database_service.dart';

class Repositores {
  Future<Map<String, dynamic>> countriesGet() async {
    final url = Uri.parse(APIClients.countriesApi);
    final headers = {'Content-Type': 'application/json'};
    // Map<String, String> body = {"nbrAccessToken": nbrAccessToken, "cipherText": "", "deviceId": deviceId, "currentUser": g_currentUser};
    try {
      Response response = await https.get(
        url,
        headers: headers,
      );
      //print(response.body);
      //print("afikkkkkkkkkk");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print("country api resonse");
        print(response.body);
        return jsonDecode(response.body);
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<Map> SignUp(String first_name, String last_name, String email, String password, String password_confirmation, String country_id) async {
    final url = Uri.parse(APIClients.signUpApi);
    final headers = {'Accept': 'application/json', 'Content-Type': 'application/json'};
    Map<String, String> body = {
      "first_name": first_name,
      "last_name": last_name,
      "email": email,
      "password": password,
      "password_confirmation": password_confirmation,
      country_id: country_id
    };
    print(body);
    try {
      final Response response = await https.post(url, headers: headers, body: jsonEncode(body));
      print("create user api response ${response.body}");
      print(response.statusCode);
      if (response.statusCode == 201) {
        print("User Create status code :- ${response.statusCode}");

        return jsonDecode(response.body);
      } else {
        return jsonDecode(response.body);
        print('User create faild: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<Map> SignIn(String email, String password) async {
    final url = Uri.parse(APIClients.signInApi);
    final headers = {'Accept': 'application/json', 'Content-Type': 'application/json', 'Authorization': 'Bearer $g_token'};
    Map<String, String> body = {"email": email, "password": password};
    print(body);
    try {
      final Response response = await https.post(url, headers: headers, body: jsonEncode(body));
      print(" user  sign in api response ${response.body}");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print("user  sign in  status code :- ${response.statusCode}");

        return jsonDecode(response.body);
      } else {
        print('user  sign in  faild: ${response.reasonPhrase}');
        return jsonDecode(response.body);
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<Map> OtpVarificationSubmit(String OTP) async {
    final url = Uri.parse(APIClients.otpVarificationApi);
    List userinfo = await SqliteService().getUserData();
    if (userinfo.isNotEmpty) {
      g_token = userinfo[0]['token'];
    }
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $g_token',
    };
    Map<String, String> body = {"otp_code": OTP};
    print(body);
    try {
      final Response response = await https.post(url, headers: headers, body: jsonEncode(body));
      print("otp api response ${response.body}");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print("otp api status code :- ${response.statusCode}");

        return jsonDecode(response.body);
      } else {
        print('otp faild: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<Map> ResendVarification() async {
    final url = Uri.parse(APIClients.resendOtpVarificationApi);
    List userinfo = await SqliteService().getUserData();
    if (userinfo.isNotEmpty) {
      g_token = userinfo[0]['token'];
    }
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $g_token',
    };
    Map<String, String> body = {};
    print(body);
    try {
      final Response response = await https.post(url, headers: headers, body: jsonEncode(body));
      print("resned otp api response ${response.body}");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(" resned otp api status code :- ${response.statusCode}");

        return jsonDecode(response.body);
      } else {
        print(' resned otp faild: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<Map> forgetPassword(String email) async {
    final url = Uri.parse(APIClients.forgetPasswordApi);
    List userinfo = await SqliteService().getUserData();
    if (userinfo.isNotEmpty) {
      g_token = userinfo[0]['token'];
    }
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $g_token',
    };
    Map<String, String> body = {
      "email": email,
    };
    print(body);
    try {
      final Response response = await https.post(url, headers: headers, body: jsonEncode(body));
      print("forgetPasswordapi response ${response.body}");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print("forgetPasswordapi status code :- ${response.statusCode}");

        return jsonDecode(response.body);
      } else {
        print(' forgetPasswordfaild: ${response.reasonPhrase}');
        return jsonDecode(response.body);
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<Map> forgetPasswordSucess(String email, String password, String passwordConfirmation, String code) async {
    final url = Uri.parse(APIClients.forgetPasswordSucessApi);
    List userinfo = await SqliteService().getUserData();
    if (userinfo.isNotEmpty) {
      g_token = userinfo[0]['token'];
    }
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $g_token',
    };
    Map<String, String> body = {
      "email": email,
      "password": password,
      "password_confirmation": passwordConfirmation,
      "otp": code.toString(),
    };
    print("forgetPasswordSucess $body");
    try {
      final Response response = await https.post(url, headers: headers, body: jsonEncode(body));
      print("forgetPasswordSucess response ${response.body}");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print("forgetPasswordSucess status code :- ${response.statusCode}");

        return jsonDecode(response.body);
      } else {
        print(' forgetPasswordSucess: ${response.reasonPhrase}');
        return jsonDecode(response.body);
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  // Future<List<dynamic>> tryafik(int currentPage) async {
  //   final url = Uri.parse('https://jsonplaceholder.typicode.com/posts?_page=$currentPage&_limit=10');

  //   final headers = {'Accept': 'application/json', 'Content-Type': 'application/json'};
  //   try {
  //     final Response response = await https.get(url);
  //     print("pagesss response ${response.body}");
  //     print(response.statusCode);
  //     if (response.statusCode == 200) {
  //       print("pagesss status code :- ${response.statusCode}");

  //       return jsonDecode(response.body);
  //     } else {
  //       print('pagesss faild: ${response.reasonPhrase}');
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  //   return [];
  // }

  Future<Map<String, dynamic>> subjectApi(int currentPage) async {
    final url = Uri.parse('${APIClients.BASE_URL}/programs/programming/subjects?page=$currentPage');

    final headers = {'Accept': 'application/json', 'Content-Type': 'application/json'};
    print("YYYYYYYYYYYYYYYYYYYYYYYYYYYY");
    try {
      final Response response = await https.get(url);
      print(response.statusCode);
      print("pagesss response ${response.body}");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print("pagesss status code :- ${response.statusCode}");

        return jsonDecode(response.body);
      } else {
        print('pagesss faild: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<Map<String, dynamic>> randomQuiz(int currentPage) async {
    final url = Uri.parse('${APIClients.BASE_URL}/random-quizzes?page=$currentPage');
    List userinfo = await SqliteService().getUserData();
    if (userinfo.isNotEmpty) {
      g_token = userinfo[0]['token'];
    }
    print("random       tttttttttt$g_token");

    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $g_token',
    };
    try {
      final Response response = await https.get(url, headers: headers);
      print("randomQuize ${response.body}");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print("randomQuiz status code :- ${response.statusCode}");

        return jsonDecode(response.body);
      } else {
        print('randomQuiz faild: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<Map<String, dynamic>> topicsOfSubject(String subjctName, int currentPage) async {
    final url = Uri.parse('${APIClients.BASE_URL}/subjects/$subjctName/topics?page=$currentPage');
    List userinfo = await SqliteService().getUserData();
    if (userinfo.isNotEmpty) {
      g_token = userinfo[0]['token'];
    }

    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $g_token',
    };
    try {
      final Response response = await https.get(url);
      print("topicsOfSubject api response ${jsonDecode(response.body)}");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print("topicsOfSubject api status code :- ${response.statusCode}");

        return jsonDecode(response.body);
      } else {
        print('pagesss faild: ${response.reasonPhrase}');
        return jsonDecode(response.body);
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<Map<String, dynamic>> topicsOfQuestions(String subjctName, int currentPage) async {
    final url = Uri.parse('${APIClients.BASE_URL}/topics/$subjctName/questions?page=$currentPage');
    List userinfo = await SqliteService().getUserData();
    if (userinfo.isNotEmpty) {
      g_token = userinfo[0]['token'];
    }
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $g_token',
    };
    try {
      final Response response = await https.get(url);
      print("topicsOfQuesiton api response ${jsonDecode(response.body)}");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print("topicsOfQuesiton api status code :- ${response.statusCode}");

        return jsonDecode(response.body);
      } else {
        print('topicsOfQuesiton  faild: ${response.reasonPhrase}');
        return jsonDecode(response.body);
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<Map<String, dynamic>> QuizTopic(String subjctName, int currentPage) async {
    final url = Uri.parse('${APIClients.BASE_URL}/topics/$subjctName/quizzes?page=$currentPage');
    List userinfo = await SqliteService().getUserData();
    if (userinfo.isNotEmpty) {
      g_token = userinfo[0]['token'];
    }

    print("aaaaaaaaaaaaaaaaaf111111111111 $g_token");
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $g_token',
    };
    try {
      final Response response = await https.get(url);
      print("QuizTopic api response ${jsonDecode(response.body)}");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print("QuizTopic api status code :- ${response.statusCode}");

        return jsonDecode(response.body);
      } else {
        print('QuizTopic  faild: ${response.reasonPhrase}');
        return jsonDecode(response.body);
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<QuizModel> quizDetails(String slug) async {
    final url = Uri.parse('${APIClients.quizDetailsApi}/$slug');

    List userinfo = await SqliteService().getUserData();
    if (userinfo.isNotEmpty) {
      g_token = userinfo[0]['token'];
    }

    print("aaaaaaaaaaaaaaaaaf111111111111 $g_token");

    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $g_token',
    };
    try {
      final Response response = await https.get(url);
      print("quizDetails api response ${jsonDecode(response.body)}");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print("quizDetails api status code :- ${response.statusCode}");
        log(response.body);
        return QuizModel.fromJson(jsonDecode(response.body));
      } else {
        print('quizDetails  faild: ${response.reasonPhrase}');
        return jsonDecode(response.body);
      }
    } catch (e) {
      print(e);
    }
    return QuizModel(message: '', status: false);
  }

  Future<Map<String, dynamic>> quizSubmit(String slug, Map<String, dynamic> result) async {
    final url = Uri.parse('${APIClients.BASE_URL}/quizzes/$slug/result');
    List userinfo = await SqliteService().getUserData();
    if (userinfo.isNotEmpty) {
      g_token = userinfo[0]['token'];
    }
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $g_token',
    };
    print("aaaeeeeeeeeeettttttttttttttttt$result");
    try {
      final Response response = await https.post(url, headers: headers, body: jsonEncode(result));
      print("quizSubmit api response ${jsonDecode(response.body)}");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print("quizSubmit api status code :- ${response.statusCode}");
        log(response.body);
        return jsonDecode(response.body);
      } else {
        print('quizSubmit  faild: ${response.reasonPhrase}');
        return jsonDecode(response.body);
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<Map<String, dynamic>> leaderBorad() async {
    final url = Uri.parse('${APIClients.leaderBoradApi}');
    List userinfo = await SqliteService().getUserData();
    if (userinfo.isNotEmpty) {
      g_token = userinfo[0]['token'];
    }
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $g_token',
    };
    try {
      final Response response = await https.get(url, headers: headers);
      print("leaderBorad api response ${jsonDecode(response.body)}");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print("leaderBorad api status code :- ${response.statusCode}");

        return jsonDecode(response.body);
      } else {
        print('leaderBorad   faild: ${response.reasonPhrase}');
        return jsonDecode(response.body);
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<Map<String, dynamic>> GetProfile() async {
    final url = Uri.parse('${APIClients.GetProfileApi}');
    List userinfo = await SqliteService().getUserData();
    if (userinfo.isNotEmpty) {
      g_token = userinfo[0]['token'];
    }
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $g_token',
    };
    try {
      final Response response = await https.get(url, headers: headers);
      print("get Profile api response ${jsonDecode(response.body)}");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print("get Profile api status code :- ${response.statusCode}");

        return jsonDecode(response.body);
      } else {
        print('get Profile   faild: ${response.reasonPhrase}');
        return jsonDecode(response.body);
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<Map<String, dynamic>> EditProfile(String first_name, String last_name, String gender, String phone, String city) async {
    final url = Uri.parse('${APIClients.EditProfileApi}');
    List userinfo = await SqliteService().getUserData();
    if (userinfo.isNotEmpty) {
      g_token = userinfo[0]['token'];
    }
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $g_token',
    };
    Map<String, String> body = {
      "first_name": first_name,
      "last_name": last_name,
      "gender": gender,
      "phone": phone,
      "city": city,
    };
    print(body);
    try {
      final Response response = await https.post(url, headers: headers, body: jsonEncode(body));
      print("EditProfileApi api response ${jsonDecode(response.body)}");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print("EditProfileApi api status code :- ${response.statusCode}");

        return jsonDecode(response.body);
      } else {
        print('EditProfileApi   faild: ${response.reasonPhrase}');
        return jsonDecode(response.body);
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<Map<String, dynamic>> SearchQuestions(int currentPage, String keyword) async {
    final url = Uri.parse('${APIClients.BASE_URL}/search?q=$keyword&type=questions&page=$currentPage');
    List userinfo = await SqliteService().getUserData();
    if (userinfo.isNotEmpty) {
      g_token = userinfo[0]['token'];
    }
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $g_token',
    };
    print("EEEEEEEEEEEEEEEE$keyword");
    try {
      final Response response = await https.get(url, headers: headers);
      print("SearchQuestions api response ${jsonDecode(response.body)}");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print("SearchQuestions api status code :- ${response.body}");

        return jsonDecode(response.body);
      } else {
        print('SearchQuestions   faild: ${response.reasonPhrase}');
        return jsonDecode(response.body);
      }
    } catch (e) {
      print("exception");
      print(e);
    }
    return {};
  }

  Future<Map<String, dynamic>> SearchQuiz(int currentPage, String keyword) async {
    final url = Uri.parse('${APIClients.BASE_URL}/search?q=$keyword&type=quizzes&page=$currentPage');
    List userinfo = await SqliteService().getUserData();
    if (userinfo.isNotEmpty) {
      g_token = userinfo[0]['token'];
    }
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $g_token',
    };
    print("EEEEEEEEEEEEEEEE  $keyword");
    try {
      final Response response = await https.get(url, headers: headers);
      print("SearchQuiz api response ${jsonDecode(response.body)}");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print("SearchQuiz api status code :- ${response.statusCode}");

        return jsonDecode(response.body);
      } else {
        print('SearchQuiz   faild: ${response.reasonPhrase}');
        return jsonDecode(response.body);
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  // Future<Map<String, dynamic>> uploadImage(File imageFile) async {
  //   try {
  //     String apiUrl = '${APIClients.BASE_URL}/profile/photo/update';
  //     var request = https.MultipartRequest('POST', Uri.parse(apiUrl));
  //     request.files.add(await https.MultipartFile.fromPath('profile_photo', imageFile.path));
  //     request.headers['Authorization'] = 'Bearer $g_token';
  //     var response = await request.send();
  //     if (response.statusCode == 200) {
  //       var responseData = await response.stream.bytesToString();
  //       Map<String, dynamic> parsedResponse = json.decode(responseData);
  //       print("photo upload api response${parsedResponse}");
  //       return parsedResponse;
  //     } else {
  //       var responseData = await response.stream.bytesToString();
  //       Map<String, dynamic> parsedResponse = json.decode(responseData);
  //       return parsedResponse;
  //     }
  //   } catch (e) {
  //     print('Error uploading image: $e');
  //     throw Exception('Failed to upload image. Error: $e');
  //   }
  // }
  Future<Map<String, dynamic>> uploadImage(File imageFile) async {
    String res = '';

    try {
      List userinfo = await SqliteService().getUserData();
      if (userinfo.isNotEmpty) {
        g_token = userinfo[0]['token'];
      }
      String apiUrl = '${APIClients.BASE_URL}/profile/photo/update';
      var request = https.MultipartRequest('POST', Uri.parse(apiUrl));
      request.files.add(await https.MultipartFile.fromPath('profile_photo', imageFile.path));
      request.headers['Authorization'] = 'Bearer $g_token';
      request.headers['Content-Type'] = ['application/json'].toString();
      request.headers['Accept'] = ['application/json'].toString();
      var response = await request.send();
      print('Status Code: ${response.statusCode}');
      print('Response Headers: ${response.headers}');
      print('Request Headers: ${request.headers}');
      print('Request Files: ${request.files}');

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        Map<String, dynamic> parsedResponse = json.decode(responseData);
        print("photo upload api response: $parsedResponse");
        return parsedResponse;
      } else {
        var responseData = await response.stream.bytesToString();
        print("Non-200 status code. Response: ${response.statusCode}");
        res = response.statusCode.toString();
        Map<String, dynamic> parsedResponse = json.decode(responseData);
        return {"StatusCode": response.statusCode};
      }
    } catch (e) {
      print('Error uploading image: $e');
      if (res.isEmpty) {
        print("2222222");
        return {"StatusCode": '413'};
      } else {
        print("1111111111");
        return {"StatusCode": res};
      }
    }
  }
}
