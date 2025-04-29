import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:custom_supabase_drift_sync/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:universal_platform/universal_platform.dart';

class MobileEditor extends StatefulWidget {
  const MobileEditor({super.key, required this.editorState});

  final EditorState editorState;

  @override
  State<MobileEditor> createState() => _MobileEditorState();
}

class _MobileEditorState extends State<MobileEditor> {
  EditorState get editorState => widget.editorState;

  late final EditorScrollController editorScrollController;

  @override
  void initState() {
    super.initState();

    editorScrollController = EditorScrollController(
      editorState: editorState,
      shrinkWrap: false,
    );
  }

  @override
  void reassemble() {
    super.reassemble();
  }

  @override
  Widget build(BuildContext context) {
    return MobileToolbarV2(
      toolbarHeight: 48.0,
      toolbarItems: [
        textDecorationMobileToolbarItemV2,
        buildTextAndBackgroundColorMobileToolbarItem(),
        blocksMobileToolbarItem,
        linkMobileToolbarItem,
        dividerMobileToolbarItem,
      ],
      editorState: editorState,
      child: Column(
        children: [
          // build appflowy editor
          Expanded(
            child: MobileFloatingToolbar(
              editorState: editorState,
              floatingToolbarHeight: 48.0,
              editorScrollController: editorScrollController,
              toolbarBuilder: (context, anchor, closeToolbar) {
                return AdaptiveTextSelectionToolbar.editable(
                  clipboardStatus: ClipboardStatus.pasteable,
                  onCopy: () {
                    copyCommand.execute(editorState);
                    closeToolbar();
                  },
                  onCut: () => cutCommand.execute(editorState),
                  onPaste: () => pasteCommand.execute(editorState),
                  onSelectAll: () => selectAllCommand.execute(editorState),
                  onLiveTextInput: null,
                  onLookUp: null,
                  onSearchWeb: null,
                  onShare: null,
                  anchors: TextSelectionToolbarAnchors(primaryAnchor: anchor),
                );
              },
              child: AppFlowyEditor(
                editorStyle: _buildMobileEditorStyle(context),
                editorState: editorState,
                editorScrollController: editorScrollController,
                blockComponentBuilders: _buildBlockComponentBuilders(context),
                showMagnifier: true,
                // showcase 3: customize the header and footer.
                // header: Padding(
                //   padding: const EdgeInsets.only(bottom: 10.0),
                //   child: Image.asset('assets/images/header.png'),
                // ),
                footer: const SizedBox(height: 100),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // showcase 1: customize the editor style.
  EditorStyle _buildMobileEditorStyle(BuildContext context) {
    return EditorStyle.mobile(
      textScaleFactor: 1.0,
      cursorColor: context.colorScheme.primary,
      dragHandleColor: context.colorScheme.primary,
      selectionColor: context.colorScheme.primary.withOpacity(0.3),
      textStyleConfiguration: TextStyleConfiguration(
        text: GoogleFonts.poppins(fontSize: 14, color: context.textColor),
        code: GoogleFonts.sourceCodePro(color: context.textColor),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      magnifierSize: const Size(144, 96),
      mobileDragHandleBallSize: UniversalPlatform.isIOS
          ? const Size.square(12)
          : const Size.square(8),
      mobileDragHandleLeftExtend: 12.0,
      mobileDragHandleWidthExtend: 24.0,
    );
  }

  // showcase 2: customize the block style
  Map<String, BlockComponentBuilder> _buildBlockComponentBuilders(
      BuildContext context) {
    final map = {...standardBlockComponentBuilderMap};
    // customize the heading block component
    final levelToFontSize = [24.0, 22.0, 20.0, 18.0, 16.0, 14.0];
    map[HeadingBlockKeys.type] = HeadingBlockComponentBuilder(
      textStyleBuilder: (level) => GoogleFonts.poppins(
        fontSize: levelToFontSize.elementAtOrNull(level - 1) ?? 14.0,
        fontWeight: FontWeight.w600,
        color: context.textColor,
      ),
    );
    map[ParagraphBlockKeys.type] = ParagraphBlockComponentBuilder(
      configuration: BlockComponentConfiguration(
        placeholderText: (node) => 'Type something...',
      ),
    );
    return map;
  }
}
