import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';
import 'package:flutter_highlight/themes/dark.dart';
import 'package:flutter_highlight/themes/docco.dart';
import 'package:flutter_highlight/themes/dracula.dart';
import 'package:flutter_highlight/themes/github-gist.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:flutter_highlight/themes/gml.dart';
import 'package:flutter_highlight/themes/googlecode.dart';
import 'package:flutter_highlight/themes/grayscale.dart';
import 'package:flutter_highlight/themes/hybrid.dart';
import 'package:flutter_highlight/themes/nord.dart';
import 'package:flutter_highlight/themes/ocean.dart';
import 'package:flutter_highlight/themes/railscasts.dart';
import 'package:flutter_highlight/themes/rainbow.dart';
import 'package:flutter_highlight/themes/routeros.dart';
import 'package:flutter_highlight/themes/school-book.dart';
import 'package:flutter_highlight/themes/sunburst.dart';
import 'package:flutter_highlight/themes/tomorrow.dart';
import 'package:flutter_highlight/themes/vs.dart';
import 'package:flutter_highlight/themes/vs2015.dart';
import 'package:flutter_highlight/themes/xcode.dart';
import 'package:highlight/languages/all.dart';
import 'package:notus/notus.dart';
import 'package:zefyr/src/util/date_util.dart';

import 'code_highlighter.dart';
import 'editable_text_line.dart';
import 'editor.dart';
import 'embed_proxy.dart';
import 'rich_text_proxy.dart';
import 'theme.dart';

/// Line of text in Zefyr editor.
///
/// This widget allows to render non-editable line of rich text, but can be
/// wrapped with [EditableTextLine] which adds editing features.
class TextLine extends StatelessWidget {
  /// Line of text represented by this widget.
  final LineNode node;
  final TextDirection textDirection;
  final ZefyrEmbedBuilder embedBuilder;
  final String totalString;

