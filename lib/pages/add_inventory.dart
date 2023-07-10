import 'package:flutter/material.dart';

import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/constants/constants.dart';
import 'package:yes_broker/constants/firebase/inventory_questions.dart';
import 'package:yes_broker/widgets/card/questions%20card/chip_button_card.dart';
import 'package:yes_broker/widgets/card/questions%20card/dropdown_card.dart';
import 'package:yes_broker/widgets/card/questions%20card/textform_card.dart';

class AddInventory extends StatefulWidget {
  static const routeName = '/add-inventory';
  const AddInventory({super.key});

  @override
  State<AddInventory> createState() => _AddInventoryState();
}

class _AddInventoryState extends State<AddInventory> {
  PageController? pageController;

  int currentIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController(initialPage: currentIndex);
  }

  final List arr = [
    {
      'question': '',
      'options': ['', '', ''],
      "type": 'chip',
      "id": 2
    },
    {
      'question': '',
      'options': ['', '', ''],
      "type": 'chip',
      "id": 2
    },
    {
      'question': '',
      'options': ['', '', ''],
      "type": 'chip',
      "id": 2
    },
    {
      'question': '',
      'options': ['', '', ''],
      "type": 'chip',
      "id": 2
    },
    {
      'question': '',
      'options': ['', '', ''],
      "type": 'chip',
      "id": 2
    },
    // {
    //   'question': '',
    //   'listItem': ['No of bedrrom?', 'Additional Rooms'],
    //   'options': [
    //     ['', '', ''],
    //     ['', '', ''],
    //   ],
    //   "type": 'chip',
    //   "id": 2
    // },
  ];

  var selectedOption = '';
  List<String> allAnswers = [];

  _next(String selectedAnswer, List<InventoryQuestions> data) {
    if (currentIndex < data.length - 1) {
      currentIndex++;
      allAnswers.add(selectedAnswer);
      pageController?.animateToPage(
        currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  _back() {
    if (currentIndex != 0) {
      currentIndex--;
      pageController?.animateToPage(
        currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Container(
              // height: h,
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
              child: FutureBuilder(
                future: InventoryQuestions.getQuestions(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    final questionsArr = snapshot.data!;
                    return PageView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      controller: pageController,
                      scrollDirection: Axis.horizontal,
                      itemCount: questionsArr.length,
                      itemBuilder: (context, index) {
                        return displayDifferentCards(questionsArr, index,
                            questionsArr[index].type, questionsArr[index].id);
                      },
                    );
                  }
                  return Container(
                    color: Colors.amber,
                  );
                },
              ),
              // child: DropDownCard(),
            ),
          ),
          Positioned(
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
                  _back();
                },
                icon: const Icon(Icons.arrow_back),
              ),
              title: const CustomText(
                title: 'Add Inventory',
                fontWeight: FontWeight.w700,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget displayDifferentCards(
      List<InventoryQuestions> questionsArr, int index, String type, int id) {
    switch (id) {
      case 5:
        return TextFormCard(
          fieldsPlaceholder: questionsArr[index].options,
          onSelect: () {
            currentIndex++;
            pageController?.animateToPage(
              currentIndex,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          },
        );
      case 9:
        return DropDownCard();
      default:
        // return Text('data');
        return ChipButtonCard(
          question: questionsArr[index].question,
          options: questionsArr[index].options,
          data: questionsArr,
          currentIndex: currentIndex,
          onSelect: _next,
        );
    }
  }
}
