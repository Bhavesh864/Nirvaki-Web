import 'package:flutter/material.dart';

import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/constants/constants.dart';
import 'package:yes_broker/widgets/card/chip_button_card.dart';
import 'package:yes_broker/widgets/card/dropdown_card.dart';

class AddInventory extends StatefulWidget {
  static const routeName = '/add-inventory';
  const AddInventory({super.key});

  @override
  State<AddInventory> createState() => _AddInventoryState();
}

class _AddInventoryState extends State<AddInventory> {
  var _indexQuestion = 0;
  var selectedOption = '';

  final _questions = [
    'Which Property Category does this inventory Fall under ?',
    'What Category does this inventory belong to?',
    'What is the specific type of Property?',
    'From where did you source this inventory?',
    'What kind of property would you like to list?',
  ];

  List answers = [
    ['Residential', 'Commercial'],
    ['Rent', 'Sell'],
    ['Direct', 'Broker'],
    [
      '99Acers',
      'Magic Bricks',
      'Housing.com',
      'Social Media',
      'Data Calling',
      'Other',
    ],
    [
      'Apartment',
      'Independent House/Villa ',
      'Builder Floor ',
      'Plot',
      'Farm House',
    ],
  ];

  _next(String selectedAnswer) {
    if (selectedAnswer == 'Direct') {
      answers.removeAt(_indexQuestion);
      _questions.removeAt(_indexQuestion);
    }
    selectedOption = selectedAnswer;
    setState(() {
      var lastIndex = _questions.length - 1;
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
              child: ChipButtonCard(
                questions: _questions,
                currentQuestionIndex: _indexQuestion,
                answers: answers,
                onSelect: _next,
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