  const TextLine({
    Key key,
    @required this.node,
    this.textDirection,
    @required this.embedBuilder,
    this.totalString,
  })  : assert(node != null),
        assert(embedBuilder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));

    final textDirection = Directionality.of(context);

    if (node.hasEmbed) {
      final embed = node.children.single as EmbedNode;
      return EmbedProxy(child: embedBuilder(context, embed));
    }
    final text = buildText(context, node);
    final textAlign = getTextAlign(node);
    final strutStyle =
        StrutStyle.fromTextStyle(text.style, forceStrutHeight: true);
    return RichTextProxy(
      textStyle: text.style,
      textAlign: textAlign,
      textDirection: textDirection,
      strutStyle: strutStyle,
      locale: Localizations.localeOf(
        context,
        //nullOk: true
      ),
      child: RichText(
        text: buildText(context, node),
        textAlign: textAlign,
        textDirection: textDirection,
        strutStyle: strutStyle,
        textScaleFactor: MediaQuery.textScaleFactorOf(context),
      ),
    );
  }

  TextAlign getTextAlign(LineNode node) {
    final alignment = node.style.get(NotusAttribute.alignment);
    if (alignment == NotusAttribute.alignment.left) {
      return TextAlign.left;
    } else if (alignment == NotusAttribute.alignment.center) {
      return TextAlign.center;
    } else if (alignment == NotusAttribute.alignment.right) {
      return TextAlign.right;
    } else if (alignment == NotusAttribute.alignment.justify) {
      return TextAlign.justify;
    }
    return TextAlign.start;
  }

  TextSpan buildText(BuildContext context, LineNode node) {
    if (node.style.containsSame(NotusAttribute.block.code)) {
      final theme = ZefyrTheme.of(context);

      var lang = '';

      if (totalString.contains(RegExp(r'<?php|:php:'))) {
        lang = 'php';
      }
      if (totalString
          .contains(RegExp(r':dart:|StatefulWidget|StatelessWidget|Widget'))) {
        lang = 'dart';
      }
      if (totalString.contains(RegExp(
          r':html:|<a|<b|<i|<div|<h<|<hr|<br|<head|<html|<body|<meta'))) {
        lang = 'html';
      }
      if (totalString.contains(RegExp(r':js:|:javascript:|<script'))) {
        lang = 'js';
      }
      builtinLanguages.forEach((key, value) {
        if (totalString.contains(RegExp(r':' + key + ':'))) {
          lang = key;
        }
        return;
      });

      final children = node.children.map((node) {
        return _codeSegmentToTextSpan(context, node, theme, lang);
      }).toList(growable: false);

      return TextSpan(
        style: _getParagraphTextStyle(node.style, theme),
        children: children,
      );
    } else {
      final theme = ZefyrTheme.of(context);
      final children = node.children.map((node) {
        return _segmentToTextSpan(node, theme);
      }).toList(growable: false);
      return TextSpan(
        style: _getParagraphTextStyle(node.style, theme),
        children: children,
      );
    }
  }

  InlineSpan _segmentToTextSpan(Node node, ZefyrThemeData theme) {
    final TextNode segment = node;
    final attrs = segment.style;

    if (attrs.contains(NotusAttribute.date)) {
      return WidgetSpan(
        child: Container(
          decoration: theme.date.decoration,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: Text(
            DateUtil.formatDateFromString(attrs.get(NotusAttribute.date).value),
            style: theme.date.style,
          ),
        ),
      );
    }
    return TextSpan(
      text: segment.value,
      style: _getInlineTextStyle(attrs, theme),
    );
  }

  TextSpan _codeSegmentToTextSpan(
      context, Node node, ZefyrThemeData theme, language) {
    final TextNode segment = node;

    var editorTheme;
    switch (theme.codeSnippetStyle) {
      case CodeSnippetStyle.github:
        editorTheme = githubTheme;
        break;
      case CodeSnippetStyle.atomLight:
        editorTheme = atomOneLightTheme;
        break;
      case CodeSnippetStyle.atomDark:
        editorTheme = atomOneDarkTheme;
        break;
      case CodeSnippetStyle.sunburst:
        editorTheme = sunburstTheme;
        break;
      case CodeSnippetStyle.tomorrow:
        editorTheme = tomorrowTheme;
        break;
      case CodeSnippetStyle.rainbow:
        editorTheme = rainbowTheme;
        break;
      case CodeSnippetStyle.schoolbook:
        editorTheme = schoolBookTheme;
        break;
      case CodeSnippetStyle.nord:
        editorTheme = nordTheme;
        break;
      case CodeSnippetStyle.dark:
        editorTheme = darkTheme;
        break;
      case CodeSnippetStyle.dracula:
        editorTheme = draculaTheme;
        break;
      case CodeSnippetStyle.docCo:
        editorTheme = doccoTheme;
        break;
      case CodeSnippetStyle.gml:
        editorTheme = gmlTheme;
        break;
      case CodeSnippetStyle.github_gist:
        editorTheme = githubGistTheme;
        break;
      case CodeSnippetStyle.googleCode:
        editorTheme = googlecodeTheme;
        break;
      case CodeSnippetStyle.grayscale:
        editorTheme = grayscaleTheme;
        break;
      case CodeSnippetStyle.hybrid:
        editorTheme = hybridTheme;
        break;
      case CodeSnippetStyle.ocean:
        editorTheme = oceanTheme;
        break;
      case CodeSnippetStyle.railScasts:
        editorTheme = railscastsTheme;
        break;
      case CodeSnippetStyle.routerOs:
        editorTheme = routerosTheme;
        break;
      case CodeSnippetStyle.vs:
        editorTheme = vsTheme;
        break;
      case CodeSnippetStyle.xCode:
        editorTheme = xcodeTheme;
        break;
      case CodeSnippetStyle.vs2015:
        editorTheme = vs2015Theme;
        break;
    }
    return HighlightView(
      segment.value,
      theme: editorTheme,
      language: language,
    ).toTextSpan;
  }

  TextStyle _getParagraphTextStyle(NotusStyle style, ZefyrThemeData theme) {
    var textStyle = TextStyle();
    final heading = node.style.get(NotusAttribute.heading);
    if (heading == NotusAttribute.heading.level1) {
      textStyle = textStyle.merge(theme.heading1.style);
    } else if (heading == NotusAttribute.heading.level2) {
      textStyle = textStyle.merge(theme.heading2.style);
    } else if (heading == NotusAttribute.heading.level3) {
      textStyle = textStyle.merge(theme.heading3.style);
    } else {
      textStyle = textStyle.merge(theme.paragraph.style);
    }

    final block = style.get(NotusAttribute.block);
    if (block == NotusAttribute.block.quote) {
      textStyle = textStyle.merge(theme.quote.style);
    } else if (block == NotusAttribute.block.code) {
      textStyle = textStyle.merge(theme.code.style);
    } else if (block != null) {
      // lists
      textStyle = textStyle.merge(theme.lists.style);
    }

    return textStyle;
  }

  TextStyle _getInlineTextStyle(NotusStyle style, ZefyrThemeData theme) {
    var result = TextStyle();
    if (style.containsSame(NotusAttribute.bold)) {
      result = _mergeTextStyleWithDecoration(result, theme.bold);
    }
    if (style.containsSame(NotusAttribute.italic)) {
      result = _mergeTextStyleWithDecoration(result, theme.italic);
    }
    if (style.contains(NotusAttribute.link)) {
      result = _mergeTextStyleWithDecoration(result, theme.link);
    }
    if (style.contains(NotusAttribute.mentionTopic)) {
      result = _mergeTextStyleWithDecoration(result, theme.link);
    }
    if (style.contains(NotusAttribute.mentionPost)) {
      result = _mergeTextStyleWithDecoration(result, theme.link);
    }
    if (style.contains(NotusAttribute.mentionPerson)) {
      result = _mergeTextStyleWithDecoration(result, theme.link);
    }
    if (style.contains(NotusAttribute.underline)) {
      result = _mergeTextStyleWithDecoration(result, theme.underline);
    }
    if (style.contains(NotusAttribute.strikethrough)) {
      result = _mergeTextStyleWithDecoration(result, theme.strikethrough);
    }
    return result;
  }

  TextStyle _mergeTextStyleWithDecoration(TextStyle a, TextStyle b) {
    var decorations = <TextDecoration>[];
    if (a.decoration != null) {
      decorations.add(a.decoration);
    }
    if (b.decoration != null) {
      decorations.add(b.decoration);
    }
    return a.merge(b).apply(decoration: TextDecoration.combine(decorations));
  }
}
