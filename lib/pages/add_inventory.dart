import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/constants/firebase/inventory_details.dart';

import 'package:yes_broker/constants/firebase/inventory_questions.dart';
import 'package:yes_broker/constants/firebase/random_uid.dart';
import 'package:yes_broker/constants/firebase/user_info.dart';

import 'package:yes_broker/controllers/all_selected_ansers_provider.dart';
import 'package:yes_broker/widgets/card/questions%20card/chip_button_card.dart';
import 'package:yes_broker/widgets/card/questions%20card/dropdown_card.dart';
import 'package:yes_broker/widgets/card/questions%20card/textform_card.dart';

import '../constants/utils/image_constants.dart';

class AddInventory extends ConsumerStatefulWidget {
  static const routeName = '/add-inventory';
  const AddInventory({super.key});

  @override
  _AddInventoryState createState() => _AddInventoryState();
}

class _AddInventoryState extends ConsumerState<AddInventory> {
  PageController? pageController;

  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: currentIndex);
  }

  final randomuid = generateUid();
  var selectedOption = '';
  List<String> allAnswers = [];
// dd
  // submit() async {
  //   final InventoryDetails item = InventoryDetails(
  //       inventoryTitle: 'inventoryTitle',
  //       inventoryDescription: 'inventoryDescription',
  //       inventoryId: 'inventoryId',
  //       inventoryStatus: "new",
  //       brokerid: auth.currentUser!.uid,
  //       inventorycategory: 'array'[0],
  //       customerinfo: Customerinfo(firstname: "maish", lastname: "", email: ""),
  //       createdby: Createdby());

  //   await InventoryDetails.addInventoryDetails(item);
  // }

  _next(String selectedAnswer, List<InventoryQuestions> data) {
    if (currentIndex < data.length - 1) {
      currentIndex++;
      // allAnswers.add(selectedAnswer);
      ref.read(allSelectedAnswersProvider.notifier).add(selectedAnswer);
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
                      physics: const NeverScrollableScrollPhysics(),
                      controller: pageController,
                      scrollDirection: Axis.horizontal,
                      itemCount: questionsArr.length,
                      itemBuilder: (context, index) {
                        return displayDifferentCards(
                            questionsArr,
                            index,
                            questionsArr[index].type,
                            questionsArr[index].id,
                            questionsArr[index].question);
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

  Widget displayDifferentCards(List<InventoryQuestions> questionsArr, int index,
      String type, int id, String question) {
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
      case 9 || 10:
        return DropDownCard(
            values: questionsArr[index].dropdownList,
            question: question,
            onSelect: () {
              currentIndex++;
              pageController?.animateToPage(
                currentIndex,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
            },
            id: id);
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
