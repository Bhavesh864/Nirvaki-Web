import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';
import 'package:yes_broker/constants/firebase/statesModel/state_c_ity_model.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/Customs/custom_text.dart';

import 'package:yes_broker/widgets/calendar_view.dart';
import 'package:yes_broker/widgets/timeline_view.dart';
import 'package:yes_broker/widgets/workitems/workitems_list.dart';

import '../../constants/firebase/questionModels/inventory_question.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  late Future<List<CardDetails>> getCardDetails;

  @override
  void initState() {
    super.initState();
    getCardDetails = CardDetails.getCardDetails();
    // setdata();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: getCardDetails,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            child: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        }
        if (snapshot.hasData) {
          List<CardDetails> workItems = snapshot.data!.where((item) => item.cardType == "IN" || item.cardType == "LD").toList();
          List<CardDetails> todoItems = snapshot.data!.where((item) => item.cardType != "IN" && item.cardType != "LD").toList();
          return Row(
            children: [
              Expanded(
                flex: size.width > 1340 ? 3 : 5,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, left: 0),
                  child: WorkItemsList(
                    title: "To do",
                    getCardDetails: todoItems,
                  ),
                ),
              ),
              size.width > 1200
                  ? Expanded(
                      flex: size.width > 1340 ? 3 : 5,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: WorkItemsList(
                          title: "Work Items",
                          getCardDetails: workItems,
                        ),
                      ),
                    )
                  : Container(),
              size.width >= 850
                  ? Expanded(
                      flex: size.width > 1340 ? 4 : 6,
                      child: Column(
                        children: [
                          const Expanded(
                            flex: 2,
                            child: CustomCalendarView(),
                          ),
                          Expanded(
                            flex: 4,
                            child: Container(
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: AppColor.secondary,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                                    child: CustomText(
                                      title: 'Timeline',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Container(
                                    height: 360,
                                    margin: const EdgeInsets.symmetric(horizontal: 10),
                                    child: const CustomTimeLineView(
                                      fromHome: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }
}
