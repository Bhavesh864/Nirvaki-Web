import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:image_picker/image_picker.dart';
import 'package:yes_broker/Customs/custom_chip.dart';
import 'package:yes_broker/Customs/custom_fields.dart';
import 'package:yes_broker/Customs/dropdown_field.dart';
import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/constants/firebase/detailsModels/inventory_details.dart';
import 'package:yes_broker/providers/selected_workitem.dart';
import 'package:yes_broker/widgets/questionaries/google_maps.dart';

import '../../Customs/custom_text.dart';
import '../../constants/utils/colors.dart';
import '../../constants/utils/constants.dart';
import '../../widgets/workItemDetail/Inventory_details_header.dart';
import '../../widgets/workItemDetail/contact_information.dart';
import '../../widgets/workItemDetail/tab_bar_widget.dart';

class InventoryDetailsScreen extends ConsumerStatefulWidget {
  const InventoryDetailsScreen({super.key});

  @override
  _InventoryDetailsScreenState createState() => _InventoryDetailsScreenState();
}

class _InventoryDetailsScreenState extends ConsumerState<InventoryDetailsScreen> with TickerProviderStateMixin {
  late TabController tabviewController;
  late Future<InventoryDetails?> inventoryDetails;

  void showUploadDocumentModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              padding: const EdgeInsets.all(15),
              height: 300,
              width: 500,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Upload New Document',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        iconSize: 20,
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog when the close icon is pressed
                        },
                      ),
                    ],
                  ),
                  DropDownField(title: 'Document Type', optionsList: const ['Adhaar', 'Pan ', 'Insurance'], onchanged: (e) {}),
                  CustomButton(
                    text: 'Upload Document',
                    rightIcon: Icons.publish_outlined,
                    buttonColor: AppColor.secondary,
                    // isBorder: false,
                    textColor: Colors.black,
                    righticonColor: Colors.black,
                    titleLeft: true,
                    onPressed: () async {
                      XFile? pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
                      pickedImage!.path;
                    },
                  ),
                  CustomButton(text: 'Done', onPressed: () {}),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showImageSlider(List<String> imageUrls, int initialIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(0),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Stack(
            children: [
              Expanded(
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 550,
                    initialPage: initialIndex,
                    enlargeCenterPage: true,
                    viewportFraction: 0.55,
                    enableInfiniteScroll: false,
                  ),
                  items: imageUrls.map(
                    (url) {
                      return Builder(
                        builder: (BuildContext context) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: Image.network(
                              url,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      );
                    },
                  ).toList(),
                ),
              ),
              Positioned(
                top: -5,
                right: 10,
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    tabviewController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final workItemId = Responsive.isMobile(context) ? ModalRoute.of(context)!.settings.arguments : ref.watch(selectedWorkItemId.notifier).state;
    inventoryDetails = InventoryDetails.getInventoryDetails(workItemId);

    return Scaffold(
      appBar: Responsive.isMobile(context)
          ? AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                iconSize: 25,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: const CustomText(
                title: 'Inventory Details',
                color: Colors.black,
              ),
              foregroundColor: Colors.black,
              toolbarHeight: 50,
            )
          : null,
      body: FutureBuilder(
          future: inventoryDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            if (snapshot.hasData) {
              final data = snapshot.data;
              return Container(
                decoration: !Responsive.isMobile(context)
                    ? const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.secondary,
                            spreadRadius: 12,
                            blurRadius: 4,
                            offset: Offset(5, 5),
                          ),
                        ],
                        color: Colors.white,
                      )
                    : null,
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                        child: SingleChildScrollView(
                          child: Container(
                            padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20, right: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InventoryDetailsHeader(
                                  title: data!.inventoryTitle!,
                                  category: data.inventorycategory!,
                                  type: data.inventoryType!,
                                  propertyCategory: data.propertycategory!,
                                  status: data.inventoryStatus!,
                                  price: data.propertyprice!.price!,
                                  unit: data.propertyprice!.unit!,
                                ),
                                if (Responsive.isMobile(context))
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: HeaderChips(
                                      category: data.inventorycategory!,
                                      type: data.inventoryType!,
                                      propertyCategory: data.propertycategory!,
                                      status: data.inventoryStatus!,
                                    ),
                                  ),
                                ListTile(
                                  leading: const Icon(
                                    Icons.location_on_outlined,
                                    size: 20,
                                    color: Colors.black,
                                  ),
                                  minLeadingWidth: 2,
                                  horizontalTitleGap: 8,
                                  titleAlignment: ListTileTitleAlignment.center,
                                  title: CustomText(
                                    title: '${data.propertyaddress!.state},${data.propertyaddress!.city},${data.propertyaddress!.addressline1}',
                                    size: 12,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFFA8A8A8),
                                  ),
                                ),
                                if (Responsive.isMobile(context))
                                  CustomButton(
                                    text: 'View Owner Detail',
                                    onPressed: () {},
                                    height: 40,
                                    width: 180,
                                  ),
                                if (Responsive.isMobile(context))
                                  const Padding(
                                    padding: EdgeInsets.only(top: 12.0),
                                    child: CustomText(
                                      title: '₹90,000/month',
                                      color: AppColor.primary,
                                    ),
                                  ),
                                TabBarWidget(tabviewController: tabviewController),
                                const SizedBox(
                                  height: 30,
                                ),
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
                                      return GestureDetector(
                                        onTap: () {
                                          _showImageSlider(inventoryDetailsImageUrls, index);
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.all(10),
                                              height: 150,
                                              width: 150,
                                              decoration: BoxDecoration(
                                                border: Border.all(color: Colors.grey),
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
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 8.0),
                                  child: CustomText(
                                    title: "Attachments",
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showUploadDocumentModal(context);
                                  },
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
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
                                if (Responsive.isMobile(context)) const MapViewWidget()
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (Responsive.isDesktop(context))
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        width: 1,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    if (Responsive.isDesktop(context))
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              ContactInformation(customerinfo: data.customerinfo!),
                              const Padding(
                                padding: EdgeInsets.only(top: 17),
                                child: Row(
                                  children: [
                                    Icon(Icons.add),
                                    Padding(
                                        padding: EdgeInsets.only(left: 4, top: 1, bottom: 1),
                                        child: Text("Added by ",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ))),
                                    Padding(
                                        padding: EdgeInsets.only(left: 6, top: 2),
                                        child: Text("Shamsheer Singh",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              color: AppColor.primary,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            )))
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20, bottom: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.person_add_alt_outlined),
                                    const Padding(
                                      padding: EdgeInsets.only(left: 4, top: 2),
                                      child: Text(
                                        "Assigned to",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 22),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(left: 4, right: 4),
                                            child: const Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(left: 6, top: 4),
                                                  child: Text(
                                                    "Shamsheer Singh",
                                                    overflow: TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      color: AppColor.primary,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Padding(
                                              padding: EdgeInsets.only(top: 16),
                                              child: Row(children: [
                                                Padding(
                                                    padding: EdgeInsets.only(left: 4, top: 2),
                                                    child: Text("Rajpal Yadav",
                                                        overflow: TextOverflow.ellipsis,
                                                        textAlign: TextAlign.left,
                                                        style: TextStyle(
                                                          color: AppColor.primary,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w400,
                                                        )))
                                              ])),
                                          const Padding(
                                              padding: EdgeInsets.only(top: 15),
                                              child: Row(children: [
                                                Padding(
                                                    padding: EdgeInsets.only(left: 6, top: 2),
                                                    child: Text("Gaurav Singh ",
                                                        overflow: TextOverflow.ellipsis,
                                                        textAlign: TextAlign.left,
                                                        style: TextStyle(
                                                          color: AppColor.primary,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w400,
                                                        )))
                                              ])),
                                          const Padding(
                                            padding: EdgeInsets.only(top: 14),
                                            child: Row(
                                              children: [
                                                Icon(Icons.add),
                                                Padding(
                                                  padding: EdgeInsets.only(left: 6),
                                                  child: Text("Add More",
                                                      overflow: TextOverflow.ellipsis,
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        color: AppColor.primary,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w400,
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (Responsive.isDesktop(context)) const MapViewWidget(),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }
            return const SizedBox();
          }),
    );
  }
}

class MapViewWidget extends StatelessWidget {
  const MapViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10, top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const CustomText(
                title: 'Location',
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(
                width: 10,
              ),
              if (!Responsive.isMobile(context))
                const CustomChip(
                  label: Icon(
                    Icons.share_outlined,
                  ),
                  paddingHorizontal: 3,
                ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: CustomGoogleMap(
            onLatLngSelected: (d) {},
            stateName: 'Rajasthan',
            cityName: 'Jaipur',
            address1: 'wtp',
            address2: 'wtp',
          ),
        ),
      ],
    );
  }
}
