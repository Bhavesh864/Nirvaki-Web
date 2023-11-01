import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/constants/firebase/statesModel/state_c_ity_model.dart';
import 'package:yes_broker/customs/custom_text.dart';
import 'package:yes_broker/customs/responsive.dart';
import 'package:yes_broker/constants/firebase/questionModels/inventory_question.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/riverpodstate/filterQuestions/inventory_all_question.dart';
import 'package:yes_broker/riverpodstate/inventory_res_filter_question.dart';
import 'package:yes_broker/widgets/questionaries/workitem_success.dart';
import '../Customs/loader.dart';
import '../constants/functions/filterQuestions/filter_inventory_question.dart';
import '../constants/functions/get_inventory_questions.dart';
import '../customs/custom_fields.dart';
import '../constants/utils/image_constants.dart';
import '../riverpodstate/all_selected_ansers_provider.dart';
import 'largescreen_dashboard.dart';

final myArrayProvider = StateNotifierProvider<AllChipSelectedAnwers, List<Map<String, dynamic>>>(
  (ref) => AllChipSelectedAnwers(),
);

class AddInventory extends ConsumerStatefulWidget {
  const AddInventory({super.key});

  @override
  AddInventoryState createState() => AddInventoryState();
}

class AddInventoryState extends ConsumerState<AddInventory> {
  bool allQuestionFinishes = false;
  bool isEdit = false;
  late Future<List<InventoryQuestions>> getQuestions;
  List<Screen> currentScreenList = [];
  PageController? pageController;
  int currentScreenIndex = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<States> stateList = [];
  bool isMobileNoEmpty = false;
  bool iswhatsappMobileNoEmpty = false;
  bool isChecked = true;
  String errorMessage = "";
  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void initializeData() async {
    getQuestions = InventoryQuestions.getAllQuestionssFromFirestore();
    pageController = PageController(initialPage: currentScreenIndex);
    final answers = ref.read(myArrayProvider);
    answers.isNotEmpty ? isEdit = true : isEdit = false;
    try {
      if (isEdit) {
        if (answers[0]["item"] == "Residential") {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(filterCommercialQuestion.notifier).toggleCommericalQuestionary(false);
          });
        } else if (answers[0]["item"] == "Commercial") {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(filterCommercialQuestion.notifier).toggleCommericalQuestionary(true);
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  addDataOnfirestore(AllChipSelectedAnwers notify) {
    notify.submitInventory(isEdit, ref).then((value) => {
          if (value == "success")
            setState(() {
              allQuestionFinishes = true;
            })
        });
  }

  nextQuestion({List<Screen>? screensDataList, required String option}) {
    int numberIndex = isEdit ? 2 : 3;
    if (currentScreenIndex == numberIndex) {
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
    updateListInventory(ref, option);
    if (currentScreenIndex < screensDataList!.length - 1 && !allQuestionFinishes) {
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

  InventoryQuestions? getcurrentInventory(AsyncSnapshot<List<InventoryQuestions>> snapshot, option) {
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
    final isRentSelected = ref.read(filterRentQuestion);
    final isPlotSelected = ref.read(filterPlotQuestion);
    final allInventoryQuestionsNotifier = ref.read(allInventoryQuestion.notifier);
    final allInventoryQuestions = ref.read(allInventoryQuestion);

    return GestureDetector(
        onTap: () {
          if (!kIsWeb) FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          body: FutureBuilder<List<InventoryQuestions>>(
              future: getQuestions,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Loader());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final res = selectedValues.isNotEmpty ? getWhichItemIsSelectedBYId(selectedValues, 1) : "Residential";
                  InventoryQuestions? screenData = getcurrentInventory(snapshot, res);

                  List<Screen> screensDataList = screenData!.screens;

                  if (allInventoryQuestions.isEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      allInventoryQuestionsNotifier.addAllQuestion(screensDataList);
                    });
                  }

                  if (selectedValues.isNotEmpty && getWhichItemIsSelectedBYId(selectedValues, 1) == "Residential") {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      allInventoryQuestionsNotifier.addAllQuestion(screensDataList);
                    });
                  } else if (selectedValues.isNotEmpty && getWhichItemIsSelectedBYId(selectedValues, 1) == "Commercial") {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      allInventoryQuestionsNotifier.addAllQuestion(screensDataList);
                    });
                  }
                  currentScreenList = allInventoryQuestions.isEmpty ? screensDataList : allInventoryQuestions.where((screen) => screen.isActive == true).toList();
                  if (isEdit) {
                    final arr = ["S1"];
                    final filter = currentScreenList.where((element) => !arr.contains(element.screenId)).toList();
                    currentScreenList = filter;
                  }

                  return Stack(
                    // fit: StackFit.expand,
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
                                                        size: Responsive.isMobile(context) ? 20 : 26,
                                                        title: currentScreenList[index].title.toString(),
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  // CustomTextInput(
                                                  //   controller: controller,
                                                  //   hintText: "demo",
                                                  // ),
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
                                                        buildInventoryQuestions(
                                                          currentScreenList[index].questions[i],
                                                          currentScreenList,
                                                          currentScreenIndex,
                                                          notify,
                                                          nextQuestion,
                                                          isRentSelected,
                                                          isPlotSelected,
                                                          isEdit,
                                                          selectedValues,
                                                          stateList,
                                                          isMobileNoEmpty,
                                                          iswhatsappMobileNoEmpty,
                                                          isChecked,
                                                          isCheckedUpdate,
                                                          ref,
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
                                                                            // setState(() {
                                                                            //   allQuestionFinishes = true;
                                                                            // });
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
                                  isInventory: "IN",
                                  isEdit: isEdit,
                                )),
                      !allQuestionFinishes ? inventoryAppBar(currentScreenList) : const SizedBox(),
                    ],
                  );
                }
              }),
        ));
  }

  Consumer inventoryAppBar(List<Screen> screensDataList) {
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
                final questiontype = allquestion.any((element) => element == "textfield" || element == "photo");
                ref.read(desktopSideBarIndexProvider.notifier).update((state) => 0);
                goBack(ids, questiontype);
              },
              icon: const Icon(
                Icons.arrow_back,
                size: 24,
              ),
            ),
            title: Text(isEdit ? "Edit Inventory" : 'Add Inventory'),
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

String? getWhichItemIsSelectedBYId(List<Map<String, dynamic>> list, int id) {
  final item = list.firstWhere(
    (item) => item['id'] == id,
  );
  return item['item'];
}
