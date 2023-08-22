import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:yes_broker/Customs/responsive.dart';
import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/widgets/todo/todo_filter_view.dart';
import '../../Customs/custom_chip.dart';
import '../../Customs/custom_text.dart';
import '../../constants/utils/constants.dart';
import '../../riverpodstate/selected_workitem.dart';
import '../../routes/routes.dart';
import '../../widgets/app/nav_bar.dart';
import '../../widgets/calendar_view.dart';
import '../../widgets/card/card_header.dart';
import '../../widgets/card/custom_card.dart';
import '../../widgets/top_search_bar.dart';
import '../../widgets/workitems/workitem_filter_view.dart';
import '../../widgets/workitems/workitems_list.dart';

class TodoListingScreen extends ConsumerStatefulWidget {
  const TodoListingScreen({super.key});

  @override
  TodoListingScreenState createState() => TodoListingScreenState();
}

class TodoListingScreenState extends ConsumerState<TodoListingScreen> {
  List<String> selectedFilters = [];
  final TextEditingController searchController = TextEditingController();
  bool isFilterOpen = false;
  bool showTableView = false;
  Future<List<CardDetails>>? future;

  List<CardDetails>? status;

  @override
  void initState() {
    future = CardDetails.getCardDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.hasData) {
            List<CardDetails> todoItemsList = snapshot.data!.where((item) => item.cardType != "IN" && item.cardType != "LD").toList();
            List<CardDetails> filterTodoList = todoItemsList.where((item) {
              if (searchController.text.isEmpty) {
                return true;
              } else {
                final searchText = searchController.text.toLowerCase();
                final fullName = "${item.customerinfo!.firstname} ${item.customerinfo!.lastname}".toLowerCase();
                final title = item.cardTitle!.toLowerCase();
                final mobileNumber = item.customerinfo!.mobile!.toLowerCase();
                return fullName.contains(searchText) || title.contains(searchText) || mobileNumber.contains(searchText);
              }
            }).toList();

            filterTodoList = filterTodoList.where((item) {
              final bool isStatusMatch = selectedFilters.isEmpty || selectedFilters.contains(item.status!.toLowerCase());
              final bool isLinkItemTypeMatch = selectedFilters.isEmpty || selectedFilters.contains(item.linkedItemType == 'IN' ? 'inventory' : 'lead');
              final bool isTodoTypeMatch = selectedFilters.isEmpty || selectedFilters.contains(item.cardType!.toLowerCase());

              return isStatusMatch || isLinkItemTypeMatch || isTodoTypeMatch;
            }).toList();

            status = filterTodoList;

            final tableRowList = filterTodoList.map((e) {
              return _buildWorkItemRowTile(e, filterTodoList.indexOf(e), status);
            });

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TopSerachBar(
                          onChanged: (value) {
                            setState(() {});
                          },
                          onToggleShowTable: () {
                            setState(() {
                              showTableView = !showTableView;
                            });
                          },
                          showTableView: showTableView,
                          searchController: searchController,
                          title: 'Todo',
                          isMobile: Responsive.isMobile(context),
                          isFilterOpen: isFilterOpen,
                          onFilterClose: () {
                            setState(() {
                              isFilterOpen = false;
                            });
                          },
                          onFilterOpen: () {
                            if (Responsive.isMobile(context)) {
                              Navigator.of(context).push(AppRoutes.createAnimatedRoute(const WorkItemFilterView(
                                originalCardList: [],
                              )));
                            } else {
                              setState(() {
                                isFilterOpen = true;
                              });
                            }
                          },
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  if (Responsive.isMobile(context)) ...[
                                    SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          const CustomCalendarView(),
                                          Container(
                                            constraints: const BoxConstraints(),
                                            child: WorkItemsList(
                                              isScrollable: false,
                                              title: 'To do',
                                              getCardDetails: filterTodoList,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ] else ...[
                                    if (showTableView) ...[
                                      filterTodoList.isNotEmpty
                                          ? Container(
                                              margin: const EdgeInsets.symmetric(horizontal: 10),
                                              child: LayoutBuilder(builder: (context, constraints) {
                                                final availableWidth = constraints.maxWidth;
                                                return Table(
                                                  columnWidths: {
                                                    0: FixedColumnWidth(availableWidth * 0.25),
                                                    1: FixedColumnWidth(availableWidth * 0.18),
                                                    2: FixedColumnWidth(availableWidth * 0.15),
                                                    3: FixedColumnWidth(availableWidth * 0.15),
                                                    4: FixedColumnWidth(availableWidth * 0.1),
                                                    5: FixedColumnWidth(availableWidth * 0.1),
                                                  },
                                                  border: TableBorder(
                                                    bottom: BorderSide(color: Colors.grey.withOpacity(.5), width: 1.5),
                                                    horizontalInside: BorderSide(color: Colors.grey.withOpacity(.5), width: 1.5),
                                                  ),
                                                  children: [
                                                    _buildTableHeader(),
                                                    ...tableRowList,
                                                  ],
                                                );
                                              }),
                                            )
                                          : SizedBox(
                                              height: 500,
                                              width: width! * 0.9,
                                              child: const Center(
                                                child: Text(
                                                  "No results found.",
                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                    ] else ...[
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppColor.secondary,
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                        margin: Responsive.isMobile(context) ? null : const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        child: filterTodoList.isNotEmpty
                                            ? GridView.builder(
                                                shrinkWrap: true,
                                                physics: const ScrollPhysics(),
                                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: Responsive.isMobile(context)
                                                        ? 1
                                                        : Responsive.isTablet(context) || isFilterOpen
                                                            ? 2
                                                            : 3,
                                                    // mainAxisSpacing: 5.0,
                                                    crossAxisSpacing: 10.0,
                                                    mainAxisExtent: Responsive.isMobile(context) ? 197 : 170),
                                                itemCount: filterTodoList.length,
                                                itemBuilder: (context, index) => GestureDetector(
                                                  onTap: () {
                                                    final id = filterTodoList[index].workitemId;

                                                    if (Responsive.isMobile(context)) {
                                                      Navigator.of(context).pushNamed(AppRoutes.todoDetailsScreen, arguments: id);
                                                    } else {
                                                      ref.read(selectedWorkItemId.notifier).addItemId(id!);
                                                      context.beamToNamed('/todo/todo-details/$id');
                                                    }
                                                  },
                                                  child: CustomCard(index: index, cardDetails: filterTodoList),
                                                ),
                                              )
                                            : const Center(
                                                child: Text(
                                                  "No results found.", // Customize the message
                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                      ),
                                    ]
                                  ]
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                if (Responsive.isDesktop(context) && isFilterOpen)
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                          width: 1,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        Expanded(
                          child: TodoFilterView(
                            closeFilterView: () {
                              setState(() {
                                isFilterOpen = false;
                              });
                            },
                            onApplyFilters: (list) {
                              selectedFilters = list;
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          }
          return const SizedBox.shrink();
        });
  }

  TableRow _buildTableHeader() {
    return TableRow(
      children: [
        _buildWorkItemTableItem(
          const Text(
            'DESCRIPTION',
            style: TextStyle(
              color: AppColor.cardtitleColor,
            ),
          ),
        ),
        _buildWorkItemTableItem(
          const Text(
            'DETAILS',
            style: TextStyle(
              color: AppColor.cardtitleColor,
            ),
          ),
        ),
        _buildWorkItemTableItem(
          const Text(
            'STATUS',
            style: TextStyle(
              color: AppColor.cardtitleColor,
            ),
          ),
        ),
        _buildWorkItemTableItem(
          const Text(
            'OWNER',
            style: TextStyle(
              color: AppColor.cardtitleColor,
            ),
          ),
        ),
        _buildWorkItemTableItem(
            const Text(
              'ASSIGNED TO',
              style: TextStyle(
                color: AppColor.cardtitleColor,
              ),
            ),
            align: Alignment.center),
        // _buildWorkItemTableItem(
        //   Container(),
        //   align: Alignment.center,
        // ),
      ],
    );
  }

  TableRow _buildWorkItemRowTile(
    CardDetails leadItem,
    int index,
    List<CardDetails>? status,
  ) {
    return TableRow(
      key: ValueKey(leadItem.workitemId),
      children: [
        _buildWorkItemTableItem(
          Text(
            leadItem.cardTitle!,
          ),
        ),
        _buildWorkItemTableItem(
          ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              CustomChip(
                  label: Icon(
                    checkIconByCategory(leadItem),
                    color: checkIconColorByCategory(leadItem),
                    size: 18,
                    // weight: 10.12,
                  ),
                  color: checkChipColorByCategory(leadItem)),
              checkNotNUllItem(leadItem.roomconfig?.bedroom)
                  ? CustomChip(
                      label: CustomText(
                        title: "${leadItem.roomconfig?.bedroom}BHK+${leadItem.roomconfig?.additionalroom?[0] ?? ""}",
                        size: 10,
                      ),
                    )
                  : const SizedBox(),
              isTypeisTodo(leadItem)
                  ? CustomChip(
                      color: AppColor.primary.withOpacity(0.1),
                      label: CustomText(
                        title: "${leadItem.cardType}",
                        size: 10,
                        color: AppColor.primary,
                      ),
                    )
                  : const SizedBox(),
              checkNotNUllItem(leadItem.propertyarearange?.arearangestart)
                  ? CustomChip(
                      label: CustomText(
                        title: "${leadItem.propertyarearange?.arearangestart} ${leadItem.propertyarearange?.unit}",
                        size: 10,
                      ),
                    )
                  : const SizedBox(),
              checkNotNUllItem(leadItem.propertypricerange?.arearangestart)
                  ? CustomChip(
                      label: CustomText(
                        title: "${leadItem.propertypricerange?.arearangestart}${leadItem.propertypricerange?.unit}",
                        size: 10,
                      ),
                    )
                  : const SizedBox(),
              checkNotNUllItem(leadItem.cardCategory)
                  ? CustomChip(
                      label: CustomText(
                        title: leadItem.cardCategory!,
                        size: 10,
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
        _buildWorkItemTableItem(
          PopupMenuButton(
            initialValue: status ?? leadItem.status,
            splashRadius: 0,
            padding: EdgeInsets.zero,
            color: Colors.white.withOpacity(1),
            offset: const Offset(10, 40),
            itemBuilder: (context) => dropDownStatusDataList.map((e) => popupMenuItem(e.toString())).toList(),
            onSelected: (value) {
              CardDetails.updateCardStatus(id: leadItem.workitemId!, newStatus: value);
              status[index].status = value;
              setState(() {});
            },
            child: IntrinsicWidth(
              child: CustomChip(
                label: Row(
                  children: [
                    CustomText(
                      title: status![index].status ?? leadItem.status!,
                      color: taskStatusColor(status[index].status ?? leadItem.status!),
                      size: 10,
                    ),
                    Icon(
                      Icons.expand_more,
                      size: 18,
                      color: taskStatusColor(status[index].status ?? leadItem.status!),
                    ),
                  ],
                ),
                color: taskStatusColor(status[index].status ?? leadItem.status!).withOpacity(0.1),
              ),
            ),
          ),
        ),
        _buildWorkItemTableItem(
          ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(right: 3),
                  child: Text(
                    "${leadItem.customerinfo!.firstname!} ${leadItem.customerinfo!.lastname!}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const CustomChip(
                label: Icon(
                  Icons.call_outlined,
                ),
                paddingHorizontal: 3,
              ),
              const CustomChip(
                label: FaIcon(
                  FontAwesomeIcons.whatsapp,
                ),
                paddingHorizontal: 3,
              ),
            ],
          ),
        ),
        _buildWorkItemTableItem(
            Container(
              margin: const EdgeInsets.only(right: 5),
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                image: DecorationImage(image: NetworkImage(leadItem.assignedto![0].image!.isEmpty ? noImg : leadItem.assignedto![0].image!), fit: BoxFit.fill),
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            align: Alignment.center),
        // _buildWorkItemTableItem(
        //   Container(),
        //   align: Alignment.center,
        // ),
      ],
    );
  }

  TableCell _buildWorkItemTableItem(Widget child, {Alignment align = Alignment.centerLeft}) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 0),
        alignment: align,
        height: 70,
        child: child,
      ),
    );
  }
}