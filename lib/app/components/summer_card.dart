import 'package:flutter/material.dart';

import '../utils/exports.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(NSizes.md),
      decoration: BoxDecoration(
        color: NAppColor.kbgColor2,
        borderRadius: BorderRadius.circular(NSizes.cardRadiusMd),
        border: Border.all(color: NAppColor.borderSecondary),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(NSizes.cardRadiusMd),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: NSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: style(
                    fontSize: NSizes.fontSizeLg + 2,
                    color: NAppColor.kTextStyleColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: style(
                    fontSize: NSizes.fontSizeSm - 2,
                    color: NAppColor.kTextStyleColorGray,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
