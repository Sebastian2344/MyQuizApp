part of 'quiz_editor_cubit.dart';

@freezed
class QuizEditorState with _$QuizEditorState {
  const factory QuizEditorState.initial() = _Initial;
  const factory QuizEditorState.loaded(List<Quiz> questions) = _Loaded;
  const factory QuizEditorState.error() = _Error;
}

