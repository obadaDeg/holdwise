import 'package:flutter/material.dart';

class StreakBadges extends StatelessWidget {
  final int currentStreak;
  final int longestStreak;
  final String latestBadge;
  final int nextBadgeGoal;
  final List<String> earnedBadges; // New: List of all earned badges

  const StreakBadges({
    Key? key,
    required this.currentStreak,
    required this.longestStreak,
    required this.latestBadge,
    required this.nextBadgeGoal,
    required this.earnedBadges, // New
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double progress = (currentStreak / nextBadgeGoal).clamp(0.0, 1.0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "🏆 Streak & Badges",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Current Streak & Longest Streak
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStreakInfo("🔥 Current Streak", currentStreak),
                _buildStreakInfo("🏅 Longest Streak", longestStreak),
              ],
            ),
            SizedBox(height: 15),

            // Latest Badge Display with Animation
            AnimatedScale(
              scale: 1.1,
              duration: Duration(milliseconds: 500),
              child: Column(
                children: [
                  Text(
                    "Latest Badge Earned",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 5),
                  _buildBadgeIcon(latestBadge),
                  Text(
                    latestBadge,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),

            // Show All Button
            TextButton(
              onPressed: () => _showAllBadges(context),
              child: Text(
                "Show All Badges",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.blueAccent),
              ),
            ),

            SizedBox(height: 10),

            // Progress to Next Badge
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Text(
                    "Next Badge Progress",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 5),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.shade300,
                    color: Colors.blueAccent,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Keep going! ${nextBadgeGoal - currentStreak} more days for the next badge! 🎖️",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAllBadges(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("All Earned Badges"),
          content: SingleChildScrollView(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: earnedBadges.map((badge) => _buildBadgeIcon(badge)).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStreakInfo(String title, int streak) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        SizedBox(height: 5),
        Text(
          "$streak 🔥",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orange),
        ),
      ],
    );
  }

  Widget _buildBadgeIcon(String badge) {
    IconData icon;
    Color color;

    switch (badge) {
      case "Bronze":
        icon = Icons.emoji_events;
        color = Colors.brown;
        break;
      case "Silver":
        icon = Icons.emoji_events;
        color = Colors.grey;
        break;
      case "Gold":
        icon = Icons.emoji_events;
        color = Colors.amber;
        break;
      case "Diamond":
        icon = Icons.star;
        color = Colors.blueAccent;
        break;
      default:
        icon = Icons.lock;
        color = Colors.grey;
    }

    return Icon(icon, size: 40, color: color);
  }
}
