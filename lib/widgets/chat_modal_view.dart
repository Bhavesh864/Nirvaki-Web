import 'package:flutter/material.dart';

import '../Customs/custom_text.dart';

class ChatDialogBox extends StatefulWidget {
  const ChatDialogBox({super.key});

  @override
  State<ChatDialogBox> createState() => _ChatDialogBoxState();
}

class _ChatDialogBoxState extends State<ChatDialogBox> {
  bool isChatOpen = false;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        padding: const EdgeInsets.only(bottom: 45, right: 80),
        width: 450,
        child: Card(
          color: const Color(0xFFF5F9FE),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isChatOpen ? 0 : 15, vertical: isChatOpen ? 0 : 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isChatOpen) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CustomText(
                          title: 'Chat',
                          fontWeight: FontWeight.w600,
                        ),
                        InkWell(
                          child: const Icon(
                            Icons.close,
                            size: 20,
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 350,
                    child: Card(
                      elevation: 0,
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              isChatOpen = true;
                              setState(() {});
                            },
                            leading: const CircleAvatar(),
                            title: const CustomText(title: 'Team Unicorns'),
                            subtitle: const CustomText(
                              title: 'Okay, I will check...',
                              color: Color(0xFF9B9B9B),
                            ),
                            trailing: const CircleAvatar(
                              radius: 10,
                              child: CustomText(
                                title: '1',
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                        itemCount: 5,
                      ),
                    ),
                  ),
                ] else ...[
                  Column(
                    children: [
                      ListTile(
                        leading: SizedBox(
                          width: 70,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                child: const Icon(
                                  Icons.arrow_back,
                                  size: 20,
                                  color: Colors.black,
                                ),
                                onTap: () {
                                  isChatOpen = false;
                                  setState(() {});
                                },
                              ),
                              const CircleAvatar(),
                            ],
                          ),
                        ),
                        title: const CustomText(title: 'Team Unicorns'),
                        subtitle: const CustomText(
                          title: 'Abhi, John and 4 more',
                          color: Color(0xFF9B9B9B),
                        ),
                        trailing: InkWell(
                          child: const Icon(
                            Icons.close,
                            size: 20,
                            color: Colors.black,
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Container(
                    height: 400,
                  ),
                  const Divider(
                    height: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      children: [
                        const Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Type your message...',
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () {
                            // Implement the send message functionality here
                          },
                        ),
                      ],
                    ),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
