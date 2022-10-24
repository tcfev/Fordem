import 'package:notus/src/models/alignment.dart';

class VideoData {
  const VideoData({
    this.localPath,
    this.url,
    this.height,
    this.width,
    this.saveRatio = true,
    this.align = const NotusAlignment.center(),
  })  : assert(saveRatio != null),
        assert(align != null);

  factory VideoData.fromJson(Map<String, dynamic> json) => VideoData(
        localPath: json['local_path'],
        url: json['url'],
        height: json['height'],
        width: json['width'],
        saveRatio: json['save_ratio'] ?? true,
        align: json['alignment'] != null ? NotusAlignment.fromString(json['alignment']) : NotusAlignment.center(),
      );

  final String localPath;
  final String url;
  final double height;
  final double width;
  final bool saveRatio;
  final NotusAlignment align;

  Map<String, dynamic> toJson() => {
        'local_path': localPath,
        'url': url,
        'height': height,
        'width': width,
        'save_ratio': saveRatio,
        'alignment': align.value,
      };
}
