import 'package:flutter/material.dart';

import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/constants/constants.dart';
import 'package:yes_broker/constants/firebase/inventory_questions.dart';
import 'package:yes_broker/widgets/card/chip_button_card.dart';

class AddInventory extends StatefulWidget {
  static const routeName = '/add-inventory';
  const AddInventory({super.key});

  @override
  State<AddInventory> createState() => _AddInventoryState();
}

class _AddInventoryState extends State<AddInventory> {
  var _indexQuestion = 0;
  var selectedOption = '';
  List<String> allAnswers = [];

  _next(String selectedAnswer, List<InventoryQuestions> question) {
    // if (selectedAnswer == 'Direct') {
    //   answers.removeAt(_indexQuestion);
    //   _questions.removeAt(_indexQuestion);
    // }
    selectedOption = selectedAnswer;
    allAnswers.add(selectedAnswer);
    print(question);
    setState(() {
      var lastIndex = question.length - 1;
      if (_indexQuestion < lastIndex) {
        _indexQuestion++;
      } else {
        // Is the last question
      }
    });
  }

  _back() {
    setState(() {
      var firstIndex = 0;
      if (_indexQuestion > firstIndex) {
        _indexQuestion--;
      } else {
        // Is the firstz question
      }
    });
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
                  if (snapshot.hasData) {
                    return ChipButtonCard(
                      data: snapshot.data!,
                      currentQuestionIndex: _indexQuestion,
                      onSelect: _next,
                    );
                  }
                  return const SizedBox();
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
}
