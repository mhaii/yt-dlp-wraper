enum VideoFormat {
  best('best'),
  webm,
  mkv,
  mov,
  flv,
  mp4;

  final String? value;

  const VideoFormat([this.value]);
}

enum AudioFormat {
  best('best'),
  aac,
  flac,
  m4a,
  mp3,
  mka,
  opus,
  ogg,
  vorbis,
  wav;

  final String? value;

  const AudioFormat([this.value]);
}

enum ThumbnailOptions {
  download('write-thumbnails'),
  downloadAll('no-write-thumbnails'),
  doNotDownload('write-all-thumbnails');

  final String value;

  const ThumbnailOptions(this.value);
}
