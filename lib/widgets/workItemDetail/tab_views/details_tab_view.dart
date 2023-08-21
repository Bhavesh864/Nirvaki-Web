// import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:yes_broker/constants/firebase/detailsModels/inventory_details.dart';
import 'package:yes_broker/constants/firebase/detailsModels/lead_details.dart';
import 'package:yes_broker/widgets/app/nav_bar.dart';

import '../../../Customs/custom_chip.dart';
import '../../../Customs/custom_text.dart';
import '../../../Customs/responsive.dart';
import '../../../constants/app_constant.dart';
import '../../../constants/functions/workitems_detail_methods.dart';
import '../../../constants/utils/constants.dart';
import '../mapview_widget.dart';

// class CustomAttachment {
//   Platform selectedFileName;
//   List<PlatformFile> pickedFilesLists = [];
//   List<String> selectedDocNameList = [];

//   CustomAttachment({
//     required this.selectedFileName,
//     required this.pickedFilesLists,
//     required this.selectedDocNameList,
//   });
// }

// ignore: must_be_immutable
class DetailsTabView extends StatefulWidget {
  final dynamic data;
  final Function updateData;
  final bool isLeadView;
  final String id;

  const DetailsTabView({
    Key? key,
    required this.data,
    this.isLeadView = false,
    required this.id,
    this.updateData = updateFunc,
  }) : super(key: key);

  static void updateFunc() {}

  @override
  State<DetailsTabView> createState() => _DetailsTabViewState();
}

class _DetailsTabViewState extends State<DetailsTabView> {
  PlatformFile? selectedFile;
  List<PlatformFile> pickedFilesList = [];
  List<String> selectedDocsNameList = [];

  @override
  Widget build(BuildContext context) {
    List<String> allImages = [];
    List<String> allTitles = [];

    if (!widget.isLeadView) {
      final inventoryData = widget.data as InventoryDetails;
      if (inventoryData.propertyphotos != null) {
        final Map<String, List<String>> propertyPhotos = {
          'frontelevation': [...inventoryData.propertyphotos!.frontelevation!],
          'bedroom': [...inventoryData.propertyphotos!.bedroom!],
          'bathroom': [...inventoryData.propertyphotos!.bathroom!],
          'pujaroom': [...inventoryData.propertyphotos!.pujaroom!],
          'servantroom': [...inventoryData.propertyphotos!.servantroom!],
          'studyroom': [...inventoryData.propertyphotos!.studyroom!],
          'officeroom': [...inventoryData.propertyphotos!.officeroom!],
        };

        propertyPhotos.forEach((key, value) {
          if (value.isNotEmpty) {
            allImages.addAll(value);

            // ignore: unused_local_variable
            for (var i in value) {
              allTitles.add(capitalizeFirstLetter(key));
            }
          }
        });

        if (AppConst.getPublicView()) {
          allImages.removeAt(0);
          allTitles.removeAt(0);
        }
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!widget.isLeadView) ...[
          const CustomText(
            title: "Images",
            fontWeight: FontWeight.w700,
          ),
          SizedBox(
            height: 200,
            child: ListView.builder(
              physics: const ScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: widget.data.propertyphotos == null ? inventoryDetailsImageUrls.length : allImages.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    showImageSliderCarousel(
                      widget.data.propertyphotos == null ? inventoryDetailsImageUrls : allImages,
                      index,
                      context,
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        height: 130,
                        width: 150,
                        decoration: BoxDecoration(
                          // border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            widget.data.propertyphotos == null ? inventoryDetailsImageUrls[index] : '${allImages[index]}.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.error_outline,
                                size: 50,
                                color: Colors.red,
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              return loadingProgress == null ? child : const Center(child: CircularProgressIndicator.adaptive());
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomText(
                          title: widget.data.propertyphotos == null ? 'Front Elevation' : allTitles[index],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
        if (widget.data.amenities != null) ...[
          CustomText(
            title: !widget.isLeadView ? "Overview" : 'Requirements',
            fontWeight: FontWeight.w700,
          ),
          Wrap(
            children: List<Widget>.generate(
              widget.data.amenities!.length,
              (index) => Padding(
                padding: const EdgeInsets.only(right: 8.0, top: 10),
                child: CustomChip(
                  label: Text(widget.data.amenities![index]),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
        const Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: CustomText(
            title: "Property Description",
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          widget.data.comments!,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),
        ),
        const SizedBox(
          height: 30,
        ),
        if (!AppConst.getPublicView())
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: CustomText(
                  title: "Attachments",
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 100,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.data.attachments.length + 1,
                    itemBuilder: (context, index) {
                      final attachments = widget.data.attachments;
                      if (index < attachments.length) {
                        final attachment = attachments[index];
                        return Stack(
                          children: [
                            Container(
                              height: 99,
                              margin: const EdgeInsets.only(right: 15),
                              width: 108,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.withOpacity(0.5)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.image_outlined,
                                    size: 40,
                                  ),
                                  CustomText(
                                    title: widget.data.attachments[index].title,
                                    size: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 10,
                              child: Row(
                                children: [
                                  GestureDetector(
                                    child: const Icon(
                                      Icons.download_for_offline,
                                      size: 18,
                                    ),
                                    onTap: () {
                                      if (kIsWeb) {
                                        // AnchorElement anchorElement = AnchorElement(href: attachment.path);
                                        // anchorElement.download = 'Attachment file';
                                        // anchorElement.click();
                                      }
                                    },
                                  ),
                                  GestureDetector(
                                    child: const Icon(
                                      Icons.cancel,
                                      size: 18,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        showConfirmDeleteAttachment(context, () {
                                          if (widget.id.contains("IN")) {
                                            InventoryDetails.deleteAttachment(itemId: widget.id, attachmentIdToDelete: attachment.id!).then(
                                              (value) => widget.updateData(),
                                            );
                                          } else if (widget.id.contains("LD")) {
                                            LeadDetails.deleteAttachment(itemId: widget.id, attachmentIdToDelete: attachment.id!).then(
                                              (value) => widget.updateData(),
                                            );
                                          }
                                        });
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else {
                        return GestureDetector(
                          onTap: () async {
                            showUploadDocumentModal(
                              context,
                              widget.updateData,
                              selectedDocsNameList,
                              selectedFile,
                              pickedFilesList,
                              () {
                                setState(() {});
                              },
                              widget.id,
                            );
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.withOpacity(0.5)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  size: 40,
                                ),
                                CustomText(
                                  title: 'Add more',
                                  size: 8,
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    }),
              ),
            ],
          ),
        if (!Responsive.isDesktop(context)) ...[
          if (widget.isLeadView) ...[
            MapViewWidget(
              state: widget.data.preferredlocality!.state!,
              city: widget.data.preferredlocality!.city!,
              addressline1: widget.data.preferredlocality!.addressline1!,
              addressline2: widget.data.preferredlocality?.addressline2,
            ),
          ] else ...[
            MapViewWidget(
              state: widget.data.propertyaddress!.state!,
              city: widget.data.propertyaddress!.city!,
              addressline1: widget.data.propertyaddress!.addressline1!,
              addressline2: widget.data.propertyaddress?.addressline2,
            ),
          ]
        ],
      ],
    );
  }
}
