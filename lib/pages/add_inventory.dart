import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/constants/firebase/questions.dart';
import 'package:yes_broker/constants/functions/get_inventory_questions.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import '../Customs/custom_fields.dart';
import '../constants/utils/image_constants.dart';

class AddInventory extends ConsumerStatefulWidget {
  static const routeName = '/add-inventory';
  const AddInventory({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddInventoryState createState() => _AddInventoryState();
}

class _AddInventoryState extends ConsumerState<AddInventory> {
  late Future<List<Questions>> getQuestions;
  PageController? pageController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    getQuestions = Questions.getAllQuestionssFromFirestore();
    pageController = PageController(initialPage: currentIndex);
  }

  nextQuestion(List<Screen> screens) {
    if (currentIndex < screens.length - 1) {
      setState(() {
        currentIndex++; // Increment the current index
        pageController!.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    } else {
      // Handle reaching the last question or any other action
    }
  }

  goBack() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--; // Decrement the current index
        pageController!.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    } else {
      Navigator.pop(context); // Go back to the previous screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Questions>>(
        future: getQuestions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator
                    .adaptive()); // Display a loading indicator while waiting
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Questions> screenData = snapshot.data as List<Questions>;
            List<Screen> screens = screenData[0].screens;

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
                  child: PageView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: pageController,
                    scrollDirection: Axis.horizontal,
                    itemCount: screens.length,
                    itemBuilder: (context, index) {
                      return Center(
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            constraints: const BoxConstraints(
                              minHeight: 0,
                              maxHeight: double.infinity,
                            ),
                            width: Responsive.isMobile(context)
                                ? width! * 0.9
                                : 650,
                            padding: const EdgeInsets.all(25),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (screens[index].title != null)
                                  CustomText(
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                    size: 30,
                                    title: screens[index].title.toString(),
                                    fontWeight: FontWeight.bold,
                                  ),
                                for (var i = 0;
                                    i < screens[index].questions.length;
                                    i++)
                                  Column(
                                    children: [
                                      if (screens[index].title == null)
                                        CustomText(
                                          softWrap: true,
                                          textAlign: TextAlign.center,
                                          size: 30,
                                          title: screens[index]
                                              .questions[i]
                                              .questionTitle,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      // buildQuestionWidget(
                                      //   screens[index].questions[i],
                                      //   screens,
                                      // ),
                                      buildQuestionWidget(
                                        screens[index].questions[i],
                                        screens,
                                        currentIndex,
                                        selectedOption,
                                        pageController!,
                                      ),
                                      if (i ==
                                              screens[index].questions.length -
                                                  1 &&
                                          screens[index]
                                                  .questions[i]
                                                  .questionOptionType !=
                                              'chip')
                                        Container(
                                          margin:
                                              const EdgeInsets.only(top: 10),
                                          alignment: Alignment.centerRight,
                                          child: CustomButton(
                                            text: 'Next',
                                            onPressed: () {
                                              nextQuestion(screens);
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
                      );
                    },
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
                        goBack();
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    title: Consumer(
                      builder: (context, ref, child) {
                        return const CustomText(
                          title: 'Add Inventory ',
                          fontWeight: FontWeight.w700,
                          size: 20,
                          color: Colors.white,
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
