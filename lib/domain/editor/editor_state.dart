import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'editor_state.freezed.dart';

@freezed
class EditorStateCustom with _$EditorStateCustom {
  const factory EditorStateCustom({
    required EditorState editorState,
  }) = _EditorStateCustom;

  const EditorStateCustom._();
}
