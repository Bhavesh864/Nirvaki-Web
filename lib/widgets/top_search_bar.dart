import 'package:flutter/material.dart';
import 'package:yes_broker/Customs/custom_fields.dart';
import 'package:yes_broker/Customs/custom_text.dart';

class TopSerachBar extends StatefulWidget {
  final String title;
  final bool isMobile;
  final bool isFilterOpen;
  final VoidCallback onFilterClose;
  final VoidCallback onFilterOpen;

  const TopSerachBar({
    required this.isMobile,
    required this.isFilterOpen,
    required this.onFilterClose,
    required this.onFilterOpen,
    required this.title,
  });

  @override
  State<TopSerachBar> createState() => _TopSerachBarState();
}

class _TopSerachBarState extends State<TopSerachBar> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return !widget.isMobile
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 5, left: 20, right: 20),
                width: MediaQuery.of(context).size.width * 0.3,
                child: CustomTextInput(
                  controller: searchController,
                  hintText: 'Search',
                  leftIcon: Icons.search,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: widget.onFilterOpen,
                    icon: const Icon(
                      Icons.filter_alt_outlined,
                      size: 24,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.view_stream_outlined,
                      size: 24,
                    ),
                  ),
                ],
              )
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: CustomText(
                  title: widget.title,
                  fontWeight: FontWeight.w600,
                  size: 18,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: widget.onFilterClose,
                    icon: const Icon(Icons.filter_list),
                  ),
                  IconButton(
                    onPressed: widget.onFilterOpen,
                    icon: const Icon(Icons.more_horiz),
                  ),
                ],
              )
            ],
          );
  }
}
