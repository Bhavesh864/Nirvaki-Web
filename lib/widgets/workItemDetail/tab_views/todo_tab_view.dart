import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/Customs/custom_chip.dart';
import 'package:yes_broker/Customs/custom_fields.dart';
import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/constants/app_constant.dart';
import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';
import 'package:yes_broker/constants/functions/navigation/navigation_functions.dart';
import 'package:yes_broker/riverpodstate/user_data.dart';
import 'package:yes_broker/routes/routes.dart';
import 'package:yes_broker/widgets/card/custom_card.dart';
import '../../../Customs/loader.dart';
import '../../../Customs/responsive.dart';
import '../../../constants/firebase/userModel/user_info.dart';
import '../../../constants/functions/filterdataAccordingRole/data_according_role.dart';
import '../../../constants/utils/colors.dart';
import '../../../constants/utils/constants.dart';
import '../../../pages/add_inventory.dart';
import '../../../riverpodstate/todo/linked_with_workItem.dart';
import '../../table_view/table_view_widgets.dart';

class TodoTabView extends ConsumerStatefulWidget {
  final String id;
  const TodoTabView({
    super.key,
    required this.id,
  });

  @override
  TodoTabViewState createState() => TodoTabViewState();
}

class TodoTabViewState extends ConsumerState<TodoTabView> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> cardDetails;

  TextEditingController searchController = TextEditingController();
  bool showTableView = false;
  Future<List<CardDetails>>? future;
  List<User> userList = [];
  bool isUserLoaded = false;

  @override
  void initState() {
    super.initState();
    setCardDetails();
  }

  void setCardDetails() {
    cardDetails = FirebaseFirestore.instance.collection('cardDetails').where("linkedItemId", isEqualTo: widget.id).snapshots(includeMetadataChanges: true);
  }

  void getDetails(User currentuser) async {
    if (mounted) {
      final List<User> user = await User.getUserAllRelatedToBrokerId(currentuser);
      if (mounted) {
        setState(() {
          userList = user;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userDataProvider);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: Responsive.isMobile(context) ? MediaQuery.of(context).size.width * 0.55 : MediaQuery.of(context).size.width * 0.3,
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    isDense: true,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  if (!Responsive.isMobile(context))
                    GestureDetector(
                      onTap: () {
                        showTableView = !showTableView;
                        setState(() {});
                      },
                      child: const CustomChip(
                        paddingVertical: 5,
                        label: Icon(
                          Icons.view_agenda_outlined,
                          size: 24,
                        ),
                      ),
                    ),
                  const SizedBox(
                    width: 8,
                  ),
                  CustomButton(
                    height: Responsive.isMobile(context) ? 45 : 40,
                    onPressed: () {
                      AppConst.getOuterContext()?.beamToNamed(AppRoutes.addTodo);
                      ref.read(myArrayProvider.notifier).resetState();
                      ref.read(linkedWithWorkItem.notifier).setgotToDetailsScreenState(true);
                    },
                    leftIcon: Icons.add,
                    text: 'Add',
                    textColor: Colors.white,
                    fontWeight: FontWeight.w500,
                  )
                ],
              ),
            ],
          ),
        ),
        StreamBuilder(
            stream: cardDetails,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 300,
                  child: Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                );
              }
              if (snapshot.hasData) {
                if (user == null) return const Loader();
                if (!isUserLoaded) {
                  getDetails(user);
                  isUserLoaded = true;
                }
                final filterItem = filterCardsAccordingToRole(snapshot: snapshot, ref: ref, userList: userList, currentUser: user);
                final List<CardDetails> todoItems =
                    filterItem!.map((doc) => CardDetails.fromSnapshot(doc)).where((item) => item.cardType != "IN" && item.cardType != "LD").toList();

                List<CardDetails> todoItemsList = todoItems.where((card) {
                  final searchTerm = searchController.text.toLowerCase();
                  return card.cardTitle!.toLowerCase().contains(searchTerm) || card.cardType!.toLowerCase().contains(searchTerm);
                }).toList();

                todoItemsList = todoItemsList.where((item) => item.status != 'Closed').toList();

                if (showTableView) {
                  final tableRowList = todoItemsList.map((e) {
                    return buildWorkItemRowTile(
                      e,
                      todoItemsList.indexOf(e),
                      todoItemsList,
                      id: e.workitemId,
                      ref: ref,
                      context: context,
                    );
                  });
                  return todoItemsList.isNotEmpty
                      ? Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 0),
                          padding: EdgeInsets.zero,
                          child: LayoutBuilder(builder: (context, constraints) {
                            final availableWidth = constraints.maxWidth;
                            return Table(
                              columnWidths: {
                                0: FixedColumnWidth(availableWidth * 0.25),
                                1: FixedColumnWidth(availableWidth * 0.15),
                                2: FixedColumnWidth(availableWidth * 0.15),
                                3: FixedColumnWidth(availableWidth * 0.15),
                                4: FixedColumnWidth(availableWidth * 0.20),
                                5: FixedColumnWidth(availableWidth * 0.1),
                              },
                              border: TableBorder(
                                bottom: BorderSide(color: Colors.grey.withOpacity(.5), width: 1.5),
                                horizontalInside: BorderSide(color: Colors.grey.withOpacity(.5), width: 1.5),
                              ),
                              children: [
                                buildTableHeader(isTodo: true),
                                ...tableRowList,
                              ],
                            );
                          }),
                        )
                      : SizedBox(
                          height: 300,
                          width: width! * 0.9,
                          child: const Center(
                            child: Text(
                              "No results found.",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                } else {
                  return todoItemsList.isNotEmpty
                      ? Container(
                          decoration: BoxDecoration(
                            color: AppColor.secondary,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: Responsive.isMobile(context) ? 1 : 2,
                              mainAxisSpacing: 10.0,
                              crossAxisSpacing: 10.0,
                              mainAxisExtent: 170,
                            ),
                            itemCount: todoItemsList.length,
                            itemBuilder: (context, index) => GestureDetector(
                              onTap: () {
                                navigateBasedOnId(context, todoItemsList[index].workitemId!, ref);
                              },
                              child: CustomCard(cardDetails: todoItemsList, index: index),
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 300,
                          width: width! * 0.9,
                          child: const Center(
                            child: Text(
                              "No results found.",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                }
              }
              return Container(
                color: Colors.indigo,
                height: 300,
                child: const Center(
                  child: CustomText(title: "NO DATA FOUND"),
                ),
              );
            }),
      ],
    );
  }
}
