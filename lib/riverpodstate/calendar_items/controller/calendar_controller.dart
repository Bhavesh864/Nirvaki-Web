import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/constants/firebase/calenderModel/calender_model.dart';
import 'package:yes_broker/constants/firebase/detailsModels/card_details.dart';
import 'package:yes_broker/riverpodstate/calendar_items/repositories/calendar_repository.dart';

import '../../../constants/firebase/userModel/user_info.dart';
import '../../user_data.dart';

final calendarControllerProvider = Provider(
  (ref) {
    final calendarRepository = ref.watch(calendarRepositoryProvider);
    return CalendarController(
      calendarRepository: calendarRepository,
      ref: ref,
    );
  },
);

class CalendarController {
  final CalendarRepository calendarRepository;
  final ProviderRef ref;

  CalendarController({
    required this.calendarRepository,
    required this.ref,
  });

  Stream<List<CalendarModel>?> calendarEvents() {
    final User? user = ref.read(userDataProvider);
    return calendarRepository.getCalendarEventsStream(user);
  }

  Stream<List<CardDetails>?> cardDetails(WidgetRef ref) {
    return calendarRepository.getCardDetailsStream(ref);
  }
}
