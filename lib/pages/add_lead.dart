// ignore_for_file: invalid_use_of_protected_member
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/Customs/loader.dart';

import 'package:yes_broker/customs/custom_text.dart';
import 'package:yes_broker/customs/responsive.dart';
import 'package:yes_broker/constants/firebase/questionModels/lead_question.dart';
import 'package:yes_broker/constants/functions/get_lead_questions.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/pages/add_inventory.dart' as imp;
import 'package:yes_broker/pages/add_inventory.dart';
import 'package:yes_broker/pages/largescreen_dashboard.dart';
import 'package:yes_broker/riverpodstate/filterQuestions/lead_all_question.dart';
import 'package:yes_broker/riverpodstate/lead_filter_question.dart';
import 'package:yes_broker/widgets/questionaries/workitem_success.dart';
import '../constants/functions/filterQuestions/filter_lead_question.dart';
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
  bool isBuy = true;
  late Future<List<LeadQuestions>> getQuestions;
  List<Screen> currentScreenList = [];
  PageController? pageController;
  int currentScreenIndex = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isMobileNoEmpty = false;
  bool iswhatsappMobileNoEmpty = false;
  bool isChecked = true;

  @override
  void initState() {
    super.initState();
    getQuestions = LeadQuestions.getAllQuestionssFromFirestore();
    pageController = PageController(initialPage: currentScreenIndex);
    final answers = ref.read(myArrayProvider);
    answers.isNotEmpty ? isEdit = true : isEdit = false;
    try {
      if (isEdit) {
        if (answers[1]["item"] == "Buy") {
          isBuy = true;
        } else {
          isBuy = false;
        }

        if (answers[0]["item"] == "Residential") {
          ref.read(leadFilterCommercialQuestion.notifier).toggleCommericalQuestionary(false);
        } else if (answers[0]["item"] == "Commercial") {
          ref.read(leadFilterCommercialQuestion.notifier).toggleCommericalQuestionary(true);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  addDataOnfirestore(AllChipSelectedAnwers notify) {
    notify.submitLead(isEdit, ref).then((value) => {
          setState(() {
            response = value;
          })
        });
  }

  nextQuestion({List<Screen>? screensDataList, required String option}) {
    if (currentScreenIndex == 3) {
      final List<Map<String, dynamic>> selectedValues = ref.read(myArrayProvider);
      final mobileNoValue = selectedValues.where((e) => e["id"] == 7).toList();
      final whatsappNoValue = selectedValues.where((e) => e["id"] == 8).toList();

      if (mobileNoValue.isEmpty || mobileNoValue[0]['item'].split(' ')[1].length < 10) {
        setState(() {
          isMobileNoEmpty = true;
        });
        if (isChecked) {
          return;
        }
      } else {
        List<String> itemValue = mobileNoValue[0]["item"].split(' ');
        if (itemValue[1] == "") {
          setState(() {
            isMobileNoEmpty = true;
          });
          return;
        }
        setState(() {
          isMobileNoEmpty = false;
        });
      }

      if (!isChecked) {
        if (whatsappNoValue.isEmpty || whatsappNoValue[0]['item'].split(' ')[1].length < 10) {
          setState(() {
            iswhatsappMobileNoEmpty = true;
          });
          return;
        } else {
          List<String> itemValue = whatsappNoValue[0]["item"].split(' ');
          if (itemValue[1] == "") {
            setState(() {
              iswhatsappMobileNoEmpty = true;
            });
            return;
          }
          setState(() {
            iswhatsappMobileNoEmpty = false;
          });
        }
      } else {
        setState(() {
          iswhatsappMobileNoEmpty = false;
        });
      }
    }
    updateLeadListInventory(ref, option, screensDataList);
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

  void isCheckedUpdate(bool value) {
    setState(() {
      isChecked = value;
    });
  }

  bool backButtonEnabled = true;
  void goBack(List<int> id, type) {
    if (backButtonEnabled) {
      if (currentScreenIndex > 0) {
        setState(() {
          backButtonEnabled = false;
          currentScreenIndex--;
          !isEdit
              ? type
                  ? null
                  : ref.read(myArrayProvider.notifier).remove(id)
              : null;
          pageController!.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        });
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            backButtonEnabled = true;
          });
        });
      } else {
        Navigator.pop(context);
      }
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
    final isPlotSelected = ref.read(leadFilterPlotQuestion);
    final allLeadQuestionsNotifier = ref.read(allLeadQuestion.notifier);
    final allLeadQuestions = ref.read(allLeadQuestion);
    // final isVillaSelected = ref.read(leadFilterVillaQuestion);
    // final isCommericalSelected = ref.read(leadFilterCommercialQuestion);

    return GestureDetector(
      onTap: () {
        if (!kIsWeb) FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: FutureBuilder<List<LeadQuestions>>(
          future: getQuestions,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Loader());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final res = selectedValues.isNotEmpty ? getWhichItemIsSelectedBYId(selectedValues, 1) : "Residential";
              LeadQuestions? screenData = getCurrentLead(snapshot, res);
              List<Screen> screensDataList = screenData!.screens;
              if (allLeadQuestions.isEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  allLeadQuestionsNotifier.addAllQuestion(screensDataList);
                });
              }
              if (selectedValues.isNotEmpty && getWhichItemIsSelectedBYId(selectedValues, 1) == "Residential") {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  allLeadQuestionsNotifier.addAllQuestion(screensDataList);
                });
              } else if (selectedValues.isNotEmpty && getWhichItemIsSelectedBYId(selectedValues, 1) == "Commercial") {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  allLeadQuestionsNotifier.addAllQuestion(screensDataList);
                });
              }
              currentScreenList = allLeadQuestions.isEmpty ? screensDataList : allLeadQuestions.where((screen) => screen.isActive == true).toList();

              if (isEdit) {
                final arr = ["S1"];
                final filter = currentScreenList.where((element) => !arr.contains(element.screenId)).toList();
                currentScreenList = filter;
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
                                      child: Container(
                                        constraints: BoxConstraints(
                                          maxHeight: MediaQuery.of(context).size.height * 0.8,
                                        ),
                                        width: Responsive.isMobile(context) ? width! * 0.9 : 650,
                                        padding: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: Responsive.isMobile(context) ? 10 : 20),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              if (currentScreenList[index].title != null)
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 20.0),
                                                  child: CustomText(
                                                    softWrap: true,
                                                    textAlign: TextAlign.center,
                                                    size: Responsive.isDesktop(context) ? 26 : 20,
                                                    title: currentScreenList[index].title.toString(),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              for (var i = 0; i < currentScreenList[index].questions.length; i++)
                                                Column(
                                                  children: [
                                                    if (currentScreenList[index].title == null)
                                                      Padding(
                                                        padding: const EdgeInsets.only(bottom: 20.0),
                                                        child: CustomText(
                                                            softWrap: true,
                                                            textAlign: TextAlign.center,
                                                            size: Responsive.isDesktop(context) ? 26 : 20,
                                                            title: currentScreenList[index].questions[i].questionTitle,
                                                            fontWeight: FontWeight.bold),
                                                      ),
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
                                                      isMobileNoEmpty,
                                                      iswhatsappMobileNoEmpty,
                                                      isChecked,
                                                      isCheckedUpdate,
                                                      ref,
                                                      isBuy,
                                                    ),
                                                    SizedBox(height: currentScreenList[index].questions[i].questionOptionType != 'textfield' ? 10 : 0),
                                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                      const SizedBox(),
                                                      if (i == currentScreenList[index].questions.length - 1 &&
                                                          currentScreenList[index].questions[i].questionOptionType != 'chip') ...[
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
                                                                          nextQuestion(screensDataList: screensDataList, option: "");
                                                                        }
                                                                      }
                                                                      // final hasvalues = selectedValues.any((element) => element["id"] == 36);
                                                                      // final assignFieldValue = selectedValues.firstWhere((element) => element["id"] == 36);
                                                                      if (currentScreenList[index].title == "Assign to") {
                                                                        setState(() {
                                                                          allQuestionFinishes = true;
                                                                        });
                                                                        addDataOnfirestore(notify);
                                                                      }
                                                                    }
                                                                    if (!kIsWeb) FocusManager.instance.primaryFocus?.unfocus();
                                                                  },
                                                                  width: currentScreenList[index].title == "Assign to" ? 90 : 70,
                                                                  height: 39,
                                                                ),
                                                        ),
                                                      ] else ...[
                                                        const SizedBox()
                                                      ]
                                                    ]),
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
                          : WorkItemSuccessWidget(
                              isInventory: 'LD',
                              isEdit: isEdit,
                            )),
                  !allQuestionFinishes ? leadAppbar(screensDataList) : const SizedBox(),
                ],
              );
            }
          },
        ),
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
                final allquestion = currentScreenQuestions.map((q) => q.questionOptionType).toList();
                final questiontype = allquestion.any((element) => element == "textfield" || element == "rangeSlider");
                ref.read(desktopSideBarIndexProvider.notifier).update((state) => 0);
                goBack(ids, questiontype);
              },
              icon: const Icon(
                Icons.arrow_back,
                size: 24,
              ),
            ),
            title: Text(isEdit ? "Edit Lead" : 'Add Lead'),
            actions: [
              CustomButton(
                text: Responsive.isMobile(context) ? "" : "Back to home",
                fontsize: 20,
                buttonColor: Colors.transparent,
                borderColor: Colors.transparent,
                onPressed: () {
                  ref.read(desktopSideBarIndexProvider.notifier).update((state) => 0);
                  Navigator.of(context).pop();
                },
                leftIcon: Icons.home_outlined,
              )
            ],
          ),
        );
      },
    );
  }
}
