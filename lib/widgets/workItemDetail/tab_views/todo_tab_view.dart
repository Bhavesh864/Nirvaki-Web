import 'package:beamer/beamer.dart';
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
  TextEditingController searchController = TextEditingController();
  bool showTableView = false;
  Future<List<CardDetails>>? future;
  List<User> userList = [];
  @override
  void initState() {
    future = CardDetails.getcardByInventoryId(widget.id);
    super.initState();
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
        FutureBuilder(
            future: future,
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
                final filterItem = filterCardsAccordingToRoleInFutureBuilder(snapshot: snapshot, ref: ref, userList: userList, currentUser: user);
                List<CardDetails> filteredList = filterItem!.where((card) {
                  final searchTerm = searchController.text.toLowerCase();
                  return card.cardTitle!.toLowerCase().contains(searchTerm) || card.cardType!.toLowerCase().contains(searchTerm);
                }).toList();
                if (showTableView) {
                  final tableRowList = filteredList.map((e) {
                    return buildWorkItemRowTile(
                      e,
                      filteredList.indexOf(e),
                      filteredList,
                      id: e.workitemId,
                      ref: ref,
                      context: context,
                    );
                  });
                  return filteredList.isNotEmpty
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
                  return filteredList.isNotEmpty
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
                            itemCount: filteredList.length,
                            itemBuilder: (context, index) => GestureDetector(
                              onTap: () {
                                navigateBasedOnId(context, filteredList[index].workitemId!, ref);
                              },
                              child: CustomCard(cardDetails: filteredList, index: index),
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
