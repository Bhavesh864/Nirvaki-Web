import 'package:flutter/material.dart';

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
                    Container(
                      margin: const EdgeInsets.only(right: 5),
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: NetworkImage(imageUrlCreatedBy), fit: BoxFit.fill),
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
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
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            image: DecorationImage(image: NetworkImage(imageUrlAssignTo), fit: BoxFit.fill),
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
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
                        child: Row(children: [
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
                        ])),
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
