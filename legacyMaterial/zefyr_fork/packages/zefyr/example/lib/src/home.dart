import 'dart:convert';

import 'package:example/src/read_only_view.dart';
import 'package:example/src/scaffold.dart';
import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zefyr/zefyr.dart';

import 'forms_decorated_field.dart';
import 'layout.dart';
import 'layout_expanded.dart';
import 'layout_scrollable.dart';
import 'settings.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ZefyrController _controller;
  final FocusNode _focusNode = FocusNode();

  Settings _settings;

  void _handleSettingsLoaded(Settings value) {
    setState(() {
      _settings = value;
      _loadFromAssets();
    });
  }

  @override
  void initState() {
    super.initState();
    Settings.load().then(_handleSettingsLoaded);
  }

  Future<void> _loadFromAssets() async {
    try {
      // final result = await rootBundle.loadString('assets/welcome.note');
      final result = await rootBundle.loadString('assets/mock_data.note');
      final doc = NotusDocument.fromJson(jsonDecode(result));
      setState(() {
        _controller = ZefyrController(doc);
      });
    } catch (error) {
      final doc = NotusDocument()..insert(0, 'Empty asset');
      setState(() {
        _controller = ZefyrController(doc);
      });
    }
  }

  Future<void> _save() async {
    final fs = LocalFileSystem();
    // final file = fs.directory(_settings.assetsPath).childFile('welcome.note');
    final file = fs.directory(_settings.assetsPath).childFile('mock_data.note');
    final data = jsonEncode(_controller.document);
    await file.writeAsString(data);
  }

  @override
  Widget build(BuildContext context) {
    if (_settings == null || _controller == null) {
      return Scaffold(body: Center(child: Text('Loading...')));
    }

    return SettingsProvider(
      settings: _settings,
      child: PageLayout(
        appBar: AppBar(
          backgroundColor: Colors.grey.shade800,
          elevation: 0,
          centerTitle: false,
          title: Text(
            'Zefyr',
            style: GoogleFonts.fondamento(color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.settings, size: 16),
              onPressed: _showSettings,
            ),
            if (_settings.assetsPath.isNotEmpty)
              IconButton(
                icon: Icon(Icons.save, size: 16),
                onPressed: _save,
              )
          ],
        ),
        menuBar: Material(
          color: Colors.grey.shade800,
          child: _buildMenuBar(context),
        ),
        body: _buildWelcomeEditor(context),
      ),
    );
  }

  void _showSettings() async {
    final result = await showSettingsDialog(context, _settings);
    if (mounted && result != null) {
      setState(() {
        _settings = result;
      });
    }
  }

  Widget _buildMenuBar(BuildContext context) {
    final headerStyle = TextStyle(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.bold);
    final itemStyle = TextStyle(color: Colors.white);
    return ListView(
      children: [
        ListTile(
          title: Text('BASIC EXAMPLES', style: headerStyle),
          // dense: true,
          visualDensity: VisualDensity.compact,
        ),
        ListTile(
          title: Text('¶   Read only view', style: itemStyle),
          dense: true,
          visualDensity: VisualDensity.compact,
          onTap: _readOnlyView,
        ),
        ListTile(
          title: Text('LAYOUT EXAMPLES', style: headerStyle),
          // dense: true,
          visualDensity: VisualDensity.compact,
        ),
        ListTile(
          title: Text('¶   Expandable', style: itemStyle),
          dense: true,
          visualDensity: VisualDensity.compact,
          onTap: _expanded,
        ),
        ListTile(
          title: Text('¶   Custom scrollable', style: itemStyle),
          dense: true,
          visualDensity: VisualDensity.compact,
          onTap: _scrollable,
        ),
        ListTile(
          title: Text('FORMS AND FIELDS EXAMPLES', style: headerStyle),
          // dense: true,
          visualDensity: VisualDensity.compact,
        ),
        ListTile(
          title: Text('¶   Decorated field', style: itemStyle),
          dense: true,
          visualDensity: VisualDensity.compact,
          onTap: _decoratedField,
        ),
      ],
    );
  }

  Widget _buildWelcomeEditor(BuildContext context) {
    return Column(
      children: [
        ZefyrToolbar.basic(
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
        Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
        Expanded(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: ZefyrEditor(
              controller: _controller,
              focusNode: _focusNode,
              autofocus: true,
              suggestionListBuilder: (trigger, value) {
                print(trigger);
                print(value);
                return Future.value([
                  Suggestions(child: Text('Mr.Oliver'), replaceText: '${trigger}Oliver', id: 0),
                  Suggestions(child: Text('Mrs.Olivia'), replaceText: '${trigger}Olivia', id: 1),
                ]);
              },
              // readOnly: true,
              // padding: EdgeInsets.only(left: 16, right: 16),
              onLaunchUrl: _launchUrl,
            ),
          ),
        ),
      ],
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

  void _launchUrl(String url) async {
    final result = await canLaunch(url);
    if (result) {
      await launch(url);
    }
  }

  void _expanded() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => SettingsProvider(
          settings: _settings,
          child: ExpandedLayout(),
        ),
      ),
    );
  }

  void _readOnlyView() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => SettingsProvider(
          settings: _settings,
          child: ReadOnlyView(),
        ),
      ),
    );
  }

  void _scrollable() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => SettingsProvider(
          settings: _settings,
          child: ScrollableLayout(),
        ),
      ),
    );
  }

  void _decoratedField() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => SettingsProvider(
          settings: _settings,
          child: DecoratedFieldDemo(),
        ),
      ),
    );
  }
}
