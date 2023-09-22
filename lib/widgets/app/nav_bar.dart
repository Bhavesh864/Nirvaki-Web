// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: invalid_use_of_protected_member

import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/Customs/custom_chip.dart';
import 'package:yes_broker/constants/app_constant.dart';
import 'package:yes_broker/constants/firebase/userModel/notification_model.dart';
import 'package:yes_broker/customs/loader.dart';
import '../../Customs/custom_text.dart';
import '../../constants/firebase/userModel/user_info.dart';
import '../../constants/functions/navigation/navigation_functions.dart';
import '../../constants/functions/time_formatter.dart';
import '../../constants/utils/colors.dart';
import '../../constants/utils/constants.dart';
import '../../screens/account_screens/Teams/team_screen.dart';

final notificationListProvider = StateProvider<List<NotificationModel>>((ref) => []);

class LargeScreenNavBar extends ConsumerStatefulWidget {
  final void Function(String) onOptionSelect;
  const LargeScreenNavBar(this.onOptionSelect, {super.key});

  @override
  ConsumerState<LargeScreenNavBar> createState() => _LargeScreenNavBarState();
}

class _LargeScreenNavBarState extends ConsumerState<LargeScreenNavBar> {
  late Future<User?> user;
  @override
  void initState() {
    super.initState();
    user = User.getUser(AppConst.getAccessToken(), ref: ref);
  }

  @override
  Widget build(BuildContext context) {
    final notificationCollection = FirebaseFirestore.instance.collection("notification");
    return Container(
      height: 70,
      margin: const EdgeInsets.only(bottom: 5, right: 5),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColor.secondary,
            spreadRadius: 12,
            blurRadius: 4,
            offset: Offset(5, -15),
          ),
        ],
        color: Colors.white,
      ),
      child: FutureBuilder(
        future: user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  largeScreenView("${snapshot.data?.userfirstname} ${snapshot.data?.userlastname}", context),
                  const Spacer(),
                  StreamBuilder(
                      stream: notificationCollection.where("userId", arrayContains: AppConst.getAccessToken()).where('isRead', isEqualTo: false).snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final notificationCount = snapshot.data!.docs.length;
                          return Stack(
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return const NotificationDialogBox();
                                    },
                                  );
                                },
                                child: const Icon(
                                  Icons.notifications_none,
                                  size: 25,
                                ),
                              ),
                              if (notificationCount > 0)
                                Positioned(
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 12,
                                      minHeight: 12,
                                    ),
                                    child: Text(
                                      notificationCount.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 8,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                            ],
                          );
                        }
                        return const SizedBox();
                      }),
                  const SizedBox(
                    width: 20,
                  ),
                  PopupMenuButton(
                    onCanceled: () {},
                    onSelected: (value) {
                      widget.onOptionSelect(value);
                    },
                    color: Colors.white.withOpacity(1),
                    offset: const Offset(200, 40),
                    itemBuilder: (contex) {
                      // if (snapshot.data?.role != "Broker" && profileMenuItems.any((element) => element.title != "Team")) {
                      // profileMenuItems.insert(1, ProfileMenuItems(title: "Team", screen: const TeamScreen(), id: 2));
                      // }
                      return profileMenuItems.map(
                        (e) {
                          return popupMenuItem(e.title);
                        },
                      ).toList();
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(snapshot.data!.image.trim().isEmpty ? noImg : snapshot.data!.image),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              );
            }
          }
          return const SizedBox();
        },
      ),
    );
  }
}

PopupMenuItem popupMenuItem(
  String title,
) {
  return PopupMenuItem(
    onTap: null,
    value: title,
    height: 5,
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Center(
      child: Container(
        width: 200,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppColor.secondary,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(title),
      ),
    ),
  );
}

String capitalizeFirstLetter(String input) {
  if (input.isEmpty) {
    return input;
  }
  return input[0].toUpperCase() + input.substring(1);
}

