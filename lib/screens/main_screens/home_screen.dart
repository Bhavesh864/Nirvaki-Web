import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/customs/loader.dart';

import 'package:yes_broker/widgets/calendar_view.dart';
import 'package:yes_broker/widgets/timeline_view.dart';
import 'package:yes_broker/widgets/workitems/empty_work_item_list.dart';
import 'package:yes_broker/widgets/workitems/workitems_list.dart';

import '../../constants/app_constant.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder(
      // future: getCardDetails,
      stream: cardDetailsCollection.orderBy("createdate", descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }

        if (snapshot.hasData) {
          final filterItem = snapshot.data?.docs.where((item) => item["assignedto"].any((user) => user["userid"] == AppConst.getAccessToken()));
          final List<CardDetails> todoItems =
              filterItem!.map((doc) => CardDetails.fromSnapshot(doc)).where((item) => item.cardType != "IN" && item.cardType != "LD").toList();

          final List<CardDetails> workItems =
              filterItem.map((doc) => CardDetails.fromSnapshot(doc)).where((item) => item.cardType == "IN" || item.cardType == "LD").toList();

          return Row(
            children: [
              if (workItems.isEmpty && todoItems.isEmpty) ...[
                Expanded(flex: size.width > 1340 ? 5 : 6, child: const EmptyWorkItemList()),
              ] else ...[
                Expanded(
                  flex: size.width > 1340 ? 3 : 5,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
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
              ],
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
                                borderRadius: BorderRadius.circular(10),
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
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 10),

                                      // height: 360,
                                      child: const CustomTimeLineView(
                                        fromHome: true,
                                      ),
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
