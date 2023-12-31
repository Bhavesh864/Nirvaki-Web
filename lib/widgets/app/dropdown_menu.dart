// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../Customs/custom_text.dart';
import '../../constants/utils/constants.dart';

class CustomStatusDropDown extends StatelessWidget {
  final dynamic status;
  final Function(dynamic) onSelected;
  final List<PopupMenuEntry<dynamic>> Function(BuildContext) itemBuilder;

  const CustomStatusDropDown({
    super.key,
    this.status,
    required this.itemBuilder,
    required this.onSelected,
  });

  @override
  PopupMenuButton build(BuildContext context) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      initialValue: status,
      tooltip: '',
      padding: EdgeInsets.zero,
      color: Colors.white.withOpacity(1),
      offset: const Offset(10, 40),
      itemBuilder: itemBuilder,
      onSelected: (value) {
        onSelected(value);
      },
      child: IntrinsicWidth(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: kIsWeb ? 4.5 : 4.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: taskStatusColor(status).withOpacity(0.1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(
                title: status,
                size: 10,
                color: taskStatusColor(status),
              ),
              Icon(
                Icons.expand_more,
                size: 16,
                color: taskStatusColor(status),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomDropDown extends StatelessWidget {
  final String initialValue;
  final Function(dynamic) onSelected;
  final Widget child;
  final List<PopupMenuEntry<dynamic>> Function(BuildContext) itemBuilder;

  const CustomDropDown({
    Key? key,
    required this.initialValue,
    required this.onSelected,
    required this.child,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      initialValue: initialValue,
      tooltip: '',
      padding: EdgeInsets.zero,
      color: Colors.white.withOpacity(1),
      offset: const Offset(10, 40),
      itemBuilder: itemBuilder,
      onSelected: (value) {
        onSelected(value);
      },
      child: child,
    );
  }
}
