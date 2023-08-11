import 'package:flutter/material.dart';
import 'package:yes_broker/Customs/responsive.dart';

import '../../Customs/custom_chip.dart';
import '../../Customs/custom_text.dart';
import '../../constants/app_constant.dart';
import '../../constants/utils/colors.dart';
import '../../constants/utils/constants.dart';
import '../app/app_bar.dart';

class InventoryDetailsHeader extends StatelessWidget {
  final String title;
  final String category;
  final String propertyCategory;
  final String status;
  final String type;
  final String? price;
  final String? unit;
  final Function setState;

  const InventoryDetailsHeader({
    super.key,
    required this.title,
    required this.category,
    required this.propertyCategory,
    required this.status,
    required this.type,
    required this.price,
    required this.unit,
    required this.setState,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0), // Adjust as needed
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            if (!Responsive.isMobile(context))
              HeaderChips(
                category: category,
                type: type,
                propertyCategory: propertyCategory,
                status: status,
              ),
            const CustomChip(
              label: Icon(
                Icons.share_outlined,
              ),
              paddingHorizontal: 3,
            ),
            PopupMenuButton(
              tooltip: '',
              initialValue: status,
              splashRadius: 0,
              padding: EdgeInsets.zero,
              color: Colors.white.withOpacity(1),
              offset: const Offset(10, 40),
              itemBuilder: (context) => dropDownDetailsList
                  .map(
                    (e) => popupMenuItem(e['title'].toString(), (e) {
                      if (e.contains('Public')) {
                        AppConst.setPublicView(!AppConst.getPublicView());
                        setState();
                      }
                    }, showicon: true, icon: e['icon']),
                  )
                  .toList(),
              child: const CustomChip(
                label: Icon(
                  Icons.more_vert,
                ),
                paddingHorizontal: 3,
              ),
            ),
          ],
        ),
        if (!Responsive.isMobile(context))
          CustomText(
            title: price != null ? '$price$unit' : '50k/month',
            color: AppColor.primary,
          ),
      ],
    );
  }
}

class HeaderChips extends StatelessWidget {
  final String category;
  final String type;
  final String propertyCategory;
  final String status;

  const HeaderChips({
    super.key,
    required this.category,
    required this.type,
    required this.propertyCategory,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        CustomChip(
          color: AppColor.primary.withOpacity(0.1),
          label: CustomText(
            title: category,
            size: 10,
            color: AppColor.primary,
          ),
        ),
        CustomChip(
          color: AppColor.primary.withOpacity(0.1),
          label: CustomText(
            title: type,
            size: 10,
            color: AppColor.primary,
          ),
        ),
        CustomChip(
          color: AppColor.primary.withOpacity(0.1),
          label: CustomText(
            title: propertyCategory,
            size: 10,
            color: AppColor.primary,
          ),
        ),
        if (!AppConst.getPublicView())
          SizedBox(
            width: 60,
            child: PopupMenuButton(
              tooltip: '',
              initialValue: status,
              splashRadius: 0,
              padding: EdgeInsets.zero,
              color: Colors.white.withOpacity(1),
              offset: const Offset(10, 40),
              itemBuilder: (context) => dropDownStatusDataList.map((e) => popupMenuItem(e.toString(), (e) {})).toList(),
              child: CustomChip(
                label: Row(
                  children: [
                    CustomText(
                      title: selectedOption,
                      color: taskStatusColor(selectedOption),
                      size: 10,
                    ),
                    Icon(
                      Icons.expand_more,
                      size: 18,
                      color: taskStatusColor(selectedOption),
                    ),
                  ],
                ),
                color: taskStatusColor(selectedOption).withOpacity(0.1),
              ),
            ),
          ),
      ],
    );
  }
}
