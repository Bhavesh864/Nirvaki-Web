// import 'package:flutter/material.dart';

// class ChartBars extends StatelessWidget {
//   const ChartBars({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: ColorConstant.whiteA700,
//         appBar: CustomAppBar(
//             height: getVerticalSize(56),
//             leadingWidth: 48,
//             leading: CustomIconButton(
//                 height: 32,
//                 width: 32,
//                 margin: getMargin(left: 16, top: 12, bottom: 12),
//                 onTap: () {
//                   onTapBtnArrowleft(context);
//                 },
//                 child: CustomImageView(svgPath: ImageConstant.imgArrowleft)),
//             title: Padding(
//                 padding: getPadding(left: 12),
//                 child: Text("Filter your search",
//                     overflow: TextOverflow.ellipsis,
//                     textAlign: TextAlign.left,
//                     style: AppStyle.txtDMSansBold18))),
//         body: Container(
//             width: double.maxFinite,
//             padding: getPadding(left: 16, top: 13, right: 16, bottom: 13),
//             child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Text("Room Configuration",
//                       overflow: TextOverflow.ellipsis,
//                       textAlign: TextAlign.left,
//                       style: AppStyle.txtDMSansBold18),
//                   Padding(
//                       padding: EdgeInsets.only(top: 11),
//                       child: Wrap(
//                           runSpacing: getVerticalSize(5),
//                           spacing: getHorizontalSize(5),
//                           children: List<Widget>.generate(
//                               8, (index) => ChipviewtagsItemWidget()))),
//                   Padding(
//                       padding: getPadding(top: 25),
//                       child: Text("Rent Range",
//                           overflow: TextOverflow.ellipsis,
//                           textAlign: TextAlign.left,
//                           style: AppStyle.txtDMSansBold18)),
//                   Padding(
//                       padding: getPadding(top: 10),
//                       child: Text("₹10,000 - ₹50,000 per month",
//                           overflow: TextOverflow.ellipsis,
//                           textAlign: TextAlign.left,
//                           style: AppStyle.txtDMSansMedium14)),
//                   CustomImageView(
//                       svgPath: ImageConstant.imgGroup13,
//                       height: getVerticalSize(65),
//                       width: getHorizontalSize(396),
//                       margin: getMargin(top: 10)),
//                   Padding(
//                       padding: getPadding(top: 23),
//                       child: Text("Amenities",
//                           overflow: TextOverflow.ellipsis,
//                           textAlign: TextAlign.left,
//                           style: AppStyle.txtDMSansBold18)),
//                   Padding(
//                       padding: getPadding(top: 11),
//                       child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("Swimming Pool",
//                                 overflow: TextOverflow.ellipsis,
//                                 textAlign: TextAlign.left,
//                                 style: AppStyle.txtDMSansRegular16),
//                             CustomImageView(
//                                 svgPath: ImageConstant.imgCheckmark,
//                                 height: getSize(20),
//                                 width: getSize(20),
//                                 margin: getMargin(bottom: 1))
//                           ])),
//                   Padding(
//                       padding: getPadding(top: 14),
//                       child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("Gym",
//                                 overflow: TextOverflow.ellipsis,
//                                 textAlign: TextAlign.left,
//                                 style: AppStyle.txtDMSansRegular16),
//                             CustomImageView(
//                                 svgPath: ImageConstant.imgBookmark,
//                                 height: getSize(20),
//                                 width: getSize(20),
//                                 margin: getMargin(bottom: 1))
//                           ])),
//                   Padding(
//                       padding: getPadding(top: 14),
//                       child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("Gated Community",
//                                 overflow: TextOverflow.ellipsis,
//                                 textAlign: TextAlign.left,
//                                 style: AppStyle.txtDMSansRegular16),
//                             CustomImageView(
//                                 svgPath: ImageConstant.imgBookmark,
//                                 height: getSize(20),
//                                 width: getSize(20),
//                                 margin: getMargin(bottom: 1))
//                           ])),
//                   Padding(
//                       padding: getPadding(top: 14),
//                       child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("Parking",
//                                 overflow: TextOverflow.ellipsis,
//                                 textAlign: TextAlign.left,
//                                 style: AppStyle.txtDMSansRegular16),
//                             CustomImageView(
//                                 svgPath: ImageConstant.imgCheckmark,
//                                 height: getSize(20),
//                                 width: getSize(20),
//                                 margin: getMargin(bottom: 1))
//                           ])),
//                   Padding(
//                       padding: getPadding(top: 14),
//                       child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("Washing Machine",
//                                 overflow: TextOverflow.ellipsis,
//                                 textAlign: TextAlign.left,
//                                 style: AppStyle.txtDMSansRegular16),
//                             CustomImageView(
//                                 svgPath: ImageConstant.imgBookmark,
//                                 height: getSize(20),
//                                 width: getSize(20),
//                                 margin: getMargin(bottom: 1))
//                           ])),
//                   Padding(
//                       padding: getPadding(top: 14),
//                       child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("Dryer",
//                                 overflow: TextOverflow.ellipsis,
//                                 textAlign: TextAlign.left,
//                                 style: AppStyle.txtDMSansRegular16),
//                             CustomImageView(
//                                 svgPath: ImageConstant.imgCheckmark,
//                                 height: getSize(20),
//                                 width: getSize(20),
//                                 margin: getMargin(bottom: 1))
//                           ])),
//                   Padding(
//                       padding: getPadding(top: 14),
//                       child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("Pet Friendly",
//                                 overflow: TextOverflow.ellipsis,
//                                 textAlign: TextAlign.left,
//                                 style: AppStyle.txtDMSansRegular16),
//                             CustomImageView(
//                                 svgPath: ImageConstant.imgBookmark,
//                                 height: getSize(20),
//                                 width: getSize(20),
//                                 margin: getMargin(bottom: 1))
//                           ])),
//                   Padding(
//                       padding: getPadding(top: 14),
//                       child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("Power Backup",
//                                 overflow: TextOverflow.ellipsis,
//                                 textAlign: TextAlign.left,
//                                 style: AppStyle.txtDMSansRegular16),
//                             CustomImageView(
//                                 svgPath: ImageConstant.imgBookmark,
//                                 height: getSize(20),
//                                 width: getSize(20),
//                                 margin: getMargin(bottom: 1))
//                           ])),
//                   Padding(
//                       padding: getPadding(top: 13),
//                       child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("Smoke Alarm",
//                                 overflow: TextOverflow.ellipsis,
//                                 textAlign: TextAlign.left,
//                                 style: AppStyle.txtDMSansRegular16),
//                             CustomImageView(
//                                 svgPath: ImageConstant.imgBookmark,
//                                 height: getSize(20),
//                                 width: getSize(20),
//                                 margin: getMargin(top: 1))
//                           ])),
//                   Padding(
//                       padding: getPadding(top: 14, bottom: 5),
//                       child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("Front Garden",
//                                 overflow: TextOverflow.ellipsis,
//                                 textAlign: TextAlign.left,
//                                 style: AppStyle.txtDMSansRegular16),
//                             CustomImageView(
//                                 svgPath: ImageConstant.imgBookmark,
//                                 height: getSize(20),
//                                 width: getSize(20),
//                                 margin: getMargin(top: 1))
//                           ]))
//                 ])),
//         bottomNavigationBar: Container(
//           margin: getMargin(left: 15, right: 16, bottom: 16),
//           decoration: AppDecoration.outlineBlack90019,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               CustomButton(height: getVerticalSize(44), text: "Apply Filters")
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
