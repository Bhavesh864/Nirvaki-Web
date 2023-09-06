import 'package:flutter/material.dart';
import 'package:yes_broker/Customs/snackbar.dart';
import 'package:yes_broker/Customs/text_utility.dart';
import 'package:yes_broker/constants/app_constant.dart';
import 'package:yes_broker/constants/firebase/userModel/user_info.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/constants/utils/constants.dart';

// ignore: must_be_immutable
class GroupUserList extends StatelessWidget {
  List<User> userInfo;
  final String? adminId;
  GroupUserList({super.key, required this.userInfo, this.adminId});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const PageScrollPhysics(),
        shrinkWrap: true,
        itemCount: userInfo.length,
        itemBuilder: (ctx, index) {
          final user = userInfo[index];
          return Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
            margin: const EdgeInsets.all(5),
            child: ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              leading: Hero(
                tag: user.userId,
                child: CircleAvatar(radius: 26, backgroundImage: NetworkImage(user.image.isEmpty ? noImg : user.image)),
              ),
              title: AppText(
                text: user.userId == adminId ? '${user.userfirstname} ${user.userlastname} (Admin)' : '${user.userfirstname} ${user.userlastname}',
                textColor: const Color.fromRGBO(44, 44, 46, 1),
                fontWeight: FontWeight.w500,
                fontsize: 16,
              ),
              trailing: AppConst.getAccessToken() == adminId && user.userId != adminId
                  ? InkWell(
                      onTap: () {
                        customSnackBar(context: context, text: '${user.userfirstname} ${user.userlastname} has been removed');
                      },
                      splashColor: Colors.grey[350],
                      child: const Padding(
                        padding: EdgeInsets.all(5),
                        child: AppText(
                          text: 'Remove',
                          textColor: AppColor.primary,
                          fontWeight: FontWeight.w500,
                          fontsize: 15,
                        ),
                      ),
                    )
                  : null,
            ),
          );
        });
  }
}
