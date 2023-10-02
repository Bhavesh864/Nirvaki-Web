// import 'dart:html';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:yes_broker/constants/firebase/detailsModels/inventory_details.dart';
import 'package:yes_broker/constants/firebase/detailsModels/lead_details.dart';
import 'package:yes_broker/customs/loader.dart';
import '../../../Customs/custom_chip.dart';
import '../../../Customs/custom_text.dart';
import '../../../Customs/responsive.dart';
import '../../../constants/app_constant.dart';
import '../../../constants/functions/workitems_detail_methods.dart';
import '../../../constants/utils/colors.dart';
import '../../../constants/utils/constants.dart';
import '../mapview_widget.dart';

class AttachmentPreviewDialog extends StatelessWidget {
  final String attachmentPath;

  const AttachmentPreviewDialog({
    super.key,
    required this.attachmentPath,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Image.network(attachmentPath),
      ),
    );
  }
}

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
  bool isUploading = false;
  // String videoUrl = "https://www.youtube.com/embed/C3aRyxcpy5A";

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    List<String> allImages = [];
    List<String> allTitles = [];
    final videoUrl = !widget.isLeadView && widget.data?.propertyvideo != null ? widget.data.propertyvideo : "";

    if (!widget.isLeadView) {
      final inventoryData = widget.data as InventoryDetails;
      if (inventoryData.propertyphotos != null) {
        allImages.addAll(inventoryData.propertyphotos!.imageUrl!);
        allTitles.addAll(inventoryData.propertyphotos!.imageTitle!);

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
        if (!widget.isLeadView && widget.data.propertyphotos != null) ...[
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
          const Divider(
            height: 10,
          ),
        ],
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: CustomText(
            title: "Property Details",
            fontWeight: FontWeight.w700,
          ),
        ),
        if (!widget.isLeadView) ...[
          Wrap(children: [
            if (checkNotNUllItem(widget.data.roomconfig.bedroom)) ...[
              buildInfoFields(
                'Layout',
                buildRoomsText(widget.data.roomconfig, false),
                context,
              ),
              buildInfoFields(
                'Additional Room',
                buildRoomsText(widget.data.roomconfig, true),
                context,
              ),
            ],
            if (checkNotNUllItem(widget.data.propertyarea.superarea) && checkNotNUllItem(widget.data.propertyarea.unit))
              buildInfoFields(
                'Area',
                "${widget.data.propertyarea.superarea} ${widget.data.propertyarea.unit}",
                context,
              ),
            if (widget.data.inventorycategory == 'Rent' && widget.data.propertyrent.securityamount != null)
              buildInfoFields(
                'Security Deposit',
                "₹${widget.data.propertyrent.securityamount}",
                context,
              ),
            if (checkNotNUllItem(widget.data.transactiontype))
              buildInfoFields(
                'Transaction Type',
                widget.data.transactiontype,
                context,
              ),
            if (checkNotNUllItem(widget.data.availability))
              buildInfoFields(
                'Availability',
                widget.data.availability,
                context,
              ),
            if (checkNotNUllItem(widget.data.possessiondate))
              buildInfoFields(
                'Possessiondate',
                widget.data.possessiondate,
                context,
              ),
            if (checkNotNUllItem(widget.data.propertyfacing))
              buildInfoFields(
                'Property Facing',
                widget.data.propertyfacing,
                context,
              ),
            if (checkNotNUllItem(widget.data.villatype))
              buildInfoFields(
                'Villa Type',
                widget.data.villatype,
                context,
              ),
            if (widget.data.propertykind == 'Plot')
              buildInfoFields(
                'No. of Open Sides',
                widget.data.plotdetails.opensides,
                context,
              ),
            if (checkNotNUllItem(widget.data.plotdetails.boundarywall))
              buildInfoFields(
                'Boundary',
                widget.data.plotdetails.boundarywall,
                context,
              ),
          ]),
          const Divider(
            height: 40,
          ),
        ] else ...[
          Wrap(children: [
            if (checkNotNUllItem(widget.data.roomconfig.bedroom)) ...[
              buildInfoFields(
                'Layout',
                buildRoomsText(widget.data.roomconfig, false),
                context,
              ),
              buildInfoFields(
                'Additional Room',
                buildRoomsText(widget.data.roomconfig, true),
                context,
              ),
            ],
            if (checkNotNUllItem(widget.data.propertyarea.superarea) && checkNotNUllItem(widget.data.propertyarea.unit))
              buildInfoFields(
                'Area',
                "${widget.data.propertyarea.superarea} ${widget.data.propertyarea.unit}",
                context,
              ),
            if (checkNotNUllItem(widget.data.transactiontype))
              buildInfoFields(
                'Transaction Type',
                widget.data.transactiontype,
                context,
              ),
            if (checkNotNUllItem(widget.data.availability))
              buildInfoFields(
                'Availability',
                widget.data.availability,
                context,
              ),
            if (checkNotNUllItem(widget.data.possessiondate))
              buildInfoFields(
                'Possessiondate',
                widget.data.possessiondate,
                context,
              ),
            if (checkNotNUllItem(widget.data.preferredpropertyfacing))
              buildInfoFields(
                'Property Facing',
                widget.data.preferredpropertyfacing,
                context,
              ),
            if (checkNotNUllItem(widget.data.villatype))
              buildInfoFields(
                'Villa Type',
                widget.data.villatype,
                context,
              ),
            if (widget.data.propertykind == 'Plot')
              buildInfoFields(
                'No. of Open Sides',
                widget.data.plotdetails.opensides,
                context,
              ),
            if (checkNotNUllItem(widget.data.plotdetails.boundarywall))
              buildInfoFields(
                'Boundary',
                widget.data.plotdetails.boundarywall,
                context,
              ),
            const Divider(
              height: 40,
            ),
          ]),
        ],
        if (widget.data.amenities != null) ...[
          CustomText(
            title: !widget.isLeadView ? "Features" : 'Requirements',
            fontWeight: FontWeight.w700,
          ),

          Wrap(
            children: List<Widget>.generate(
              widget.data.amenities!.length + 1,
              (index) {
                if (index == widget.data.amenities!.length) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0, top: 10),
                    child: CustomChip(
                      label: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const Text(
                            'No. of Reserved Parking: ',
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade600,
                            ),
                            child: Text(
                              '${widget.data.reservedparking.covered}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0, top: 10),
                    child: CustomChip(
                      label: Text(
                        widget.data.amenities![index],
                      ),
                    ),
                  );
                }
              },
            ),
          ),

          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 5.0),
          //   child: Row(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text(
          //         'No. of Reserved Parking',
          //         style: const TextStyle(
          //           fontSize: 14,
          //           color: Color(0xFF818181),
          //           fontWeight: FontWeight.w500,
          //         ),
          //       ),
          //       const SizedBox(width: 15),
          //       CustomChip(
          //         label: Text(
          //           widget.data.reservedparking.covered,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          const Divider(
            height: 40,
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
        const Divider(
          height: 40,
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
                            GestureDetector(
                              onTap: () async {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AttachmentPreviewDialog(attachmentPath: attachment.path);
                                  },
                                );
                              },
                              child: Container(
                                height: 110,
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
                                    onTap: () async {
                                      // FileDownloader.downloadFile(
                                      //   url: attachment.path.trim(),
                                      //   onDownloadError: (errorMessage) {
                                      //     print('errorMessage');
                                      //   },
                                      //   onDownloadCompleted: (path) {
                                      //     print(path);
                                      //   },
                                      // );
                                      // final res = await downloadFile(attachment.path, 'fileName', 'download');
                                      // if (kIsWeb) {
                                      // AnchorElement anchorElement = AnchorElement(href: attachment.path);
                                      // anchorElement.download = 'Attachment file';
                                      // anchorElement.click();
                                      // }
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
                                          if (widget.id.contains(ItemCategory.isInventory)) {
                                            InventoryDetails.deleteAttachment(itemId: widget.id, attachmentIdToDelete: attachment.id!).then(
                                              (value) => widget.updateData(),
                                            );
                                          } else if (widget.id.contains(ItemCategory.isLead)) {
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
                            if (!isUploading) {
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
                                (k) {
                                  isUploading = k;
                                  setState(() {});
                                },
                              );
                            }
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.withOpacity(0.5)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (isUploading) ...[
                                  const Loader(),
                                ] else ...[
                                  const Icon(
                                    Icons.add,
                                    size: 40,
                                  ),
                                  const CustomText(
                                    title: 'Add more',
                                    size: 8,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ]
                              ],
                            ),
                          ),
                        );
                      }
                    }),
              ),
              // ================================ Video Section ================================
              if (!widget.isLeadView && videoUrl != null && videoUrl.contains('youtube.com')) ...[
                const Divider(
                  height: 40,
                ),
                const CustomText(
                  title: "Video",
                  fontWeight: FontWeight.w700,
                ),
                const SizedBox(height: 12),
                Container(
                  width: kIsWeb ? 400 : width / 1.1,
                  height: kIsWeb ? 250 : 220,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColor.chipGreyColor,
                    // color: const Color.fromARGB(40, 68, 97, 239),
                  ),
                  child: HtmlWidget(
                    '''
                    <iframe
                      width="300"
                      height="300"
                      src="$videoUrl"
                      frameborder="0"
                      title="Brokr"
                      allow="accelerometer"
                      allowfullscreen
                    ></iframe>
                  ''',
                  ),
                ),
              ]
            ],
          ),
        if (!Responsive.isDesktop(context)) ...[
          if (widget.isLeadView) ...[
            MapViewWidget(
              state: widget.data.preferredlocality!.state!,
              city: widget.data.preferredlocality!.city!,
              addressline1: widget.data.preferredlocality!.addressline1!,
              addressline2: widget.data.preferredlocality?.addressline2,
              locality: widget.data.preferredlocality!.locality!,
            ),
          ] else ...[
            MapViewWidget(
              state: widget.data.propertyaddress!.state!,
              city: widget.data.propertyaddress!.city!,
              addressline1: widget.data.propertyaddress!.addressline1!,
              addressline2: widget.data.propertyaddress?.addressline2,
              locality: widget.data.propertyaddress!.locality!,
            ),
          ]
        ],
      ],
    );
  }
}

Widget buildInfoFields(String fieldName, String fieldDetail, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$fieldName:',
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF818181),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 15),
        Flexible(
          child: Text(
            fieldDetail,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}
