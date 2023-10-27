// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../Customs/custom_text.dart';
import '../../Customs/loader.dart';
import '../../constants/firebase/detailsModels/inventory_details.dart';
import '../../constants/firebase/detailsModels/lead_details.dart';
import '../../constants/firebase/detailsModels/todo_details.dart';
import '../../constants/functions/datetime/date_time.dart';
import '../../constants/functions/workitems_detail_methods.dart';
import '../../constants/utils/constants.dart';
import '../workItemDetail/tab_views/details_tab_view.dart';

class AttachmentWidget extends StatefulWidget {
  final List? attachments;
  final String id;
  final Function? updateData;
  final PlatformFile? selectedImageName;

  const AttachmentWidget({
    Key? key,
    this.attachments,
    required this.id,
    this.updateData,
    this.selectedImageName,
  }) : super(key: key);

  @override
  State<AttachmentWidget> createState() => AttachmentWidgetState();
}

class AttachmentWidgetState extends State<AttachmentWidget> {
  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: CustomText(
            title: "Attachments",
            fontWeight: FontWeight.w700,
          ),
        ),
        StatefulBuilder(
          builder: (context, setstate) {
            return Wrap(
              runSpacing: 15,
              children: [
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.attachments!.length,
                    itemBuilder: (context, index) {
                      // if (index < attachments.length) {
                      final attachment = widget.attachments![index];
                      return Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AttachmentPreviewDialog(
                                    attachmentPath: attachment.path!,
                                  );
                                },
                              );
                            },
                            child: Container(
                              height: 99,
                              margin: const EdgeInsets.only(right: 15, top: 5),
                              width: 108,
                              clipBehavior: Clip.none,
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
                                  onTap: () {
                                    // if (kIsWeb) {
                                    //   AnchorElement anchorElement = AnchorElement(href: attachment.path);
                                    //   anchorElement.download = 'Attachment file';
                                    //   anchorElement.click();
                                    // }
                                  },
                                ),
                                InkWell(
                                  child: const Icon(
                                    Icons.cancel,
                                    size: 18,
                                  ),
                                  onTap: () {
                                    showConfirmDeleteAttachment(context, () {
                                      if (widget.id.contains(ItemCategory.isInventory)) {
                                        InventoryDetails.deleteAttachment(itemId: widget.id, attachmentIdToDelete: attachment.id!).then(
                                          (value) => widget.updateData!(),
                                        );
                                      } else if (widget.id.contains(ItemCategory.isLead)) {
                                        LeadDetails.deleteAttachment(itemId: widget.id, attachmentIdToDelete: attachment.id!).then(
                                          (value) => widget.updateData!(),
                                        );
                                      } else {
                                        TodoDetails.deleteAttachment(
                                          itemId: widget.id,
                                          attachmentIdToDelete: attachment.id!,
                                        );
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                      // } else {

                      // },
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  child: InkWell(
                    onTap: () async {
                      if (!isUploading) {
                        showUploadDocumentModal(
                          context,
                          () {},
                          widget.selectedImageName,
                          () {
                            setstate(() {});
                          },
                          widget.id,
                          (k) {
                            isUploading = k;
                            setstate(() {});
                          },
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 100,
                      width: 100,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: !isUploading
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.add,
                                  size: 40,
                                ),
                                CustomText(
                                  title: 'ADD MORE',
                                  size: 10,
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            )
                          : const Loader(),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
