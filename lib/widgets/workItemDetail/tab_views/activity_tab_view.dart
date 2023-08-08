import 'package:flutter/material.dart';

import '../../timeline_view.dart';

class ActivityTabView extends StatelessWidget {
  const ActivityTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 450,
      child: CustomTimeLineView(),
    );
  }
}
