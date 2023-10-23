import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/constants/firebase/calenderModel/calender_model.dart';
import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';

import '../../../constants/firebase/userModel/user_info.dart';

final calendarRepositoryProvider = Provider(
  (ref) => CalendarRepository(
    firestore: FirebaseFirestore.instance,
  ),
);

class CalendarRepository {
  final FirebaseFirestore firestore;

  CalendarRepository({
    required this.firestore,
  });

  Stream<List<CalendarModel>?> getCalendarEventsStream(User? user) {
    return FirebaseFirestore.instance.collection('calenderDetails').where('brokerId', isEqualTo: user?.brokerId).snapshots().map((querySnapshot) {
      // Check if there is data in the querySnapshot
      if (querySnapshot.docs.isNotEmpty) {
        // Map QueryDocumentSnapshot to CalendarModel and convert to a list
        return querySnapshot.docs.map((doc) => CalendarModel.fromSnapshot(doc)).toList();
      } else {
        return null; // Return null if there is no data
      }
    });
  }

  Stream<List<CardDetails>?> getCardDetailsStream() {
    return FirebaseFirestore.instance
        .collection('cardDetails')
        .orderBy(
          "createdate",
          descending: true,
        )
        .snapshots()
        .map((
      querySnapshot,
    ) {
      // Check if there is data in the querySnapshot
      if (querySnapshot.docs.isNotEmpty) {
        // Map QueryDocumentSnapshot to CardDetails and convert to a list

        final filterItem = querySnapshot.docs.map((doc) => CardDetails.fromSnapshot(doc)).where((item) => item.cardType != "IN" && item.cardType != "LD").toList();

        // final List<CardDetails> todoItemsList =
        //   filterItem.map((doc) => CardDetails.fromSnapshot(doc)).where((item) => item.cardType != "IN" && item.cardType != "LD").toList();

        return filterItem;
      } else {
        return null; // Return null if there is no data
      }
    });
  }
}
