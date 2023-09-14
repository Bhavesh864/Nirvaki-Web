import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../riverpodstate/filterQuestions/lead_all_question.dart';
import '../../../riverpodstate/lead_filter_question.dart';

void updateLeadListInventory(WidgetRef ref, option, screenList) {
  final questionNotifier = ref.read(allLeadQuestion.notifier);
  final plotNotifier = ref.read(leadFilterPlotQuestion.notifier);
  final isCommercial = ref.read(leadFilterCommercialQuestion);
  final isCommercialNotifier = ref.read(leadFilterCommercialQuestion.notifier);
  final isRentNotifier = ref.read(leadFilterRentQuestion.notifier);
  // residental flow --------->

  if (option == "Rent" && !isCommercial) {
    questionNotifier.updateScreenIsActive(setTrueInScreens: [], setFalseInScreens: ["S10", "S8"]);
    isRentNotifier.toggleRentQuestionary(true);
  } else if (option == "Buy" && !isCommercial) {
    isRentNotifier.toggleRentQuestionary(false);
    questionNotifier.updateScreenIsActive(setTrueInScreens: ["S8", "S10"], setFalseInScreens: []);
  } else if (option == "Independent House/Villa") {
    plotNotifier.togglePlotQuestionary(false);
    questionNotifier.updateScreenIsActive(setTrueInScreens: ["S6", "S9", "S8"], setFalseInScreens: ["S10"]);
  } else if (option == "Apartment" || option == "Builder Floor" || option == "Farm House") {
    plotNotifier.togglePlotQuestionary(false);
    questionNotifier.updateScreenIsActive(setTrueInScreens: ["S9", "S8"], setFalseInScreens: ["S6", "S10"]);
  }
  if (option == "Plot") {
    plotNotifier.togglePlotQuestionary(true);
    questionNotifier.updateScreenIsActive(setTrueInScreens: ["S10"], setFalseInScreens: ["S6", "S9", "S8"]);
  }
  // common flow
  if (option == "Residential") {
    isCommercialNotifier.toggleCommericalQuestionary(false);
  }
  if (option == "Commercial") {
    isCommercialNotifier.toggleCommericalQuestionary(true);
  }

  // Commercial flow--------->
  // if (option == "Rent" && isCommercial) {
  //   questionNotifier.updateScreenIsActive(setTrueInScreens: [], setFalseInScreens: []);
  //   isRentNotifier.toggleRentQuestionary(true);
  // } else if (option == "Buy" && isCommercial) {
  //   isRentNotifier.toggleRentQuestionary(false);
  //   questionNotifier.updateScreenIsActive(setTrueInScreens: [], setFalseInScreens: []);
  // }
  if (option == "Land") {
    List<String> setTofalse = ["S7", "S8", "S9", "S10", "S11", "S12", "S13", "S14", "S17"];
    questionNotifier.updateScreenIsActive(setTrueInScreens: ["S16", "S6"], setFalseInScreens: setTofalse);
  }
  if (option == "Constructed Property") {
    List<String> setTofalse = ["S6", "S16", "S17"];
    // List<String> setToTrue = ["S7"];
    List<String> setToTrue = ["S7", "S8", "S9", "S10", "S11", "S12", "S13", "S14", "S17"];
    questionNotifier.updateScreenIsActive(setTrueInScreens: setToTrue, setFalseInScreens: setTofalse);
  }
  if (option == "Under Construction") {
    List<String> setTofalse = ["S6", "S16"];
    // List<String> setToTrue = ["S7"];
    List<String> setToTrue = ["S7", "S8", "S9", "S10", "S11", "S12", "S13", "S14", "S17"];
    questionNotifier.updateScreenIsActive(setTrueInScreens: setToTrue, setFalseInScreens: setTofalse);
  }
  if (option == "Office") {
    List<String> setTofalse = ["S9", "S10", "S11", "S12", "S13", "S14"];
    List<String> setToTrue = ["S8"];
    questionNotifier.updateScreenIsActive(setTrueInScreens: setToTrue, setFalseInScreens: setTofalse);
  }
  if (option == "Retail") {
    List<String> setTofalse = ["S8", "S10", "S11", "S12", "S13", "S14"];
    List<String> setToTrue = ["S9"];
    questionNotifier.updateScreenIsActive(setTrueInScreens: setToTrue, setFalseInScreens: setTofalse);
  }
  if (option == "Industrial") {
    List<String> setTofalse = ["S8", "S9", "S10", "S11", "S12", "S13", "S14"];
    List<String> setToTrue = [];
    questionNotifier.updateScreenIsActive(setTrueInScreens: setToTrue, setFalseInScreens: setTofalse);
  }
  if (option == "Hospitality") {
    List<String> setTofalse = ["S8", "S9", "S11", "S12", "S13"];
    List<String> setToTrue = ["S10", "S14"];
    questionNotifier.updateScreenIsActive(setTrueInScreens: setToTrue, setFalseInScreens: setTofalse);
  }
  if (option == "Healthcare") {
    List<String> setTofalse = ["S8", "S9", "S10", "S12", "S13", "S14"];
    List<String> setToTrue = ["S11"];
    questionNotifier.updateScreenIsActive(setTrueInScreens: setToTrue, setFalseInScreens: setTofalse);
  }
  if (option == "Institutional") {
    List<String> setTofalse = ["S8", "S9", "S10", "S11", "S12", "S13", "S14"];
    List<String> setToTrue = [];
    questionNotifier.updateScreenIsActive(setTrueInScreens: setToTrue, setFalseInScreens: setTofalse);
  }
  if (option == "School") {
    List<String> setTofalse = ["S8", "S9", "S10", "S11", "S12", "S14"];
    List<String> setToTrue = ["S13"];
    questionNotifier.updateScreenIsActive(setTrueInScreens: setToTrue, setFalseInScreens: setTofalse);
  }
  if (option == "Warehouse") {
    List<String> setTofalse = ["S8", "S9", "S10", "S11", "S12", "S13", "S14"];
    List<String> setToTrue = [];
    questionNotifier.updateScreenIsActive(setTrueInScreens: setToTrue, setFalseInScreens: setTofalse);
  }
  if (option == "Mall") {
    List<String> setTofalse = ["S8", "S9", "S10", "S11", "S12", "S13", "S14"];
    List<String> setToTrue = [];
    questionNotifier.updateScreenIsActive(setTrueInScreens: setToTrue, setFalseInScreens: setTofalse);
  }
  if (option == "Shopping Complex") {
    List<String> setTofalse = ["S8", "S9", "S10", "S11", "S12", "S13", "S14"];
    List<String> setToTrue = [];
    questionNotifier.updateScreenIsActive(setTrueInScreens: setToTrue, setFalseInScreens: setTofalse);
  }
  if (option == "Shop Cum Office") {
    List<String> setTofalse = ["S8", "S9", "S10", "S11", "S12", "S13", "S14"];
    List<String> setToTrue = [];
    questionNotifier.updateScreenIsActive(setTrueInScreens: setToTrue, setFalseInScreens: setTofalse);
  }
  if (option == "Hospital") {
    List<String> setTofalse = [];
    List<String> setToTrue = ["S12"];
    questionNotifier.updateScreenIsActive(setTrueInScreens: setToTrue, setFalseInScreens: setTofalse);
  }
  if (option == "Clinic") {
    List<String> setTofalse = ["S12"];
    List<String> setToTrue = [];
    questionNotifier.updateScreenIsActive(setTrueInScreens: setToTrue, setFalseInScreens: setTofalse);
  }
}
