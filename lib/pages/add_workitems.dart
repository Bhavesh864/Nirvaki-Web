import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/Customs/responsive.dart';

import 'package:yes_broker/constants/firebase/questionModels/inventory_question.dart' as IN;
import 'package:yes_broker/constants/firebase/questionModels/lead_question.dart' as LD;

import 'package:yes_broker/constants/functions/get_workItem_question.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/widgets/questionaries/workitem_success.dart';
import '../Customs/custom_fields.dart';
import '../constants/utils/image_constants.dart';
import '../riverpodstate/all_selected_ansers_provider.dart';

final myArrayProvider = StateNotifierProvider<AllChipSelectedAnwers, List<Map<String, dynamic>>>(
  (ref) => AllChipSelectedAnwers(),
);

class AddWorkItem extends ConsumerStatefulWidget {
  final bool isInventory;

  const AddWorkItem({this.isInventory = true, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddWorkItemState createState() => _AddWorkItemState();
}

class _AddWorkItemState extends ConsumerState<AddWorkItem> {
  String? response;
  bool allQuestionFinishes = false;
  late Future<List<IN.InventoryQuestions>> getInventoryQuestions;
  late Future<List<LD.LeadQuestions>> getLeadQuestions;
  PageController? pageController;
  int currentScreenIndex = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.isInventory) {
      getInventoryQuestions = IN.InventoryQuestions.getAllQuestionssFromFirestore();
    } else {
      getLeadQuestions = LD.LeadQuestions.getAllQuestionssFromFirestore();
    }
    pageController = PageController(initialPage: currentScreenIndex);
  }

  addDataOnfirestore(AllChipSelectedAnwers notify) {
    notify.submitInventory().then((value) => {
          setState(() {
            response = value;
            if (value == 'success') allQuestionFinishes = true;
          })
        });
  }

  nextQuestion({List<dynamic>? screensDataList, option}) {
    if (currentScreenIndex < screensDataList!.length - 1) {
      setState(() {
        currentScreenIndex++;
        pageController!.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    } else {
      setState(() {});
    }
  }

  goBack(List<int> id) {
    if (currentScreenIndex > 0) {
      setState(() {
        currentScreenIndex--;
        ref.read(myArrayProvider.notifier).remove(id);
        pageController!.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    } else {
      Navigator.pop(context);
    }
  }

  IN.InventoryQuestions? getcurrentInventory(AsyncSnapshot<List<dynamic>> snapshot, option) {
    for (var data in snapshot.data!) {
      if (data.type == option) {
        return data;
      }
    }
    return null;
  }

  LD.LeadQuestions? getCurrentLead(AsyncSnapshot<List<dynamic>> snapshot, option) {
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
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: widget.isInventory ? getInventoryQuestions : getLeadQuestions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final String res = notify.state.isNotEmpty ? notify.state[0]["item"] : "Residential";
            dynamic screenData = widget.isInventory ? getcurrentInventory(snapshot, res) : getCurrentLead(snapshot, res);
            List<dynamic> screensDataList = screenData!.screens;
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
                            itemCount: screensDataList.length,
                            itemBuilder: (context, index) {
                              return Center(
                                child: Card(
                                  child: Container(
                                    constraints: BoxConstraints(
                                      minHeight: 0,
                                      maxHeight: Responsive.isMobile(context) ? height! * 0.8 : height! * 0.88,
                                    ),
                                    width: Responsive.isMobile(context) ? width! * 0.9 : 650,
                                    padding: const EdgeInsets.all(25),
                                    child: ScrollConfiguration(
                                      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (screensDataList[index].title != null)
                                              CustomText(
                                                softWrap: true,
                                                textAlign: TextAlign.center,
                                                size: 30,
                                                title: screensDataList[index].title.toString(),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ListView.builder(
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              itemCount: screensDataList[index].questions.length,
                                              itemBuilder: (context, i) {
                                                final question = screensDataList[index].questions[i];
                                                return Column(
                                                  children: [
                                                    if (screensDataList[index].title == null)
                                                      CustomText(
                                                        softWrap: true,
                                                        textAlign: TextAlign.center,
                                                        size: 30,
                                                        title: question.questionTitle,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    buildWorkItemQuestion(
                                                      question,
                                                      screensDataList,
                                                      currentScreenIndex,
                                                      notify,
                                                      nextQuestion,
                                                    ),
                                                    if (i == screensDataList[index].questions.length - 1 && question.questionOptionType != 'chip')
                                                      Container(
                                                        margin: const EdgeInsets.only(top: 10),
                                                        alignment: Alignment.centerRight,
                                                        child: CustomButton(
                                                          text: 'Next',
                                                          onPressed: () {
                                                            FocusScope.of(context).unfocus();

                                                            nextQuestion(
                                                              screensDataList: screensDataList,
                                                            );
                                                            // if (_formKey.currentState!.validate()) {
                                                            //   nextQuestion(
                                                            //     screensDataList: screensDataList,
                                                            //   );
                                                            // }
                                                            if (screensDataList[index].title == "Assign to") {
                                                              addDataOnfirestore(notify);
                                                            }
                                                          },
                                                          width: 73,
                                                          height: 39,
                                                        ),
                                                      ),
                                                  ],
                                                );
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : response == "success"
                          ? WorkItemSuccessWidget(
                              isInventory: widget.isInventory ? 'IN' : 'LD',
                            )
                          : const Center(
                              child: CircularProgressIndicator.adaptive(),
                            ),
                ),
                inventoryAppBar(screensDataList),
              ],
            );
          }
        },
      ),
    );
  }

  Consumer inventoryAppBar(List<dynamic> screensDataList) {
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
            title: Text(widget.isInventory ? 'Add Inventory ' : 'Add Lead'),
          ),
        );
      },
    );
  }
}
