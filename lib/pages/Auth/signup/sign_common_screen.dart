import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/pages/Auth/signup/company_details.dart';
import 'package:yes_broker/pages/Auth/signup/personal_details.dart';
import 'package:yes_broker/pages/Auth/signup/signup_screen.dart';

import '../../../constants/utils/image_constants.dart';

class SignUpCommonScreen extends ConsumerStatefulWidget {
  const SignUpCommonScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  SignUpCommonScreenState createState() => SignUpCommonScreenState();
}

class SignUpCommonScreenState extends ConsumerState<SignUpCommonScreen> {
  int currentScreenIndex = 0;
  PageController? pageController;

  @override
  void initState() {
    pageController = PageController(initialPage: 0);
    super.initState();
  }

  // Initialize the screens list in the constructor
  late final List<Widget> screens = _buildScreensList();

  // final List<Widget> screens = [
  //   SignUpScreen(
  //     pageController: pageController,
  //   ),
  //   const PersonalDetailsAuthScreen(),
  //   const CompanyDetailsAuthScreen(),
  // ];

  void nextScreen() {
    // if (currentScreenIndex < screens.length - 1) {
    setState(() {
      currentScreenIndex++;
      pageController!.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
    // } else {}
  }

  void previousScreen() {
    // if (currentScreenIndex < screens.length - 1) {
    setState(() {
      currentScreenIndex--;
      pageController!.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
    // } else {}
  }

  List<Widget> _buildScreensList() {
    return [
      SignUpScreen(
        goToNextScreen: nextScreen,
        goToPreviousScreen: previousScreen,
      ),
      PersonalDetailsAuthScreen(
        goToNextScreen: nextScreen,
        goToPreviousScreen: previousScreen,
      ),
      CompanyDetailsAuthScreen(
        goToNextScreen: nextScreen,
        goToPreviousScreen: previousScreen,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // final currentIndex = ref.watch(changeScreenIndex);
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
                  return screens[currentScreenIndex];
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
