import 'package:flutter/material.dart';
import 'package:holdwise/app/config/constants.dart';
import 'package:holdwise/features/explore_screen/data/models/advice.dart';
import 'package:share_plus/share_plus.dart';

class AdviceCard extends StatelessWidget {
  final AdviceModel advice;

  const AdviceCard({Key? key, required this.advice}) : super(key: key);

  void _shareAdvice(BuildContext context) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    Share.share(
      '${advice.title}\n\n${advice.content}',
      subject: 'Check out this advice!',
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final mediaHeight = screenWidth * 0.5;

    // Build the final file URL if mediaUrl (encrypted token) exists.
    String? finalMediaUrl;
    if (advice.mediaUrl != null) {
      
      finalMediaUrl = 'http://${APIs.baseServerUrl}/file/${advice.mediaUrl}';
    }

    // Build media widget based on advice type.
    Widget mediaWidget = Container();
    if (advice.type == AdviceType.image && finalMediaUrl != null) {
      mediaWidget = Image.network(
        finalMediaUrl,
        height: mediaHeight,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/placeholders/not_found.jpeg',
            height: mediaHeight,
            width: double.infinity,
            fit: BoxFit.cover,
          );
        },
      );
    } else if (advice.type == AdviceType.video && finalMediaUrl != null) {
      mediaWidget = Stack(
        children: [
          Image.network(
            finalMediaUrl,
            height: mediaHeight,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/placeholders/not_found.jpeg',
                height: mediaHeight,
                width: double.infinity,
                fit: BoxFit.cover,
              );
            },
          ),
          Positioned.fill(
            child: Center(
              child: Icon(
                Icons.play_circle_fill,
                size: 50,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ),
        ],
      );
    }

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display media if applicable.
          if (advice.type != AdviceType.text && finalMediaUrl != null)
            mediaWidget,
          // Advice title
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              advice.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          // Advice content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Text(
              advice.content,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          // Optional action buttons.
          OverflowBar(
            alignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  _shareAdvice(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
