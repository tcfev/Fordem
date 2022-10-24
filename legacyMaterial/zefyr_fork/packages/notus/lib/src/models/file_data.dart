import 'package:notus/src/models/alignment.dart';

class FileData {
  const FileData({
    this.localPath,
    this.url,
  });

  factory FileData.fromJson(Map<String, dynamic> json) => FileData(
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
