import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yt_dlp_wrapper/blocs/base/file_persistent_config_state.dart';
import 'package:yt_dlp_wrapper/utils.dart';

abstract class FilePersistentConfigCubit<S extends FilePersistentConfigState>
    extends Cubit<S> {
  static const _defaultConfigFileName = 'conf.json';
  final String? _configFileName;
  final S Function(Map<String, dynamic> json) _deserializer;

  File get _configFile => File(path.join(Utils.pwd, _configFileName));

  FilePersistentConfigCubit(
    super.initialState, {
    required S Function(Map<String, dynamic> json) deserializer,
    String? configFileName,
  })  : _deserializer = deserializer,
        _configFileName = configFileName ?? _defaultConfigFileName {
    loadConf();
  }

  Future<void> loadConf() async {
    final configFile = _configFile;

    if (configFile.existsSync()) {
      try {
        final jsonState = await _configFile.readAsString();
        final stateMap = jsonDecode(jsonState);

        emit(_deserializer(stateMap));
      } on FormatException {
        if (kDebugMode) {
          print("Invalid Config File");
        }
      }
    }
  }

  Future<void> saveConf() async {
    final jsonState = jsonEncode(state.toMap());
    _configFile.writeAsString(jsonState);
  }
}
