import 'package:flutter/material.dart';

class FlashReaderAdaptiveContextSelectionMenu extends StatelessWidget {
  final SelectableRegionState selectableRegionState;
  const FlashReaderAdaptiveContextSelectionMenu(
      {Key? key, required this.selectableRegionState})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdaptiveTextSelectionToolbar(
      anchors: selectableRegionState.contextMenuAnchors,
      children: [
        Wrap(
          spacing: 5,
          children: [
            IconButton(
                onPressed: selectableRegionState.contextMenuButtonItems
                    .firstWhere(
                        (element) => element.type == ContextMenuButtonType.copy)
                    .onPressed,
                icon: const Icon(Icons.copy)),
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.format_quote_rounded)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.translate)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
          ],
        )
      ],
    );
  }
}
