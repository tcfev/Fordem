import 'package:flutter/cupertino.dart';
import 'package:zefyr/zefyr.dart';

class ComposeNotifier extends ChangeNotifier {
  ZefyrController zefyrController = ZefyrController();
  FocusNode focusNode = FocusNode();
  Future<ImageData> imageData;
  Future<VideoData> videoData;

  void startListener() {
    notifyListeners();
  }
}