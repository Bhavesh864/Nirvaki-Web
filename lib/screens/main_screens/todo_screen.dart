import 'package:flutter/material.dart';

import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/widgets/todo/todo_filter_view.dart';
import 'package:yes_broker/widgets/todo/todo_list_view.dart';

import '../../widgets/calendar_view.dart';
import '../../widgets/top_search_bar.dart';
import '../../widgets/workitems/workitems_list.dart';

class TodoTabScreen extends StatefulWidget {
  const TodoTabScreen({super.key});

  @override
  State<TodoTabScreen> createState() => _TodoTabScreenState();
}

class _TodoTabScreenState extends State<TodoTabScreen> {
  bool isFilterOpen = false;

  Future<List<CardDetails>>? future;

  @override
  void initState() {
    future = CardDetails.getCardDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              // height: height! * 0.7,
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            );
          }
          if (snapshot.hasData) {
            List<CardDetails> todoItems = snapshot.data!.where((item) => item.cardType != "IN" && item.cardType != "LD").toList();
            return Container(
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: AppColor.secondary,
                    spreadRadius: 12,
                    blurRadius: 4,
                    offset: Offset(5, 5),
                  ),
                ],
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        TopSerachBar(
                            title: 'Todo',
                            isMobile: Responsive.isMobile(context),
                            isFilterOpen: isFilterOpen,
                            onFilterClose: () {
                              setState(() {
                                isFilterOpen = false;
                              });
                            },
                            onFilterOpen: () {
                              setState(() {
                                isFilterOpen = true;
                              });
                            }),
                        Expanded(
                          // height: height! * 0.74,
                          child: Row(
                            children: [
                              !Responsive.isMobile(context)
                                  ? Expanded(
                                      child: WorkItemsList(
                                        title: 'To do',
                                        headerShow: false,
                                        getCardDetails: todoItems,
                                      ),
                                    )
                                  : Expanded(
                                      child: SingleChildScrollView(
                                        // physics: const NeverScrollableScrollPhysics(),
                                        child: Column(
                                          children: [
                                            const CustomCalendarView(),
                                            Container(
                                              constraints: BoxConstraints(),
                                              child: WorkItemsList(
                                                isScrollable: false,
                                                title: 'To do',
                                                getCardDetails: todoItems,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                              !Responsive.isMobile(context)
                                  ? const Expanded(
                                      child: TodoListView(
                                        headerShow: false,
                                      ),
                                    )
                                  : Container(),
                              if (size.width > 1200)
                                if (!Responsive.isMobile(context) && !isFilterOpen)
                                  const Expanded(
                                    child: TodoListView(
                                      headerShow: false,
                                    ),
                                  )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Responsive.isDesktop(context) && isFilterOpen
                      ? Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                                width: 1,
                                color: Colors.grey.withOpacity(0.5),
                              ),
                              Expanded(
                                child: TodoFilterView(
                                  closeFilterView: () {
                                    setState(() {
                                      isFilterOpen = false;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        });
  }
}
