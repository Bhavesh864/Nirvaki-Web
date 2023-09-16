import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/customs/custom_text.dart';
import 'package:yes_broker/customs/responsive.dart';

import 'package:yes_broker/constants/firebase/questionModels/todo_question.dart';

import 'package:yes_broker/constants/functions/get_todo_questions.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/widgets/questionaries/workitem_success.dart';
import '../customs/custom_fields.dart';
import '../constants/utils/image_constants.dart';
import '../riverpodstate/all_selected_ansers_provider.dart';

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
  late Future<List<TodoQuestion>> getQuestions;
  PageController? pageController;
  int currentScreenIndex = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getQuestions = TodoQuestion.getAllQuestionssFromFirestore();
    pageController = PageController(initialPage: currentScreenIndex);
  }

  addDataOnfirestore(AllChipSelectedAnwers notify) {
    notify.submitTodo(ref);
  }

  nextQuestion({List<Screen>? screensDataList, option}) {
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
        // ref.read(myArrayProvider.notifier).remove(id);
        pageController!.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    } else {
      Navigator.pop(context);
    }
  }

  TodoQuestion? getCurrentLead(AsyncSnapshot<List<TodoQuestion>> snapshot, option) {
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

    return Scaffold(
      body: FutureBuilder<List<TodoQuestion>>(
        future: getQuestions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            // final String res = notify.state.isNotEmpty ? notify.state[0]["item"] : "Residential";
            List<TodoQuestion>? screenData = snapshot.data;
            List<Screen> screensDataList = screenData![0].screens;
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
                                            if (screensDataList[index].title != null)
                                              CustomText(
                                                softWrap: true,
                                                textAlign: TextAlign.center,
                                                size: 30,
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
                                                        size: 30,
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
                          )),
                !allQuestionFinishes ? leadAppbar(screensDataList) : const SizedBox(),
              ],
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
                goBack(ids);
              },
              icon: const Icon(
                Icons.arrow_back,
                size: 24,
              ),
            ),
            title: const Text('Add Todo'),
          ),
        );
      },
    );
  }
}
