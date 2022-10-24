import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:zefyr/src/rendering/editor.dart';
import 'editor.dart';

class MentionSuggestionOverlay {
  final BuildContext context;
  final RenderEditor renderObject;
  final Widget debugRequiredFor;
  final Future<List<Suggestions>> suggestionListBuilder;
  final TextEditingValue textEditingValue;
  final Function(int, String) suggestionSelected;
  final Widget suggestionListLoadingBuilder;
  OverlayEntry overlayEntry;

  MentionSuggestionOverlay({
    @required this.textEditingValue,
    @required this.context,
    @required this.renderObject,
    @required this.debugRequiredFor,
    @required this.suggestionListBuilder,
    this.suggestionListLoadingBuilder,
    this.suggestionSelected,
  });

  void showSuggestions() {
    overlayEntry = OverlayEntry(
        builder: (context) => _MentionSuggestionList(
              renderObject: renderObject,
              suggestionListBuilder: suggestionListBuilder,
              textEditingValue: textEditingValue,
              suggestionSelected: suggestionSelected,
          suggestionListLoadingBuilder: suggestionListLoadingBuilder,
            ));
    Overlay.of(context, rootOverlay: true, debugRequiredFor: debugRequiredFor)
        .insert(overlayEntry);
  }

  void hide() {
    overlayEntry.remove();
  }

  void updateForScroll() {
    _markNeedsBuild();
  }

  void _markNeedsBuild() {
    overlayEntry.markNeedsBuild();
  }
}

const double listMaxHeight = 200;

class _MentionSuggestionList extends StatelessWidget {
  final RenderEditor renderObject;
  final Future<List<Suggestions>> suggestionListBuilder;
  final TextEditingValue textEditingValue;
  final Function(int, String) suggestionSelected;
  final Widget suggestionListLoadingBuilder;

  const _MentionSuggestionList({
    Key key,
    @required this.renderObject,
    @required this.suggestionListBuilder,
    @required this.textEditingValue,
    this.suggestionSelected,
    this.suggestionListLoadingBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (suggestionListBuilder != null) {
      final endpoints =
      renderObject.getEndpointsForSelection(textEditingValue.selection);
      final editingRegion = Rect.fromPoints(
        renderObject.localToGlobal(Offset.zero),
        renderObject.localToGlobal(renderObject.size.bottomRight(Offset.zero)),
      );
      final baseLineHeight =
      renderObject.preferredLineHeight(textEditingValue.selection.base);
      final listMaxWidth = editingRegion.width / 2;
      final screenHeight = MediaQuery
          .of(context)
          .size
          .height;

      var positionFromTop = endpoints[0].point.dy + editingRegion.top;
      var positionFromRight = editingRegion.width - endpoints[0].point.dx;
      double positionFromLeft;

      if (positionFromTop + listMaxHeight > screenHeight) {
        positionFromTop = positionFromTop - listMaxHeight - baseLineHeight;
      }
      if (positionFromRight + listMaxWidth > editingRegion.width) {
        positionFromRight = null;
        positionFromLeft = endpoints[0].point.dx;
      }

      if (!kIsWeb) {
        return FutureBuilder(
          future: suggestionListBuilder,
          builder: (context, AsyncSnapshot<List<Suggestions>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return suggestionListLoadingBuilder ?? _buildLoading(context);
            } else if (snapshot.data.isEmpty) {
              return SizedBox.shrink();
            } else {
              return Positioned(
                bottom: MediaQuery
                    .of(context)
                    .viewInsets
                    .bottom,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: 20, maxHeight: 60),
                    child: _buildOverlayWidget(context, snapshot.data,
                        axis: Axis.horizontal),
                  ),
                ),
              );
            }
          },
        );
      } else {
        return FutureBuilder(
          future: suggestionListBuilder,
          builder: (context, AsyncSnapshot<List<Suggestions>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return suggestionListLoadingBuilder ?? SizedBox.shrink();
            } else if (snapshot.data.isEmpty) {
              return SizedBox.shrink();
            } else {
              return Positioned(
                top: positionFromTop,
                right: positionFromRight,
                left: positionFromLeft,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: listMaxWidth, maxHeight: listMaxHeight),
                  child: _buildOverlayWidget(
                      context, snapshot.data),
                ),
              );
            }
          },
        );
      }
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _buildLoading(context) {
    return Positioned(
      bottom: MediaQuery.of(context).viewInsets.bottom,
      left: 0,
      right: 0,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Card(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: 40, maxHeight: 40),
            child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  'Loading...',
                  textAlign: TextAlign.center,
                )),
          ),
        ),
      ),
    );
  }

  Widget _buildOverlayWidget(BuildContext context, List<Suggestions> suggestions,
      {axis = Axis.vertical}) {
    return Card(
      child: SingleChildScrollView(
        scrollDirection: axis,
        child: IntrinsicWidth(
          child: axis == Axis.horizontal
              ? Row(
                  children: suggestions
                      .map((key) =>
                          _buildListItem(context, key.id, key.replaceText, key.child))
                      .toList(),
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                )
              : Column(
                  children: suggestions
                      .map((key) =>
                      _buildListItem(context, key.id, key.replaceText, key.child))
                      .toList(),
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                ),
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, int id, String text, Widget child) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1),
      child: InkWell(
        onTap: () => suggestionSelected?.call(id, text),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: child ?? Text(
            text,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
