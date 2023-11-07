import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:yes_broker/constants/firebase/detailsModels/activity_details.dart';
import 'package:yes_broker/constants/firebase/random_uid.dart';
import '../../app_constant.dart';
import '../userModel/user_info.dart';

Future<String> submitActivity({required itemid, required activitytitle, required User user}) async {
  ActivityDetails activity = ActivityDetails(
    activityId: generateUid(),
    activityStatus: "New",
    brokerid: user.brokerId,
    managerid: user.managerid,
    createdby: Createdby(
      userfirstname: user.userfirstname,
      userid: user.userId,
      userimage: user.image,
      userlastname: user.userlastname,
    ),
    createdate: Timestamp.now(),
    itemid: itemid,
    userImageUrl: user.image,
    activitybody: Activitybody(
      activitytitle: activitytitle,
    ),
    itemtype: itemid,
    userid: AppConst.getAccessToken(),
  );
  ActivityDetails.addactivity(activity);
  return "success";
}
