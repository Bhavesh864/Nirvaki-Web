import 'package:flutter/material.dart';

import 'package:yes_broker/Customs/custom_text.dart';
import 'package:yes_broker/customs/responsive.dart';

class TopSerachBar extends StatefulWidget {
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
  State<TopSerachBar> createState() => _TopSerachBarState();
}

class _TopSerachBarState extends State<TopSerachBar> {
  @override
  Widget build(BuildContext context) {
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
                    IconButton(
                      onPressed: () {
                        widget.onFilterOpen();
                      },
                      icon: const Icon(
                        Icons.filter_alt_outlined,
                        size: 24,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        widget.onToggleShowTable();
                      },
                      icon: Icon(
                        !widget.showTableView ? Icons.view_agenda_outlined : Icons.view_module_outlined,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        : widget.title != 'Todo'
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      title: widget.title,
                      fontWeight: FontWeight.w600,
                      size: 18,
                    ),
                    Row(
                      children: [
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
                          onTap: () {
                            widget.onFilterOpen();
                          },
                          child: const Icon(
                            Icons.more_horiz,
                            size: 20,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            : Container();
  }
}
