import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/Customs/custom_chip.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';
import 'package:yes_broker/constants/functions/navigation/navigation_functions.dart';
import 'package:yes_broker/routes/routes.dart';
import 'package:yes_broker/widgets/card/custom_card.dart';

import '../../../Customs/responsive.dart';
import '../../../constants/utils/colors.dart';
import '../../../constants/utils/constants.dart';
import '../../table_view/table_view_widgets.dart';

class TodoTabView extends ConsumerStatefulWidget {
  final String id;
  const TodoTabView({super.key, required this.id});

  @override
  _TodoTabViewState createState() => _TodoTabViewState();
}

class _TodoTabViewState extends ConsumerState<TodoTabView> {
  bool showTableView = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: Responsive.isMobile(context) ? MediaQuery.of(context).size.width * 0.55 : MediaQuery.of(context).size.width * 0.3,
                child: TextField(
                  controller: TextEditingController(),
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              Row(
                children: [
                  if (!Responsive.isMobile(context))
                    GestureDetector(
                      onTap: () {
                        showTableView = !showTableView;
                        setState(() {});
                      },
                      child: const CustomChip(
                        label: Icon(
                          Icons.view_agenda_outlined,
                          size: 24,
                        ),
                      ),
                    ),
                  const SizedBox(
                    width: 8,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.beamToNamed(AppRoutes.addTodo);
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.add),
                        CustomText(
                          title: 'Add new',
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        FutureBuilder(
            future: CardDetails.getcardByInventoryId(widget.id),
            builder: (context, snapshot) {
              final todoList = snapshot.data;
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 300,
                  child: Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                );
              }
              if (snapshot.hasData) {
                if (showTableView) {
                  final tableRowList = todoList!.map((e) {
                    return buildWorkItemRowTile(e, todoList.indexOf(e), todoList);
                  });
                  return todoList.isNotEmpty
                      ? Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 0),
                          padding: EdgeInsets.zero,
                          child: LayoutBuilder(builder: (context, constraints) {
                            final availableWidth = constraints.maxWidth;
                            return Table(
                              columnWidths: {
                                0: FixedColumnWidth(availableWidth * 0.25),
                                1: FixedColumnWidth(availableWidth * 0.18),
                                2: FixedColumnWidth(availableWidth * 0.15),
                                3: FixedColumnWidth(availableWidth * 0.20),
                                4: FixedColumnWidth(availableWidth * 0.1),
                                5: FixedColumnWidth(availableWidth * 0.1),
                              },
                              border: TableBorder(
                                bottom: BorderSide(color: Colors.grey.withOpacity(.5), width: 1.5),
                                horizontalInside: BorderSide(color: Colors.grey.withOpacity(.5), width: 1.5),
                              ),
                              children: [
                                buildTableHeader(),
                                ...tableRowList,
                              ],
                            );
                          }),
                        )
                      : SizedBox(
                          height: 300,
                          width: width! * 0.9,
                          child: const Center(
                            child: Text(
                              "No results found.",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                } else {
                  return todoList!.isNotEmpty
                      ? Container(
                          decoration: BoxDecoration(
                            color: AppColor.secondary,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: Responsive.isMobile(context) ? 1 : 2,
                                mainAxisSpacing: 10.0, // Spacing between rows
                                crossAxisSpacing: 10.0,
                                mainAxisExtent: 170 // Spacing between columns
                                ),
                            itemCount: todoList.length,
                            itemBuilder: (context, index) => GestureDetector(
                              onTap: () {
                                navigateBasedOnId(context, todoList[index].workitemId!, ref);
                              },
                              child: CustomCard(cardDetails: todoList, index: index),
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 300,
                          width: width! * 0.9,
                          child: const Center(
                            child: Text(
                              "No results found.",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                }
              }
              return Container(
                color: Colors.indigo,
                height: 300,
                child: const Center(
                  child: CustomText(title: "NO DATA FOUND"),
                ),
              );
            }),
      ],
    );
  }
}
