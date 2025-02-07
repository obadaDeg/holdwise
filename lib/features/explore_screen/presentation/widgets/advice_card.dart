import 'package:flutter/material.dart';
import 'package:holdwise/features/explore_screen/data/models/advice.dart';

class AdviceCard extends StatelessWidget {
  final AdviceModel advice;

  const AdviceCard({Key? key, required this.advice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final mediaHeight = screenWidth * 0.5;

    // Build media widget based on advice type.
    Widget mediaWidget = Container();
    if (advice.type == AdviceType.image && advice.mediaUrl != null) {
      mediaWidget = Image.network(
        advice.mediaUrl!,
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
    } else if (advice.type == AdviceType.video && advice.mediaUrl != null) {
      mediaWidget = Stack(
        children: [
          Image.network(
            advice.mediaUrl!,
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
          if (advice.type != AdviceType.text) mediaWidget,
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
                  // Implement share functionality.
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
