import 'dart:io';

import 'package:yt_dlp_wrapper/blocs/base/file_persistent_config_cubit.dart';

import 'package:yt_dlp_wrapper/blocs/path_state.dart';

class PathCubit extends FilePersistentConfigCubit<PathState> {
  static const _configFileName = 'path-conf.json';

  PathCubit()
      : super(
          PathState(),
          deserializer: PathState.fromMap,
          configFileName: _configFileName,
        ) {
    loadConf();
  }

  void updateYtdlpPath(String path) {
    if (state.destPath == null) {
      final f = File(path);
      if (f.existsSync()) {
        emit(state.copyWith(
          ytdlpPath: path,
          destPath: f.parent.path,
        ));
      } else {
        emit(state.copyWith(ytdlpPath: path));
      }
    } else {
      emit(state.copyWith(ytdlpPath: path));
    }

    saveConf();
  }

  void updateDestPath(String path) {
    emit(state.copyWith(destPath: path));
    saveConf();
  }
}
