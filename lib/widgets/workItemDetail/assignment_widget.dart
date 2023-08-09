import 'package:flutter/material.dart';
import 'package:yes_broker/Customs/small_custom_profile_image.dart';

import '../../constants/app_constant.dart';
import '../../constants/utils/colors.dart';

class AssignmentWidget extends StatelessWidget {
  final String createdBy;
  final String assignTo;
  final String imageUrlAssignTo;
  final String imageUrlCreatedBy;

  const AssignmentWidget({
    super.key,
    required this.createdBy,
    required this.assignTo,
    required this.imageUrlAssignTo,
    required this.imageUrlCreatedBy,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!AppConst.getPublicView())
          Padding(
            padding: const EdgeInsets.only(top: 17),
            child: Row(
              children: [
                const Icon(Icons.add),
                const Padding(
                    padding: EdgeInsets.only(left: 4, top: 1, bottom: 1),
                    child: Text("Added by ",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ))),
                Padding(
                  padding: const EdgeInsets.only(left: 6, top: 2),
                  child: Row(
                    children: [
                      SmallCustomCircularImage(imageUrl: imageUrlCreatedBy),
                      Text(
                        createdBy,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: AppColor.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(top: 18, bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.person_add_alt_outlined),
              const Padding(
                padding: EdgeInsets.only(left: 6),
                child: Text(
                  "Assigned to",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SmallCustomCircularImage(imageUrl: imageUrlAssignTo),
                        Padding(
                          padding: const EdgeInsets.only(left: 4, top: 4),
                          child: Text(
                            assignTo,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              color: AppColor.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Row(children: [
                          Padding(
                              padding: EdgeInsets.only(left: 4, top: 2),
                              child: Text("Rajpal Yadav",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: AppColor.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  )))
                        ])),
                    const Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Row(
                        children: [
                          Padding(
                              padding: EdgeInsets.only(left: 6, top: 2),
                              child: Text("Gaurav Singh ",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: AppColor.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  )))
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 14),
                      child: Row(
                        children: [
                          Icon(Icons.add),
                          Padding(
                            padding: EdgeInsets.only(left: 6),
                            child: Text("Add More",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: AppColor.primary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                )),
                          ),
                        ],
                      ),
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
