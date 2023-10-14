// import 'dart:html';
import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/constants/firebase/detailsModels/lead_details.dart';
import 'package:yes_broker/constants/firebase/send_notification.dart';
import 'package:yes_broker/riverpodstate/user_data.dart';
import 'package:yes_broker/widgets/app/dropdown_menu.dart';
import '../../Customs/custom_chip.dart';
import '../../Customs/custom_text.dart';

import '../../constants/app_constant.dart';
import '../../constants/firebase/detailsModels/card_details.dart';
import '../../constants/firebase/detailsModels/inventory_details.dart';
import '../../constants/firebase/userModel/user_info.dart';
import '../../constants/utils/colors.dart';
import '../../constants/utils/constants.dart';
import '../../riverpodstate/common_index_state.dart';
import '../../routes/routes.dart';
import '../app/app_bar.dart';
import '../app/nav_bar.dart';

Future<void> shareUrl(BuildContext context, {String textToCombine = ''}) async {
  try {
    // final location = Beamer.of(context).currentBeamLocation.state.routeInformation.location!;
    // print(location);

    // final currentUrl = window.location.href;
    // Clipboard.setData(ClipboardData(text: currentUrl + textToCombine)).then((_) {
    //   customSnackBar(context: context, text: 'URL copied to clipboard');
    // });
  } catch (e) {
    print('Error sharing URL: $e');
  }
}

class InventoryDetailsHeader extends ConsumerWidget {
  final String title;
  final String category;
  final String id;
  final String propertyCategory;
  final String status;
  final String type;
  final String? price;
  final Function setState;
  final Function(int) setCurrentIndex;
  final dynamic inventoryDetails;

  const InventoryDetailsHeader(
      {super.key,
      required this.title,
      required this.id,
      this.inventoryDetails,
      required this.category,
      this.setCurrentIndex = defaultFunc,
      required this.propertyCategory,
      required this.status,
      required this.type,
      required this.price,
      required this.setState});

  static void defaultFunc(e) {}

  Future<void> shareUrl(BuildContext context) async {
    try {
      // final currentUrl = window.location.href;
      // await Clipboard.setData(ClipboardData(text: currentUrl));
      // customSnackBar(context: context, text: 'URL copied to clipboard');
    } catch (e) {
      print('Error sharing URL: $e');
    }
  }

  void navigateToEditPage(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 500), () {
      AppConst.getOuterContext()?.beamToNamed(
        id.contains("IN") ? AppRoutes.addInventory : AppRoutes.addLead,
        data: true,
      );
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: Responsive.isMobile(context) ? width! * 0.75 : null,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0), // Adjust as needed
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  // overflow: TextOverflow.ellipsis,
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
            Row(
              children: [
                CustomChip(
                  paddingVertical: 5,
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
                    // tooltip: '',
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.white.withOpacity(1),
                    offset: const Offset(10, 40),
                    itemBuilder: (context) => AppConst.getPublicView()
                        ? dropDownDetailsList2
                            .map(
                              (e) => appBarPopupMenuItem(e['title'].toString(), (e) {
                                if (e.contains('Public')) {
                                  AppConst.setPublicView(!AppConst.getPublicView());
                                  setState();
                                } else if (e.contains("Edit")) {
                                  Future.delayed(const Duration(milliseconds: 400)).then(
                                    (value) => AppConst.getOuterContext()!.beamToNamed(id.contains("IN") ? AppRoutes.addInventory : AppRoutes.addLead, data: true),
                                  );
                                }
                              }, showicon: true, icon: e['icon']),
                            )
                            .toList()
                        : dropDownDetailsList
                            .map(
                              (e) => appBarPopupMenuItem(e['title'].toString(), (e) {
                                if (e.contains('Public')) {
                                  AppConst.setPublicView(!AppConst.getPublicView());
                                  setCurrentIndex(0);

                                  setState();
                                } else if (e.contains("Edit")) {
                                  Future.delayed(const Duration(milliseconds: 400)).then(
                                    (value) => AppConst.getOuterContext()!.beamToNamed(id.contains("IN") ? AppRoutes.addInventory : AppRoutes.addLead, data: true),
                                  );
                                }
                              }, showicon: true, icon: e['icon']),
                            )
                            .toList(),
                    child: IntrinsicWidth(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: kIsWeb ? 4.5 : 4.5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: AppColor.chipGreyColor,
                        ),
                        child: const Icon(
                          Icons.more_vert,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            if (!Responsive.isMobile(context)) ...[
              const Spacer(),
              CustomText(
                title: price!.contains('₹') ? price! : '₹$price',
                color: AppColor.primary,
              ),
            ]
          ],
        ),
      ],
    );
  }
}

class HeaderChips extends ConsumerStatefulWidget {
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
  ConsumerState<HeaderChips> createState() => _HeaderChipsState();
}

class _HeaderChipsState extends ConsumerState<HeaderChips> {
  String? currentStatus;

  @override
  Widget build(BuildContext context) {
    final User? user = ref.read(userDataProvider);
    return Wrap(
      children: [
        CustomChip(
          paddingVertical: 6,
          color: AppColor.primary.withOpacity(0.1),
          label: CustomText(
            title: widget.category,
            size: 10,
            color: AppColor.primary,
          ),
        ),
        if (!AppConst.getPublicView())
          CustomChip(
            paddingVertical: 6,
            color: AppColor.primary.withOpacity(0.1),
            label: CustomText(
              title: widget.type,
              size: 10,
              color: AppColor.primary,
            ),
          ),
        CustomChip(
          paddingVertical: 6,
          color: AppColor.primary.withOpacity(0.1),
          label: CustomText(
            title: widget.propertyCategory,
            size: 10,
            color: AppColor.primary,
          ),
        ),
        if (!AppConst.getPublicView())
          Container(
            margin: const EdgeInsets.only(right: 4),
            child: CustomStatusDropDown(
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
                notifyToUser(
                    currentuserdata: user!,
                    itemid: widget.id,
                    assignedto: widget.inventoryDetails.assignedto,
                    content: "${user.userfirstname} ${user.userlastname} change status to $value",
                    title: "${widget.id.contains(ItemCategory.isInventory) ? "Inventory" : "Lead"} status changed");
              },
            ),
          ),
      ],
    );
  }
}
