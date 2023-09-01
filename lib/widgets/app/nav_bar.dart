// ignore_for_file: invalid_use_of_protected_member

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/Customs/custom_chip.dart';
import 'package:yes_broker/constants/app_constant.dart';
import '../../constants/firebase/userModel/user_info.dart';
import '../../constants/utils/colors.dart';
import '../../Customs/custom_text.dart';
import '../../constants/utils/constants.dart';

// final userProvider = StateNotifierProvider<UserNotifier, User>((ref) {
//   return UserNotifier();
// });

// class UserNotifier extends StateNotifier<User> {
//   UserNotifier()
//       : super(
//           User(
//               whatsAppNumber: "whatsAppNumber",
//               brokerId: 'brokerId',
//               status: 'status',
//               userfirstname: 'userfirstname',
//               userlastname: 'userlastname',
//               userId: 'userId',
//               mobile: "3434",
//               email: 'email',
//               role: 'role',
//               image: 'image',
//               fcmToken: "fcmToken"),
//         );

//   void addCurrentState(User currentUser) {
//     state = currentUser;
//   }
// }

final userProvider = FutureProvider<User>(
  (ref) async {
    final User? initialCardDetails =
        await User.getUser(AppConst.getAccessToken()!);
    // final initialStatuses = initialCardDetails.map((card) => card.status).toList();

    return initialCardDetails!;
  },
);

class LargeScreenNavBar extends ConsumerWidget {
  final void Function(String) onOptionSelect;
  const LargeScreenNavBar(this.onOptionSelect, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final token = AppConst.getAccessToken();
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
        future: User.getUser(token!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              ref.read(userProvider.future).then((value) {
                print(value.managerName);
              });
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  largeScreenView(
                      "${snapshot.data?.userfirstname} ${snapshot.data?.userlastname}",
                      context),
                  const Spacer(),
                  Stack(
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
                          child: const Text(
                            '2',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  PopupMenuButton(
                    onCanceled: () {},
                    onSelected: (value) {
                      onOptionSelect(value);
                    },
                    color: Colors.white.withOpacity(1),
                    offset: const Offset(200, 40),
                    itemBuilder: (contex) => profileMenuItems.map(
                      (e) {
                        return popupMenuItem(e.title);
                      },
                    ).toList(),
                    child: Container(
                      height: 30,
                      width: 30,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(snapshot.data!.image.isEmpty
                                ? noImg
                                : snapshot.data!.image)),
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
          title: capitalizeFirstLetter(name) != 'Public View'
              ? 'Welcome, ${capitalizeFirstLetter(name)}'
              : capitalizeFirstLetter(name),
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

class NotificationDialogBox extends StatefulWidget {
  const NotificationDialogBox({super.key});

  @override
  State<NotificationDialogBox> createState() => _NotificationDialogBoxState();
}

class _NotificationDialogBoxState extends State<NotificationDialogBox> {
  bool isChatOpen = false;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        padding: const EdgeInsets.only(top: 45, right: 80),
        width: 500,
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isChatOpen) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        title: 'Notifications',
                        fontWeight: FontWeight.w600,
                      ),
                      Row(
                        children: [
                          Text('Mark all as read'),
                          Icon(Icons.check_circle_outline),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 550,
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      return const SizedBox(
                        height: 100,
                        child: ListTile(
                          titleAlignment: ListTileTitleAlignment.top,
                          leading: CircleAvatar(),
                          title: SizedBox(
                            height: 100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Ravi Sharma have assigned a new lead to you. ',
                                  maxLines:
                                      3, // Adjust the maximum number of lines as needed
                                  overflow: TextOverflow
                                      .ellipsis, // Handle text overflow
                                ),
                                Spacer(),
                                CustomText(
                                  title: 'Today at 9:42 AM',
                                  color: Color(0xFF9B9B9B),
                                  size: 14,
                                ),
                              ],
                            ),
                          ),
                          trailing: CustomChip(
                            paddingHorizontal: 0,
                            label: CustomText(
                              title: 'IN123 ',
                              size: 10,
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemCount: 5,
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
          ),
        ),
      ),
    );
  }
}
