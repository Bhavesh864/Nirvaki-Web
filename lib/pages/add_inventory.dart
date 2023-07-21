import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/constants/firebase/questionModels/inventory_question.dart';
import 'package:yes_broker/constants/functions/get_inventory_questions_widgets.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/widgets/inventory/inventory_success_widget.dart';
import '../Customs/custom_fields.dart';
import '../constants/utils/image_constants.dart';
import '../controllers/all_selected_ansers_provider.dart';

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
  bool allQuestionFinishes = false;
  late Future<List<InventoryQuestions>> getQuestions;
  PageController? pageController;
  int currentScreenIndex = 20;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getQuestions = InventoryQuestions.getAllQuestionssFromFirestore();
    pageController = PageController(initialPage: currentScreenIndex);
  }

  nextQuestion({List<Screen>? screensDataList}) {
    if (currentScreenIndex < screensDataList!.length - 1) {
      setState(() {
        currentScreenIndex++;
        pageController!.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    } else {
      setState(() {
        allQuestionFinishes = true;
      });
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

  @override
  Widget build(BuildContext context) {
    final notify = ref.read(myArrayProvider.notifier);

    return Scaffold(
      body: FutureBuilder<List<InventoryQuestions>>(
        future: getQuestions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<InventoryQuestions> screenData = snapshot.data as List<InventoryQuestions>;
            List<Screen> screensDataList = screenData[0].screens;
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
                                                buildQuestionWidget(
                                                  screensDataList[index].questions[i],
                                                  screensDataList,
                                                  currentScreenIndex,
                                                  notify,
                                                  nextQuestion,
                                                ),
                                                if (i == screensDataList[index].questions.length - 1 && screensDataList[index].questions[i].questionOptionType != 'chip')
                                                  Container(
                                                    margin: const EdgeInsets.only(top: 10),
                                                    alignment: Alignment.centerRight,
                                                    child: CustomButton(
                                                      text: 'Next',
                                                      onPressed: () {
                                                        if (_formKey.currentState!.validate()) {
                                                          nextQuestion(
                                                            screensDataList: screensDataList,
                                                          );
                                                        }
                                                      },
                                                      width: 73,
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
                      : const InventorySuccessWidget(),
                ),
                Consumer(
                  builder: (context, ref, child) {
                    return Positioned(
                      top: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: AppBar(
                        elevation: 0,
                        iconTheme: const IconThemeData(color: Colors.white),
                        backgroundColor: Colors.transparent,
                        centerTitle: true,
                        leading: IconButton(
                          onPressed: () {
                            final currentScreenQuestions = screensDataList[currentScreenIndex].questions;
                            final ids = currentScreenQuestions.map((q) => q.questionId).toList();
                            goBack(ids);
                          },
                          icon: const Icon(Icons.arrow_back),
                        ),
                        title: const CustomText(
                          title: 'Add Inventory ',
                          fontWeight: FontWeight.w700,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
