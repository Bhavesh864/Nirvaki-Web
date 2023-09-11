// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/customs/custom_text.dart';
import 'package:yes_broker/customs/responsive.dart';

import 'package:yes_broker/constants/firebase/questionModels/lead_question.dart';

import 'package:yes_broker/constants/functions/get_lead_questions.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/riverpodstate/lead_filter_question.dart';
import 'package:yes_broker/widgets/questionaries/workitem_success.dart';
import '../customs/custom_fields.dart';
import '../constants/utils/image_constants.dart';
import '../riverpodstate/all_selected_ansers_provider.dart';

final myArrayProvider = StateNotifierProvider<AllChipSelectedAnwers, List<Map<String, dynamic>>>(
  (ref) => AllChipSelectedAnwers(),
);

class AddLead extends ConsumerStatefulWidget {
  const AddLead({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddLeadState createState() => _AddLeadState();
}

class _AddLeadState extends ConsumerState<AddLead> {
  String? response;
  bool allQuestionFinishes = false;
  bool isEdit = false;

  late Future<List<LeadQuestions>> getQuestions;
  List<Screen> currentScreenList = [];
  PageController? pageController;
  int currentScreenIndex = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getQuestions = LeadQuestions.getAllQuestionssFromFirestore();
    pageController = PageController(initialPage: currentScreenIndex);
    final answers = ref.read(myArrayProvider);
    answers.isNotEmpty ? isEdit = true : isEdit = false;
    try {
      if (isEdit) {
        if (answers[0]["item"] == "Residential") {
          ref.read(leadFilterCommercialQuestion.notifier).toggleCommericalQuestionary(false);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  addDataOnfirestore(AllChipSelectedAnwers notify) {
    notify.submitLead(isEdit).then((value) => {
          setState(() {
            response = value;
          })
        });
  }

  nextQuestion({List<Screen>? screensDataList, option}) {
    updateLeadListInventory(ref, option);
    if (currentScreenIndex < screensDataList!.length - 1) {
      setState(() {
        currentScreenIndex++;
        pageController!.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    } else {}
  }

  goBack(List<int> id) {
    if (currentScreenIndex > 0) {
      setState(() {
        currentScreenIndex--;
        !isEdit ? ref.read(myArrayProvider.notifier).remove(id) : null;
        pageController!.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    } else {
      Navigator.pop(context);
    }
  }

  LeadQuestions? getCurrentLead(AsyncSnapshot<List<LeadQuestions>> snapshot, option) {
    for (var data in snapshot.data!) {
      if (data.type == option) {
        return data;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final notify = ref.read(myArrayProvider.notifier);
    final List<Map<String, dynamic>> selectedValues = ref.read(myArrayProvider);
    final isRentSelected = ref.read(leadFilterRentQuestion);
    final isVillaSelected = ref.read(leadFilterVillaQuestion);
    final isPlotSelected = ref.read(leadFilterPlotQuestion);
    final isCommericalSelected = ref.read(leadFilterCommercialQuestion);

    return Scaffold(
      body: FutureBuilder<List<LeadQuestions>>(
        future: getQuestions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final String res = selectedValues.isNotEmpty ? selectedValues[0]["item"] : "Residential";
            LeadQuestions? screenData = getCurrentLead(snapshot, res);
            List<Screen> screensDataList = screenData!.screens;

            if (!currentScreenList.contains(screensDataList[0])) {
              currentScreenList = screensDataList;
            }
            if (isEdit) {
              final arr = ["S1"];
              final filter = screensDataList.where((element) => !arr.contains(element.screenId)).toList();
              screensDataList = filter;
            }
            if (!isCommericalSelected) {
              if (isRentSelected) {
                final arr = ["S8", "S10", "S6"];
                final filter = screensDataList.where((element) => !arr.contains(element.screenId)).toList();
                currentScreenList = filter;
              } else if (!isRentSelected) {
                final arr = ["S6", "S10"];
                final filter = screensDataList.where((element) => !arr.contains(element.screenId)).toList();
                currentScreenList = filter;
              }
              if (isVillaSelected) {
                var index = isEdit ? 4 : 5;
                final filter = screensDataList.firstWhere((element) => element.screenId == "S6");
                currentScreenList.insert(index, filter);
              }
              if (isPlotSelected) {
                var index = isEdit ? 8 : 9;
                final arr = ["S9", "S6"];
                final filter = currentScreenList.where((element) => !arr.contains(element.screenId)).toList();
                currentScreenList = filter;
                final filter2 = screensDataList.firstWhere((element) => element.screenId == "S10");
                currentScreenList.insert(index, filter2);
              }
            } else {
              currentScreenList = screensDataList;
            }

            return Stack(
              children: [
                Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(authBgImage),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black38,
                          BlendMode.darken,
                        ),
                      ),
                    ),
                    child: !allQuestionFinishes
                        ? Form(
                            key: _formKey,
                            child: PageView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              controller: pageController,
                              scrollDirection: Axis.horizontal,
                              itemCount: currentScreenList.length,
                              itemBuilder: (context, index) {
                                return Center(
                                  child: Card(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: SingleChildScrollView(
                                      child: Container(
                                        constraints: const BoxConstraints(
                                          minHeight: 0,
                                          maxHeight: double.infinity,
                                        ),
                                        width: Responsive.isMobile(context) ? width! * 0.9 : 650,
                                        padding: const EdgeInsets.all(25),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (currentScreenList[index].title != null)
                                              CustomText(
                                                softWrap: true,
                                                textAlign: TextAlign.center,
                                                size: 30,
                                                title: currentScreenList[index].title.toString(),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            for (var i = 0; i < currentScreenList[index].questions.length; i++)
                                              Column(
                                                children: [
                                                  if (currentScreenList[index].title == null)
                                                    CustomText(
                                                        softWrap: true,
                                                        textAlign: TextAlign.center,
                                                        size: 30,
                                                        title: currentScreenList[index].questions[i].questionTitle,
                                                        fontWeight: FontWeight.bold),
                                                  buildLeadQuestions(
                                                    currentScreenList[index].questions[i],
                                                    currentScreenList,
                                                    currentScreenIndex,
                                                    notify,
                                                    nextQuestion,
                                                    isRentSelected,
                                                    isEdit,
                                                    isPlotSelected,
                                                    selectedValues,
                                                  ),
                                                  if (i == currentScreenList[index].questions.length - 1 &&
                                                      currentScreenList[index].questions[i].questionOptionType != 'chip')
                                                    Container(
                                                      margin: const EdgeInsets.only(top: 10),
                                                      alignment: Alignment.centerRight,
                                                      child: allQuestionFinishes
                                                          ? const Center(
                                                              child: CircularProgressIndicator.adaptive(),
                                                            )
                                                          : CustomButton(
                                                              text: currentScreenList[index].title == "Assign to" ? 'Submit' : 'Next',
                                                              onPressed: () {
                                                                if (!allQuestionFinishes) {
                                                                  if (currentScreenList[index].title != "Assign to") {
                                                                    if (_formKey.currentState!.validate()) {
                                                                      nextQuestion(screensDataList: screensDataList);
                                                                    }
                                                                  }
                                                                  if (currentScreenList[index].title == "Assign to") {
                                                                    setState(() {
                                                                      allQuestionFinishes = true;
                                                                    });
                                                                    addDataOnfirestore(notify);
                                                                  }
                                                                }
                                                              },
                                                              width: currentScreenList[index].title == "Assign to" ? 90 : 70,
                                                              height: 39,
                                                            ),
                                                    ),
                                                ],
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : const WorkItemSuccessWidget(
                            isInventory: 'LD',
                          )),
                !allQuestionFinishes ? leadAppbar(screensDataList) : const SizedBox(),
              ],
            );
          }
        },
      ),
    );
  }

  Consumer leadAppbar(List<Screen> screensDataList) {
    return Consumer(
      builder: (context, ref, child) {
        return Positioned(
          top: 0.0,
          left: 0.0,
          right: 0.0,
          child: AppBar(
            leading: IconButton(
              onPressed: () {
                final currentScreenQuestions = screensDataList[currentScreenIndex].questions;
                final ids = currentScreenQuestions.map((q) => q.questionId).toList();
                goBack(ids);
              },
              icon: const Icon(
                Icons.arrow_back,
                size: 24,
              ),
            ),
            title: Text(isEdit ? "Edit Lead" : 'Add Lead'),
          ),
        );
      },
    );
  }
}

void updateLeadListInventory(WidgetRef ref, option) {
  if (option == "Rent") {
    ref.read(leadFilterRentQuestion.notifier).toggleRentQuestionary(true);
  } else if (option == "Sell") {
    ref.read(leadFilterRentQuestion.notifier).toggleRentQuestionary(false);
  } else if (option == "Independent House/Villa") {
    ref.read(leadFilterVillaQuestion.notifier).toggleVillaQuestionary(true);
  } else if (option == "Apartment" || option == "Builder Floor" || option == "Plot" || option == "Farm House") {
    ref.read(leadFilterVillaQuestion.notifier).toggleVillaQuestionary(false);
  }
  if (option == "Plot") {
    ref.read(leadFilterPlotQuestion.notifier).togglePlotQuestionary(true);
  }
  if (option == "Apartment" || option == "Builder Floor" || option == "Independent House/Villa" || option == "Farm House") {
    ref.read(leadFilterPlotQuestion.notifier).togglePlotQuestionary(false);
  }
  if (option == "Residential") {
    ref.read(leadFilterCommercialQuestion.notifier).toggleCommericalQuestionary(false);
  }
  if (option == "Commercial") {
    ref.read(leadFilterCommercialQuestion.notifier).toggleCommericalQuestionary(true);
  }
}
