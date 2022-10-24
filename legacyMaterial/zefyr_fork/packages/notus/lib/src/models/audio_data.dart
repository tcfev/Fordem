class AudioData {
  const AudioData({
    this.localPath,
    this.url,
  });

  factory AudioData.fromJson(Map<String, dynamic> json) => AudioData(
        localPath: json['local_path'],
        url: json['url'],
      );

  final String localPath;
  final String url;

  Map<String, dynamic> toJson() => {
        'local_path': localPath,
        'url': url,
      };
}
