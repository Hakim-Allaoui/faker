import 'package:faker/utils/theme.dart';
import 'package:faker/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProButton extends StatelessWidget {
  final bool background;

  const ProButton({Key key, this.background = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: background
                ? LinearGradient(
                    colors: [
                      Palette.move.withOpacity(0.5),
                      Palette.rose,
                    ],
                  )
                : null,
            boxShadow: background
                ? [
                    BoxShadow(
                      color: Palette.rose,
                      blurRadius: 2.0,
                    )
                  ]
                : [],
          ),
          child: IconButton(
            icon: SvgPicture.asset(
              'assets/icons/pro_badge.svg',
              width: 30.0,
            ),
            onPressed: () {
              Tools.showProDialog(context);
            },
          ),
        ),
        background
            ? Text(
                'Go Pro',
                style: TextStyle(
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                  color: Palette.move,
                ),
              )
            : SizedBox(),
      ],
    );
  }
}
