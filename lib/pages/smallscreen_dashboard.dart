import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/routes/routes.dart';
import 'package:yes_broker/widgets/app/app_bar.dart';
import 'package:yes_broker/widgets/app/speed_dial_button.dart';

import '../constants/firebase/userModel/broker_info.dart';

final currentIndexProvider = StateProvider<int>((ref) {
  return 0;
});

class SmallScreen extends ConsumerWidget {
  const SmallScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentIndexProvider);
    return Scaffold(
      appBar: mobileAppBar(context, (selectedVal) {
        if (selectedVal == 'Profile') {
          ref.read(currentIndexProvider.notifier).update((state) => 3);
        } else if (selectedVal == "Logout") {
          authentication.signOut().then(
                (value) => Navigator.of(context).pushReplacementNamed(AppRoutes.loginScreen),
              );
        }
      }),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColor.primary,
        onTap: (value) => ref.read(currentIndexProvider.notifier).update((state) => value),
        currentIndex: currentIndex,
        items: List.generate(
          bottomBarItems.length,
          (index) => BottomNavigationBarItem(
            icon: Icon(
              bottomBarItems[index].iconData,
              color: index == currentIndex ? AppColor.primary : Colors.black,
            ),
            label: bottomBarItems[index].label,
          ),
        ),
      ),
      body: bottomBarItems[currentIndex].screen,
      floatingActionButton: const CustomSpeedDialButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
