import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/constants/app_constant.dart';

import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';

import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/widgets/calendar_view.dart';
import 'package:yes_broker/widgets/timeline_view.dart';
import 'package:yes_broker/widgets/workitems/workitems_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<CardDetails>> getCardDetails;

  @override
  void initState() {
    super.initState();
    getCardDetails = CardDetails.getCardDetails();
    // adddata();
    // getdata();
    print(AppConst.getAccessToken());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer(
      builder: (context, ref, child) {
        // final currentUserData = ref.watch(userProvider).state;
        return FutureBuilder(
          future: getCardDetails,
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
              List<CardDetails> workItems = snapshot.data!.where((item) => item.cardType == "IN" || item.cardType == "LD").toList();
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
                                    child: const Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                                          child: CustomText(
                                            title: 'Timeline',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        CustomTimeLineView(),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        );
      },
    );
  }
}
