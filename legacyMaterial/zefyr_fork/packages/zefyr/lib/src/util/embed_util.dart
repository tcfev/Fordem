extension MimeTypeExtension on String {
  bool get isImage => this != null && startsWith('image/');

  bool get isVideo => this != null && startsWith('video/');

  bool get isAudio => this != null && startsWith('audio/');

  bool get isText => this != null && startsWith('text/');

  bool get isPdf => this != null && this == 'application/pdf';
}
