// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../constants/firebase/detailsModels/card_details.dart';

// final cardStatusesProvider = StateProvider<List<String?>>((ref) => []);

// class CardStatusNotifier extends StateNotifier<List<String?>> {
//   CardStatusNotifier(List<String?> initialStatuses) : super(initialStatuses);

//   void updateCardStatus(int index, String newStatus) {
//     state[index] = newStatus;
//     state = [...state]; // Trigger a rebuild
//   }
// }

// final cardStatusesProvider = FutureProvider<List<CardDetails?>>(
//   (ref) async {
//     final initialCardDetails = await CardDetails.getCardDetails();
//     // final initialStatuses = initialCardDetails.map((card) => card.status).toList();

//     return initialCardDetails;
//   },
// );

// class CardStatusNotifier extends StateNotifier<List<CardDetails?>> {
//   CardStatusNotifier(List<CardDetails?> initialStatus) : super(initialStatus);

//   void updateCardStatus(int index, String newStatus) {
//     state[index]!.status = newStatus;
//     state = [...state]; // Trigger a rebuild
//   }
// }


// final cardStatusProvider = StateNotifierProvider<CardStatusNotifier, String?>((ref) {
//   return CardStatusNotifier(null); // Replace "initialStatus" with the actual initial status
// });

// class CardStatusNotifier extends StateNotifier<String?> {
//   CardStatusNotifier(String? initialStatus) : super(initialStatus);

//   void updateStatus(String newStatus) {
//     state = newStatus;
//   }
// }
