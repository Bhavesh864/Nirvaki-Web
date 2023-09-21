import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../riverpodstate/filterQuestions/inventory_all_question.dart';
import '../../../riverpodstate/inventory_res_filter_question.dart';

void updateListInventory(WidgetRef ref, String option, screenList) {
  final questionNotifier = ref.read(allInventoryQuestion.notifier);
  final plotNotifier = ref.read(filterPlotQuestion.notifier);
  final isCommercial = ref.read(filterCommercialQuestion);
  final isCommercialNotifier = ref.read(filterCommercialQuestion.notifier);
  final isRentNotifier = ref.read(filterRentQuestion.notifier);
  // residental flow --------->

  if (option.contains("Rent") && !isCommercial) {
    questionNotifier.updateScreenIsActive(setTrueInScreens: ["S16"], setFalseInScreens: ["S8", "S10", "S15", "S7"]);
    isRentNotifier.toggleRentQuestionary(true);
  } else if (option.contains("Sell") && !isCommercial) {
    isRentNotifier.toggleRentQuestionary(false);
    questionNotifier.updateScreenIsActive(setTrueInScreens: ["S8", "S10", "S15", "S7"], setFalseInScreens: ["S16"]);
  } else if (option.contains("Independent House/Villa")) {
    plotNotifier.togglePlotQuestionary(false);
    questionNotifier.updateScreenIsActive(setTrueInScreens: ["S6", "S9"], setFalseInScreens: ["S10"]);
  } else if (option.contains("Apartment") || option.contains("Builder Floor") || option.contains("Farm House")) {
    plotNotifier.togglePlotQuestionary(false);
    questionNotifier.updateScreenIsActive(setTrueInScreens: ["S9"], setFalseInScreens: ["S6", "S10"]);
  }
  if (option.contains("Plot")) {
    plotNotifier.togglePlotQuestionary(true);
    questionNotifier.updateScreenIsActive(setTrueInScreens: ["S10"], setFalseInScreens: ["S6", "S9"]);
  }
  // common flow
  if (option.contains("Residential")) {
    isCommercialNotifier.toggleCommericalQuestionary(false);
  }
  if (option.contains("Commercial")) {
    isCommercialNotifier.toggleCommericalQuestionary(true);
  }

  // Commercial flow--------->
  if (option.contains("Rent") && isCommercial) {
    questionNotifier.updateScreenIsActive(setTrueInScreens: ["S20"], setFalseInScreens: ["S19", "S15"]);
    isRentNotifier.toggleRentQuestionary(true);
  } else if (option.contains("Sell") && isCommercial) {
    isRentNotifier.toggleRentQuestionary(false);
    questionNotifier.updateScreenIsActive(setTrueInScreens: ["S19", "S15"], setFalseInScreens: ["S20"]);
  }
  if (option.contains("Land")) {
    List<String> setTofalse = ["S7", "S8", "S9", "S10", "S11", "S12", "S13", "S14", "S17", "S16"];
    questionNotifier.updateScreenIsActive(setTrueInScreens: ["S6"], setFalseInScreens: setTofalse);
  }
  if (option.contains("Constructed Property")) {
    List<String> setTofalse = ["S6", "S16", "S17"];
    // List<String> setToTrue = ["S7"];
    List<String> setToTrue = ["S7", "S8", "S9", "S10", "S11", "S12", "S13", "S14", "S17"];
    questionNotifier.updateScreenIsActive(setTrueInScreens: setToTrue, setFalseInScreens: setTofalse);
  }
  if (option.contains("Under Construction")) {
    List<String> setTofalse = ["S6", "S16"];
    // List<String> setToTrue = ["S7"];
    List<String> setToTrue = ["S7", "S8", "S9", "S10", "S11", "S12", "S13", "S14", "S17"];
    questionNotifier.updateScreenIsActive(setTrueInScreens: setToTrue, setFalseInScreens: setTofalse);
  }
  if (option.contains("Office")) {
    List<String> setTofalse = ["S9", "S10", "S11", "S12", "S13", "S14"];
    List<String> setToTrue = ["S8"];
    questionNotifier.updateScreenIsActive(setTrueInScreens: setToTrue, setFalseInScreens: setTofalse);
  }
  if (option.contains("Retail")) {
    List<String> setTofalse = ["S8", "S10", "S11", "S12", "S13", "S14"];
    List<String> setToTrue = ["S9"];
    questionNotifier.updateScreenIsActive(setTrueInScreens: setToTrue, setFalseInScreens: setTofalse);
  }
  if (option.contains("Industrial")) {
    List<String> setTofalse = ["S8", "S9", "S10", "S11", "S12", "S13", "S14"];
    List<String> setToTrue = [];
    questionNotifier.updateScreenIsActive(setTrueInScreens: setToTrue, setFalseInScreens: setTofalse);
  }
  if (option.contains("Hospitality")) {
    List<String> setTofalse = ["S8", "S9", "S11", "S12", "S13"];
    List<String> setToTrue = ["S10", "S14"];
    questionNotifier.updateScreenIsActive(setTrueInScreens: setToTrue, setFalseInScreens: setTofalse);
  }
  if (option.contains("Healthcare")) {
    List<String> setTofalse = ["S8", "S9", "S10", "S12", "S13", "S14"];
    List<String> setToTrue = ["S11"];
    questionNotifier.updateScreenIsActive(setTrueInScreens: setToTrue, setFalseInScreens: setTofalse);
  }
  if (option.contains("Institutional")) {
    List<String> setTofalse = ["S8", "S9", "S10", "S11", "S12", "S13", "S14"];
    List<String> setToTrue = [];
    questionNotifier.updateScreenIsActive(setTrueInScreens: setToTrue, setFalseInScreens: setTofalse);
  }
  if (option.contains("School")) {
    List<String> setTofalse = ["S8", "S9", "S10", "S11", "S12", "S14"];
    List<String> setToTrue = ["S13"];
    questionNotifier.updateScreenIsActive(setTrueInScreens: setToTrue, setFalseInScreens: setTofalse);
  }
  if (option.contains("Warehouse")) {
    List<String> setTofalse = ["S8", "S9", "S10", "S11", "S12", "S13", "S14"];
    List<String> setToTrue = [];
    questionNotifier.updateScreenIsActive(setTrueInScreens: setToTrue, setFalseInScreens: setTofalse);
  }
  if (option.contains("Mall")) {
    List<String> setTofalse = ["S8", "S9", "S10", "S11", "S12", "S13", "S14"];
    List<String> setToTrue = [];
    questionNotifier.updateScreenIsActive(setTrueInScreens: setToTrue, setFalseInScreens: setTofalse);
  }
  if (option.contains("Shopping Complex")) {
    List<String> setTofalse = ["S8", "S9", "S10", "S11", "S12", "S13", "S14"];
    List<String> setToTrue = [];
    questionNotifier.updateScreenIsActive(setTrueInScreens: setToTrue, setFalseInScreens: setTofalse);
  }
  if (option.contains("Shop Cum Office")) {
    List<String> setTofalse = ["S8", "S9", "S10", "S11", "S12", "S13", "S14"];
    List<String> setToTrue = [];
    questionNotifier.updateScreenIsActive(setTrueInScreens: setToTrue, setFalseInScreens: setTofalse);
  }
  if (option.contains("Hospital")) {
    List<String> setTofalse = [];
    List<String> setToTrue = ["S12"];
    questionNotifier.updateScreenIsActive(setTrueInScreens: setToTrue, setFalseInScreens: setTofalse);
  }
  if (option.contains("Clinic")) {
    List<String> setTofalse = ["S12"];
    List<String> setToTrue = [];
    questionNotifier.updateScreenIsActive(setTrueInScreens: setToTrue, setFalseInScreens: setTofalse);
  }
}
