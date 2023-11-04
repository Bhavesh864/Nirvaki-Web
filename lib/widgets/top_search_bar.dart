import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/customs/custom_chip.dart';
import 'package:yes_broker/customs/responsive.dart';

final showClosedTodoItemsProvider = StateProvider<bool>((ref) => false);

class TopSerachBar extends ConsumerStatefulWidget {
  final String title;
  final Function(String) onChanged;
  final Function onToggleShowTable;
  final bool showTableView;
  final TextEditingController searchController;
  final bool isFilterOpen;
  final VoidCallback onFilterClose;
  final Function onFilterOpen;

  const TopSerachBar({
    super.key,
    required this.isFilterOpen,
    required this.onFilterClose,
    required this.onFilterOpen,
    required this.title,
    required this.searchController,
    required this.onChanged,
    required this.onToggleShowTable,
    required this.showTableView,
  });

  @override
  ConsumerState<TopSerachBar> createState() => _TopSerachBarState();
}

class _TopSerachBarState extends ConsumerState<TopSerachBar> {
  // bool _showClosed = false;

  @override
  Widget build(BuildContext context) {
    final showClosed = ref.watch(showClosedTodoItemsProvider);

    return !Responsive.isMobile(context)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                width: MediaQuery.of(context).size.width * 0.3,
                child: TextField(
                  controller: widget.searchController,
                  onChanged: widget.onChanged,
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
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Row(
                  children: [
                    widget.title == 'Todo'
                        ? InkWell(
                            onTap: () {
                              // setState(() {
                              //   _showClosed = !_showClosed;
                              //   // widget.onShowClosedChanged(_showClosed);
                              // });
                              ref.read(showClosedTodoItemsProvider.notifier).state = !showClosed;
                            },
                            child: Row(
                              children: [
                                const CustomText(
                                  title: 'Show Closed',
                                  fontWeight: FontWeight.w600,
                                  size: 14,
                                ),
                                Switch(
                                    value: showClosed,
                                    onChanged: (value) {
                                      // setState(() {
                                      //   _showClosed = !_showClosed;
                                      //   // widget.onShowClosedChanged(_showClosed);
                                      // });
                                      ref.read(showClosedTodoItemsProvider.notifier).state = !showClosed;
                                    }),
                              ],
                            ),
                          )
                        : const SizedBox(),
                    const SizedBox(
                      width: 10,
                    ),
                    CustomChip(
                      paddingVertical: 5,
                      onPressed: () {
                        widget.onFilterOpen();
                      },
                      label: const Icon(
                        Icons.filter_alt_outlined,
                        size: 22,
                      ),
                    ),
                    CustomChip(
                      paddingVertical: 5,
                      onPressed: () {
                        widget.onToggleShowTable();
                      },
                      label: Icon(
                        !widget.showTableView ? Icons.view_agenda_outlined : Icons.view_module_outlined,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        :
        // : widget.title != 'Todo'
        //     ?
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  title: widget.title,
                  fontWeight: FontWeight.w600,
                  size: 18,
                  letterSpacing: 0.3,
                ),
                Row(
                  children: [
                    widget.title == 'Todo'
                        ? InkWell(
                            onTap: () {
                              // setState(() {
                              //   _showClosed = !_showClosed;
                              //   // widget.onShowClosedChanged(_showClosed);
                              // });
                              ref.read(showClosedTodoItemsProvider.notifier).state = !showClosed;
                            },
                            child: Row(
                              children: [
                                const CustomText(
                                  title: 'Show Closed',
                                  fontWeight: FontWeight.w600,
                                  size: 14,
                                ),
                                Switch(
                                    value: showClosed,
                                    onChanged: (value) {
                                      // setState(() {
                                      //   _showClosed = !_showClosed;
                                      //   // widget.onShowClosedChanged(_showClosed);
                                      // });
                                      ref.read(showClosedTodoItemsProvider.notifier).state = !showClosed;
                                    }),
                              ],
                            ),
                          )
                        : const SizedBox(),
                    InkWell(
                      onTap: () {
                        widget.onFilterOpen();
                      },
                      child: const Icon(
                        Icons.filter_list,
                        size: 20,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () {},
                      child: const Icon(
                        Icons.more_horiz,
                        size: 20,
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
    // : Container();
  }
}
