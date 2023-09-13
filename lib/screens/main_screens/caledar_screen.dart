import 'package:flutter/material.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Calendar Screen'),
    );
  }
}


// String getMessageDay(DateTime messageTime, bool isNewWeek) {
//     final DateTime now = DateTime.now();
//     final DateTime yesterday = DateTime(now.year, now.month, now.day - 1);

//     if (isSameDay(messageTime, now)) {
//       return 'Today';
//     } else if (isSameDay(messageTime, yesterday)) {
//       return 'Yesterday';
//     } else if (!isNewWeek) {
//       // Show the day name if it's a new week
//       return DateFormat('EEEE').format(messageTime); // Requires intl package
//     } else {
//       // Show the date if it's not a new week
//       return DateFormat('dd MMMM yyyy').format(messageTime); // Requires intl package
//     }
//   }

//    Expanded(
//                         child: ScrollConfiguration(
//                           behavior: const ScrollBehavior().copyWith(overscroll: false),
//                           child: ListView.builder(
//                             physics: const ClampingScrollPhysics(),
//                             controller: messageController,
//                             itemCount: snapshot.data!.length,
//                             itemBuilder: (BuildContext context, int index) {
//                               if (index == 0 && isGroupChat && chatItem != null) {
//                                 return Padding(
//                                   padding: const EdgeInsets.only(top: 10, bottom: 10),
//                                   child: Chip(
//                                     shape: const StadiumBorder(),
//                                     backgroundColor: Colors.grey.shade200,
//                                     label: Padding(
//                                       padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
//                                       child: Text(
//                                         chatItem.groupCreatedBy!,
//                                         style: const TextStyle(
//                                           color: Colors.black45,
//                                           fontSize: 12,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               } else {
//                                 final messageIndex = isGroupChat ? index - 1 : index;
//                                 final messageData = snapshot.data![messageIndex];
//                                 final isSender = messageData.senderId == AppConst.getAccessToken();

//                                 if (!isSender && !messageData.isSeen && !isGroupChat) {
//                                   ref.read(chatControllerProvider).setChatMessageSeen(
//                                         context,
//                                         chatItemId,
//                                         messageData.messageId,
//                                         isSender,
//                                       );
//                                 }

//                                 final bool isFirstMessageOfNewDay = messageIndex == 0 ||
//                                     !isSameDay(
//                                       messageData.timeSent.toDate(),
//                                       snapshot.data![messageIndex].timeSent.toDate(),
//                                     );

//                                 final bool isNewWeek =
//                                     messageIndex == 0 || messageData.timeSent.toDate().difference(snapshot.data![messageIndex].timeSent.toDate()).inDays >= 7;
//                                 final String messageDay = getMessageDay(messageData.timeSent.toDate(), isNewWeek);

//                                 return Column(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     if (isFirstMessageOfNewDay) ...[
//                                       Padding(
//                                         padding: const EdgeInsets.only(top: 10.0, bottom: 10),
//                                         child: Chip(
//                                           shape: const StadiumBorder(),
//                                           backgroundColor: Colors.grey.shade200,
//                                           label: Padding(
//                                             padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
//                                             child: Text(
//                                               messageDay,
//                                               style: const TextStyle(
//                                                 color: Colors.black45,
//                                                 fontSize: 12,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                     MessageBox(
//                                       message: messageData.text,
//                                       isSender: isSender,
//                                       data: messageData,
//                                       isSeen: messageData.isSeen,
//                                       messageType: messageData.type,
//                                     ),
//                                   ],
//                                 );
//                               }
//                             },
//                           ),
//                         ),
//                       ),