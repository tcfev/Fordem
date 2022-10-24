import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zefyr/zefyr.dart';

import 'scaffold.dart';

class ReadOnlyView extends StatefulWidget {
  @override
  _ReadOnlyViewState createState() => _ReadOnlyViewState();
}

class _ReadOnlyViewState extends State<ReadOnlyView> {
  final FocusNode _focusNode = FocusNode();

  bool _edit = false;

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      documentFilename: 'basics_read_only_view.note',
      builder: _buildContent,
      showToolbar: _edit == true,
      floatingActionButton: FloatingActionButton.extended(
          label: Text(_edit == true ? 'Done' : 'Edit'),
          onPressed: _toggleEdit,
          icon: Icon(_edit == true ? Icons.check : Icons.edit)),
    );
  }

  Widget _buildContent(BuildContext context, ZefyrController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: ZefyrTheme(
          data: ZefyrThemeData(
            codeSnippetStyle: CodeSnippetStyle.sunburst,
            code: TextBlockTheme(
              spacing: VerticalSpacing(top: 4, bottom: 4),
              style: TextStyle(color: Colors.white, fontSize: 14),
              decoration: BoxDecoration(
                color: Colors.blue[900]
              )
            )
          ),
          child: ZefyrEditor(
            controller: controller,
            focusNode: _focusNode,
            autofocus: true,
            expands: true,
            readOnly: !_edit,
            onLaunchUrl: (url) {
              launch(url);
            },
            onMentionClicked: (id, value) {
              print(id.toString() + value.toString());
            },
            suggestionListBuilder: (trigger, value) {
              if (trigger == '&') {
                return Future.value([
                  Suggestions(
                      child: Text('The Article about jack'),
                      replaceText: '&Jack Articles',
                      id: 1),
                  Suggestions(
                      child: Text('Jack & Bin Story'),
                      replaceText: '&Jack And Bin',
                      id: 2),
                ]);
              } else {
                return Future.value([
                  Suggestions(
                      child: Text('Mr.Oliver'),
                      replaceText: '${trigger}Oliver',
                      id: 0),
                  Suggestions(
                      child: Text('Mrs.Olivia'),
                      replaceText: '${trigger}Olivia',
                      id: 1),
                ]);
              }
            },
            showCursor: _edit,
            padding: EdgeInsets.symmetric(horizontal: 8),
          ),
        ),
      ),
    );
  }

  void _toggleEdit() {
    setState(() {
      _edit = !_edit;
    });
  }
}
