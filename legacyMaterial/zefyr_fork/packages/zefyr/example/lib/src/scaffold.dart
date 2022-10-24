import 'dart:convert';

import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zefyr/zefyr.dart';

import 'settings.dart';

typedef DemoContentBuilder = Widget Function(BuildContext context, ZefyrController controller);

// Common scaffold for all examples.
class DemoScaffold extends StatefulWidget {
  /// Filename of the document to load into the editor.
  final String documentFilename;
  final DemoContentBuilder builder;
  final List<Widget> actions;
  final Widget floatingActionButton;
  final bool showToolbar;

  const DemoScaffold({
    Key key,
    @required this.documentFilename,
    @required this.builder,
    this.actions,
    this.showToolbar = true,
    this.floatingActionButton,
  }) : super(key: key);

  @override
  _DemoScaffoldState createState() => _DemoScaffoldState();
}

class _DemoScaffoldState extends State<DemoScaffold> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ZefyrController _controller;

  bool _loading = false;
  bool _canSave = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller == null && !_loading) {
      _loading = true;
      final settings = Settings.of(context);
      if (settings.assetsPath.isEmpty) {
        _loadFromAssets();
      } else {
        _loadFromPath(settings.assetsPath);
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _loadFromAssets() async {
    try {
      final result = await rootBundle.loadString('assets/${widget.documentFilename}');
      final doc = NotusDocument.fromJson(jsonDecode(result));
      setState(() {
        _controller = ZefyrController(doc);
        _loading = false;
      });
    } catch (error) {
      final doc = NotusDocument()..insert(0, 'Empty asset');
      setState(() {
        _controller = ZefyrController(doc);
        _loading = false;
      });
    }
  }

  Future<void> _loadFromPath(String assetsPath) async {
    final fs = LocalFileSystem();
    final file = fs.directory(assetsPath).childFile('${widget.documentFilename}');
    if (await file.exists()) {
      final data = await file.readAsString();
      final doc = NotusDocument.fromJson(jsonDecode(data));
      setState(() {
        _controller = ZefyrController(doc);
        _loading = false;
        _canSave = true;
      });
    } else {
      final doc = NotusDocument()..insert(0, 'Empty asset');
      setState(() {
        _controller = ZefyrController(doc);
        _loading = false;
        _canSave = true;
      });
    }
  }

  Future<void> _save() async {
    final settings = Settings.of(context);
    final fs = LocalFileSystem();
    final file = fs.directory(settings.assetsPath).childFile('${widget.documentFilename}');
    final data = jsonEncode(_controller.document);
    await file.writeAsString(data);
    ScaffoldMessenger.of(_scaffoldKey.currentContext).showSnackBar(SnackBar(content: Text('Saved.')));
  }

  @override
  Widget build(BuildContext context) {
    final actions = widget.actions ?? <Widget>[];
    if (_canSave) {
      actions.add(IconButton(
        onPressed: _save,
        icon: Icon(
          Icons.save,
          color: Colors.grey.shade800,
          size: 18,
        ),
      ));
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: Colors.grey.shade800,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: _loading || widget.showToolbar == false
            ? null
            : ZefyrToolbar.basic(
                controller: _controller,
                onDisabledLinkClick: _onDisabledLinkClick,
                embeddingOptions: EmbeddingOptions(
                  embeddingPickActions: EmbeddingPickActions(
                    onImagePicked: onImagePicked,
                    onVideoPicked: onVideoPicked,
                    onFilePicked: onFilePicked,
                    onAudioPicked: onAudioPicked,
                  ),
                ),
              ),
        actions: actions,
      ),
      floatingActionButton: widget.floatingActionButton,
      body: _loading ? Center(child: Text('Loading...')) : widget.builder(context, _controller),
    );
  }

  Future<ImageData> onImagePicked(String path) async {
    var data = await showDialog(
      context: context,
      builder: (context) => ChooseImageAndVideoConfig(),
      barrierDismissible: false,
    );
    ImageData imageData;
    if (data != null) {
      imageData = ImageData(
        localPath: path,
        align: data.align,
        saveRatio: data.saveRatio,
        width: data.width,
        height: data.height,
      );
    } else {
      imageData = ImageData(localPath: path);
    }
    return imageData;
  }

  Future<VideoData> onVideoPicked(String path) async {
    var data = await showDialog(
      context: context,
      builder: (context) => ChooseImageAndVideoConfig(),
      barrierDismissible: false,
    );
    VideoData videoData;
    if (data != null) {
      videoData = VideoData(
        localPath: path,
        align: data.align,
        saveRatio: data.saveRatio,
        width: data.width,
        height: data.height,
      );
    } else {
      videoData = VideoData(localPath: path);
    }
    return videoData;
  }

  Future<FileData> onFilePicked(String path) async {
    return FileData(localPath: path);
  }

  Future<AudioData> onAudioPicked(String path) async {
    return AudioData(localPath: path);
  }

  void _onDisabledLinkClick() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('please select a text first'),
        duration: Duration(milliseconds: 2000),
      ),
    );
  }
}

class ChooseImageAndVideoConfig extends StatefulWidget {
  @override
  _ChooseImageAndVideoConfigState createState() => _ChooseImageAndVideoConfigState();
}

class _ChooseImageAndVideoConfigState extends State<ChooseImageAndVideoConfig> {
  double height, width;
  bool saveRatio = true;
  NotusAlignment alignment = NotusAlignment.center();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(8),
      children: [
        Text('height (optional)'),
        TextField(
          onChanged: (value) {
            setState(
              () {
                height = double.tryParse(value);
              },
            );
          },
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(hintText: 'enter Height'),
        ),
        SizedBox(height: 16),
        Text('width (optional)'),
        TextField(
          onChanged: (value) {
            setState(
              () {
                width = double.tryParse(value);
              },
            );
          },
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            hintText: 'enter Width',
          ),
        ),
        SizedBox(height: 16),
        Text('alignment'),
        DropdownButton(
          items: [
            DropdownMenuItem(
              child: Text('center'),
              value: 'c',
            ),
            DropdownMenuItem(
              child: Text('right'),
              value: 'r',
            ),
            DropdownMenuItem(
              child: Text('left'),
              value: 'l',
            ),
          ],
          hint: Text('Choose'),
          value: alignment.value,
          onChanged: (value) {
            setState(() {
              alignment = NotusAlignment.fromString(value);
            });
          },
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Checkbox(
              value: saveRatio,
              onChanged: (value) => setState(
                () {
                  saveRatio = value;
                },
              ),
            ),
            Text('save selected image ratio')
          ],
        ),
        SizedBox(height: 16),
        RaisedButton(
          child: Text('Confirm'),
          onPressed: () {
            Navigator.pop(context, ImageData(width: width, height: height, saveRatio: saveRatio, align: alignment));
          },
        )
      ],
    );
  }
}
