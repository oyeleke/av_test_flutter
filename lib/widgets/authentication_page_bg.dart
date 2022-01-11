import 'package:boilerplate/constants/colors.dart';
import 'package:flutter/material.dart';

class AuthenticationPageBG extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width;
    final maxHeight = MediaQuery.of(context).size.height;

    return Container(
      width: maxWidth,
      height: maxHeight,
      child: Stack(
        children: [
          Container(
            width: maxWidth,
            height: maxHeight,
            decoration: BoxDecoration(color: Colors.white),
          ),
          Container(
            child: ClipPath(
              clipper: CircularClipper(),
              child: Container(
                width: maxWidth,
                height: maxHeight - 35 0,
                color: AppColors.main[50],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CircularClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var firstStart = Offset(size.width / 2, size.height);
    var firstEnd = Offset(size.width, size.height - size.height/10);
    final path = Path()
      ..lineTo(0.0, size.height - size.height/10)
      ..quadraticBezierTo(
          firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy)
      ..lineTo(size.width, 0.0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
