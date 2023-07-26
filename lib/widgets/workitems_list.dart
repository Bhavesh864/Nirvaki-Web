import 'package:flutter/material.dart';

import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/widgets/card/custom_card.dart';

class WorkItemsList extends StatefulWidget {
  final bool headerShow;
  const WorkItemsList({super.key, this.headerShow = true});

  @override
  State<WorkItemsList> createState() => _WorkItemsListState();
}

class _WorkItemsListState extends State<WorkItemsList> {
  late Future<List<CardDetails>> getCardDetails;

  @override
  void initState() {
    getCardDetails = CardDetails.getCardDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Container(
          constraints: BoxConstraints(
            minHeight: height,
          ),
          decoration: BoxDecoration(
            color: AppColor.secondary,
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          child: SafeArea(
            right: false,
            child: Column(
              children: [
                widget.headerShow
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        height: 50,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              title: 'Work Items',
                              fontWeight: FontWeight.w600,
                            ),
                            Icon(Icons.more_horiz),
                          ],
                        ),
                      )
                    : Container(),
                FutureBuilder(
                  future: getCardDetails,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        height: height * 0.7,
                        child: const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      );
                    }
                    if (snapshot.hasData) {
                      return SizedBox(
                        height: Responsive.isMobile(context) ? height * 0.75 : height * 0.8,
                        child: ListView(
                          shrinkWrap: true,
                          // physics: const NeverScrollableScrollPhysics(),
                          children: List.generate(
                            snapshot.data!.length,
                            (index) => CustomCard(index: index, cardDetails: snapshot.data!),
                          ),
                        ),
                      );
                    }
                    return const Center(
                      child: Text("NO data found"),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
