import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/Customs/loader.dart';
import 'package:yes_broker/constants/firebase/statesModel/state_c_ity_model.dart';
import 'package:yes_broker/customs/custom_text.dart';
import 'package:yes_broker/customs/responsive.dart';
import 'package:yes_broker/constants/firebase/questionModels/inventory_question.dart';
import 'package:yes_broker/constants/functions/get_inventory_questions_widgets.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/riverpodstate/filterQuestions/inventory_all_question.dart';
import 'package:yes_broker/riverpodstate/inventory_res_filter_question.dart';
import 'package:yes_broker/widgets/questionaries/workitem_success.dart';
import '../constants/functions/filterQuestions/filter_inventory_question.dart';
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
  // ignore: library_private_types_in_public_api
  _AddInventoryState createState() => _AddInventoryState();
}

class _AddInventoryState extends ConsumerState<AddInventory> {
  String? response;
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
    final answers = ref.read(myArrayProvider);
    getQuestions = InventoryQuestions.getAllQuestionssFromFirestore();
    pageController = PageController(initialPage: currentScreenIndex);
    answers.isNotEmpty ? isEdit = true : isEdit = false;
    StateCItyModel.getAllStates().then((value) => {
          setState(() {
            stateList = value;
          })
        });
    try {
      if (isEdit) {
        if (answers[0]["item"] == "Residential") {
          ref.read(filterCommercialQuestion.notifier).toggleCommericalQuestionary(false);
        } else if (answers[0]["item"] == "Commercial") {
          ref.read(filterCommercialQuestion.notifier).toggleCommericalQuestionary(true);
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

      if (mobileNoValue.isEmpty || mobileNoValue.length < 10) {
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
        if (whatsappNoValue.isEmpty || whatsappNoValue.length < 10) {
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
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom;
    // final assignIsselected = selectedValues.firstWhere((element) => element["id"] == 36)["item"];
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
                } else if (snapshot.hasData) {
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
                    fit: StackFit.expand,
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
                                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                // mainAxisSize: MainAxisSize.min,
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
                                                  ListView.builder(
                                                    shrinkWrap: true,
                                                    physics: const NeverScrollableScrollPhysics(),
                                                    itemCount: currentScreenList[index].questions.length,
                                                    itemBuilder: (context, i) {
                                                      final question = currentScreenList[index].questions[i];
                                                      return Column(
                                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          if (currentScreenList[index].title == null) ...[
                                                            Padding(
                                                              padding: const EdgeInsets.only(bottom: 20.0),
                                                              child: CustomText(
                                                                softWrap: true,
                                                                textAlign: TextAlign.center,
                                                                size: Responsive.isDesktop(context) ? 26 : 20,
                                                                title: question.questionTitle,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                            // const SizedBox(height: 20),
                                                          ],
                                                          buildInventoryQuestions(
                                                            question,
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
                                                          ),
                                                          SizedBox(height: question.questionOptionType != 'textfield' ? 10 : 0),
                                                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                            const SizedBox(),
                                                            if (i == currentScreenList[index].questions.length - 1 && question.questionOptionType != 'chip') ...[
                                                              Container(
                                                                child: allQuestionFinishes
                                                                    ? const Center(
                                                                        child: CircularProgressIndicator.adaptive(),
                                                                      )
                                                                    : Padding(
                                                                        padding: const EdgeInsets.only(right: 5.0, top: 20),
                                                                        child: CustomButton(
                                                                          text: currentScreenList[index].title == "Assign to" ? 'Submit' : 'Next',
                                                                          onPressed: () {
                                                                            if (!allQuestionFinishes) {
                                                                              if (currentScreenList[index].title != "Assign to") {
                                                                                if (_formKey.currentState!.validate()) {
                                                                                  nextQuestion(screensDataList: currentScreenList, option: "");
                                                                                }
                                                                              }
                                                                              if (currentScreenList[index].title == "Assign to") {
                                                                                setState(() {
                                                                                  allQuestionFinishes = true;
                                                                                });
                                                                                addDataOnfirestore(notify);
                                                                              }
                                                                              if (!kIsWeb) FocusManager.instance.primaryFocus?.unfocus();
                                                                            }
                                                                          },
                                                                          width: currentScreenList[index].title == "Assign to" ? 90 : 70,
                                                                          height: 39,
                                                                        ),
                                                                      ),
                                                              ),
                                                            ] else ...[
                                                              const SizedBox()
                                                            ]
                                                          ]),
                                                        ],
                                                      );
                                                    },
                                                  )
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
                      isKeyboardOpen == 0 && !allQuestionFinishes ? inventoryAppBar(currentScreenList) : const SizedBox(),
                    ],
                  );
                }
                return const SizedBox();
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
