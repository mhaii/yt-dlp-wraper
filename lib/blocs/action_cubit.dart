import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:process_run/process_run.dart';
import 'package:yt_dlp_wrapper/blocs/action_state.dart';
import 'package:yt_dlp_wrapper/blocs/argument_state.dart';
import 'package:yt_dlp_wrapper/blocs/path_state.dart';
import 'package:yt_dlp_wrapper/components/dialogs/ok_dialog.dart';
import 'package:yt_dlp_wrapper/enums/arguments.dart';
import 'package:yt_dlp_wrapper/utils.dart';

class ActionCubit extends Cubit<ActionState> {
  final _shell = Shell(
    verbose: false,
    throwOnError: false,
  );

  ActionCubit() : super(ActionState());

  void updatePathState(PathState pathState) {
    final newState = state.copyWith(pathState: pathState);
    emit(newState.copyWith(isValid: _validate(newState)));
  }

  void updateArgumentState(ArgumentState argumentState) {
    final newState = state.copyWith(argumentState: argumentState);
    emit(newState.copyWith(isValid: _validate(newState)));
  }

  bool _validate(ActionState newState) =>
      newState.pathState?.ytdlpState == PathValidationState.valid &&
      newState.pathState?.destState == PathValidationState.valid &&
      newState.argumentState?.url != null &&
      newState.argumentState?.url != '';

  Future<void> fetch() async {
    if (!state.isValid) return;
    emit(state.copyWith(isLoading: true));

    Future? fu;
    try {
      final path = state.pathState!;
      final argument = state.argumentState!;

      final cmdPath = path.ytdlpPath!.replaceAll('"', '\\"');

      final cmdChunks = [
        // cmdPath,
        '-P',
        path.destPath!.replaceAll('"', '\\"'),

        '--audio-quality',
        '${argument.audioQuality}',
        if (argument.audioOnly) '--extract-audio',
        if (!argument.audioOnly &&
            argument.videoFormat != VideoFormat.best) ...[
          '--format', argument.videoFormat.value ?? argument.videoFormat.name,
          // not used
          // '--video-quality ${argument.videoQuality}',
        ],
        Utils.formatUrlArg(argument.url!)!
      ];

      final res = await _shell.runExecutableArguments(cmdPath, cmdChunks);

      if (res.exitCode == 0) {
        fu = Future.value();
      } else {
        final errLines = res.errLines.where((line) => line != '').toList();
        fu = OkDialog.show(errLines.last);
        if (kDebugMode) {
          for (var l in errLines) {
            print(l);
          }
        }
      }
    } catch (e) {
      fu = OkDialog.show(e.toString());
      if (kDebugMode) {
        print(e);
      }
    } finally {
      fu!.whenComplete(() => emit(state.copyWith(isLoading: false)));
    }
  }
}
