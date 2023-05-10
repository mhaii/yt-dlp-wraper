import 'package:yt_dlp_wrapper/blocs/base/file_persistent_config_state.dart';
import 'package:yt_dlp_wrapper/utils.dart';

enum PathValidationState {
  valid,
  notExist,
  empty,
}

class PathState implements FilePersistentConfigState {
  final String? ytdlpPath;
  late final PathValidationState ytdlpState;
  final String? destPath;
  late final PathValidationState destState;

  PathState({
    String? ytdlpPath,
    String? destPath,
  })  : ytdlpPath = ytdlpPath == '' ? null : ytdlpPath,
        destPath = destPath == '' ? null : destPath {
    if (ytdlpPath == null) {
      ytdlpState = PathValidationState.empty;
    } else {
      ytdlpState = Utils.checkValidFile(ytdlpPath)
          ? PathValidationState.valid
          : PathValidationState.notExist;
    }
    if (destPath == null) {
      destState = PathValidationState.empty;
    } else {
      destState = Utils.checkValidDir(destPath)
          ? PathValidationState.valid
          : PathValidationState.notExist;
    }
  }

  PathState copyWith({
    String? ytdlpPath,
    String? destPath,
  }) =>
      PathState(
        ytdlpPath: ytdlpPath ?? this.ytdlpPath,
        destPath: destPath ?? this.destPath,
      );

  factory PathState.fromMap(Map<String, dynamic> json) {
    return PathState(
      ytdlpPath: json['ytdlpPath'],
      destPath: json['destPath'],
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        'ytdlpPath': ytdlpPath,
        'destPath': destPath,
      };
}
