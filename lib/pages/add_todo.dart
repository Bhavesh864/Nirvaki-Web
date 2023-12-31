import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';

import 'package:yes_broker/customs/custom_text.dart';
import 'package:yes_broker/customs/responsive.dart';

import 'package:yes_broker/constants/firebase/questionModels/todo_question.dart';

import 'package:yes_broker/constants/functions/get_todo_questions.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/riverpodstate/todo/linked_with_workItem.dart';
import 'package:yes_broker/riverpodstate/user_data.dart';
import 'package:yes_broker/widgets/questionaries/workitem_success.dart';
import '../customs/custom_fields.dart';
import '../constants/utils/image_constants.dart';
import '../riverpodstate/all_selected_ansers_provider.dart';
import '../riverpodstate/selected_workitem.dart';
import 'largescreen_dashboard.dart';

final myArrayProvider = StateNotifierProvider<AllChipSelectedAnwers, List<Map<String, dynamic>>>(
  (ref) => AllChipSelectedAnwers(),
);

class AddTodo extends ConsumerStatefulWidget {
  const AddTodo({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends ConsumerState<AddTodo> {
  bool allQuestionFinishes = false;
  bool isLinkItem = false;
  late Future<List<TodoQuestion>> getQuestions;
  PageController? pageController;
  int currentScreenIndex = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    getQuestions = TodoQuestion.getAllQuestionssFromFirestore();
    pageController = PageController(initialPage: currentScreenIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(myArrayProvider.notifier).resetState();
    });
    setLinkedItemInRiverpod();
  }

  addDataOnfirestore(AllChipSelectedAnwers notify) {
    notify.submitTodo(ref);
  }

  nextQuestion({List<Screen>? screensDataList, option}) {
    if (currentScreenIndex < screensDataList!.length - 1) {
      setState(
        () {
          currentScreenIndex++;
          pageController!.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
      );
    } else {}
  }

  goBack(List<int> id, type) {
    if (currentScreenIndex > 0) {
      setState(() {
        currentScreenIndex--;
        type ? ref.read(myArrayProvider.notifier).remove(id) : null;
        pageController!.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    } else {
      Navigator.pop(context);
    }
  }

  linkState(bool value) {
    setState(() {
      isLinkItem = value;
    });
  }

  TodoQuestion? getCurrentLead(AsyncSnapshot<List<TodoQuestion>> snapshot, option) {
    for (var data in snapshot.data!) {
      if (data.type == option) {
        return data;
      }
    }
    return null;
  }

  setLinkedItemInRiverpod() async {
    final notify = ref.read(myArrayProvider.notifier);
    final workItemId = ref.read(selectedWorkItemId);
    final linkedWithItem = ref.read(linkedWithWorkItem);
    if (linkedWithItem && workItemId.isNotEmpty) {
      final CardDetails? cardDetail = await CardDetails.getSingleCardByWorkItemId(workItemId);
      notify.add({"id": 6, "item": cardDetail});
    }
  }

  @override
  Widget build(BuildContext context) {
    final notify = ref.read(myArrayProvider.notifier);
    final linkedWithItem = ref.read(linkedWithWorkItem);
    final List<Map<String, dynamic>> selectedValues = ref.read(myArrayProvider);
    final user = ref.watch(userDataProvider);
    return Scaffold(
      body: FutureBuilder<List<TodoQuestion>>(
        future: getQuestions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<TodoQuestion>? screenData = snapshot.data;
            List<Screen> screensDataList = screenData![0].screens;
            if (!isLinkItem) {
              screensDataList = screensDataList.where((element) => element.screenId != "S5").toList();
            }
            if (linkedWithItem) {
              final arr = ["S5", "S4"];
              screensDataList = screensDataList.where((element) => !arr.contains(element.screenId)).toList();
            }
            return GestureDetector(
              onTap: () {
                if (!kIsWeb) FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Stack(
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
                                            // mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (screensDataList[index].title != null)
                                                CustomText(
                                                  softWrap: true,
                                                  textAlign: TextAlign.center,
                                                  size: Responsive.isDesktop(context) ? 26 : 20,
                                                  title: screensDataList[index].title.toString(),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              for (var i = 0; i < screensDataList[index].questions.length; i++)
                                                Column(
                                                  children: [
                                                    if (screensDataList[index].title == null)
                                                      CustomText(
                                                          softWrap: true,
                                                          textAlign: TextAlign.center,
                                                          size: Responsive.isDesktop(context) ? 26 : 20,
                                                          title: screensDataList[index].questions[i].questionTitle,
                                                          fontWeight: FontWeight.bold),
                                                    buildTodoQuestions(
                                                      screensDataList[index].questions[i],
                                                      screensDataList,
                                                      currentScreenIndex,
                                                      notify,
                                                      nextQuestion,
                                                      context,
                                                      selectedValues,
                                                      linkState,
                                                      ref,
                                                      user!,
                                                    ),
                                                    if (i == screensDataList[index].questions.length - 1 && screensDataList[index].questions[i].questionOptionType != 'chip')
                                                      Container(
                                                        margin: const EdgeInsets.only(top: 10),
                                                        alignment: Alignment.centerRight,
                                                        child: allQuestionFinishes
                                                            ? const Center(
                                                                child: CircularProgressIndicator.adaptive(),
                                                              )
                                                            : CustomButton(
                                                                text: screensDataList[index].title == "Assign to" ? 'Submit' : 'Next',
                                                                onPressed: () {
                                                                  if (!kIsWeb) FocusManager.instance.primaryFocus?.unfocus();
                                                                  if (!allQuestionFinishes) {
                                                                    if (screensDataList[index].title != "Assign to") {
                                                                      if (_formKey.currentState!.validate()) {
                                                                        nextQuestion(screensDataList: screensDataList);
                                                                      }
                                                                    }
                                                                    if (screensDataList[index].title == "Assign to") {
                                                                      setState(() {
                                                                        allQuestionFinishes = true;
                                                                      });
                                                                      addDataOnfirestore(notify);
                                                                    }
                                                                  }
                                                                },
                                                                width: screensDataList[index].title == "Assign to" ? 90 : 70,
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
                              isInventory: 'Todo',
                              isEdit: false,
                            )),
                  !allQuestionFinishes ? leadAppbar(screensDataList) : const SizedBox(),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  final hello = true;

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
                final questiontype = currentScreenQuestions.any((element) => element.questionTitle.contains("Link Work Item"));
                ref.read(desktopSideBarIndexProvider.notifier).update((state) => 0);
                goBack(ids, questiontype);
              },
              icon: const Icon(
                Icons.arrow_back,
                size: 24,
              ),
            ),
            title: const Text('Add Todo'),
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
