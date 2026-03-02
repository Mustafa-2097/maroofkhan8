import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderSection extends StatelessWidget {
  final String title;
  const HeaderSection({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(width: 60, height: 1, color: Colors.grey.shade300),
          const SizedBox(width: 10),
          Icon(
            Icons.circle,
            size: 4,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: GoogleFonts.amiri(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 10),
          Icon(
            Icons.circle,
            size: 4,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 10),
          Container(width: 60, height: 1, color: Colors.grey.shade300),
        ],
      ),
    );
  }
}

const Color kPrimaryBrown = Color(0xFF8D3C1F);
const Color kDarkBlack = Color(0xFF1E120D);
const Color kLightGrey = Color(0xFFA4AFC1);
