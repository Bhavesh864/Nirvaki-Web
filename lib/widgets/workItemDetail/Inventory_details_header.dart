// ignore_for_file: use_build_context_synchronously

// import 'dart:html';
import 'package:flutter/material.dart';

import 'package:yes_broker/Customs/responsive.dart';

import 'package:yes_broker/constants/firebase/detailsModels/lead_details.dart';
import 'package:yes_broker/constants/firebase/send_notification.dart';
import 'package:yes_broker/widgets/app/dropdown_menu.dart';
import '../../Customs/custom_chip.dart';
import '../../Customs/custom_text.dart';
import '../../Customs/snackbar.dart';
import '../../constants/app_constant.dart';
import '../../constants/firebase/detailsModels/card_details.dart';
import '../../constants/firebase/detailsModels/inventory_details.dart';
import '../../constants/firebase/userModel/user_info.dart';
import '../../constants/utils/colors.dart';
import '../../constants/utils/constants.dart';
import '../app/nav_bar.dart';
import '../app/app_bar.dart';

Future<void> shareUrl(BuildContext context, {String textToCombine = ''}) async {
  try {
    // final currentUrl = window.location.href;
    // await Clipboard.setData(ClipboardData(text: currentUrl + textToCombine));
    customSnackBar(context: context, text: 'URL copied to clipboard');
  } catch (e) {
    print('Error sharing URL: $e');
  }
}

class InventoryDetailsHeader extends StatelessWidget {
  final String title;
  final String category;
  final String id;
  final String propertyCategory;
  final String status;
  final String type;
  final String? price;
  final String? unit;
  final Function setState;
  final dynamic inventoryDetails;

  const InventoryDetailsHeader({
    super.key,
    required this.title,
    required this.id,
    this.inventoryDetails,
    required this.category,
    required this.propertyCategory,
    required this.status,
    required this.type,
    required this.price,
    required this.unit,
    required this.setState,
  });

  // Future<void> shareUrl(BuildContext context) async {
  //   try {
  //     final currentUrl = window.location.href;
  //     await Clipboard.setData(ClipboardData(text: currentUrl));
  //     customSnackBar(context: context, text: 'URL copied to clipboard');
  //   } catch (e) {
  //     print('Error sharing URL: $e');
  //   }
  // }

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
                inventoryDetails: inventoryDetails,
                category: category,
                type: type,
                propertyCategory: propertyCategory,
                status: status,
                id: id,
              ),
            CustomChip(
              onPressed: () {
                shareUrl(context);
              },
              label: const Icon(
                Icons.share_outlined,
              ),
              paddingHorizontal: 3,
            ),
            if (!AppConst.getPublicView() || AppConst.getIsAuthenticated())
              PopupMenuButton(
                tooltip: '',
                splashRadius: 0,
                padding: EdgeInsets.zero,
                color: Colors.white.withOpacity(1),
                offset: const Offset(10, 40),
                itemBuilder: (context) => dropDownDetailsList
                    .map(
                      (e) => appBarPopupMenuItem(e['title'].toString(), (e) {
                        if (e.contains('Public')) {
                          AppConst.setPublicView(!AppConst.getPublicView());
                          setState();
                        } else {
                          // AppConst.getOuterContext()!.beamToNamed(AppRoutes.addInventory);
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

class HeaderChips extends StatefulWidget {
  final String category;
  final String type;
  final String propertyCategory;
  final String status;
  final String id;
  final dynamic inventoryDetails;

  const HeaderChips({
    super.key,
    required this.category,
    required this.type,
    required this.propertyCategory,
    required this.status,
    required this.id,
    this.inventoryDetails,
  });

  @override
  State<HeaderChips> createState() => _HeaderChipsState();
}

class _HeaderChipsState extends State<HeaderChips> {
  String? currentStatus;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        CustomChip(
          color: AppColor.primary.withOpacity(0.1),
          label: CustomText(
            title: widget.category,
            size: 10,
            color: AppColor.primary,
          ),
        ),
        CustomChip(
          color: AppColor.primary.withOpacity(0.1),
          label: CustomText(
            title: widget.type,
            size: 10,
            color: AppColor.primary,
          ),
        ),
        CustomChip(
          color: AppColor.primary.withOpacity(0.1),
          label: CustomText(
            title: widget.propertyCategory,
            size: 10,
            color: AppColor.primary,
          ),
        ),
        if (!AppConst.getPublicView())
          CustomStatusDropDown(
            status: currentStatus ?? widget.status,
            itemBuilder: (context) => dropDownStatusDataList.map((e) => popupMenuItem(e.toString())).toList(),
            onSelected: (value) {
              CardDetails.updateCardStatus(id: widget.id, newStatus: value);
              if (widget.id.contains(ItemCategory.isInventory)) {
                InventoryDetails.updatecardStatus(id: widget.id, newStatus: value);
              } else if (widget.id.contains(ItemCategory.isLead)) {
                LeadDetails.updatecardStatus(id: widget.id, newStatus: value);
              }
              currentStatus = value;
              setState(() {});
              print(widget.inventoryDetails?.assignedto?[0].userid);
              notifyToUser(
                  itemid: widget.id,
                  assignedto: widget.inventoryDetails.assignedto,
                  content: "${currentUser["userfirstname"]} ${currentUser["userlastname"]} change status to $value",
                  title: "${widget.id.contains(ItemCategory.isInventory) ? "Inventory" : "Lead"} status changed");
            },
          ),
      ],
    );
  }
}
