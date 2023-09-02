import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/constants/utils/image_constants.dart';

// ignore: must_be_immutable
class MessageBox extends StatelessWidget {
  const MessageBox({super.key, required this.isSender, required this.message, required this.document});
  final String message;
  final bool isSender;
  final Map<String, dynamic> document;

  // String formatTimestamp(DateTime timestamp) {
  //   final formattedTime = DateFormat.jm().format(timestamp); // Format to 'hh:mm a'
  //   return formattedTime;
  // }

  String formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes < 5) {
          return 'Just now';
        }
        return '${difference.inMinutes} minutes ago';
      } else {
        return '${difference.inHours} hours ago';
      }
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return DateFormat.yMMMd().format(timestamp);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        if (isSender == true)
          Positioned(
            top: 8,
            right: 0,
            child: Image.asset('assets/images/messageTip.png'),
          ),
        Container(
          padding: const EdgeInsets.all(8.0),
          alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isSender) ...[
                const CircleAvatar(
                  radius: 15,
                  backgroundImage: AssetImage(profileImage),
                ),
                const SizedBox(width: 2),
                // Image.asset('assets/images/receiveMsgTip.png'),
              ],
              Container(
                constraints: BoxConstraints(
                  maxWidth: width * 3 / 4,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isSender ? AppColor.primary : AppColor.secondary,
                  borderRadius: BorderRadius.only(
                    topLeft: isSender ? const Radius.circular(8) : const Radius.circular(0),
                    topRight: isSender ? const Radius.circular(0) : const Radius.circular(8),
                    bottomLeft: const Radius.circular(8),
                    bottomRight: const Radius.circular(8),
                  ),
                ),
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isSender)
                      Text(
                        document['senderEmail'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    Container(
                      margin: !isSender ? const EdgeInsets.only(left: 5) : null,
                      child: Text(
                        message,
                        style: TextStyle(
                          color: isSender ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      // mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          formatTimestamp(document['timestamp'].toDate()), // Replace DateTime.now() with your actual timestamp
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: isSender ? Colors.white : AppColor.inActiveColor,
                            fontSize: 12,
                          ),
                        ),
                        if (isSender)
                          const Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Icon(
                              Icons.done_all,
                              color: Colors.white,
                            ),
                          )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
