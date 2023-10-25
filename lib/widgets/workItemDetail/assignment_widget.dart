// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/Customs/small_custom_profile_image.dart';
import 'package:yes_broker/widgets/app/nav_bar.dart';
import '../../Customs/responsive.dart';
import '../../constants/app_constant.dart';
import '../../constants/firebase/userModel/user_info.dart';
import '../../constants/functions/assingment_methods.dart';
import '../../constants/functions/datetime/date_time.dart';
import '../../constants/utils/colors.dart';
import '../../constants/utils/constants.dart';
import '../../riverpodstate/user_data.dart';

class AssignmentWidget extends ConsumerStatefulWidget {
  final List assignto;
  final String createdBy;
  final String imageUrlCreatedBy;
  final String id;
  final dynamic data;

  const AssignmentWidget({
    super.key,
    required this.assignto,
    required this.createdBy,
    required this.imageUrlCreatedBy,
    required this.id,
    this.data,
  });

  @override
  AssignmentWidgetState createState() => AssignmentWidgetState();
}

class AssignmentWidgetState extends ConsumerState<AssignmentWidget> {
  bool loadedData = false;
  void assign(List<User> assignedUser) {
    setState(() {
      user = assignedUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User? userData = ref.watch(userDataProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (!AppConst.getPublicView())
          Padding(
            padding: const EdgeInsets.only(top: 17),
            child: Row(
              children: [
                const Icon(Icons.add),
                const Padding(
                  padding: EdgeInsets.only(left: 4, top: 1, bottom: 1),
                  child: Text(
                    "Added by",
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
                  padding: const EdgeInsets.only(left: 29, top: 2),
                  child: Row(
                    children: [
                      SmallCustomCircularImage(imageUrl: widget.imageUrlCreatedBy),
                      Text(
                        capitalizeFirstLetter(widget.createdBy),
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
        if (!Responsive.isMobile(context))
          Padding(
            padding: const EdgeInsets.only(top: 17),
            child: Row(
              children: [
                const Row(
                  children: [
                    Icon(Icons.add),
                    Padding(
                      padding: EdgeInsets.only(left: 4, top: 1, bottom: 1),
                      child: Text(
                        "Added on",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 29, top: 2),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_month_outlined),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        checkNotNUllItem(widget.data.createdate) ? formatMessageDate(widget.data.createdate.toDate()) : "",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.person_add_alt_outlined),
                  Padding(
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
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: widget.assignto.isNotEmpty
                          ? widget.assignto.map((item) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 7),
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: AppColor.secondary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SmallCustomCircularImage(imageUrl: item.image!.isNotEmpty ? item.image! : noImg),
                                    Container(
                                      constraints: BoxConstraints(
                                        maxWidth: Responsive.isDesktop(context) ? 150 : 110,
                                      ),
                                      child: Text(
                                        "${capitalizeFirstLetter(item.firstname!)} ${capitalizeFirstLetter(item.lastname)}",
                                        // "${item.firstname!} /${item.lastname}",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        softWrap: true,
                                        // textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          color: AppColor.primary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 3),
                                    if (widget.assignto.length > 1)
                                      userData?.role != "Employee"
                                          ? GestureDetector(
                                              onTap: () {
                                                deleteassignUser(item.userid, widget.id);
                                                if (Responsive.isMobile(context)) {
                                                  Navigator.of(context).pop();
                                                }
                                              },
                                              child: const Icon(Icons.close),
                                            )
                                          : const SizedBox.shrink(),
                                  ],
                                ),
                              );
                            }).toList()
                          : [const SizedBox()],
                    ),
                    userData?.role != "Employee"
                        ? InkWell(
                            overlayColor: const MaterialStatePropertyAll(Colors.transparent),
                            hoverColor: Colors.transparent,
                            onTap: () {
                              assginUserToTodo(context, assign, widget.assignto, widget.id, () {
                                Navigator.of(context).pop();
                              }, userData!);
                              user = [];
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
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
                          )
                        : const SizedBox(),
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
