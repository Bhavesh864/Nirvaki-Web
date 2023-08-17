import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:yes_broker/widgets/app/nav_bar.dart';

import '../../../Customs/custom_chip.dart';
import '../../../Customs/custom_text.dart';
import '../../../Customs/responsive.dart';
import '../../../constants/app_constant.dart';
import '../../../constants/functions/workitems_detail_methods.dart';
import '../../../constants/utils/constants.dart';
import '../mapview_widget.dart';

// ignore: must_be_immutable
class DetailsTabView extends StatelessWidget {
  final dynamic data;
  final List<PlatformFile> pickedFilesList;
  final List<String> selectedDocNameList;
  late PlatformFile? selectedFileName;
  final bool isLeadView;
  final String id;
  DetailsTabView({
    Key? key,
    required this.data,
    required this.pickedFilesList,
    required this.selectedDocNameList,
    this.selectedFileName,
    this.isLeadView = false,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> allImages = [];
    List<String> allTitles = [];

    if (!isLeadView) {
      if (data.propertyphotos != null) {
        final Map<String, List<String>> propertyPhotos = {
          'frontelevation': [...data!.propertyphotos.frontelevation],
          'bedroom': [...data!.propertyphotos.bedroom],
          'bathroom': [...data!.propertyphotos.bathroom],
          'pujaroom': [...data!.propertyphotos.pujaroom],
          'servantroom': [...data!.propertyphotos.servantroom],
          'studyroom': [...data!.propertyphotos.studyroom],
          'officeroom': [...data!.propertyphotos.officeroom],
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
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isLeadView) ...[
          const CustomText(
            title: "Images",
            fontWeight: FontWeight.w700,
          ),
          SizedBox(
            height: 200,
            child: ListView.builder(
              physics: const ScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: data.propertyphotos == null ? inventoryDetailsImageUrls.length : allImages.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    showImageSliderCarousel(
                      data.propertyphotos == null ? inventoryDetailsImageUrls : allImages,
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
                            data.propertyphotos == null ? inventoryDetailsImageUrls[index] : '${allImages[index]}.png',
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
                          title: data.propertyphotos == null ? 'Front Elevation' : allTitles[index],
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
        if (data.amenities != null) ...[
          CustomText(
            title: !isLeadView ? "Overview" : 'Requirements',
            fontWeight: FontWeight.w700,
          ),
          Wrap(
            children: List<Widget>.generate(
              data.amenities!.length,
              (index) => Padding(
                padding: const EdgeInsets.only(right: 8.0, top: 10),
                child: CustomChip(
                  label: Text(data.amenities![index]),
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
          data.comments!,
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
              StatefulBuilder(
                builder: (context, setState) {
                  return SizedBox(
                    height: 100,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: pickedFilesList.length + 1,
                        itemBuilder: (context, index) {
                          if (index < pickedFilesList.length) {
                            final document = pickedFilesList[index];
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
                                        title: selectedDocNameList[index],
                                        size: 13,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: -13,
                                  right: 0,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.cancel,
                                      size: 16,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        pickedFilesList.remove(document);
                                        selectedDocNameList.removeAt(index);
                                      });
                                    },
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return GestureDetector(
                              onTap: () async {
                                showUploadDocumentModal(
                                  context,
                                  selectedDocNameList,
                                  selectedFileName,
                                  pickedFilesList,
                                  () {
                                    setState(() {});
                                  },
                                  id,
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
                  );
                },
              ),
            ],
          ),
        if (!Responsive.isDesktop(context)) ...[
          if (isLeadView) ...[
            MapViewWidget(
              state: data.preferredlocality!.state!,
              city: data.preferredlocality!.city!,
              addressline1: data.preferredlocality!.addressline1!,
              addressline2: data.preferredlocality?.addressline2,
            ),
          ] else ...[
            MapViewWidget(
              state: data.propertyaddress!.state!,
              city: data.propertyaddress!.city!,
              addressline1: data.propertyaddress!.addressline1!,
              addressline2: data.propertyaddress?.addressline2,
            ),
          ]
        ],
      ],
    );
  }
}
