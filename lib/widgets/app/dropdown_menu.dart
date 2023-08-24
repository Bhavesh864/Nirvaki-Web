import 'package:flutter/material.dart';

import '../../Customs/custom_chip.dart';
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
      initialValue: status,
      splashRadius: 0,
      padding: EdgeInsets.zero,
      color: Colors.white.withOpacity(1),
      offset: const Offset(10, 40),
      itemBuilder: itemBuilder,
      onSelected: (value) {
        onSelected(value);
      },
      child: IntrinsicWidth(
        child: CustomChip(
          label: Row(
            children: [
              CustomText(
                title: status,
                color: taskStatusColor(status),
                size: 10,
              ),
              Icon(
                Icons.expand_more,
                size: 18,
                color: taskStatusColor(status),
              ),
            ],
          ),
          color: taskStatusColor(status).withOpacity(0.1),
        ),
      ),
    );
  }
}
