import 'dart:io';
import 'dart:typed_data';

import 'package:epub_view/epub_view.dart';
import 'package:flashcards_reader/bloc/providers/book_pagination_provider.dart';
import 'package:flashcards_reader/bloc/providers/word_collection_provider.dart';
import 'package:flashcards_reader/util/error_handler.dart';
import 'package:flashcards_reader/views/menu/adaptive_context_selection_menu.dart';
import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart' as flutter_widgets;
import 'package:flutter_html/flutter_html.dart';

class EpubTextView extends StatefulWidget {
  final File file;
  final Function(int? pageIndex, String? epubCFI) saveBook;
  final int? pageIndex;
  final String? epubCFI;

  const EpubTextView(
      {super.key,
      required this.file,
      required this.saveBook,
      required this.pageIndex,
      required this.epubCFI});

  @override
  State<EpubTextView> createState() => _EpubTextViewState();
}

class _EpubTextViewState extends State<EpubTextView> {
  late EpubController _epubReaderController;
  bool firstOpen = false;

  @override
  void initState() {
    _epubReaderController =
        EpubController(document: EpubDocument.openFile(widget.file));
    firstOpen = true;
    super.initState();
  }

  int? currentPageIndex;
  String? epubCfi;

  @override
  void dispose() {
    debugPrintIt('save epub cfi: $currentPageIndex');
    widget.saveBook(currentPageIndex ?? 0, epubCfi);
    try {
      _epubReaderController.dispose();
    } catch (e) {
      debugPrintIt('bug on disposing');
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: EpubViewActualChapter(
            controller: _epubReaderController,
            builder: (chapterValue) => Text(
              chapterValue?.chapter?.Title?.replaceAll('\n', '').trim() ?? '',
              textAlign: TextAlign.start,
            ),
          ),
        ),
        body: EpubView(
          onChapterChanged: (value) {
            if (firstOpen) {
              firstOpen = false;
              _scrollToPreviousPosition(widget.pageIndex);
            } else {
              currentPageIndex =
                  _epubReaderController.currentValue!.position.index;
              epubCfi = _epubReaderController.generateEpubCfi();

              if (epubCfi != null) {
                epubCfi = epubCfi!.contains('null') ? null : epubCfi;
              }

              debugPrintIt('chapter changed cfi to : $currentPageIndex');
              debugPrintIt('chapter changed cfi to : $epubCfi');
            }
          },
          builders: EpubViewBuilders<DefaultBuilderOptions>(
            options: const DefaultBuilderOptions(),
            chapterDividerBuilder: (_) => const Divider(),
            chapterBuilder: (context, builders, document, chapters, paragraphs,
                index, chapterIndex, paragraphIndex, onExternalLinkPressed) {
              if (paragraphs.isEmpty) {
                return Container();
              }

              final defaultBuilder =
                  builders as EpubViewBuilders<DefaultBuilderOptions>;
              final options = defaultBuilder.options;

              return Column(
                children: <Widget>[
                  if (chapterIndex >= 0 && paragraphIndex == 0)
                    builders.chapterDividerBuilder(chapters[chapterIndex]),
                  SelectionArea(
                    contextMenuBuilder: (
                      BuildContext context,
                      SelectableRegionState selectableRegionState,
                    ) =>
                        FlashReaderAdaptiveContextSelectionMenu(
                            selectableRegionState: selectableRegionState,
                            addNoteCallback: () {},
                            hideNotes: true),
                    onSelectionChanged: (value) {
                      if (value != null) {
                        WordCreatingUIProvider.tmpFlashCard.question =
                            value.plainText;
                        TextSelectorProvider.selectedText = value.plainText;
                      }
                    },
                    child: Html(
                      data: paragraphs[index].element.outerHtml,
                      onLinkTap: (href, _, __) => onExternalLinkPressed(href!),
                      style: {
                        'html': Style(
                          padding: HtmlPaddings.only(
                            top: (options.paragraphPadding as EdgeInsets?)?.top,
                            right: (options.paragraphPadding as EdgeInsets?)
                                ?.right,
                            bottom: (options.paragraphPadding as EdgeInsets?)
                                ?.bottom,
                            left:
                                (options.paragraphPadding as EdgeInsets?)?.left,
                          ),
                        ).merge(Style.fromTextStyle(options.textStyle)),
                      },
                      extensions: [
                        TagExtension(
                          tagsToExtend: {"img"},
                          builder: (imageContext) {
                            final url = imageContext.attributes['src']!
                                .replaceAll('../', '');
                            final content = Uint8List.fromList(
                                document.Content!.Images![url]!.Content!);
                            return flutter_widgets.Image(
                              image: MemoryImage(content),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          controller: _epubReaderController,
        ),
      );

  void _scrollToPreviousPosition(int? index) {
    if (epubCfi != null && !epubCfi!.contains('null')) {
      _epubReaderController.gotoEpubCfi(epubCfi!);
    } else if (index != null) {
      _epubReaderController.scrollTo(index: index);
    }
  }
}
