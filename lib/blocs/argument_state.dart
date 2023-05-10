import 'package:collection/collection.dart';
import 'package:yt_dlp_wrapper/blocs/base/file_persistent_config_state.dart';
import 'package:yt_dlp_wrapper/enums/arguments.dart';
import 'package:yt_dlp_wrapper/utils.dart';

enum UrlValidationState {
  valid,
  invalid,
  empty,
}

class ArgumentState implements FilePersistentConfigState {
  final String? url;
  late final UrlValidationState urlState;
  final bool audioOnly;
  final VideoFormat videoFormat;
  final int videoQuality;
  final AudioFormat audioFormat;
  final int audioQuality;

  ArgumentState({
    this.url,
    bool? audioOnly,
    VideoFormat? videoFormat,
    int? videoQuality,
    AudioFormat? audioFormat,
    int? audioQuality,
  })  : audioOnly = audioOnly ?? false,
        videoFormat = videoFormat ?? VideoFormat.best,
        videoQuality = videoQuality ?? 5,
        audioFormat = audioFormat ?? AudioFormat.best,
        audioQuality = audioQuality ?? 5 {
    if (url == null) {
      urlState = UrlValidationState.empty;
    } else {
      urlState = Utils.formatUrlArg(url!) == null
          ? UrlValidationState.invalid
          : UrlValidationState.valid;
    }
  }

  ArgumentState copyWith({
    String? url,
    bool? audioOnly,
    VideoFormat? videoFormat,
    int? videoQuality,
    AudioFormat? audioFormat,
    int? audioQuality,
  }) =>
      ArgumentState(
        url: url ?? this.url,
        audioOnly: audioOnly ?? this.audioOnly,
        videoFormat: videoFormat ?? this.videoFormat,
        videoQuality: videoQuality ?? this.videoQuality,
        audioFormat: audioFormat ?? this.audioFormat,
        audioQuality: audioQuality ?? this.audioQuality,
      );

  factory ArgumentState.fromMap(Map<String, dynamic> json) {
    return ArgumentState(
      audioOnly: json['audioOnly'],
      videoFormat: VideoFormat.values
          .firstWhereOrNull((e) => e.name == json['videoFormat']),
      videoQuality: json['videoQuality'],
      audioFormat: AudioFormat.values
          .firstWhereOrNull((e) => e.name == json['audioFormat']),
      audioQuality: json['audioQuality'],
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        'audioOnly': audioOnly,
        'videoFormat': videoFormat.name,
        'videoQuality': videoQuality,
        'audioFormat': audioFormat.name,
        'audioQuality': audioQuality,
      };
}
