import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:yes_broker/constants/firebase/detailsModels/activity_details.dart';
import 'package:yes_broker/constants/firebase/random_uid.dart';
import '../../app_constant.dart';
import '../userModel/user_info.dart';

Future<String> submitActivity({required itemid, required activitytitle}) async {
  ActivityDetails activity = ActivityDetails(
    activityId: generateUid(),
    activityStatus: "New",
    brokerid: currentUser["brokerId"],
    managerid: currentUser["managerid"],
    createdby: Createdby(
      userfirstname: currentUser["userfirstname"],
      userid: currentUser["userId"],
      userimage: currentUser["image"],
      userlastname: currentUser["userlastname"],
    ),
    createdate: Timestamp.now(),
    itemid: itemid,
    activitybody: Activitybody(
      activitytitle: activitytitle,
    ),
    itemtype: itemid,
    userid: AppConst.getAccessToken(),
  );
  ActivityDetails.addactivity(activity);
  return "success";
}
