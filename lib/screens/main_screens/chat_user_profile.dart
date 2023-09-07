// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yes_broker/Customs/text_utility.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/screens/main_screens/add_group_member_screen.dart';
import 'package:yes_broker/widgets/chat/group/group_user_list.dart';

import '../../constants/firebase/userModel/user_info.dart';

class ChatUserProfile extends StatefulWidget {
  final String profilePic;
  final String contactId;
  final String name;
  final String? adminId;
  final bool isGroupChat;
  final User? user;
  final List<String>? members;

  const ChatUserProfile({
    Key? key,
    required this.profilePic,
    required this.name,
    required this.user,
    required this.contactId,
    required this.isGroupChat,
    this.members,
    this.adminId,
  }) : super(key: key);

  @override
  State<ChatUserProfile> createState() => _ChatUserProfileState();
}

class _ChatUserProfileState extends State<ChatUserProfile> {
  List<User>? userInfo = [];
  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  void getUserDetails() async {
    final user = await User.getListOfUsersByIds(widget.members!);
    userInfo!.addAll(user);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: AppColor.secondary,
        iconTheme: const IconThemeData(size: 22),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColor.secondary,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 330,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AppText(
                          text: widget.name,
                          fontsize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                        CircleAvatar(
                          radius: 68,
                          backgroundImage: NetworkImage(widget.profilePic.isEmpty ? noImg : widget.profilePic),
                        ),
                        SizedBox(
                          height: 100,
                          width: 180,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(32, 14, 50, 0.05),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    width: 40,
                                    height: 40,
                                    child: const Center(
                                      child: Icon(
                                        Icons.call_outlined,
                                        size: 26,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  AppText(
                                    text: widget.user != null ? widget.user!.mobile : '91293843854',
                                    fontsize: 14,
                                    fontWeight: FontWeight.w500,
                                    textColor: const Color(0xFFA8A8A8),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(32, 14, 50, 0.05),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Center(
                                        child: FaIcon(
                                          FontAwesomeIcons.whatsapp,
                                          size: 26,
                                        ),
                                      )),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  const AppText(
                                    text: 'Not Acitve',
                                    fontsize: 14,
                                    fontWeight: FontWeight.w500,
                                    textColor: Color(0xFFA8A8A8),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 30, bottom: 20),
                  child: AppText(
                    text: 'Upcoming Acitivity',
                    textColor: Color(0xFF181818),
                    fontWeight: FontWeight.w700,
                    fontsize: 18,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    height: 90,
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColor.secondary,
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 3,
                                backgroundColor: AppColor.primary,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              AppText(
                                text: 'Follow Up',
                                fontsize: 12,
                                fontWeight: FontWeight.w400,
                                textColor: AppColor.primary,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          AppText(
                            text: 'Google meet 10:30-11:00 am',
                            fontsize: 10,
                            fontWeight: FontWeight.w300,
                            textColor: Color.fromARGB(255, 63, 63, 63),
                          )
                        ]),
                      ),
                    ),
                  ),
                ),
                if (widget.isGroupChat) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const AppText(
                          text: 'Members',
                          textColor: Color(0xFF181818),
                          fontWeight: FontWeight.w700,
                          fontsize: 18,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => AddGroupMembers(userInfo: widget.members!, contactId: widget.contactId)));
                            },
                            child: const Row(
                              children: [
                                Icon(Icons.add_circle_outlined, size: 20, color: AppColor.primary),
                                SizedBox(
                                  width: 5,
                                ),
                                AppText(
                                  text: 'Add Members',
                                  textColor: Color.fromARGB(255, 57, 57, 57),
                                  fontWeight: FontWeight.w700,
                                  fontsize: 14,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: GroupUserList(
                      userInfo: userInfo!,
                      adminId: widget.adminId,
                      contactId: widget.contactId,
                      memberuids: widget.members!,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
