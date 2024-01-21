import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Row buildDivider() {
  return const Row(
    children: [
      Expanded(
        child: Divider(),
      ),
      Text('OR'),
      Expanded(
        child: Divider(),
      ),
    ],
  );
}

Expanded buildSocialLogin({required String icon, Function()? onTap}) {
  return Expanded(
    child: InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            10,
          ),
          border: Border.all(),
        ),
        child: SvgPicture.asset(
          icon,
        ),
      ),
    ),
  );
}
