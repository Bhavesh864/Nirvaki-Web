import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/constants/firebase/calenderModel/calender_model.dart';
import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';
import 'package:yes_broker/riverpodstate/user_data.dart';

import '../../../constants/firebase/userModel/user_info.dart';
import '../../../constants/functions/filterdataAccordingRole/data_according_role.dart';

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

  Stream<List<CardDetails>?> getCardDetailsStream(WidgetRef ref) {
    final brokerid = ref.watch(userDataProvider)?.brokerId;
    return FirebaseFirestore.instance.collection('cardDetails').where("brokerid", isEqualTo: brokerid).snapshots().map((
      querySnapshot,
    ) {
      // Check if there is data in the querySnapshot
      final currentUser = ref.watch(userDataProvider);
      final List<User> userList = [];
      if (querySnapshot.docs.isNotEmpty) {
        final snap = filterCalenderItemByRole(snapshot: querySnapshot, ref: ref, userList: userList, currentUser: currentUser!);
        final filterItem = snap?.map((doc) => CardDetails.fromSnapshot(doc)).where((item) => item.cardType != "IN" && item.cardType != "LD").toList();
        // final List<CardDetails> todoItemsList =
        //   filterItem.map((doc) => CardDetails.fromSnapshot(doc)).where((item) => item.cardType != "IN" && item.cardType != "LD").toList();
        return filterItem;
      } else {
        return null;
      }
    });
  }
}
