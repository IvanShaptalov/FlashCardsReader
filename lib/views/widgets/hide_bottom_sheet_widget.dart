import 'package:flashcards_reader/views/config/view_config.dart';
import 'package:flutter/material.dart';

class HideBottomSheet extends StatelessWidget {
  const HideBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: SizeConfig.getMediaHeight(context, p: 0.01)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: SizeConfig.getMediaWidth(context, p: 0.4),
            height: 5,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              color: Palette.grey600,
            ),
          )
        ],
      ),
    );
  }
}
