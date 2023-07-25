import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference questionsCollection = FirebaseFirestore.instance.collection('LeadQuestions');

class LeadQuestions {
  List<Screen> screens;
  String type;
  LeadQuestions({required this.screens, required this.type});

  factory LeadQuestions.fromJson(Map<String, dynamic> json) {
    List<Screen> screens = List<Screen>.from(json['screens'].map((screen) => Screen.fromJson(screen)).toList());
    return LeadQuestions(screens: screens, type: json["type"]);
  }

  Map<String, dynamic> toJson() {
    return {'screens': screens.map((screen) => screen.toJson()).toList(), "type": type};
  }

  // Get all Questions data from Firestore
  static Future<List<LeadQuestions>> getAllQuestionssFromFirestore() async {
    final List<LeadQuestions> questionss = [];
    try {
      QuerySnapshot querySnapshot = await questionsCollection.get();
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          LeadQuestions questions = LeadQuestions.fromJson(data);
          questionss.add(questions);
        }
      }
      return questionss;
    } catch (e) {
      print('Error getting Questions data: $e');
    }
    return questionss;
  }

  static Future<void> addScreens(List<LeadQuestions> screens) async {
    try {
      for (LeadQuestions screen in screens) {
        final DocumentReference documentReference = await questionsCollection.add(screen.toJson());
        print('Screen added with ID: ${documentReference.id}');
      }
    } catch (e) {
      print('Error adding screens to Firestore: $e');
    }
  }
}

class Screen {
  String screenId;
  List<Question> questions;
  String previousScreenId;
  String nextScreenId;
  bool isActive;
  String? title;

  Screen({
    required this.screenId,
    required this.questions,
    required this.previousScreenId,
    required this.nextScreenId,
    required this.isActive,
    this.title,
  });

  factory Screen.fromJson(Map<String, dynamic> json) {
    List<Question> questions = List<Question>.from(json['questions'].map((question) => Question.fromJson(question)).toList());
    return Screen(
        screenId: json['screenId'],
        questions: questions,
        previousScreenId: json['previousScreenId'],
        nextScreenId: json['nextScreenId'],
        isActive: json['isActive'],
        title: json["title"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'screenId': screenId,
      'questions': questions.map((question) => question.toJson()).toList(),
      'previousScreenId': previousScreenId,
      'nextScreenId': nextScreenId,
      'isActive': isActive,
      "title": title
    };
  }
}

class Question {
  int questionId;
  String questionTitle;
  String questionOptionType;
  dynamic questionOption;

  Question({
    required this.questionId,
    required this.questionTitle,
    required this.questionOptionType,
    required this.questionOption,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      questionId: json['questionId'],
      questionTitle: json['questionTitle'],
      questionOptionType: json['questionOptionType'],
      questionOption: json['questionOption'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'questionTitle': questionTitle,
      'questionOptionType': questionOptionType,
      'questionOption': questionOption,
    };
  }

  // @override
  // String toString() {
  //   return "Question(questionId: $questionId, questionTitle: $questionTitle, questionOptionType: $questionOptionType, questionOption: $questionOption)";
  // }
}
