import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yes_broker/Customs/custom_chip.dart';
import 'package:yes_broker/Customs/custom_fields.dart';
import 'package:yes_broker/Customs/dropdown_field.dart';
import 'package:yes_broker/Customs/label_text_field.dart';
import 'package:yes_broker/widgets/questionaries/google_maps.dart';

import '../../Customs/custom_text.dart';
import '../../constants/utils/colors.dart';
import '../../constants/utils/constants.dart';
import '../../widgets/app/app_bar.dart';

class InventoryDetailsScreen extends StatefulWidget {
  const InventoryDetailsScreen({super.key});

  @override
  State<InventoryDetailsScreen> createState() => _InventoryDetailsScreenState();
}

class _InventoryDetailsScreenState extends State<InventoryDetailsScreen> with TickerProviderStateMixin {
  late TabController tabviewController;

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {},
    );
    Widget continueButton = TextButton(
      child: const Text("Continue"),
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("AlertDialog"),
      content: const Text("Would you like to continue learning how to use Flutter alerts?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _showChatDialog(BuildContext context) {
    showDialog(
      context: context,
      // position: RelativeRect.fromLTRB(offset.dx, offset.dy, offset.dx + button.size.width, offset.dy + button.size.height),
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Upload New Document',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ), // Replace with your dialog title
          content: SizedBox(
            height: 200,
            width: 500,
            child: Column(
              children: [
                // LabelTextInputField(
                //   isDropDown: true,
                //   hintText: '-select-',
                //   labelText: 'Document Type',
                //   inputController: TextEditingController(),
                // ),
                DropDownField(title: 'Document Type', optionsList: const ['Adhaar', 'Pan ', 'Icici'], onchanged: (e) {}),
                CustomButton(
                  text: 'Upload Document',
                  buttonColor: AppColor.pink,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          actions: [
            CustomButton(text: 'Done', onPressed: () {}),
          ],
        );
      },
    );
  }

  List<String> items = [
    'Residential',
    'Apartment',
    'Floor Wise',
    '3BHK + Study',
    'Balcony',
    'In house Gym',
    '2 Car Parking',
    'Pool',
    'Power Backup',
    'Power Backup',
    'Power Backup',
    'Power Backup',
    'Power Backup',
    'Power Backup',
    'Power Backup',
  ];

  @override
  void initState() {
    super.initState();
    tabviewController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColor.secondary,
            spreadRadius: 12,
            blurRadius: 4,
            offset: Offset(5, 5),
          ),
        ],
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                width: 430,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    const Text(
                                      "Regal Heaven",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    CustomChip(
                                      color: AppColor.primary.withOpacity(0.1),
                                      label: const CustomText(
                                        title: "Sell",
                                        size: 10,
                                        color: AppColor.primary,
                                      ),
                                    ),
                                    CustomChip(
                                      color: AppColor.primary.withOpacity(0.1),
                                      label: const CustomText(
                                        title: "Direct",
                                        size: 10,
                                        color: AppColor.primary,
                                      ),
                                    ),
                                    CustomChip(
                                      color: AppColor.primary.withOpacity(0.1),
                                      label: const CustomText(
                                        title: "Residential",
                                        size: 10,
                                        color: AppColor.primary,
                                      ),
                                    ),
                                    PopupMenuButton(
                                      tooltip: '',
                                      initialValue: 'New',
                                      splashRadius: 0,
                                      padding: EdgeInsets.zero,
                                      color: Colors.white.withOpacity(1),
                                      offset: const Offset(10, 40),
                                      itemBuilder: (context) => dropDownListData.map((e) => popupMenuItem(e.toString(), (e) {})).toList(),
                                      child: CustomChip(
                                        label: Row(
                                          children: [
                                            CustomText(
                                              title: selectedOption,
                                              color: taskStatusColor(selectedOption),
                                              size: 10,
                                            ),
                                            Icon(
                                              Icons.expand_more,
                                              size: 18,
                                              color: taskStatusColor(selectedOption),
                                            ),
                                          ],
                                        ),
                                        color: taskStatusColor(selectedOption).withOpacity(0.1),
                                      ),
                                    ),
                                    const CustomChip(
                                      label: Icon(
                                        Icons.share_outlined,
                                      ),
                                      paddingHorizontal: 3,
                                    ),
                                    const CustomChip(
                                      label: Icon(
                                        Icons.more_vert,
                                      ),
                                      paddingHorizontal: 3,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const CustomText(
                            title: '₹90,000/month',
                            color: AppColor.primary,
                          )
                        ],
                      ),
                      const ListTile(
                        leading: Icon(
                          Icons.location_on_outlined,
                          size: 20,
                          color: Colors.black,
                        ),
                        minLeadingWidth: 2,
                        horizontalTitleGap: 8,
                        titleAlignment: ListTileTitleAlignment.center,
                        title: CustomText(
                          title: 'South-ex, Delhi',
                          size: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFA8A8A8),
                        ),
                      ),
                      Container(
                        height: 62,
                        // width: 396,
                        margin: const EdgeInsets.only(top: 22),
                        decoration: BoxDecoration(
                          color: AppColor.secondary,
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                        child: TabBar(
                          controller: tabviewController,
                          labelColor: Colors.white,
                          labelStyle: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.w600,
                          ),
                          unselectedLabelColor: Colors.black,
                          unselectedLabelStyle: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.w600,
                          ),
                          indicatorPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          splashBorderRadius: BorderRadius.circular(8),
                          indicator: BoxDecoration(
                            color: AppColor.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          tabs: const [
                            Tab(
                              child: Text(
                                "Details",
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Tab(
                              child: Text(
                                "Activity",
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Tab(
                              child: Text(
                                "To-Do",
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Tab(
                              child: Text(
                                "Matches",
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const CustomText(
                        title: "Images",
                        color: Color(0xFF181818),
                        fontWeight: FontWeight.w700,
                      ),
                      SizedBox(
                        height: 170,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(10),
                                  height: 120,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                const CustomText(title: 'Front Elevation')
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const CustomText(
                        title: "Overview",
                        color: Color(0xFF181818),
                        fontWeight: FontWeight.w700,
                      ),
                      Wrap(
                        children: List<Widget>.generate(
                          items.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(right: 8.0, top: 10),
                            child: CustomChip(
                              label: Text(items[index]),
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
                          color: Color(0xFF181818),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Text(
                        "A beautiful 2 BHK which offers you luxury at every corner of this Farm. The garden is huge and beautifully maintained. The swimming pool is like the cherry on the cake. This 2 bedroom can easily accommodate up to 6 guests. To ensure you have a comfortable stay, housekeeping and the services of a caretaker are provided here.",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: CustomText(
                          title: "Attachments",
                          color: Color(0xFF181818),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _showChatDialog(context);
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
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            width: 1,
            color: Colors.grey.withOpacity(0.5),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        title: 'Miss. Riya Sharma',
                        fontWeight: FontWeight.w600,
                        size: 20,
                      ),
                      CustomChip(
                        label: Icon(
                          Icons.more_vert,
                        ),
                        paddingHorizontal: 3,
                      ),
                    ],
                  ),
                  const ListTile(
                    contentPadding: EdgeInsets.all(0),
                    dense: true,
                    visualDensity: VisualDensity(vertical: -2),
                    leading: CustomChip(
                      label: Icon(
                        Icons.call_outlined,
                        color: Colors.black,
                      ),
                      paddingHorizontal: 3,
                    ),
                    title: CustomText(
                      title: '+919876543210',
                      size: 14,
                      color: Color(0xFFA8A8A8),
                    ),
                    minLeadingWidth: 0,
                  ),
                  const ListTile(
                    contentPadding: EdgeInsets.all(0),
                    dense: true,
                    visualDensity: VisualDensity(vertical: -2),
                    leading: CustomChip(
                      label: Icon(
                        FontAwesomeIcons.whatsapp,
                        color: Colors.black,
                      ),
                      paddingHorizontal: 3,
                    ),
                    title: CustomText(
                      title: 'Not Active',
                      size: 12,
                      color: Color(0xFFA8A8A8),
                    ),
                    minLeadingWidth: 0,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 17,
                    ),
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
                                  fontFamily: 'DM Sans',
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
                                  fontFamily: 'DM Sans',
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
                              fontFamily: 'DM Sans',
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
                                        child: Text("Shamsheer Singh",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              color: AppColor.primary,
                                              fontSize: 14,
                                              fontFamily: 'DM Sans',
                                              fontWeight: FontWeight.w400,
                                            ))),
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
                                              fontFamily: 'DM Sans',
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
                                              fontFamily: 'DM Sans',
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
                                            fontFamily: 'DM Sans',
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
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomText(
                          title: 'Location',
                          fontWeight: FontWeight.w600,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        CustomChip(
                          label: Icon(
                            Icons.share_outlined,
                          ),
                          paddingHorizontal: 3,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    // width: 314,
                    height: 197,
                    child: CustomGoogleMap(
                      onLatLngSelected: (d) {},
                      stateName: 'Rajasthan',
                      cityName: 'Jaipur',
                      address1: 'wtp',
                      address2: 'wtp',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
