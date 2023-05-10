import 'dart:io';

import 'package:path/path.dart' as path;

class Utils {
  Utils._();

  static final String pwd = () {
    final exePath = Platform.resolvedExecutable;
    final comps = exePath.split(Platform.pathSeparator);
    comps.removeLast();

    return path.joinAll(comps);
  }();

  static bool checkValidDir(dynamic dir) {
    if (dir is String) {
      dir = Directory(dir);
    } else if (dir is File) {
      dir = dir.parent;
    }

    if (dir is Directory) {
      return dir.existsSync();
    }

    throw ArgumentError(dir);
  }

  static bool checkValidFile(dynamic file) {
    if (file is String) {
      file = File(file);
    }

    if (file is File) {
      return file.existsSync();
    }

    throw ArgumentError(file);
  }

  static String? formatUrlArg(String? url) {
    if (url == null) return null;

    try {
      final uri = Uri.parse(url);

      switch(uri.host) {
        case 'youtu.be':
          return uri.pathSegments[0];
        case 'youtube.com':
        case 'www.youtube.com':
          final id = uri.queryParameters['v'];
          if (id != null){
            return id;
          }
          break;
      }

      // yt-dlp probably supports more stuff so let it figure out instead ;p
      return url;
    } catch (_) {
      return null;
    }
  }
}
