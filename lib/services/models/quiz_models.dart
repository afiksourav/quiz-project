import 'dart:convert';

QuizModel quizModelFromJson(String str) => QuizModel.fromJson(json.decode(str));
String quizModelToJson(QuizModel data) => json.encode(data.toJson());

class QuizModel {
  bool status;
  String message;
  Data? data;

  QuizModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) => QuizModel(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data!.toJson(),
      };
}

class Data {
  int id;
  String title;
  String slug;
  dynamic shortDescription;
  String longDescription;
  int status;
  int publicAccessibility;
  int guestAccessibility;
  int userAccessibility;
  int memberAccessibility;
  int privateAccessibility;
  int totalScore;
  int totalTime;
  int programId;
  int subjectId;
  int topicId;
  int totalVisitor;
  int avgScore;
  dynamic topScorer;
  DateTime createdAt;
  DateTime updatedAt;
  List<Question> questions;

  Data({
    required this.id,
    required this.title,
    required this.slug,
    required this.shortDescription,
    required this.longDescription,
    required this.status,
    required this.publicAccessibility,
    required this.guestAccessibility,
    required this.userAccessibility,
    required this.memberAccessibility,
    required this.privateAccessibility,
    required this.totalScore,
    required this.totalTime,
    required this.programId,
    required this.subjectId,
    required this.topicId,
    required this.totalVisitor,
    required this.avgScore,
    required this.topScorer,
    required this.createdAt,
    required this.updatedAt,
    required this.questions,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        title: json["title"],
        slug: json["slug"],
        shortDescription: json["short_description"],
        longDescription: json["long_description"],
        status: json["status"],
        publicAccessibility: json["public_accessibility"],
        guestAccessibility: json["guest_accessibility"],
        userAccessibility: json["user_accessibility"],
        memberAccessibility: json["member_accessibility"],
        privateAccessibility: json["private_accessibility"],
        totalScore: json["total_score"],
        totalTime: json["total_time"],
        programId: json["program_id"],
        subjectId: json["subject_id"],
        topicId: json["topic_id"],
        totalVisitor: json["total_visitor"],
        avgScore: json["avg_score"],
        topScorer: json["top_scorer"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        questions: List<Question>.from(json["questions"].map((x) => Question.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "slug": slug,
        "short_description": shortDescription,
        "long_description": longDescription,
        "status": status,
        "public_accessibility": publicAccessibility,
        "guest_accessibility": guestAccessibility,
        "user_accessibility": userAccessibility,
        "member_accessibility": memberAccessibility,
        "private_accessibility": privateAccessibility,
        "total_score": totalScore,
        "total_time": totalTime,
        "program_id": programId,
        "subject_id": subjectId,
        "topic_id": topicId,
        "total_visitor": totalVisitor,
        "avg_score": avgScore,
        "top_scorer": topScorer,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
      };
}

class Question {
  int id;
  String title;
  String? longDescription;
  dynamic shortDescription;
  Type type;
  int laravelThroughKey;
  List<Option> options;

  Question({
    required this.id,
    required this.title,
    required this.longDescription,
    required this.shortDescription,
    required this.type,
    required this.laravelThroughKey,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json["id"],
        title: json["title"],
        longDescription: json["long_description"],
        shortDescription: json["short_description"],
        type: typeValues.map[json["type"]]!,
        laravelThroughKey: json["laravel_through_key"],
        options: List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "long_description": longDescription,
        "short_description": shortDescription,
        "type": typeValues.reverse[type],
        "laravel_through_key": laravelThroughKey,
        "options": List<dynamic>.from(options.map((x) => x.toJson())),
      };
}

class Option {
  int id;
  int questionId;
  String title;

  Option({
    required this.id,
    required this.questionId,
    required this.title,
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        id: json["id"],
        questionId: json["question_id"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question_id": questionId,
        "title": title,
      };
}

enum Type { SINGLE_CHOOSE }

final typeValues = EnumValues({"single choose": Type.SINGLE_CHOOSE});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
