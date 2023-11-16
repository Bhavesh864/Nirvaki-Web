import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/pages/Auth/signup/company_details.dart';
import 'package:yes_broker/pages/Auth/signup/personal_details.dart';
import 'package:yes_broker/pages/Auth/signup/signup_screen.dart';
import 'package:yes_broker/riverpodstate/signup/change_screen_index.dart';

import '../../../constants/utils/image_constants.dart';

final changeScreenIndex = StateNotifierProvider<ChangeScreenIndex, int>((ref) {
  return ChangeScreenIndex();
});

class SignUpCommonScreen extends ConsumerStatefulWidget {
  const SignUpCommonScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  SignUpCommonScreenState createState() => SignUpCommonScreenState();
}

class SignUpCommonScreenState extends ConsumerState<SignUpCommonScreen> {
  PageController? pageController;
  int currentScreenIndex = 0;
  @override
  void initState() {
    pageController = PageController(initialPage: currentScreenIndex);
    super.initState();
  }

  final List<Widget> screens = [
    const SignUpScreen(),
    const PersonalDetailsAuthScreen(),
    const CompanyDetailsAuthScreen(),
  ];

  void nextScreen() {
    if (currentScreenIndex < screens.length - 1) {
      setState(() {
        currentScreenIndex++;
        pageController!.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(changeScreenIndex);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(authBgImage),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black26,
                    BlendMode.darken,
                  ),
                ),
              ),
              child: PageView.builder(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: screens.length,
                itemBuilder: (context, index) {
                  return screens[currentIndex];
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
