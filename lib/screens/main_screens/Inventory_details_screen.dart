import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:yes_broker/Customs/custom_chip.dart';
import 'package:yes_broker/Customs/custom_fields.dart';
import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';
import 'package:yes_broker/constants/firebase/detailsModels/inventory_details.dart';
import 'package:yes_broker/providers/selected_workitem.dart';
import 'package:yes_broker/widgets/card/custom_card.dart';
import 'package:yes_broker/widgets/timeline_view.dart';

import '../../Customs/custom_text.dart';
import '../../constants/functions/workitems_detail_methods.dart';
import '../../constants/utils/colors.dart';
import '../../constants/utils/constants.dart';
import '../../widgets/workItemDetail/assignment_widget.dart';
import '../../widgets/workItemDetail/contact_information.dart';
import '../../widgets/workItemDetail/inventory_details_header.dart';
import '../../widgets/workItemDetail/mapview_widget.dart';
import '../../widgets/workItemDetail/tab_bar_widget.dart';

class InventoryDetailsScreen extends ConsumerStatefulWidget {
  const InventoryDetailsScreen({super.key});

  @override
  InventoryDetailsScreenState createState() => InventoryDetailsScreenState();
}

class InventoryDetailsScreenState extends ConsumerState<InventoryDetailsScreen> with TickerProviderStateMixin {
  late TabController tabviewController;
  late Future<InventoryDetails?> inventoryDetails;
  XFile? selectedImageName;
  List<XFile> pickedDocuments = [];
  List<String> selectedDocsName = [];
  int currentSelectedTab = 0;

  void showOwnerDetailsAndAssignToBottomSheet(BuildContext context, String title, Widget innerContent) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      size: 20,
                      color: AppColor.primary,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              innerContent,
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
    // final workItemId = ref.read(selectedWorkItemId.notifier).state;
    // inventoryDetails = InventoryDetails.getInventoryDetails(workItemId);
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
                        // color: Color(0xFFF9F9FD),
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InventoryDetailsHeader(
                                  title: data!.inventoryTitle!,
                                  category: data.inventorycategory!,
                                  type: data.inventoryType!,
                                  propertyCategory: data.propertycategory!,
                                  status: data.inventoryStatus!,
                                  price: data.propertyprice?.price,
                                  unit: data.propertyprice?.unit,
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
                                    onPressed: () {
                                      showOwnerDetailsAndAssignToBottomSheet(
                                        context,
                                        'Owner Details',
                                        ContactInformation(customerinfo: data.customerinfo!),
                                      );
                                    },
                                    height: 40,
                                    width: 180,
                                  ),
                                if (Responsive.isMobile(context))
                                  GestureDetector(
                                    onTap: () {
                                      showOwnerDetailsAndAssignToBottomSheet(
                                        context,
                                        'Assignment',
                                        AssignmentWidget(
                                          imageUrlAssignTo: data.assignedto![0].image == null || data.assignedto![0].image!.isEmpty ? noImg : data.assignedto![0].image!,
                                          imageUrlCreatedBy: data.createdby!.userimage == null || data.createdby!.userimage!.isEmpty ? noImg : data.createdby!.userimage!,
                                          createdBy: data.createdby!.userfirstname! + data.createdby!.userlastname!,
                                          assignTo: data.assignedto![0].firstname! + data.assignedto![0].firstname!,
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 12.0),
                                      child: CustomText(
                                        title: data.propertyprice?.price != null ? '${data.propertyprice!.price}${data.propertyprice!.unit}' : '50k/month',
                                        color: AppColor.primary,
                                      ),
                                    ),
                                  ),
                                TabBarWidget(
                                  tabviewController: tabviewController,
                                  onTabChanged: (e) {
                                    setState(() {
                                      currentSelectedTab = e;
                                    });
                                  },
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                if (currentSelectedTab == 0)
                                  DetailsTabView(
                                    data: data,
                                    pickedDocuments: pickedDocuments,
                                    selectedDocsName: selectedDocsName,
                                    selectedImageName: selectedImageName,
                                  ),
                                if (currentSelectedTab == 1) const ActivityTabView(),
                                // if (currentSelectedTab == 2)  TodoTabView(data),
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
                              if (Responsive.isDesktop(context))
                                AssignmentWidget(
                                  imageUrlAssignTo: data.assignedto![0].image == null || data.assignedto![0].image!.isEmpty ? noImg : data.assignedto![0].image!,
                                  imageUrlCreatedBy: data.createdby!.userimage == null || data.createdby!.userimage!.isEmpty ? noImg : data.createdby!.userimage!,
                                  createdBy: '${data.createdby!.userfirstname!} ${data.createdby!.userlastname!}',
                                  assignTo: '${data.assignedto![0].firstname!} ${data.assignedto![0].lastname!}',
                                ),
                              if (Responsive.isDesktop(context))
                                MapViewWidget(
                                  state: data.propertyaddress!.state!,
                                  city: data.propertyaddress!.city!,
                                  addressline1: data.propertyaddress!.addressline1!,
                                  addressline2: data.propertyaddress?.addressline2,
                                ),
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

class ActivityTabView extends StatelessWidget {
  const ActivityTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 450,
      child: CustomTimeLineView(),
    );
  }
}

class TodoTabView extends StatelessWidget {
  final List<CardDetails> cardDetails;
  const TodoTabView({super.key, required this.cardDetails});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 450,
      child: ListView.builder(
          itemCount: cardDetails.length,
          itemBuilder: (context, index) {
            return CustomCard(index: index, cardDetails: cardDetails);
          }),
    );
  }
}
