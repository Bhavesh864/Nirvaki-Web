// import 'dart:html';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yes_broker/constants/firebase/detailsModels/inventory_details.dart';
import 'package:yes_broker/constants/firebase/detailsModels/lead_details.dart';
import 'package:yes_broker/customs/loader.dart';
import 'package:yes_broker/customs/snackbar.dart';
import 'package:yes_broker/widgets/workItemDetail/tab_views/iframe_modules.dart';
import '../../../Customs/custom_chip.dart';
import '../../../Customs/custom_text.dart';
import '../../../Customs/responsive.dart';
import '../../../Customs/text_utility.dart';
import '../../../constants/app_constant.dart';
import '../../../constants/functions/datetime/date_time.dart';
import '../../../constants/functions/workitems_detail_methods.dart';
import '../../../constants/utils/colors.dart';
import '../../../constants/utils/constants.dart';
import '../mapview_widget.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class AttachmentPreviewDialog extends StatelessWidget {
  final String attachmentPath;

  const AttachmentPreviewDialog({
    super.key,
    required this.attachmentPath,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(15),
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
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        mute: false,
        showFullscreenButton: true,
        loop: false,
      ),
    );

    _controller.setFullScreenListener(
      (isFullScreen) {
        print('${isFullScreen ? 'Entered' : 'Exited'} Fullscreen.');
      },
    );
  }

  void downloadFile(String url, String name) async {
    FileDownloader.downloadFile(
      url: url,
      onDownloadCompleted: (String path) {
        customSnackBar(context: context, text: 'FILE DOWNLOADED TO PATH: $path');
      },
    );
  }

  Future<String> getFilePath(String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    return "${dir.path}/$filename";
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    List<String> allImages = [];
    List<String> allTitles = [];

    final videoUrl = !widget.isLeadView && widget.data?.propertyvideo != null && widget.data?.propertyvideo.contains('watch') ? widget.data.propertyvideo : "";

    if (!widget.isLeadView && videoUrl != null && videoUrl.contains('youtube.com')) {
      _controller.loadVideo(videoUrl);

      final regex = RegExp(r'.*\?v=(.+?)($|[\&])', caseSensitive: false);
      String? videoId = '';
      try {
        if (regex.hasMatch(videoUrl)) {
          videoId = regex.firstMatch(videoUrl)!.group(1);
        }
      } catch (e) {
        print(e);
      }
      _controller = YoutubePlayerController.fromVideoId(
        videoId: videoId!,
        autoPlay: false,
        params: const YoutubePlayerParams(showFullscreenButton: true),
      );
    }

    if (!widget.isLeadView) {
      final inventoryData = widget.data as InventoryDetails;
      if (inventoryData.propertyphotos != null) {
        allImages.addAll(inventoryData.propertyphotos!.imageUrl!);
        allTitles.addAll(inventoryData.propertyphotos!.imageTitle!);

        // if (AppConst.getPublicView()) {
        //   allImages.removeAt(0);
        //   allTitles.removeAt(0);
        // }
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
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
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
                              return loadingProgress == null ? child : const Loader();
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomText(
                          title: widget.data.propertyphotos == null ? 'Front Elevation' : allTitles[index],
                        ),
                      ),
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
        // if (!AppConst.getPublicView()) ...[
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: CustomText(
            title: "Property Details",
            fontWeight: FontWeight.w700,
          ),
        ),
        if (!widget.isLeadView) ...[
          if (widget.data.propertycategory == 'Commercial') ...[
            Wrap(children: [
              if (checkNotNUllItem(widget.data.availability)) ...[
                buildInfoFields(
                  'Property Category',
                  widget.data.availability,
                  context,
                ),
              ],
              if (checkNotNUllItem(widget.data.propertykind))
                buildInfoFields(
                  'Type of Land',
                  "${widget.data.propertykind}",
                  context,
                ),
              if (checkNotNUllItem(widget.data.commericialtype))
                buildInfoFields(
                  'Property Type',
                  "${widget.data.commericialtype}",
                  context,
                ),
              if (checkNotNUllItem(widget.data.typeofoffice))
                buildInfoFields(
                  'Type of office',
                  widget.data.typeofoffice,
                  context,
                ),
              if (checkNotNUllItem(widget.data.typeofretail))
                buildInfoFields(
                  'Type of Retail',
                  widget.data.typeofretail,
                  context,
                ),
              if (checkNotNUllItem(widget.data.typeofhospitality))
                buildInfoFields(
                  'Type of Hospitality',
                  widget.data.typeofhospitality,
                  context,
                ),
              if (checkNotNUllItem(widget.data.typeofhealthcare))
                buildInfoFields(
                  'Type of Healthcare',
                  widget.data.typeofhealthcare,
                  context,
                ),
              if (checkNotNUllItem(widget.data.approvedbeds))
                buildInfoFields(
                  'Approve beds',
                  widget.data.approvedbeds,
                  context,
                ),
              if (checkNotNUllItem(widget.data.typeofschool))
                buildInfoFields(
                  'Type of School',
                  widget.data.typeofschool,
                  context,
                ),
              if (checkNotNUllItem(widget.data.hospitalityrooms))
                buildInfoFields(
                  'Rooms Constructed',
                  widget.data.hospitalityrooms,
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
              if (checkNotNUllItem(widget.data.furnishedStatus))
                buildInfoFields(
                  'Furnished Status',
                  widget.data.furnishedStatus,
                  context,
                ),
            ]),
            const Divider(
              height: 40,
            ),
          ]
        ] else ...[
          if (widget.data.propertycategory == 'Commercial') ...[
            if (checkNotNUllItem(widget.data.availability)) ...[
              buildInfoFields(
                'Property Category',
                widget.data.availability,
                context,
              ),
            ],
            if (checkNotNUllItem(widget.data.propertykind))
              buildInfoFields(
                'Type of Land',
                "${widget.data.propertykind}",
                context,
              ),
            if (checkNotNUllItem(widget.data.commericialtype))
              buildInfoFields(
                'Property Type',
                "${widget.data.commericialtype}",
                context,
              ),
            if (checkNotNUllItem(widget.data.propertyarearange) && checkNotNUllItem(widget.data.propertyarea.unit))
              buildInfoFields(
                'Area',
                "${widget.data.propertyarearange.arearangestart}-${widget.data.propertyarearange.arearangeend} ${widget.data.propertyarea.unit}",
                context,
              ),
            if (checkNotNUllItem(widget.data.typeofoffice))
              buildInfoFields(
                'Type of office',
                widget.data.typeofoffice,
                context,
              ),
            if (checkNotNUllItem(widget.data.typeofretail))
              buildInfoFields(
                'Type of Retail',
                widget.data.typeofretail,
                context,
              ),
            if (checkNotNUllItem(widget.data.typeofhospitality))
              buildInfoFields(
                'Type of Hospitality',
                widget.data.typeofhospitality,
                context,
              ),
            if (checkNotNUllItem(widget.data.typeofhealthcare))
              buildInfoFields(
                'Type of Healthcare',
                widget.data.typeofhealthcare,
                context,
              ),
            if (checkNotNUllItem(widget.data.approvedbeds))
              buildInfoFields(
                'Approve beds',
                widget.data.approvedbeds,
                context,
              ),
            if (checkNotNUllItem(widget.data.typeofschool))
              buildInfoFields(
                'Type of School',
                widget.data.typeofschool,
                context,
              ),
            if (checkNotNUllItem(widget.data.hospitalityrooms))
              buildInfoFields(
                'Rooms Constructed',
                widget.data.hospitalityrooms,
                context,
              ),
            const Divider(
              height: 40,
            ),
          ] else ...[
            Wrap(
              children: [
                if (checkNotNUllItem(widget.data.roomconfig.bedroom)) ...[
                  buildInfoFields(
                    'Layout',
                    buildRoomsText(widget.data.roomconfig, false),
                    context,
                  ),
                  if (widget.data.roomconfig?.additionalroom.length != 0)
                    buildInfoFields(
                      'Additional Room',
                      buildRoomsText(widget.data.roomconfig, true),
                      context,
                    ),
                ],
                if (checkNotNUllItem(widget.data.propertyarearange) && checkNotNUllItem(widget.data.propertyarea.unit))
                  buildInfoFields(
                    'Area',
                    "${widget.data.propertyarearange.arearangestart}-${widget.data.propertyarearange.arearangeend} ${widget.data.propertyarea.unit}",
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
                if (checkNotNUllItem(widget.data.furnishedStatus))
                  buildInfoFields(
                    'Furnished Status',
                    widget.data.furnishedStatus,
                    context,
                  ),
                const Divider(
                  height: 40,
                ),
              ],
            ),
          ],
        ],
        // ],
        // if (!AppConst.getPublicView())
        if (widget.data.amenities != null && widget.data.amenities.isNotEmpty) ...[
          CustomText(
            title: !widget.isLeadView ? "Features" : 'Requirements',
            fontWeight: FontWeight.w700,
          ),
          Wrap(
            children: List<Widget>.generate(
              widget.data.amenities!.length + 1,
              (index) {
                if (index == widget.data.amenities!.length) {
                  if (checkNotNUllItem(widget.data.reservedparking.covered)) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0, top: 10),
                      child: CustomChip(
                        paddingVertical: 3,
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
                  }
                  return const SizedBox();
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0, top: 10),
                    child: CustomChip(
                      paddingVertical: 6,
                      label: Text(
                        widget.data.amenities![index],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          const Divider(
            height: 40,
          ),
        ],
        if (!AppConst.getPublicView()) ...[
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
        ],
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
                height: 120,
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
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AttachmentPreviewDialog(attachmentPath: attachment.path);
                                  },
                                );
                              },
                              child: Container(
                                height: 110,
                                margin: const EdgeInsets.only(right: 15, top: 4),
                                width: 108,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.withOpacity(0.5)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Icon(
                                      Icons.image_outlined,
                                      size: 40,
                                    ),
                                    Column(
                                      children: [
                                        CustomText(
                                          title: attachment.title!,
                                          size: 13,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        CustomText(
                                          title: 'Added ${formatMessageDate(attachment.createddate!.toDate())}',
                                          size: 8,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ],
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
                                  InkWell(
                                    child: const Icon(
                                      Icons.download_for_offline,
                                      size: 18,
                                    ),
                                    onTap: () async {
                                      // if (kIsWeb) {
                                      //   AnchorElement anchorElement = AnchorElement(href: attachment.path);
                                      //   anchorElement.download = 'Attachment file';
                                      //   anchorElement.click();
                                      // }

                                      downloadFile(
                                        attachment.path,
                                        attachment.title,
                                      );
                                    },
                                  ),
                                  InkWell(
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
                        return InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () async {
                            if (!isUploading) {
                              showUploadDocumentModal(
                                context,
                                widget.updateData,
                                selectedFile,
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
                            width: 100,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            margin: const EdgeInsets.only(top: 4),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.withOpacity(0.5)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (isUploading) ...[
                                  const Loader(),
                                ] else ...[
                                  const Icon(
                                    Icons.add,
                                    size: 40,
                                  ),
                                  const CustomText(
                                    title: 'ADD MORE',
                                    size: 10,
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
              if (!widget.isLeadView && videoUrl != null && videoUrl.contains('youtube.com') && videoUrl.contains('watch')) ...[
                const Divider(
                  height: 40,
                ),
                const CustomText(
                  title: "Video",
                  fontWeight: FontWeight.w700,
                ),
                const SizedBox(height: 12),
                Container(
                  width: Responsive.isDesktop(context) ? 400 : width / 1.1,
                  height: Responsive.isDesktop(context) ? 250 : 220,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColor.chipGreyColor,
                    // color: const Color.fromARGB(40, 68, 97, 239),
                  ),
                  child: YoutubePlayerScaffold(
                    controller: _controller,
                    builder: (context, player) {
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          if (kIsWeb && constraints.maxWidth > 750) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      player,
                                      const VideoPositionIndicator(),
                                    ],
                                  ),
                                ),
                                const Expanded(
                                  child: SingleChildScrollView(
                                    child: Controls(),
                                  ),
                                ),
                              ],
                            );
                          }

                          return ListView(
                            children: [
                              player,
                              const VideoPositionIndicator(),
                              const Controls(),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ]
            ],
          ),
        if (!Responsive.isDesktop(context) && !AppConst.getPublicView()) ...[
          if (widget.isLeadView) ...[
            const SizedBox(height: 10),
            const AppText(
              text: "Preffered Locality",
              fontsize: 20,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: (widget.data.preferredlocality?.listofLocality ?? []).map<Widget>((e) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: const Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        width: 280,
                        child: AppText(
                          text: e.fullAddress.toString(),
                          softwrap: true,
                          fontsize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            )
          ] else ...[
            MapViewWidget(
              latLng: widget.isLeadView
                  ? LatLng(widget.data.preferredlocation[0], widget.data.preferredlocation[1])
                  : LatLng(widget.data.propertylocation[0], widget.data.propertylocation[1]),
              state: widget.data.propertyaddress!.state!,
              city: widget.data.propertyaddress!.city!,
              addressline1: widget.data.propertyaddress!.addressline1,
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
