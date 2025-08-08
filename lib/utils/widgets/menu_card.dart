import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onPress;
  final bool isFullWidth;

  const MenuCard({
    super.key,
    required this.icon,
    required this.title,
    this.isFullWidth = false, required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        height: MediaQuery.of(context).size.height / 2.8,
        width: isFullWidth ? double.infinity : null,
        decoration: BoxDecoration(
          color: const Color(0xFFD1E3F1),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 45, color: const Color(0xFF3B5F8A)), // Slightly bigger icon
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF3B5F8A),
                fontSize: 18, // Slightly larger text
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
class VerticalMenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onPress;
  final bool isFullWidth;

  const VerticalMenuCard({
    super.key,
    required this.icon,
    required this.title,
    this.isFullWidth = false, required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        height: MediaQuery.of(context).size.height / 4.2,
        width: isFullWidth ? double.infinity : null,
        decoration: BoxDecoration(
          color: const Color(0xFFD1E3F1),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 45, color: const Color(0xFF3B5F8A)), // Slightly bigger icon
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF3B5F8A),
                fontSize: 18, // Slightly larger text
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
