import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../Customs/custom_chip.dart';
import '../../../Customs/custom_text.dart';
import '../../../Customs/responsive.dart';
import '../../../constants/app_constant.dart';
import '../../../constants/firebase/detailsModels/inventory_details.dart';
import '../../../constants/functions/workitems_detail_methods.dart';
import '../../../constants/utils/constants.dart';
import '../mapview_widget.dart';

// ignore: must_be_immutable
class DetailsTabView extends StatelessWidget {
  final InventoryDetails data;
  final List<XFile> pickedDocuments;
  final List<String> selectedDocsName;
  late XFile? selectedImageName;

  DetailsTabView({
    Key? key,
    required this.data,
    required this.pickedDocuments,
    required this.selectedDocsName,
    this.selectedImageName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(
          title: "Images",
          fontWeight: FontWeight.w700,
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (context, index) {
              if (!AppConst.getPublicView() || index > 0) {
                return GestureDetector(
                  onTap: () {
                    showImageSliderCarousel(inventoryDetailsImageUrls, index, context);
                  },
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          // border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            inventoryDetailsImageUrls[index],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.error_outline,
                                size: 50,
                                color: Colors.red,
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              return loadingProgress == null ? child : const CircularProgressIndicator();
                            },
                          ),
                        ),
                      ),
                      const CustomText(title: 'Front Elevation')
                    ],
                  ),
                );
              }
              return SizedBox();
            },
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        const CustomText(
          title: "Overview",
          fontWeight: FontWeight.w700,
        ),
        if (data.amenities != null)
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
                  return Row(
                    children: [
                      Row(
                        children: pickedDocuments.map((document) {
                          final currentIndex = pickedDocuments.indexOf(document);
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
                                      title: selectedDocsName[currentIndex],
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
                                      pickedDocuments.remove(document);
                                      selectedDocsName.removeAt(currentIndex);
                                    });
                                  },
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                      GestureDetector(
                        onTap: () {
                          showUploadDocumentModal(context, selectedDocsName, selectedImageName, pickedDocuments, () {
                            setState(() {});
                            selectedImageName = null;
                            Navigator.of(context).pop();
                          });
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
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        if (!Responsive.isDesktop(context))
          MapViewWidget(
            state: data.propertyaddress!.state!,
            city: data.propertyaddress!.city!,
            addressline1: data.propertyaddress!.addressline1!,
            addressline2: data.propertyaddress?.addressline2,
          ),
      ],
    );
  }
}
