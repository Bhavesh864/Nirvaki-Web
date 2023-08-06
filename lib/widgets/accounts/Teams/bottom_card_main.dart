import 'package:flutter/material.dart';
import 'package:yes_broker/Customs/text_utility.dart';
import 'package:yes_broker/constants/utils/colors.dart';

class BottomCardMain extends StatefulWidget {
  const BottomCardMain({super.key});

  @override
  State<BottomCardMain> createState() => _BottomCardMainState();
}

class _BottomCardMainState extends State<BottomCardMain> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppText(text: "NAME", textColor: AppColor.cardtitleColor),
              AppText(text: "ROLE", textColor: AppColor.cardtitleColor),
              AppText(text: "MANAGER", textColor: AppColor.cardtitleColor),
              AppText(text: ""),
            ],
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColor.baseline))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const AppText(text: "Ketki Sharma", fontsize: 12, fontWeight: FontWeight.bold),
                      const AppText(text: "Manager", fontsize: 12, fontWeight: FontWeight.w400),
                      Row(
                        children: [
                          IconButton(onPressed: () {}, icon: const Icon(Icons.abc)),
                          const AppText(text: "Raj Sharma", fontsize: 12, fontWeight: FontWeight.w400),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(color: AppColor.secondary, borderRadius: BorderRadius.circular(7)),
                        child: IconButton(
                          tooltip: "Edit",
                          iconSize: 12,
                          onPressed: () {},
                          icon: const Icon(Icons.edit),
                        ),
                      )
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}
