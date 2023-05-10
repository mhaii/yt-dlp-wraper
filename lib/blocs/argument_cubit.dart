import 'package:yt_dlp_wrapper/blocs/base/file_persistent_config_cubit.dart';

import 'package:yt_dlp_wrapper/blocs/argument_state.dart';
import 'package:yt_dlp_wrapper/enums/arguments.dart';

class ArgumentCubit extends FilePersistentConfigCubit<ArgumentState> {
  static const _configFileName = 'args-conf.json';

  ArgumentCubit()
      : super(
          ArgumentState(),
          deserializer: ArgumentState.fromMap,
          configFileName: _configFileName,
        ) {
    loadConf();
  }

  void updateUrl(String url) {
    emit(state.copyWith(url: url));
  }

  void setIsAudioOnly(bool flag) {
    emit(state.copyWith(audioOnly: flag));
    saveConf();
  }
  void updateVideoQuality(int value) {
    emit(state.copyWith(videoQuality: value));
    saveConf();
  }
  void updateAudioQuality(int value) {
    emit(state.copyWith(audioQuality: value));
    saveConf();
  }
  void updateVideoFormat(VideoFormat value) {
    emit(state.copyWith(videoFormat: value));
    saveConf();
  }
  void updateAudioFormat(AudioFormat value) {
    emit(state.copyWith(audioFormat: value));
    saveConf();
  }
}
