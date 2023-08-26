import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yes_broker/Customs/text_utility.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/constants/utils/image_constants.dart';

class ChatUserProfile extends StatelessWidget {
  const ChatUserProfile({super.key});

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
                        const AppText(
                          text: 'Mr. Jane Cooper',
                          fontsize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                        const CircleAvatar(
                          radius: 68,
                          backgroundImage: AssetImage(authBgImage),
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
                                      color: const Color.fromRGBO(
                                          32, 14, 50, 0.05),
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
                                  const AppText(
                                    text: '+919876543210',
                                    fontsize: 14,
                                    fontWeight: FontWeight.w500,
                                    textColor: Color(0xFFA8A8A8),
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
                                        color: const Color.fromRGBO(
                                            32, 14, 50, 0.05),
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
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
