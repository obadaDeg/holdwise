import 'package:holdwise/features/chat_temp/data/models/message.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'profile_image.dart';

class AiMessageCard extends StatelessWidget {
  final AiMessage message;

  const AiMessageCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    const radius = Radius.circular(15);
    final mq = MediaQuery.of(context).size;

    return message.msgType == MessageType.bot

        //bot
        ? Row(children: [
            const SizedBox(width: 6),

            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: Image.asset('assets/images/logo.png', width: 24),
            ),

            //
            Container(
              constraints: BoxConstraints(maxWidth: mq.width * .6),
              margin: EdgeInsets.only(
                  bottom: mq.height * .02, left: mq.width * .02),
              padding: EdgeInsets.symmetric(
                  vertical: mq.height * .01, horizontal: mq.width * .02),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: const BorderRadius.only(
                      topLeft: radius, topRight: radius, bottomRight: radius)),
              child: message.msg.isEmpty
                  ? Lottie.asset('assets/lottie/ai.json', width: 35)
                  : Text(message.msg, textAlign: TextAlign.center),
            )
          ])

        //user
        : Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            //
            Container(
                constraints: BoxConstraints(maxWidth: mq.width * .6),
                margin: EdgeInsets.only(
                    bottom: mq.height * .02, right: mq.width * .02),
                padding: EdgeInsets.symmetric(
                    vertical: mq.height * .01, horizontal: mq.width * .02),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: const BorderRadius.only(
                        topLeft: radius, topRight: radius, bottomLeft: radius)),
                child: Text(
                  message.msg,
                  textAlign: TextAlign.center,
                )),

            const ProfileImage(size: 35),

            const SizedBox(width: 6),
          ]);
  }
}
