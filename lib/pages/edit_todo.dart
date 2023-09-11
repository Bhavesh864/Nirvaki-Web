import 'package:flutter/material.dart';

import 'package:yes_broker/customs/custom_chip.dart';
import 'package:yes_broker/customs/custom_fields.dart';
import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';
import 'package:yes_broker/constants/utils/image_constants.dart';
import '../customs/custom_text.dart';
import '../customs/responsive.dart';
import '../constants/utils/colors.dart';
import '../constants/utils/constants.dart';

class EditTodo extends StatefulWidget {
  final CardDetails? cardDetails;

  const EditTodo({Key? key, this.cardDetails}) : super(key: key);

  @override
  State<EditTodo> createState() => _EditTodoState();
}

class _EditTodoState extends State<EditTodo> {
  PageController? pageController;
  int currentScreenIndex = 0;
  String? title;
  @override
  void initState() {
    pageController = PageController(initialPage: currentScreenIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
              itemCount: currentScreenIndex == 0 ? 2 : 1,
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
                        children: [
                          if (currentScreenIndex == 0) ...[
                            CardContainer(
                              cardDetails: widget.cardDetails!,
                              onselected: (title) {
                                setState(() {
                                  title = title;
                                  currentScreenIndex = 1;
                                });
                              },
                            ),
                          ] else ...[
                            getwidgetBytitle(title)
                          ]
                        ],
                      ),
                    ),
                  ),
                ));
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget getwidgetBytitle(title) {
  if (title == "Task Name and Description") {
    return CustomTextInput(
      controller: TextEditingController(),
      hintText: "helo",
    );
  } else if (title == "Type of To Do") {
    CustomChip(
      label: const Text("data"),
      onPressed: () {},
    );
  }
  return const SizedBox();
}

class CardContainer extends StatelessWidget {
  final CardDetails cardDetails;
  final Function(String title) onselected;
  const CardContainer({Key? key, required this.cardDetails, required this.onselected}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CustomText(
          softWrap: true,
          textAlign: TextAlign.center,
          size: 30,
          title: "What do you want to edit?",
          fontWeight: FontWeight.bold,
        ),
        for (var chipData in _getChipDataList())
          ChipCustom(
            title: chipData.title,
            text: chipData.text,
            onSelect: () {
              onselected(chipData.title);
            },
          ),
      ],
    );
  }

  List<ChipData> _getChipDataList() {
    return [
      ChipData(title: "Type of To Do", text: cardDetails.cardType!),
      const ChipData(title: "Task Name and Description", text: ""),
      ChipData(title: "Due Date", text: cardDetails.duedate!),
      ChipData(title: "Work Item Linked", text: cardDetails.linkedItemType!),
    ];
  }
}

class ChipCustom extends StatelessWidget {
  final String text;
  final String title;
  final VoidCallback onSelect;

  const ChipCustom({
    Key? key,
    required this.title,
    required this.text,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        onTap: onSelect,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          constraints: const BoxConstraints(minWidth: 140),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColor.secondary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(title: title),
              CustomText(
                title: text,
                color: AppColor.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChipData {
  final String title;
  final String text;
  const ChipData({required this.title, required this.text});
}
