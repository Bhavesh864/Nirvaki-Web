import 'package:flutter/material.dart';

import 'package:yes_broker/Customs/custom_chip.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';
import 'package:yes_broker/widgets/card/custom_card.dart';

import '../../../Customs/responsive.dart';
import '../../../constants/utils/colors.dart';

class TodoTabView extends StatelessWidget {
  final String id;
  final bool showTableView = false;
  const TodoTabView({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    print("todoid--------->$id");
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
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
                  const CustomChip(
                    label: Icon(
                      Icons.view_agenda_outlined,
                      size: 24,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  ElevatedButton(
                    onPressed: () {},
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
        if (showTableView)
          ...[]
        else ...[
          Container(
            decoration: BoxDecoration(
              color: AppColor.secondary,
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            child: FutureBuilder(
                future: CardDetails.getcardByInventoryId(id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(height: 300, child: Center(child: CircularProgressIndicator.adaptive()));
                  }
                  if (snapshot.data!.isEmpty) {
                    Container(
                      color: Colors.amber,
                      height: 300,
                      child: const Center(
                        child: CustomText(title: "NO DATA FOUND"),
                      ),
                    );
                  }
                  if (snapshot.hasData) {
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: Responsive.isMobile(context) ? 1 : 2,
                          mainAxisSpacing: 10.0, // Spacing between rows
                          crossAxisSpacing: 10.0,
                          mainAxisExtent: 170 // Spacing between columns
                          ),
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {},
                        child: CustomCard(cardDetails: snapshot.data!, index: index),
                      ),
                    );
                  }
                  return Container(
                    color: Colors.indigo,
                    height: 300,
                    child: const Center(
                      child: CustomText(title: "NO DATA FOUND"),
                    ),
                  );
                }),
          ),
        ]
      ],
    );
  }
}
