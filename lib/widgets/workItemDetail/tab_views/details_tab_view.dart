// import "dart:html" show AnchorElement;

// import 'dart:html';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:yes_broker/constants/firebase/detailsModels/inventory_details.dart';
import 'package:yes_broker/constants/firebase/detailsModels/lead_details.dart';

import '../../../Customs/custom_chip.dart';
import '../../../Customs/custom_text.dart';
import '../../../Customs/responsive.dart';
import '../../../constants/app_constant.dart';
import '../../../constants/functions/workitems_detail_methods.dart';
import '../../../constants/utils/constants.dart';
import '../mapview_widget.dart';

class AttachmentPreviewDialog extends StatelessWidget {
  final String attachmentPath;

  const AttachmentPreviewDialog({super.key, required this.attachmentPath});

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

// class CustomAttachment {
//   Platform selectedFileName;
//   List<PlatformFile> pickedFilesLists = [];
//   List<inving> selectedDocNameList = [];

//   CustomAttachment({
//     required this.selectedFileName,
//     required this.pickedFilesLists,
//     required this.selectedDocNameList,
//   });
// }

// Future<String> downloadFile(String url, String fileName, String dir) async {
//   HttpClient httpClient = HttpClient();
//   File file;
//   String filePath = '';
//   String myUrl = '';

//   try {
//     myUrl = '$url';
//     var request = await httpClient.getUrl(Uri.parse(myUrl));
//     var response = await request.close();
//     if (response.statusCode == 200) {
//       var bytes = await consolidateHttpClientResponseBytes(response);
//       filePath = '$dir/$fileName';
//       file = File(filePath);
//       await file.writeAsBytes(bytes);
//     } else {
//       filePath = 'Error code: ${response.statusCode}';
//     }
//   } catch (ex) {
//     filePath = 'Can not fetch url';
//     print(ex);
//   }

//   return filePath;
// }

// static var httpClient = new HttpClient();
// Future<File> _downloadFile(String url, String filename) async {
//   var request = await httpClient.getUrl(Uri.parse(url));
//   var response = await request.close();
//   var bytes = await consolidateHttpClientResponseBytes(response);
//   String dir = (await getApplicationDocumentsDirectory()).path;
//   File file = new File('$dir/$filename');
//   await file.writeAsBytes(bytes);
//   return file;
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
        // final Map<String, List<String>> propertyPhotos = {
        //   'title': [...inventoryData.propertyphotos!.imageTitle!],
        //   'imageUrl': [...inventoryData.propertyphotos!.imageUrl!],
        //   // 'bathroom': [...inventoryData.propertyphotos!.bathroom!],
        //   // 'pujaroom': [...inventoryData.propertyphotos!.pujaroom!],
        //   // 'servantroom': [...inventoryData.propertyphotos!.servantroom!],
        //   // 'studyroom': [...inventoryData.propertyphotos!.studyroom!],
        //   // 'officeroom': [...inventoryData.propertyphotos!.officeroom!],
        // };
        allImages.addAll(inventoryData.propertyphotos!.imageUrl!);
        allTitles.addAll(inventoryData.propertyphotos!.imageTitle!);
        // propertyPhotos.forEach((key, value) {
        //   if (value.isNotEmpty) {
        //     // ignore: unused_local_variable
        //     for (var i in value) {
        //       allTitles.add(capitalizeFirstLetter(key));
        //     }
        //   }
        // });

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
                                      //   AnchorElement anchorElement = AnchorElement(href: attachment.path);
                                      //   anchorElement.download = 'Attachment file';
                                      //   anchorElement.click();
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

// Future<void> downloadAndSavePhoto(String url) async {
//   final response = await http.get(Uri.parse(url));
//   if (response.statusCode == 200) {
//     if (kIsWeb) {
//       // Set web-specific directory
//     } else {
//       final directory = await getApplicationDocumentsDirectory();
//       final filePath = '${directory.path}/photo.jpg';
//       final file = File(filePath);
//       await file.writeAsBytes(response.bodyBytes);
//       print('Photo downloaded and saved to $filePath');
//     }
//   } else {
//     throw Exception('Failed to download photo');
//   }
// }
