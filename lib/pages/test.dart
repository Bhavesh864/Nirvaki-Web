// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:yes_broker/Customs/custom_text.dart';
// import 'package:yes_broker/constants/firebase/inventory_questions.dart';
// import 'package:yes_broker/providers/inventory_questions_index_controller.dart';
// import 'package:yes_broker/widgets/card/questions%20card/dropdown_card.dart';
// import 'package:yes_broker/widgets/card/questions%20card/textform_card.dart';

// import '../constants/utils/image_constants.dart';

// final currentIndexProvider =
//     StateNotifierProvider<InventoryQuestionsIndex, int>(
//         (ref) => InventoryQuestionsIndex());

// class AddInventory extends ConsumerStatefulWidget {
//   @override
//   _AddInventoryState createState() => _AddInventoryState();
// }

// class _AddInventoryState extends ConsumerState<AddInventory> {
//   PageController? pageController = PageController(initialPage: 0);
//   // int currentIndex = 0;
//   // @override
//   // void initState() {
//   //   // TODO: implement initState
//   //   super.initState();
//   //   pageController = PageController(initialPage: currentIndex);
//   // }

//   // var selectedOption = '';
//   // List<String> allAnswers = [];

//   // _next(String selectedAnswer, List<InventoryQuestions> data) {
//   //   if (currentIndex < data.length - 1) {
//   //     currentIndex++;
//   //     allAnswers.add(selectedAnswer);
//   //     pageController?.animateToPage(
//   //       currentIndex,
//   //       duration: const Duration(milliseconds: 300),
//   //       curve: Curves.easeIn,
//   //     );
//   //   }
//   // }

//   // _back() {
//   //   if (currentIndex != 0) {
//   //     currentIndex--;
//   //     pageController?.animateToPage(
//   //       currentIndex,
//   //       duration: const Duration(milliseconds: 300),
//   //       curve: Curves.easeIn,
//   //     );
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     final currentIndex = ref.watch(currentIndexProvider);
//     return Scaffold(
//       body: Stack(
//         children: [
//           SafeArea(
//             child: Container(
//               // height: h,
//               decoration: const BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage(authBgImage),
//                   fit: BoxFit.cover,
//                   colorFilter: ColorFilter.mode(
//                     Colors.black38,
//                     BlendMode.darken,
//                   ),
//                 ),
//               ),
//               child: FutureBuilder(
//                 future: InventoryQuestions.getQuestions(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   }
//                   if (snapshot.hasData) {
//                     final questionsArr = snapshot.data!;
//                     return PageView.builder(
//                       physics: const NeverScrollableScrollPhysics(),
//                       controller: pageController,
//                       scrollDirection: Axis.horizontal,
//                       itemCount: questionsArr.length,
//                       itemBuilder: (context, index) {
//                         return displayDifferentCards(questionsArr, index,
//                             questionsArr[index].type, questionsArr[index].id);
//                       },
//                     );
//                   }
//                   return Container(
//                     color: Colors.amber,
//                   );
//                 },
//               ),
//               // child: DropDownCard(),
//             ),
//           ),
//           Positioned(
//             top: 0.0,
//             left: 0.0,
//             right: 0.0,
//             child: AppBar(
//               elevation: 0,
//               iconTheme: const IconThemeData(color: Colors.white),
//               backgroundColor: Colors.transparent,
//               centerTitle: true,
//               leading: IconButton(
//                 onPressed: () {
//                   // _back();
//                   ref.read(currentIndexProvider.notifier).decreament();
//                 },
//                 icon: const Icon(Icons.arrow_back),
//               ),
//               title: CustomText(
//                 title: 'Add Inventory $currentIndex',
//                 fontWeight: FontWeight.w700,
//                 size: 20,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget displayDifferentCards(
//       List<InventoryQuestions> questionsArr, int index, String type, int id) {
//     switch (id) {
//       case 5:
//         return TextFormCard(
//           fieldsPlaceholder: questionsArr[index].options,
//           onSelect: () {
//             // currentIndex++;
//             // pageController?.animateToPage(
//             //   currentIndex,
//             //   duration: const Duration(milliseconds: 300),
//             //   curve: Curves.easeIn,
//             // );
//           },
//         );
//       case 9:
//         return DropDownCard(
//           values: questionsArr[index].dropdownList,
//         );
//       default:
//         return Text('data');
//       // return ChipButtonCard(
//       //   question: questionsArr[index].question,
//       //   options: questionsArr[index].options,
//       //   data: questionsArr,
//       //   // currentIndex: currentIndex,
//       //   // onSelect: _next,
//       // );
//     }
//   }
// }
