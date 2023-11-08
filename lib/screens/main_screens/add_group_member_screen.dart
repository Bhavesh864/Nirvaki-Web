// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yes_broker/Customs/snackbar.dart';
import 'package:yes_broker/Customs/text_utility.dart';
import 'package:yes_broker/constants/firebase/chatModels/group_model.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/constants/utils/constants.dart';
import 'package:yes_broker/customs/loader.dart';
import 'package:yes_broker/customs/responsive.dart';

import '../../riverpodstate/user_data.dart';
import 'chat_screens/chat_list_screen.dart';

// ignore: must_be_immutable
class AddGroupMembers extends ConsumerStatefulWidget {
  final String contactId;

  const AddGroupMembers({
    super.key,
    required this.contactId,
  });

  @override
  ConsumerState<AddGroupMembers> createState() => _AddGroupMembersState();
}

class _AddGroupMembersState extends ConsumerState<AddGroupMembers> {
  VoidCallback? submitFn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.black,
        // backgroundColor: Colors.white,
        iconTheme: const IconThemeData(size: 22),
        title: const AppText(
          text: 'Add Members',
          textColor: Color.fromARGB(255, 57, 57, 57),
          fontWeight: FontWeight.w600,
          fontsize: 16,
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: AddGroupMembersScreenBody(
          contactId: widget.contactId,
          onSubmitCallback: (submit) {
            submitFn = submit;
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          submitFn!();
        },
        backgroundColor: AppColor.primary,
        child: const Icon(Icons.check),
      ),
    );
  }
}

class AddGroupMembersScreenBody extends ConsumerStatefulWidget {
  final String contactId;
  final Function? goToUserProfile;
  final Function(VoidCallback)? onSubmitCallback;

  const AddGroupMembersScreenBody({
    Key? key,
    required this.contactId,
    this.goToUserProfile,
    this.onSubmitCallback,
  }) : super(key: key);

  @override
  ConsumerState<AddGroupMembersScreenBody> createState() => _AddGroupMembersScreenBodyState();
}

class _AddGroupMembersScreenBodyState extends ConsumerState<AddGroupMembersScreenBody> {
  List<String> selectedUser = [];

  @override
  void initState() {
    super.initState();

    widget.onSubmitCallback!(onSubmit);
  }

  void onSubmit() {
    if (selectedUser.isEmpty) {
      customSnackBar(context: context, text: 'Please select a user to add!');
      return;
    }
    final selectedUserIds = ref.read(selectedUserIdsProvider.notifier);
    if (selectedUser.isEmpty) {
      customSnackBar(context: context, text: 'Atleast one user has to be selected');
      return;
    }
    Group.addMembersOnGroup(groupId: widget.contactId, userids: selectedUser);
    selectedUserIds.update((state) => [...state, ...selectedUser]);
    customSnackBar(context: context, text: 'Added successfully');

    if (Responsive.isMobile(context)) {
      Navigator.of(context).pop();
    } else {
      widget.goToUserProfile!();
    }

    // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder) => const ChatListScreen()));
  }

  void toggleUser(User user) {
    if (selectedUser.contains(user.userId)) {
      selectedUser.remove(user.userId);
    } else {
      selectedUser.add(user.userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedUserIds = ref.read(selectedUserIdsProvider.notifier).state;
    final User? user = ref.read(userDataProvider);

    return Column(
      children: [
        if (!Responsive.isMobile(context)) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  widget.goToUserProfile!();
                },
                icon: const Icon(
                  Icons.arrow_back,
                  size: 22,
                ),
              ),
              const AppText(
                text: 'Add new member',
                fontsize: 15,
                textColor: Colors.black,
                fontWeight: FontWeight.w600,
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close,
                  size: 22,
                ),
              ),
            ],
          ),
        ],
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .where(
                "brokerId",
                isEqualTo: user?.brokerId,
              )
              .snapshots(includeMetadataChanges: true),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: Responsive.isMobile(context) ? null : 410,
                child: const Loader(),
              );
            }
            if (snapshot.hasData) {
              final usersListSnapshot = snapshot.data!.docs;
              List<User> usersList = usersListSnapshot.map((doc) => User.fromSnapshot(doc)).toList();
              List<User> filterUser = usersList
                  .where(
                    (element) => !selectedUserIds.contains(element.userId),
                  )
                  .toList();

              if (filterUser.isEmpty) {
                return SizedBox(
                  height: Responsive.isMobile(context) ? height! * 0.8 : 410,
                  child: const Center(
                    child: AppText(
                      text: 'Empty User List',
                      textColor: Color.fromRGBO(44, 44, 46, 1),
                      fontWeight: FontWeight.w500,
                      fontsize: 16,
                    ),
                  ),
                );
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: filterUser.length,
                  itemBuilder: (ctx, index) {
                    final user = filterUser[index];

                    return StatefulBuilder(
                      builder: (context, setstate) {
                        return Container(
                          color: selectedUser.isNotEmpty && selectedUser.contains(user.userId) ? AppColor.secondary : Colors.white,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                            onTap: () {
                              toggleUser(user);
                              setstate(
                                () {},
                              );
                            },
                            splashColor: Colors.grey[350],
                            leading: Hero(
                              tag: user.userId,
                              child: CircleAvatar(
                                radius: 22,
                                backgroundImage: NetworkImage(user.image.isEmpty ? noImg : user.image),
                              ),
                            ),
                            title: AppText(
                              text: '${user.userfirstname} ${user.userlastname}',
                              textColor: const Color.fromRGBO(44, 44, 46, 1),
                              fontWeight: FontWeight.w500,
                              fontsize: 14,
                            ),
                            trailing: selectedUser.isNotEmpty && selectedUser.contains(user.userId)
                                ? const Icon(
                                    Icons.check_circle,
                                    size: 18,
                                    color: AppColor.primary,
                                  )
                                : null,
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            }
            return const SizedBox();
          },
        ),
        if (!Responsive.isMobile(context))
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                onSubmit();
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    text: 'Add',
                    textColor: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontsize: 17,
                  ),
                  SizedBox(width: 8.0),
                  Icon(
                    Icons.person_add,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
