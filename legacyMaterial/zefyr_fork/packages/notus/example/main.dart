// Copyright (c) 2018, the Zefyr project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:notus/notus.dart';
import 'package:notus/src/models/audio_data.dart';
import 'package:notus/src/models/file_data.dart';
import 'package:notus/src/models/location_data.dart';

void main() {
  final doc = NotusDocument();
  doc.insert(
      0,
      'BoldText, ItalicText, UnderlineText, strikeThroughText, LinkedText, '
      '@MentionedPerson, &MentionedPost, #MentionedTopic, '
      '\nHeaderTextLevel1\n, \nHeaderTextLevel2\n, \nHeaderTextLevel3\n, '
      '\nBulletList\nSecondLine\n, \nNumberList\nSecondLine\n, \nQuote\nSecondLine\n, \nCode\nSecondLine\n, '
      '\nRTLText\n, \nLTRText\n, '
      '\nRightAlignText\n, \nLeftAlignText\n, \nCenterAlignText\n, \nJustifyAlignText\n, '
      'GregorianDate , SolarDate , LunarText , \nLine with indent level 1\n, '
      '\nHorizontalRule comes after this\nImage comes after this\nVideo comes after this\nFile comes after this'
      '\nAudio comes after this\nLocation comes after this\nTable comes after this');

  doc.format(0, 8, NotusAttribute.bold);
  doc.format(10, 10, NotusAttribute.italic);
  doc.format(22, 13, NotusAttribute.underline);
  doc.format(37, 17, NotusAttribute.strikethrough);
  doc.format(56, 10, NotusAttribute.link.fromString('google.com'));
  doc.format(68, 16, NotusAttribute.mentionPerson.withId(3));
  doc.format(86, 14, NotusAttribute.mentionPost.withId(10));
  doc.format(102, 15, NotusAttribute.mentionTopic.withId(12));
  doc.format(120, 16, NotusAttribute.heading.level1);
  doc.format(140, 16, NotusAttribute.heading.level2);
  doc.format(160, 16, NotusAttribute.heading.level3);
  doc.format(180, 21, NotusAttribute.ul);
  doc.format(205, 21, NotusAttribute.ol);
  doc.format(230, 16, NotusAttribute.bq);
  doc.format(250, 15, NotusAttribute.code);
  doc.format(269, 7, NotusAttribute.rtlDirection);
  doc.format(280, 7, NotusAttribute.ltrDirection);
  doc.format(291, 14, NotusAttribute.rightAlignment);
  doc.format(309, 13, NotusAttribute.leftAlignment);
  doc.format(326, 15, NotusAttribute.centerAlignment);
  doc.format(345, 16, NotusAttribute.justifyAlignment);
  doc.format(377, 1, NotusAttribute.date.gregorian(date: '20210101'));
  doc.format(389, 1, NotusAttribute.date.solar(date: '20210101'));
  doc.format(401, 1, NotusAttribute.date.lunar(date: '20210101'));
  doc.format(405, 0, NotusAttribute.indentLevel1);
  doc.replace(465, 0, BlockEmbed.horizontalRule);
  doc.replace(489, 0, BlockEmbed.image(ImageData(localPath: 'image/src')));
  doc.replace(514, 0, BlockEmbed.video(VideoData(localPath: 'video/src')));
  doc.replace(538, 0, BlockEmbed.file(FileData(localPath: 'file/src')));
  doc.replace(563, 0, BlockEmbed.audio(AudioData(localPath: 'audio/src')));
  doc.replace(591, 0, BlockEmbed.location(LocationData(latitude: '132', longitude: '434')));
  doc.replace(
      616,
      0,
      BlockEmbed.table([
        ['a', 'b'],
        ['c', 'd']
      ]));

  print(jsonEncode(doc));
  doc.close();
}