Widget largeScreenView(String name, BuildContext context) {
  return Container(
    padding: const EdgeInsets.only(left: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(
          title: capitalizeFirstLetter(name) != 'Public View' ? 'Welcome, ${capitalizeFirstLetter(name)}' : capitalizeFirstLetter(name),
          fontWeight: FontWeight.bold,
        ),
        Center(
          child: Row(
            children: [
              const InkWell(
                child: Icon(
                  Icons.home_outlined,
                  size: 18,
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.beamToNamed('/');
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: CustomText(
                    title: AppConst.getPublicView() ? 'Login' : 'Home',
                    fontWeight: FontWeight.w600,
                    color: AppColor.primary,
                    size: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class NotificationDialogBox extends ConsumerStatefulWidget {
  const NotificationDialogBox({
    super.key,
  });

  @override
  NotificationDialogBoxState createState() => NotificationDialogBoxState();
}

class NotificationDialogBoxState extends ConsumerState<NotificationDialogBox> {
  final notificationcollection = FirebaseFirestore.instance.collection("notification");
  bool isChatOpen = false;

  void markNotificationAsRead(NotificationModel notification) async {
    try {
      await notificationcollection
          .doc(notification.id!) // Assuming each notification has a unique document ID
          .update({'isRead': true});
    } catch (e) {
      print('Error updating notification status: $e');
    }
  }

  void markAllNotificationsAsRead(List<NotificationModel> notifications) async {
    try {
      for (final notification in notifications) {
        if (!notification.isRead!) {
          await notificationcollection
              .doc(notification.id!) // Assuming each notification has a unique document ID
              .update({'isRead': true});
        }
      }
    } catch (e) {
      print('Error updating notification status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        padding: const EdgeInsets.only(top: 45, right: 80),
        width: 500,
        child: Card(
          child: StreamBuilder(
              stream: notificationCollection.where("userId", arrayContains: AppConst.getAccessToken()).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loader();
                }
                if (snapshot.hasData) {
                  final dataList = snapshot.data!.docs;
                  List<NotificationModel> notificationList = dataList.map((doc) => NotificationModel.fromSnapshot(doc)).toList();
                  notificationList.sort((a, b) => b.receiveDate!.compareTo(a.receiveDate!));
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!isChatOpen) ...[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0, top: 10, right: 10, left: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const CustomText(
                                title: 'Notifications',
                                fontWeight: FontWeight.w600,
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      markAllNotificationsAsRead(notificationList);
                                    },
                                    child: const Text('Mark all as read'),
                                  ),
                                  const Icon(Icons.check_circle_outline),
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 550,
                          width: 440,
                          child: ListView.separated(
                            itemCount: notificationList.length,
                            itemBuilder: (context, index) {
                              final firestoreTimestamp = notificationList[index].receiveDate;
                              final formattedTime = TimeFormatter.formatFirestoreTimestamp(firestoreTimestamp);
                              final notificationData = notificationList[index];

                              return Container(
                                color: notificationData.isRead! ? Colors.white : AppColor.secondary,
                                child: ListTile(
                                  onTap: () {
                                    navigateBasedOnId(context, notificationData.linkedItemId!, ref);
                                    if (!notificationData.isRead!) {
                                      markNotificationAsRead(notificationData);
                                    }
                                    Navigator.of(context).pop();
                                  },
                                  titleAlignment: ListTileTitleAlignment.top,
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(notificationData.imageUrl!.isNotEmpty && notificationData.imageUrl != null ? notificationData.imageUrl! : noImg),
                                  ),
                                  title: SizedBox(
                                    height: 80,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          notificationData.notificationContent!,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const Spacer(),
                                        CustomText(
                                          title: formattedTime,
                                          color: const Color(0xFF9B9B9B),
                                          size: 14,
                                        ),
                                      ],
                                    ),
                                  ),
                                  trailing: Column(
                                    children: [
                                      CustomChip(
                                        paddingHorizontal: 0,
                                        label: CustomText(
                                          title: notificationData.linkedItemId!,
                                          size: 10,
                                        ),
                                      ),
                                      const Spacer(),
                                      if (!notificationData.isRead!)
                                        Container(
                                          width: 10,
                                          height: 10,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColor.primary,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const Divider();
                            },
                          ),
                        ),
                      ] else ...[
                        Column(
                          children: [
                            ListTile(
                              leading: SizedBox(
                                width: 70,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      child: const Icon(
                                        Icons.arrow_back,
                                        size: 20,
                                        color: Colors.black,
                                      ),
                                      onTap: () {
                                        isChatOpen = false;
                                        setState(() {});
                                      },
                                    ),
                                    const CircleAvatar(),
                                  ],
                                ),
                              ),
                              title: const CustomText(title: 'Team Unicorns'),
                              subtitle: const CustomText(
                                title: 'Abhi, John and 4 more',
                                color: Color(0xFF9B9B9B),
                              ),
                              trailing: InkWell(
                                child: const Icon(
                                  Icons.close,
                                  size: 20,
                                  color: Colors.black,
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        Container(
                          height: 400,
                        ),
                        const Divider(
                          height: 2,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            children: [
                              const Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Type your message...',
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.send),
                                onPressed: () {
                                  // Implement the send message functionality here
                                },
                              ),
                            ],
                          ),
                        ),
                      ]
                    ],
                  );
                }
                return const SizedBox();
              }),
        ),
      ),
    );
  }
}
