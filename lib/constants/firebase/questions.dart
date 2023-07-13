import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference questionsCollection =
    FirebaseFirestore.instance.collection('questions');

class Questions {
  List<Screens>? screens;

  Questions({this.screens});

  Questions.fromJson(Map<String, dynamic> json) {
    if (json["screens"] is List) {
      screens = json["screens"] == null
          ? null
          : (json["screens"] as List).map((e) => Screens.fromJson(e)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if (screens != null) {
      _data["screens"] = screens?.map((e) => e.toJson()).toList();
    }
    return _data;
  }

  // Future<void> addQuestions(List<Questions> questions) async {
  //   try {
  //     final DocumentReference documentReference = await questionsCollection.add(
  //         {'screens': questions.map((question) => question.toJson()).toList()});

  //     print('Document added with ID: ${documentReference.id}');
  //   } catch (e) {
  //     print('Error adding questions: $e');
  //   }
  // }

  static Future<void> addScreens(List<Questions> screens) async {
    try {
      for (Questions screen in screens) {
        final DocumentReference documentReference =
            await questionsCollection.add(screen.toJson());
        print('Screen added with ID: ${documentReference.id}');
      }
    } catch (e) {
      print('Error adding screens to Firestore: $e');
    }
  }

  // static Future<Questions> getAllScreens() async {
  //   try {
  //     final QuerySnapshot querySnapshot = await questionsCollection.get();
  //     final List<Questions> screensList = querySnapshot.docs.map((doc) {
  //       return Questions.fromJson(doc.data() as Map<String, dynamic>);
  //     }).toList();

  //     return screensList;
  //   } catch (e) {
  //     print('Error getting screens: $e');
  //     return [];
  //   }
  // }

  static Future<List<Questions>> getallquestions() async {
    try {
      final QuerySnapshot querySnapshot = await questionsCollection.get();
      final List<Questions> screensList = querySnapshot.docs.map((doc) {
        return Questions.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
      return screensList;
    } catch (error) {
      // print('Failed to get Inventory items: $error');
      return [];
    }
  }
}

class Screens {
  String? screenId;
  List<Questions1>? questions;
  String? previousScreenId;
  String? nextScreenId;
  bool? isActive;

  Screens(
      {this.screenId,
      this.questions,
      this.previousScreenId,
      this.nextScreenId,
      this.isActive});

  Screens.fromJson(Map<String, dynamic> json) {
    if (json["screenId"] is String) {
      screenId = json["screenId"];
    }
    if (json["questions"] is List) {
      questions = json["questions"] == null
          ? null
          : (json["questions"] as List)
              .map((e) => Questions1.fromJson(e))
              .toList();
    }
    if (json["previousScreenId"] is String) {
      previousScreenId = json["previousScreenId"];
    }
    if (json["nextScreenId"] is String) {
      nextScreenId = json["nextScreenId"];
    }
    if (json["isActive"] is bool) {
      isActive = json["isActive"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["screenId"] = screenId;
    if (questions != null) {
      _data["questions"] = questions?.map((e) => e.toJson()).toList();
    }
    _data["previousScreenId"] = previousScreenId;
    _data["nextScreenId"] = nextScreenId;
    _data["isActive"] = isActive;
    return _data;
  }
}

class Questions1 {
  int? questionId;
  String? questionTitle;
  String? questionOptionType;
  List<String>? questionOption;

  Questions1(
      {this.questionId,
      this.questionTitle,
      this.questionOptionType,
      this.questionOption});

  Questions1.fromJson(Map<String, dynamic> json) {
    if (json["questionId"] is int) {
      questionId = json["questionId"];
    }
    if (json["questionTitle"] is String) {
      questionTitle = json["questionTitle"];
    }
    if (json["questionOptionType"] is String) {
      questionOptionType = json["questionOptionType"];
    }
    if (json["questionOption"] is List) {
      questionOption = json["questionOption"] == null
          ? null
          : List<String>.from(json["servantroom"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["questionId"] = questionId;
    data["questionTitle"] = questionTitle;
    data["questionOptionType"] = questionOptionType;
    data["questionOption"] = questionOption;
    return data;
  }
}
