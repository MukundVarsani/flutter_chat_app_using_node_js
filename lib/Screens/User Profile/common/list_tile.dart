import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfileList extends StatelessWidget {
  ProfileList({super.key, required this.content, required this.icon, required this.color});

  final String content;
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30)
          .copyWith(bottom: 8),
      child: Row(
        children: [
          Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  
                  borderRadius: BorderRadius.circular(10)),
              child:  Icon(icon , color: color,size: 28,)),
          const WidthBox(20),
          Text(
            content,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          const Spacer(),
          const Icon(
            Icons.arrow_right,
            size: 30,
            color: Colors.grey,
          )
        ],
      ),
    );
  }
}
