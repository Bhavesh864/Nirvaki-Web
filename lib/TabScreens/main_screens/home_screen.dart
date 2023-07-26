import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/constants/firebase/questionModels/lead_question.dart';

import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/widgets/app/nav_bar.dart';
import 'package:yes_broker/widgets/calendar_view.dart';
import 'package:yes_broker/widgets/timeline_view.dart';
import 'package:yes_broker/widgets/todo/todo_list_view.dart';
import 'package:yes_broker/widgets/workitems_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // questions();
  }

  questions() async {
    List<LeadQuestions> screensList = [
      LeadQuestions(
        type: "Commercial",
        screens: [
          Screen(
            questions: [
              Question(
                questionId: 1,
                questionOptionType: "chip",
                questionTitle: "Which Property Category does this Lead Fall under ?",
                questionOption: ["Residential", "Commercial"],
              ),
            ],
            isActive: true,
            previousScreenId: "",
            screenId: "S1",
            nextScreenId: "S2",
          ),
          Screen(
            questions: [
              Question(
                questionId: 2,
                questionOptionType: "chip",
                questionTitle: "What Category does this Lead belong to?",
                questionOption: ["Rent", "Buy"],
              ),
            ],
            isActive: true,
            previousScreenId: "S1",
            screenId: "S2",
            nextScreenId: "S3",
          ),
          Screen(
            questions: [
              Question(
                questionId: 3,
                questionOptionType: "chip",
                questionTitle: "What is the specific type of Property?",
                questionOption: ["Direct", "Broker"],
              ),
            ],
            isActive: true,
            previousScreenId: "S2",
            screenId: "S3",
            nextScreenId: "S4",
          ),
          Screen(
            questions: [
              Question(
                questionId: 4,
                questionOptionType: "chip",
                questionTitle: "From where did you source this inventory?",
                questionOption: ["99Acers", "Magic Bricks", "Makaan", "Housing.com", "Social Media", "Data Calling", "Other"],
              ),
            ],
            isActive: true,
            previousScreenId: "S3",
            screenId: "S4",
            nextScreenId: "S5",
          ),
          Screen(
            questions: [
              Question(
                questionId: 5,
                questionOptionType: "textfield",
                questionTitle: "First Name",
                questionOption: "",
              ),
              Question(
                questionId: 6,
                questionOptionType: "textfield",
                questionTitle: "Last Name",
                questionOption: "",
              ),
              Question(
                questionId: 7,
                questionOptionType: "textfield",
                questionTitle: "Mobile",
                questionOption: "",
              ),
              Question(
                questionId: 8,
                questionOptionType: "textfield",
                questionTitle: "Whatsapp Number",
                questionOption: "",
              ),
              Question(
                questionId: 9,
                questionOptionType: "textfield",
                questionTitle: "Email",
                questionOption: "",
              ),
              Question(
                questionId: 10,
                questionOptionType: "textfield",
                questionTitle: "Company Name",
                questionOption: "",
              ),
            ],
            title: "Customer Details",
            isActive: true,
            previousScreenId: "S4",
            screenId: "S5",
            nextScreenId: "S6",
          ),
          Screen(
            questions: [
              Question(
                questionId: 37,
                questionOptionType: "chip",
                questionTitle: "Type of Commercial Property?",
                questionOption: [
                  "Land",
                  "Constructed Property",
                  "Under Construction ",
                ],
              ),
            ],
            isActive: true,
            previousScreenId: "S5",
            screenId: "S6",
            nextScreenId: "S7",
          ),
          Screen(
            questions: [
              Question(
                questionId: 11,
                questionOptionType: "chip",
                questionTitle: "Type of Land?",
                questionOption: [
                  "Shop Cum Office",
                  "Mall",
                  "Shopping Complex",
                  "Office",
                  "School",
                  "Warehouse",
                ],
              ),
            ],
            isActive: true,
            previousScreenId: "S6",
            screenId: "S7",
            nextScreenId: "S8",
          ),
          Screen(
            questions: [
              Question(
                questionId: 38,
                questionOptionType: "chip",
                questionTitle: "Which Type of Property you want to list?",
                questionOption: [
                  "Office",
                  "Retail",
                  "Industrial",
                  "Hospitality",
                  "Healthcare",
                  "Institutional",
                  "School",
                  "Warehouse",
                ],
              ),
            ],
            isActive: true,
            previousScreenId: "S7",
            screenId: "S8",
            nextScreenId: "S9",
          ),
          Screen(
            questions: [
              Question(
                questionId: 39,
                questionOptionType: "chip",
                questionTitle: "Type of Office?",
                questionOption: [
                  "Furnished",
                  "Baresell",
                  "Co-working",
                ],
              ),
            ],
            isActive: true,
            previousScreenId: "S8",
            screenId: "S9",
            nextScreenId: "S10",
          ),
          Screen(
            questions: [
              Question(
                questionId: 40,
                questionOptionType: "chip",
                questionTitle: "Type of Retail?",
                questionOption: ["Shop", "Showroom", "SCO"],
              ),
            ],
            isActive: true,
            previousScreenId: "S9",
            screenId: "S10",
            nextScreenId: "S11",
          ),
          Screen(
            questions: [
              Question(
                questionId: 41,
                questionOptionType: "chip",
                questionTitle: "Type of Hospitality?",
                questionOption: [
                  "Hotel",
                  "Resort",
                  "Guest House",
                ],
              ),
            ],
            isActive: true,
            previousScreenId: "S10",
            screenId: "S11",
            nextScreenId: "S12",
          ),
          Screen(
            questions: [
              Question(
                questionId: 42,
                questionOptionType: "chip",
                questionTitle: "Type of HealthCare?",
                questionOption: [
                  "Hospital",
                  "Clinic",
                ],
              ),
            ],
            isActive: true,
            previousScreenId: "S11",
            screenId: "S12",
            nextScreenId: "S13",
          ),
          Screen(
            questions: [
              Question(
                questionId: 43,
                questionOptionType: "dropdown",
                questionTitle: "Number of beds approved?",
                questionOption: [
                  "10-50",
                  "51-100",
                  "101-150",
                  "151-200",
                ],
              ),
            ],
            isActive: true,
            title: "Number of beds approved?",
            previousScreenId: "S12",
            screenId: "S13",
            nextScreenId: "S14",
          ),
          Screen(
            questions: [
              Question(
                questionId: 44,
                questionOptionType: "chip",
                questionTitle: "Type of School Approved?",
                questionOption: ["Play School", "Primary School", "High School", "Secondary School"],
              ),
            ],
            isActive: true,
            previousScreenId: "S13",
            screenId: "S14",
            nextScreenId: "S15",
          ),
          Screen(
            questions: [
              Question(
                questionId: 45,
                questionOptionType: "textfield",
                questionTitle: "Number of Rooms Constructed?",
                questionOption: "",
              ),
            ],
            title: "Number of Rooms Constructed?",
            isActive: true,
            previousScreenId: "S14",
            screenId: "S15",
            nextScreenId: "S16",
          ),
          Screen(
            questions: [
              Question(
                questionId: 13,
                questionOptionType: "chip",
                questionTitle: "What Is the transaction type?",
                questionOption: ["Retail", "New Booking"],
              ),
            ],
            isActive: true,
            previousScreenId: "S15",
            screenId: "S16",
            nextScreenId: "S17",
          ),
          Screen(
            questions: [
              Question(
                questionId: 18,
                questionOptionType: "dropdown",
                questionTitle: "Is there a boundary wall around the plot?",
                questionOption: ["Yes", "No"],
              ),
              Question(
                questionId: 19,
                questionOptionType: "smallchip",
                questionTitle: "No of open Sides?",
                questionOption: ["1", "2", "3", "4"],
              ),
            ],
            isActive: true,
            previousScreenId: "S16",
            screenId: "S17",
            nextScreenId: "S18",
          ),
          Screen(
            questions: [
              Question(
                questionId: 20,
                questionOptionType: "chip",
                questionTitle: "Expected time possession ?",
                questionOption: ["Within 3 months", "Within 3 months", "Within 1 Year", "Within 2 Year", "Within 3 Year"],
              ),
            ],
            isActive: true,
            previousScreenId: "S17",
            screenId: "S18",
            nextScreenId: "S19",
          ),
          Screen(
            questions: [
              Question(
                questionId: 23,
                questionOptionType: "smallchip",
                questionTitle: "Property Area",
                questionOption: ["Sq ft", "Sq yard", "Acre"],
              ),
              Question(
                questionId: 24,
                questionOptionType: "textfield",
                questionTitle: "Super Area",
                questionOption: "",
              ),
              Question(
                questionId: 25,
                questionOptionType: "textfield",
                questionTitle: "Carpet Area",
                questionOption: "",
              ),
            ],
            isActive: true,
            previousScreenId: "S18",
            screenId: "S19",
            nextScreenId: "S20",
          ),
          Screen(
            questions: [
              Question(
                questionId: 32,
                questionOptionType: "textfield",
                questionTitle: "Budget range",
                questionOption: "",
              ),
              Question(
                questionId: 33,
                questionOptionType: "smallchip",
                questionTitle: "",
                questionOption: ["Crore", "Lakh", "Thousands"],
              ),
            ],
            isActive: true,
            title: "What is the customers budget range?",
            previousScreenId: "S19",
            screenId: "S20",
            nextScreenId: "S21",
          ),
          Screen(
            questions: [
              Question(
                questionId: 26,
                questionOptionType: "dropdown",
                questionTitle: "State",
                questionOption: [],
              ),
              Question(
                questionId: 27,
                questionOptionType: "dropdown",
                questionTitle: "City",
                questionOption: [],
              ),
              Question(
                questionId: 28,
                questionOptionType: "textfield",
                questionTitle: "Address Line 1",
                questionOption: "",
              ),
              Question(
                questionId: 29,
                questionOptionType: "textfield",
                questionTitle: "Address Line 2",
                questionOption: "",
              ),
              Question(
                questionId: 30,
                questionOptionType: "textfield",
                questionTitle: "Floor Number",
                questionOption: "",
              ),
            ],
            title: "Property Address",
            isActive: true,
            previousScreenId: "S20",
            screenId: "S21",
            nextScreenId: "S22",
          ),
          Screen(
            questions: [
              Question(
                questionId: 31,
                questionOptionType: "map",
                questionTitle: "Pin Property on Map",
                questionOption: "",
              ),
            ],
            isActive: true,
            previousScreenId: "S21",
            screenId: "S22",
            nextScreenId: "S23",
          ),
          Screen(
            questions: [
              Question(
                questionId: 32,
                questionOptionType: "chip",
                questionTitle: "Preferred Property Direction",
                questionOption: ["East", "West", "North", "South", "North East", "North West", "South East", "South West"],
              ),
            ],
            isActive: true,
            previousScreenId: "S22",
            screenId: "S23",
            nextScreenId: "S24",
          ),
          Screen(
            questions: [
              Question(
                questionId: 42,
                questionOptionType: "textfield",
                questionTitle: "Width Of Road",
                questionOption: "",
              ),
              Question(
                questionId: 43,
                questionOptionType: "smallchip",
                questionTitle: "",
                questionOption: ["Mtr", "Ft"],
              ),
            ],
            isActive: true,
            title: "Width of road in front?",
            previousScreenId: "S24",
            screenId: "S25",
            nextScreenId: "S26",
          ),
          Screen(
            questions: [
              Question(
                questionId: 35,
                questionOptionType: "textarea",
                questionTitle: "Add Note Or comment",
                questionOption: "Add Note Or comment",
              ),
            ],
            isActive: true,
            previousScreenId: "S27",
            screenId: "S28",
            nextScreenId: "S29",
          ),
          Screen(
            questions: [
              Question(
                questionId: 36,
                questionOptionType: "Assign",
                questionTitle: "Assign to",
                questionOption: "",
              ),
            ],
            isActive: true,
            title: "Assign to",
            previousScreenId: "S28",
            screenId: "S29",
            nextScreenId: "",
          ),
        ],
      ),
    ];
    await LeadQuestions.addScreens(screensList);
  }
  // await InventoryQuestions.addScreens(screensList);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Consumer(
      builder: (context, ref, child) {
        final currentUserData = ref.watch(userProvider).state;
        print(currentUserData.email);
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
                flex: size.width > 1340 ? 3 : 5,
                child: const Padding(
                  padding: EdgeInsets.only(top: 8, left: 0),
                  child: TodoListView(),
                ),
              ),
              size.width > 1200
                  ? Expanded(
                      flex: size.width > 1340 ? 3 : 5,
                      child: const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: WorkItemsList(),
                      ),
                    )
                  : Container(),
              Expanded(
                flex: size.width > 1340 ? 4 : 6,
                child: Column(
                  children: [
                    const Expanded(
                      flex: 2,
                      child: CustomCalendarView(),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: AppColor.secondary,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                              child: CustomText(
                                title: 'Timeline',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            CustomTimeLineView(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
