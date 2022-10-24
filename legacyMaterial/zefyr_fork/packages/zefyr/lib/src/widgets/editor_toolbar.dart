import 'package:intl/intl.dart';

import 'package:emojis/emoji.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:notus/notus.dart';
import 'package:solar_datepicker/solar_datepicker.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:zefyr/zefyr.dart';

import 'controller.dart';
import '../util/date_util.dart';
import '../util/embed_util.dart';

typedef embedButtonsBuilder = Widget Function(EmbedType type, Widget child);
typedef dateItemBuilder = Widget Function(DateType type, Widget child);

const double kToolbarHeight = 56.0;

class EmojiPicker extends StatefulWidget {
  final ZefyrController controller;
  final IconData icon;

  const EmojiPicker({Key key, this.controller, this.icon}) : super(key: key);

  @override
  _EmojiPickerState createState() => _EmojiPickerState();
}

class _EmojiPickerState extends State<EmojiPicker> {
  void _didChangeSelection() {
    setState(() {});
  }

  void addEmojiToTheLine(emoji) {
    // Navigator.of(context).pop();
    var controller = widget.controller;
    final index = controller.selection.baseOffset;
    final length = controller.selection.extentOffset - index;
    controller.replaceText(index, length, emoji);
    FocusScope.of(context).requestFocus(FocusNode());
  }

  IconButton _buildEmoji(emoji) {
    return IconButton(
      splashRadius: 18,
      icon: Text(
        emoji,
        style: TextStyle(fontSize: 20),
      ),
      onPressed: () => addEmojiToTheLine(emoji),
    );
  }

  List<Emoji> peopleEmojies = [];
  List<Emoji> foodEmojies = [];
  List<Emoji> flagsEmojies = [];
  List<Emoji> activitiesEmojies = [];

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_didChangeSelection);
    addEmojis();
  }

  void addEmojis() {
    peopleEmojies = Emoji.byGroup(EmojiGroup.smileysEmotion).toList();
    foodEmojies = Emoji.byGroup(EmojiGroup.foodDrink).toList();
    flagsEmojies = Emoji.byGroup(EmojiGroup.flags).toList();
    activitiesEmojies = Emoji.byGroup(EmojiGroup.activities).toList();
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.controller.getSelectionStyle();
    final isInCodeBlock = style.containsSame(NotusAttribute.block.code);
    final isInMention = style.contains(NotusAttribute.mentionPost) ||
        style.contains(NotusAttribute.mentionPerson) ||
        style.contains(NotusAttribute.mentionTopic);
    final isInDate = style.contains(NotusAttribute.date);
    final isEnabled = !isInCodeBlock && !isInDate && !isInMention;

    final theme = Theme.of(context);
    return ZIconButton(
      highlightElevation: 0,
      hoverElevation: 0,
      size: 32,
      icon: Icon(
        widget.icon,
        size: 18,
        color: isEnabled ? theme.iconTheme.color : theme.disabledColor,
      ),
      fillColor: theme.canvasColor,
      onPressed: isEnabled
          ? () {
              showMaterialModalBottomSheet(
                context: context,
                enableDrag: false,
                barrierColor: Colors.transparent,
                backgroundColor: Colors.grey[100],
                bounce: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                builder: (context) {
                  return Container(
                    constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 3),
                    padding: EdgeInsets.all(8),
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          /// People
                          SizedBox(
                            height: 8,
                          ),
                          Row(mainAxisSize: MainAxisSize.max, children: [
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              'People',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          ]),
                          Wrap(
                            spacing: 3,
                            runSpacing: 3,
                            children: [
                              for (var i = 0; i < peopleEmojies.length; i++) ...[_buildEmoji(peopleEmojies[i].char)]
                            ],
                          ),

                          /// Foods
                          SizedBox(
                            height: 8,
                          ),
                          Row(mainAxisSize: MainAxisSize.max, children: [
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              'Foods',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          ]),
                          Wrap(
                            spacing: 3,
                            runSpacing: 3,
                            children: [
                              for (var i = 0; i < foodEmojies.length; i++) ...[_buildEmoji(foodEmojies[i].char)]
                            ],
                          ),

                          /// Flags
                          SizedBox(
                            height: 8,
                          ),
                          Row(mainAxisSize: MainAxisSize.max, children: [
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              'Flags',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          ]),
                          Wrap(
                            spacing: 3,
                            runSpacing: 3,
                            children: [
                              for (var i = 0; i < flagsEmojies.length; i++) ...[_buildEmoji(flagsEmojies[i].char)]
                            ],
                          ),

                          /// activitiesEmojies
                          SizedBox(
                            height: 8,
                          ),
                          Row(mainAxisSize: MainAxisSize.max, children: [
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              'Activities',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          ]),
                          Wrap(
                            spacing: 3,
                            runSpacing: 3,
                            children: [
                              for (var i = 0; i < activitiesEmojies.length; i++) ...[
                                _buildEmoji(activitiesEmojies[i].char)
                              ]
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          : null,
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(_didChangeSelection);
    super.dispose();
  }
}

class InsertDateButton extends StatefulWidget {
  final ZefyrController controller;
  final IconData icon;
  final dateItemBuilder dateBuilder;

  const InsertDateButton({
    Key key,
    this.controller,
    this.icon,
    this.dateBuilder,
  }) : super(key: key);

  @override
  _InsertDateButtonState createState() => _InsertDateButtonState();
}

class _InsertDateButtonState extends State<InsertDateButton> {
  void _didChangeSelection() {
    setState(() {});
  }

  @override
  void initState() {
    widget.controller.addListener(_didChangeSelection);
    super.initState();
  }

  void pickGregorianDate(BuildContext context) async {
    final date = await showDialog<DateTime>(
      context: context,
      builder: (context) => SfDateRangePicker(
        initialSelectedRange: PickerDateRange(
          DateTime.now().subtract(Duration(days: 3650)),
          DateTime.now().add(Duration(days: 3650)),
        ),
        initialSelectedDate: DateTime.now(),
        selectionMode: DateRangePickerSelectionMode.single,
        onSelectionChanged: (selected) {
          Navigator.pop(context, selected.value);
        },
        showNavigationArrow: true,
        backgroundColor: Colors.white,
        headerHeight: 80,
      ),
    );
    if (date != null) {
      addDateToDocument(date);
    }
  }

  void pickLunarDate(BuildContext context) async {
    final date = await showDialog<DateTime>(
      context: context,
      builder: (context) => SfHijriDateRangePicker(
        initialSelectedRanges: [
          HijriDateRange(
            HijriDateTime.now().subtract(Duration(days: 3650)),
            HijriDateTime.now().add(Duration(days: 3650)),
          )
        ],
        initialSelectedDate: HijriDateTime.now(),
        selectionMode: DateRangePickerSelectionMode.single,
        onSelectionChanged: (selected) {
          Navigator.pop(context, convertToGregorianDate(selected.value));
        },
        showNavigationArrow: true,
        backgroundColor: Colors.white,
        headerHeight: 80,
      ),
    );
    if (date != null) {
      addDateToDocument(date);
    }
  }

  void pickSolarDate(BuildContext context) async {
    final date = await showSolarDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 100 * 365)),
      lastDate: DateTime.now().add(Duration(days: 100 * 365)),
      isPersian: true,
      builder: (context, child) => Column(
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: 400, maxHeight: 600),
            child: child,
          ),
        ],
      ),
      initialDatePickerMode: SolarDatePickerMode.day,
    );
    if (date != null) {
      addDateToDocument(date);
    }
  }

  void addDateToDocument(DateTime date) {
    final formatter = DateFormat('yyyyMMdd');
    final index = widget.controller.selection.baseOffset;
    // to insert date, insert !-Date-! for identifying.
    widget.controller.document.insert(index, '!-Date-!');
    widget.controller.formatText(index, 1, NotusAttribute.date.solar(date: formatter.format(date)));
  }

  void _handleOnTypeSelected(DateType type, BuildContext context) async {
    switch (type) {
      case DateType.gregorian:
        pickGregorianDate(context);
        break;
      case DateType.solar:
        pickSolarDate(context);
        break;
      case DateType.lunar:
        pickLunarDate(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = widget.controller.getSelectionStyle();
    final isInMention = style.contains(NotusAttribute.mentionPost) ||
        style.contains(NotusAttribute.mentionPerson) ||
        style.contains(NotusAttribute.mentionTopic);
    final isInCodeBlock = style.containsSame(NotusAttribute.block.code);
    final isInDate = style.contains(NotusAttribute.date);
    final isEnabled = !isInCodeBlock && !isInMention && !isInDate;

    final dateTypes = <String>['Gregorian (ad)', 'Solar (Shamsi)', 'Lunar (Hijri)'];

    final child = Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Icon(
        widget.icon,
        size: 18,
        color: isEnabled ? theme.iconTheme.color : theme.disabledColor,
      ),
    );
    return isEnabled
        ? PopupMenuButton<DateType>(
            itemBuilder: (BuildContext context) => dateTypes.map(
                  (item) {
                    final type = DateType.gregorian.get(dateTypes.indexOf(item));
                    final child = Text(
                      item,
                      style: TextStyle(color: Colors.black),
                    );
                    return PopupMenuItem<DateType>(
                      value: type,
                      child: widget.dateBuilder != null && widget.dateBuilder(type, child) != null
                          ? widget.dateBuilder(type, child)
                          : child,
                    );
                  },
                ).toList(),
            onSelected: (selected) {
              _handleOnTypeSelected(selected, context);
            },
            child: child)
        : child;
  }

  @override
  void dispose() {
    widget.controller.removeListener(_didChangeSelection);
    super.dispose();
  }
}

class InsertHorizontalRuleButton extends StatefulWidget {
  final ZefyrController controller;
  final IconData icon;

  const InsertHorizontalRuleButton({
    Key key,
    @required this.controller,
    @required this.icon,
  }) : super(key: key);

  @override
  _InsertHorizontalRuleButtonState createState() => _InsertHorizontalRuleButtonState();
}

class _InsertHorizontalRuleButtonState extends State<InsertHorizontalRuleButton> {
  void _didChangeSelection() {
    setState(() {});
  }

  @override
  void initState() {
    widget.controller.addListener(_didChangeSelection);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = widget.controller.getSelectionStyle();
    final isInMention = style.contains(NotusAttribute.mentionPost) ||
        style.contains(NotusAttribute.mentionPerson) ||
        style.contains(NotusAttribute.mentionTopic);
    final isInBlockCode = style.containsSame(NotusAttribute.block.code);
    final isInDate = style.contains(NotusAttribute.date);
    final isEnabled = !isInBlockCode && !isInMention && !isInDate;

    return ZIconButton(
      highlightElevation: 0,
      hoverElevation: 0,
      size: 32,
      icon: Icon(
        widget.icon,
        size: 18,
        color: isEnabled ? theme.iconTheme.color : theme.disabledColor,
      ),
      fillColor: theme.canvasColor,
      onPressed: isEnabled
          ? () {
              final index = widget.controller.selection.baseOffset;
              final length = widget.controller.selection.extentOffset - index;
              widget.controller.replaceText(index, length, BlockEmbed.horizontalRule);
            }
          : null,
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(_didChangeSelection);
    super.dispose();
  }
}

/// Toolbar button for formatting text as a link.
class LinkStyleButton extends StatefulWidget {
  final ZefyrController controller;
  final IconData icon;
  final VoidCallback onDisabledClick;

  const LinkStyleButton({
    Key key,
    @required this.controller,
    this.onDisabledClick,
    this.icon,
  }) : super(key: key);

  @override
  _LinkStyleButtonState createState() => _LinkStyleButtonState();
}

class _LinkStyleButtonState extends State<LinkStyleButton> {
  void _didChangeSelection() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_didChangeSelection);
  }

  @override
  void didUpdateWidget(covariant LinkStyleButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_didChangeSelection);
      widget.controller.addListener(_didChangeSelection);
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(_didChangeSelection);
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.controller.getSelectionStyle();
    final isInCodeBlock = style.containsSame(NotusAttribute.block.code);
    final isInMention = style.contains(NotusAttribute.mentionPost) ||
        style.contains(NotusAttribute.mentionPerson) ||
        style.contains(NotusAttribute.mentionTopic);
    final isInDate = style.contains(NotusAttribute.date);
    final isEnabled = !widget.controller.selection.isCollapsed && !isInDate && !isInCodeBlock && !isInMention;

    final theme = Theme.of(context);
    final pressAction = widget.controller.getSelectionStyle().contains(NotusAttribute.link)
        ? () => _removeLink()
        : () => _openLinkDialog(context);
    final pressedHandler = isEnabled ? pressAction : widget.onDisabledClick;
    return ZIconButton(
      highlightElevation: 0,
      hoverElevation: 0,
      size: 32,
      icon: Icon(
        widget.icon ?? Icons.link,
        size: 18,
        color: isEnabled ? theme.iconTheme.color : theme.disabledColor,
      ),
      fillColor: Theme.of(context).canvasColor,
      onPressed: pressedHandler,
    );
  }

  void _openLinkDialog(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (_) {
        return _LinkDialog();
      },
    ).then(_linkSubmitted);
  }

  void _removeLink() {
    widget.controller.formatSelection(NotusAttribute.link.unset);
  }

  void _linkSubmitted(String value) {
    if (value == null || value.isEmpty) return;
    widget.controller.formatSelection(NotusAttribute.link.fromString(value));
  }
}

class _LinkDialog extends StatefulWidget {
  const _LinkDialog({Key key}) : super(key: key);

  @override
  _LinkDialogState createState() => _LinkDialogState();
}

class _LinkDialogState extends State<_LinkDialog> {
  String _link = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: TextField(
        decoration: InputDecoration(labelText: 'Paste a link', contentPadding: EdgeInsets.zero),
        autofocus: true,
        onChanged: _linkChanged,
      ),
      contentPadding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
      actions: [
        FlatButton(
          onPressed: _link.isNotEmpty ? _applyLink : null,
          child: Text('Apply'),
        ),
      ],
    );
  }

  void _linkChanged(String value) {
    setState(() {
      _link = value;
    });
  }

  void _applyLink() {
    Navigator.pop(context, _link);
  }
}

enum EmbedType { image, video, file, audio, location }

// Toolbar button for embed file inside of text.
class EmbedButton extends StatefulWidget {
  final ZefyrController controller;

  final EmbeddingOptions embeddingOptions;

  const EmbedButton({
    Key key,
    this.controller,
    this.embeddingOptions = const EmbeddingOptions(),
  })  : assert(embeddingOptions != null),
        super(key: key);

  @override
  _EmbedButtonState createState() => _EmbedButtonState();
}

class _EmbedButtonState extends State<EmbedButton> {
  void _didChangeSelection() {
    setState(() {});
  }

  @override
  void initState() {
    widget.controller.addListener(_didChangeSelection);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final style = widget.controller.getSelectionStyle();
    final isInCodeBlock = style.containsSame(NotusAttribute.block.code);
    final isInDate = style.contains(NotusAttribute.date);
    final isInMention = style.contains(NotusAttribute.mentionPost) ||
        style.contains(NotusAttribute.mentionPerson) ||
        style.contains(NotusAttribute.mentionTopic);
    final isEnabled = !isInCodeBlock && !isInDate && !isInDate && !isInMention;

    return ZIconButton(
      highlightElevation: 0,
      hoverElevation: 0,
      size: 32,
      icon: Icon(
        Icons.attach_file,
        size: 18,
        color: isEnabled ? theme.iconTheme.color : theme.disabledColor,
      ),
      fillColor: Theme.of(context).canvasColor,
      onPressed: isEnabled ? () => _openSelectEmbedTypeDialog(context) : null,
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(_didChangeSelection);
    super.dispose();
  }

  void _openSelectEmbedTypeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return _SelectEmbedType(
          embeddingOptions: widget.embeddingOptions,
          controller: widget.controller,
        );
      },
    );
  }
}

class _SelectEmbedType extends StatelessWidget {
  final ZefyrController controller;

  final EmbeddingOptions embeddingOptions;

  const _SelectEmbedType({
    Key key,
    @required this.controller,
    @required this.embeddingOptions,
  }) : super(key: key);

  void _handleImageButtonPress(BuildContext context) async {
    Navigator.pop(context);
    if (kIsWeb) {
      final _results = await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.image, withData: false);

      if (_results != null) {
        _results.files.reversed.forEach((file) {
          _handlePickedFile(file.path, EmbedType.image);
        });
      }
    } else {
      var source;
      if (embeddingOptions.embedPickSourceChooser != null) {
        source = embeddingOptions.embedPickSourceChooser();
      } else {
        source = await showDialog(
          context: context,
          builder: (_) => PickImageDialog(
            controller: controller,
          ),
        );
      }
      if (source != null) {
        _pickImage(source);
      }
    }
  }

  void _handleVideoButtonPress(BuildContext context) async {
    Navigator.pop(context);
    if (kIsWeb) {
      final _results = await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.video, withData: false);
      if (_results != null) {
        _results.files.reversed.forEach((file) {
          _handlePickedFile(file.path, EmbedType.video);
        });
      }
    } else {
      var source;

      if (embeddingOptions.embedPickSourceChooser != null) {
        source = embeddingOptions.embedPickSourceChooser();
      } else {
        source = await showDialog(
          context: context,
          builder: (_) => PickVideoDialog(
            controller: controller,
          ),
        );
      }
      if (source != null) {
        _pickVideo(source);
      }
    }
  }

  void _handleFileButtonPress(BuildContext context) async {
    Navigator.pop(context);
    final _results = await FilePicker.platform.pickFiles(allowMultiple: true, withData: false, type: FileType.any);
    if (_results != null) {
      _results.files.reversed.forEach((file) {
        final mimeType = lookupMimeType(file.path);
        _handlePickedFile(
          file.path,
          mimeType.isImage
              ? EmbedType.image
              : mimeType.isVideo
                  ? EmbedType.video
                  : mimeType.isAudio
                      ? EmbedType.audio
                      : EmbedType.file,
        );
      });
    }
  }

  void _handleAudioButtonPress(BuildContext context) async {
    Navigator.pop(context);
    final _results = await FilePicker.platform.pickFiles(allowMultiple: true, withData: false, type: FileType.audio);
    if (_results != null) {
      _results.files.reversed.forEach((file) {
        _handlePickedFile(
          file.path,
          EmbedType.audio,
        );
      });
    }
  }

  void _handleLocationButtonPressed(BuildContext context) async {
    Navigator.pop(context);
    if (embeddingOptions.embeddingPickActions.onPickLocation != null) {
      final _results = await embeddingOptions.embeddingPickActions.onPickLocation();

      if (_results != null) {
        _addFileToController(BlockEmbed.location(_results));
      }
    }
  }

  void _pickImage(ImageSource source) async {
    final _picker = ImagePicker();
    final _pickedImage = await _picker.getImage(source: source);

    if (_pickedImage != null) {
      _handlePickedFile(_pickedImage.path, EmbedType.image);
    }
  }

  void _pickVideo(ImageSource source) async {
    final _picker = ImagePicker();
    final _pickedVideo = await _picker.getVideo(source: source);

    if (_pickedVideo != null) {
      _handlePickedFile(_pickedVideo.path, EmbedType.video);
    }
  }

  void _handlePickedFile(String path, EmbedType type) async {
    ImageData imageData;
    VideoData videoData;
    FileData fileData;
    AudioData audioData;
    if (type == EmbedType.image && embeddingOptions.embeddingPickActions.onImagePicked != null) {
      imageData = await embeddingOptions.embeddingPickActions.onImagePicked(path);
    } else if (type == EmbedType.video && embeddingOptions.embeddingPickActions.onVideoPicked != null) {
      videoData = await embeddingOptions.embeddingPickActions.onVideoPicked(path);
    } else if (type == EmbedType.file && embeddingOptions.embeddingPickActions.onFilePicked != null) {
      fileData = await embeddingOptions.embeddingPickActions.onFilePicked(path);
    } else if (type == EmbedType.audio && embeddingOptions.embeddingPickActions.onAudioPicked != null) {
      audioData = await embeddingOptions.embeddingPickActions.onAudioPicked(path);
    }

    _addFileToController(type == EmbedType.image
        ?BlockEmbed.image(imageData ?? ImageData(localPath: path))
        : type == EmbedType.video
            ? BlockEmbed.video(videoData ?? VideoData(localPath: path))
            : type == EmbedType.file
                ? BlockEmbed.file(fileData ?? FileData(localPath: path))
                : BlockEmbed.audio(audioData ?? AudioData(localPath: path)));
  }

  void _addFileToController(BlockEmbed embed) {
    final index = controller.selection.baseOffset;
    final length = controller.selection.extentOffset - index;
    controller.replaceText(
      index,
      length,
      embed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Wrap(
        alignment: WrapAlignment.center,
        children: [
          _buildButton(
            type: EmbedType.image,
            context: context,
            onPressed: () => _handleImageButtonPress(context),
          ),
          _buildButton(
            type: EmbedType.video,
            context: context,
            onPressed: () => _handleVideoButtonPress(context),
          ),
          _buildButton(
            type: EmbedType.file,
            context: context,
            onPressed: () => _handleFileButtonPress(context),
          ),
          _buildButton(
            type: EmbedType.audio,
            context: context,
            onPressed: () => _handleAudioButtonPress(context),
          ),
          _buildButton(
            type: EmbedType.location,
            context: context,
            onPressed: () => _handleLocationButtonPressed(context),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    @required VoidCallback onPressed,
    @required EmbedType type,
    @required BuildContext context,
  }) {
    IconData icon;
    String text;
    switch (type) {
      case EmbedType.file:
        icon = Icons.insert_drive_file;
        text = 'File';
        break;
      case EmbedType.video:
        icon = Icons.video_library;
        text = 'Video';
        break;
      case EmbedType.image:
        icon = Icons.image;
        text = 'Image';
        break;
      case EmbedType.audio:
        icon = Icons.audiotrack;
        text = 'Audio';
        break;
      case EmbedType.location:
        icon = Icons.location_on;
        text = 'Location';
        break;
    }

    Widget child = ClipOval(
      child: SizedBox(
        width: 80,
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon),
            Text(text),
          ],
        ),
      ),
    );

    return Semantics(
      button: true,
      enabled: onPressed != null,
      child: InkResponse(
        canRequestFocus: onPressed != null,
        onTap: onPressed,
        mouseCursor: SystemMouseCursors.click,
        child: embeddingOptions.embedBuilder != null && embeddingOptions.embedBuilder(type, child) != null
            ? embeddingOptions.embedBuilder(type, child)
            : child,
      ),
    );
  }
}

/// Dialog to pick image from device.
class PickImageDialog extends StatelessWidget {
  final ZefyrController controller;

  const PickImageDialog({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Semantics(
            button: true,
            enabled: true,
            child: InkResponse(
              canRequestFocus: true,
              onTap: () => Navigator.pop(context, ImageSource.gallery),
              mouseCursor: SystemMouseCursors.click,
              child: ClipOval(
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [Icon(Icons.photo_library), Text('Gallery')],
                  ),
                ),
              ),
            ),
          ),
          Semantics(
            button: true,
            enabled: true,
            child: InkResponse(
              canRequestFocus: true,
              onTap: () => Navigator.pop(context, ImageSource.camera),
              mouseCursor: SystemMouseCursors.click,
              child: ClipOval(
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [Icon(Icons.camera_alt), Text('Camera')],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Dialog to pick video from device.
class PickVideoDialog extends StatelessWidget {
  final ZefyrController controller;

  const PickVideoDialog({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Semantics(
            button: true,
            enabled: true,
            child: InkResponse(
              canRequestFocus: true,
              onTap: () => Navigator.pop(context, ImageSource.gallery),
              mouseCursor: SystemMouseCursors.click,
              child: ClipOval(
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [Icon(Icons.video_library), Text('Gallery')],
                  ),
                ),
              ),
            ),
          ),
          Semantics(
            button: true,
            enabled: true,
            child: InkResponse(
              canRequestFocus: true,
              onTap: () => Navigator.pop(context, ImageSource.camera),
              mouseCursor: SystemMouseCursors.click,
              child: ClipOval(
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [Icon(Icons.camera_alt), Text('Camera')],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Builder for toolbar buttons handling toggleable style attributes.
///
/// See [defaultToggleStyleButtonBuilder] as a reference implementation.
typedef ToggleStyleButtonBuilder = Widget Function(
  BuildContext context,
  NotusAttribute attribute,
  IconData icon,
  bool isToggled,
  VoidCallback onPressed,
);

/// Toolbar button which allows to toggle a style attribute on or off.
class ToggleStyleButton extends StatefulWidget {
  /// The style attribute controlled by this button.
  final NotusAttribute attribute;

  /// The icon representing the style [attribute].
  final IconData icon;

  /// Controller attached to a Zefyr editor.
  final ZefyrController controller;

  /// Builder function to customize visual representation of this button.
  final ToggleStyleButtonBuilder childBuilder;

  ToggleStyleButton({
    Key key,
    @required this.attribute,
    @required this.icon,
    @required this.controller,
    this.childBuilder = defaultToggleStyleButtonBuilder,
  })  : assert(!attribute.isUnset),
        assert(icon != null),
        assert(controller != null),
        assert(childBuilder != null),
        super(key: key);

  @override
  _ToggleStyleButtonState createState() => _ToggleStyleButtonState();
}

class _ToggleStyleButtonState extends State<ToggleStyleButton> {
  bool _isToggled;

  NotusStyle get _selectionStyle => widget.controller.getSelectionStyle();

  void _didChangeEditingValue() {
    setState(() {
      _isToggled = widget.controller.getSelectionStyle().containsSame(widget.attribute);
    });
  }

  @override
  void initState() {
    super.initState();
    _isToggled = _selectionStyle.containsSame(widget.attribute);
    widget.controller.addListener(_didChangeEditingValue);
  }

  @override
  void didUpdateWidget(covariant ToggleStyleButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_didChangeEditingValue);
      widget.controller.addListener(_didChangeEditingValue);
      _isToggled = _selectionStyle.containsSame(widget.attribute);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_didChangeEditingValue);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If the cursor is currently inside a code block we disable all
    // toggle style buttons (except the code block button itself) since there
    // is no point in applying styles to a unformatted block of text.
    // TODO: Add code block checks to heading and embed buttons as well.
    final isInCodeBlock = _selectionStyle.containsSame(NotusAttribute.block.code);
    final isEnabled = (!isInCodeBlock || widget.attribute == NotusAttribute.block.code) &&
        !_selectionStyle.contains(NotusAttribute.date);
    return widget.childBuilder(context, widget.attribute, widget.icon, _isToggled, isEnabled ? _toggleAttribute : null);
  }

  void _toggleAttribute() {
    if (_isToggled) {
      widget.controller.formatSelection(widget.attribute.unset);
    } else {
      widget.controller.formatSelection(widget.attribute);
    }
  }
}

/// Default builder for toggle style buttons.
Widget defaultToggleStyleButtonBuilder(
  BuildContext context,
  NotusAttribute attribute,
  IconData icon,
  bool isToggled,
  VoidCallback onPressed,
) {
  final theme = Theme.of(context);
  final isEnabled = onPressed != null;
  final iconColor = isEnabled
      ? isToggled
          ? theme.primaryIconTheme.color
          : theme.iconTheme.color
      : theme.disabledColor;
  final fillColor = isToggled ? theme.toggleableActiveColor : theme.canvasColor;
  return ZIconButton(
    highlightElevation: 0,
    hoverElevation: 0,
    size: 32,
    icon: Icon(icon, size: 18, color: iconColor),
    fillColor: fillColor,
    onPressed: onPressed,
  );
}

/// Toolbar button which allows to apply heading style to a line of text in
/// Zefyr editor.
///
/// Works as a dropdown menu button.
// TODO: Add "dense" parameter which if set to true changes the button to use an icon instead of text (useful for mobile layouts)
class SelectHeadingStyleButton extends StatefulWidget {
  final ZefyrController controller;

  const SelectHeadingStyleButton({Key key, @required this.controller}) : super(key: key);

  @override
  _SelectHeadingStyleButtonState createState() => _SelectHeadingStyleButtonState();
}

class _SelectHeadingStyleButtonState extends State<SelectHeadingStyleButton> {
  NotusAttribute _value;

  NotusStyle get _selectionStyle => widget.controller.getSelectionStyle();

  void _didChangeEditingValue() {
    setState(() {
      _value = _selectionStyle.get(NotusAttribute.heading) ?? NotusAttribute.heading.unset;
    });
  }

  void _selectAttribute(value) {
    widget.controller.formatSelection(value);
  }

  @override
  void initState() {
    super.initState();
    _value = _selectionStyle.get(NotusAttribute.heading) ?? NotusAttribute.heading.unset;
    widget.controller.addListener(_didChangeEditingValue);
  }

  @override
  void didUpdateWidget(covariant SelectHeadingStyleButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_didChangeEditingValue);
      widget.controller.addListener(_didChangeEditingValue);
      _value = _selectionStyle.get(NotusAttribute.heading) ?? NotusAttribute.heading.unset;
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_didChangeEditingValue);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.controller.getSelectionStyle();
    final isInCodeBlock = style.containsSame(NotusAttribute.block.code);
    final isInDate = style.contains(NotusAttribute.date);
    final isEnabled = !isInCodeBlock && !isInDate;

    return _selectHeadingStyleButtonBuilder(context, _value, _selectAttribute, isEnabled);
  }
}

Widget _selectHeadingStyleButtonBuilder(
    BuildContext context, NotusAttribute value, ValueChanged<NotusAttribute> onSelected, bool enable) {
  final theme = Theme.of(context);
  final style = TextStyle(fontSize: 12);

  final valueToText = {
    NotusAttribute.heading.unset: 'Normal text',
    NotusAttribute.heading.level1: 'Heading 1',
    NotusAttribute.heading.level2: 'Heading 2',
    NotusAttribute.heading.level3: 'Heading 3',
  };

  return ZDropdownButton<NotusAttribute>(
    highlightElevation: 0,
    hoverElevation: 0,
    height: 32,
    enable: enable,
    child: Text(
      valueToText[value],
      style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: enable ? theme.textTheme.bodyText1.color : theme.disabledColor),
    ),
    initialValue: value,
    items: [
      PopupMenuItem(
        child: Text(valueToText[NotusAttribute.heading.unset], style: style),
        value: NotusAttribute.heading.unset,
        height: 32,
      ),
      PopupMenuItem(
        child: Text(valueToText[NotusAttribute.heading.level1], style: style),
        value: NotusAttribute.heading.level1,
        height: 32,
      ),
      PopupMenuItem(
        child: Text(valueToText[NotusAttribute.heading.level2], style: style),
        value: NotusAttribute.heading.level2,
        height: 32,
      ),
      PopupMenuItem(
        child: Text(valueToText[NotusAttribute.heading.level3], style: style),
        value: NotusAttribute.heading.level3,
        height: 32,
      ),
    ],
    onSelected: onSelected,
  );
}

class IndentationButton extends StatefulWidget {
  final bool increase;
  final ZefyrController controller;

  const IndentationButton({Key key, this.increase = true, @required this.controller}) : super(key: key);

  @override
  _IndentationButtonState createState() => _IndentationButtonState();
}

class _IndentationButtonState extends State<IndentationButton> {
  NotusStyle get _selectionStyle => widget.controller.getSelectionStyle();

  void _didChangeSelection() {
    setState(() {});
  }

  @override
  void initState() {
    widget.controller.addListener(_didChangeSelection);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.controller.getSelectionStyle();
    final isInCodeBlock = style.containsSame(NotusAttribute.block.code);
    final isInDate = style.contains(NotusAttribute.date);
    final isEnabled = !isInCodeBlock && !isInDate;

    final theme = Theme.of(context);
    final fillColor = theme.canvasColor;
    return ZIconButton(
      highlightElevation: 0,
      hoverElevation: 0,
      size: 32,
      icon: Icon(widget.increase ? Icons.format_indent_increase : Icons.format_indent_decrease,
          size: 18, color: isEnabled ? theme.iconTheme.color : theme.disabledColor),
      fillColor: fillColor,
      onPressed: isEnabled
          ? () {
              final indentLevel = _selectionStyle.get(NotusAttribute.indent);
              if (indentLevel == null) {
                if (widget.increase) {
                  widget.controller.formatSelection(NotusAttribute.indentLevel1);
                }
                return;
              }
              if (indentLevel.value == 1 && !widget.increase) {
                widget.controller.formatSelection(NotusAttribute.indent.unset);
                return;
              }
              if (widget.increase) {
                widget.controller.formatSelection(NotusAttribute.getIndentAttributeForLevel(indentLevel.value + 1));
                return;
              }
              widget.controller.formatSelection(NotusAttribute.getIndentAttributeForLevel(indentLevel.value - 1));
            }
          : null,
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(_didChangeSelection);
    super.dispose();
  }
}

class ZefyrToolbar extends StatefulWidget implements PreferredSizeWidget {
  final List<Widget> children;

  const ZefyrToolbar({Key key, @required this.children}) : super(key: key);

  factory ZefyrToolbar.basic({
    Key key,
    @required ZefyrController controller,
    // TODO(arman): do we need separate for increase/decrease -
    bool hideIndentationButton = false,
    bool hideBoldButton = false,
    bool hideItalicButton = false,
    bool hideUnderLineButton = false,
    bool hideStrikeThrough = false,
    bool hideHeadingStyle = false,
    bool hideListNumbers = false,
    bool hideListBullets = false,
    bool hideCodeBlock = false,
    bool hideQuote = false,
    bool hideLink = false,
    bool hideHorizontalRule = false,
    bool hideEmbedButton = false,
    bool hideEmojiPicker = false,
    bool hideDateInsert = false,
    bool hideAlignmentButton = false,
    bool hideDirectionButton = false,
    // builder for build each date type widget.
    dateItemBuilder dateItemBuilder,

    /// Options to customize embedding.
    EmbeddingOptions embeddingOptions,

    /// function which called when click happens on disabled link button.
    VoidCallback onDisabledLinkClick,
  }) {
    return ZefyrToolbar(
      key: key,
      children: [
        Visibility(
          visible: !hideBoldButton,
          child: ToggleStyleButton(
            attribute: NotusAttribute.bold,
            icon: Icons.format_bold,
            controller: controller,
          ),
        ),
        Visibility(visible: !hideItalicButton, child: SizedBox(width: 1)),
        Visibility(
          visible: !hideItalicButton,
          child: ToggleStyleButton(
            attribute: NotusAttribute.italic,
            icon: Icons.format_italic,
            controller: controller,
          ),
        ),
        Visibility(visible: !hideUnderLineButton, child: SizedBox(width: 1)),
        Visibility(
          visible: !hideUnderLineButton,
          child: ToggleStyleButton(
            attribute: NotusAttribute.underline,
            icon: Icons.format_underline,
            controller: controller,
          ),
        ),
        Visibility(visible: !hideStrikeThrough, child: SizedBox(width: 1)),
        Visibility(
          visible: !hideStrikeThrough,
          child: ToggleStyleButton(
            attribute: NotusAttribute.strikethrough,
            icon: Icons.format_strikethrough,
            controller: controller,
          ),
        ),
        Visibility(
          visible: !hideIndentationButton,
          child: VerticalDivider(indent: 16, endIndent: 16, color: Colors.grey.shade400),
        ),
        Visibility(
          visible: !hideIndentationButton,
          child: IndentationButton(
            increase: false,
            controller: controller,
          ),
        ),
        Visibility(visible: !hideIndentationButton, child: SizedBox(width: 1)),
        Visibility(
          visible: !hideIndentationButton,
          child: IndentationButton(
            increase: true,
            controller: controller,
          ),
        ),
        Visibility(visible: !hideAlignmentButton, child: SizedBox(width: 1)),
        Visibility(
          visible: !hideAlignmentButton,
          child: VerticalDivider(indent: 16, endIndent: 16, color: Colors.grey.shade400),
        ),
        Visibility(
          visible: !hideAlignmentButton,
          child: ToggleStyleButton(
            attribute: NotusAttribute.leftAlignment,
            icon: Icons.format_align_left,
            controller: controller,
          ),
        ),
        Visibility(visible: !hideAlignmentButton, child: SizedBox(width: 1)),
        Visibility(
          visible: !hideAlignmentButton,
          child: ToggleStyleButton(
            attribute: NotusAttribute.centerAlignment,
            icon: Icons.format_align_center,
            controller: controller,
          ),
        ),
        Visibility(visible: !hideAlignmentButton, child: SizedBox(width: 1)),
        Visibility(
          visible: !hideAlignmentButton,
          child: ToggleStyleButton(
            attribute: NotusAttribute.rightAlignment,
            icon: Icons.format_align_right,
            controller: controller,
          ),
        ),
        Visibility(visible: !hideAlignmentButton, child: SizedBox(width: 1)),
        Visibility(
          visible: !hideAlignmentButton,
          child: ToggleStyleButton(
            attribute: NotusAttribute.justifyAlignment,
            icon: Icons.format_align_justify,
            controller: controller,
          ),
        ),
        Visibility(
          visible: !hideDirectionButton,
          child: VerticalDivider(indent: 16, endIndent: 16, color: Colors.grey.shade400),
        ),
        Visibility(
          visible: !hideDirectionButton,
          child: ToggleStyleButton(
            attribute: NotusAttribute.ltrDirection,
            icon: Icons.format_textdirection_l_to_r,
            controller: controller,
          ),
        ),
        Visibility(visible: !hideDirectionButton, child: SizedBox(width: 1)),
        Visibility(
          visible: !hideDirectionButton,
          child: ToggleStyleButton(
            attribute: NotusAttribute.rtlDirection,
            icon: Icons.format_textdirection_r_to_l,
            controller: controller,
          ),
        ),
        Visibility(
          visible: !hideHeadingStyle,
          child: VerticalDivider(indent: 16, endIndent: 16, color: Colors.grey.shade400),
        ),
        Visibility(
          visible: !hideHeadingStyle,
          child: SelectHeadingStyleButton(controller: controller),
        ),
        Visibility(
          visible: !hideListNumbers || !hideListBullets || !hideCodeBlock,
          child: VerticalDivider(indent: 16, endIndent: 16, color: Colors.grey.shade400),
        ),
        Visibility(
          visible: !hideListNumbers,
          child: ToggleStyleButton(
            attribute: NotusAttribute.block.numberList,
            controller: controller,
            icon: Icons.format_list_numbered,
          ),
        ),
        Visibility(
          visible: !hideListBullets,
          child: ToggleStyleButton(
            attribute: NotusAttribute.block.bulletList,
            controller: controller,
            icon: Icons.format_list_bulleted,
          ),
        ),
        Visibility(
          visible: !hideCodeBlock,
          child: ToggleStyleButton(
            attribute: NotusAttribute.block.code,
            controller: controller,
            icon: Icons.code,
          ),
        ),
        Visibility(
          visible: !hideQuote,
          child: VerticalDivider(indent: 16, endIndent: 16, color: Colors.grey.shade400),
        ),
        Visibility(
          visible: !hideQuote,
          child: ToggleStyleButton(
            attribute: NotusAttribute.block.quote,
            controller: controller,
            icon: Icons.format_quote,
          ),
        ),
        Visibility(
          visible: !hideLink,
          child: VerticalDivider(indent: 16, endIndent: 16, color: Colors.grey.shade400),
        ),
        Visibility(
          visible: !hideLink,
          child: LinkStyleButton(
            controller: controller,
            onDisabledClick: onDisabledLinkClick,
          ),
        ),
        Visibility(
          visible: !hideEmbedButton || !hideHorizontalRule,
          child: VerticalDivider(indent: 16, endIndent: 16, color: Colors.grey.shade400),
        ),
        Visibility(
          visible: !hideEmbedButton,
          child: EmbedButton(
            embeddingOptions: embeddingOptions ?? EmbeddingOptions(),
            controller: controller,
          ),
        ),
        Visibility(
          visible: !hideHorizontalRule,
          child: InsertHorizontalRuleButton(
            controller: controller,
            icon: Icons.horizontal_rule,
          ),
        ),
        Visibility(
          visible: !hideEmojiPicker,
          child: VerticalDivider(indent: 16, endIndent: 16, color: Colors.grey.shade400),
        ),
        Visibility(
          visible: !hideEmojiPicker,
          child: EmojiPicker(
            controller: controller,
            icon: Icons.tag_faces_sharp,
          ),
        ),
        Visibility(
          visible: !hideDateInsert,
          child: VerticalDivider(indent: 16, endIndent: 16, color: Colors.grey.shade400),
        ),
        Visibility(
          visible: !hideDateInsert,
          child: InsertDateButton(controller: controller, icon: Icons.date_range, dateBuilder: dateItemBuilder),
        ),
      ],
    );
  }

  @override
  _ZefyrToolbarState createState() => _ZefyrToolbarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _ZefyrToolbarState extends State<ZefyrToolbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      constraints: BoxConstraints.tightFor(height: widget.preferredSize.height),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: widget.children,
        ),
      ),
    );
  }
}

/// Default icon button used in Zefyr editor toolbar.
///
/// Named with a "Z" prefix to distinguish from the Flutter's built-in version.
class ZIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget icon;
  final double size;
  final Color fillColor;
  final double hoverElevation;
  final double highlightElevation;

  const ZIconButton({
    Key key,
    @required this.onPressed,
    this.icon,
    this.size = 40,
    this.fillColor,
    this.hoverElevation = 1,
    this.highlightElevation = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: size, height: size),
      child: RawMaterialButton(
        child: icon,
        visualDensity: VisualDensity.compact,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        padding: EdgeInsets.zero,
        fillColor: fillColor,
        elevation: 0,
        hoverElevation: hoverElevation,
        highlightElevation: hoverElevation,
        onPressed: onPressed,
      ),
    );
  }
}

class ZDropdownButton<T> extends StatefulWidget {
  final double height;
  final Color fillColor;
  final double hoverElevation;
  final double highlightElevation;
  final Widget child;
  final T initialValue;
  final List<PopupMenuEntry<T>> items;
  final ValueChanged<T> onSelected;
  final bool enable;

  const ZDropdownButton({
    Key key,
    this.height = 40,
    this.fillColor,
    this.hoverElevation = 1,
    this.highlightElevation = 1,
    this.enable = true,
    @required this.child,
    @required this.initialValue,
    @required this.items,
    @required this.onSelected,
  }) : super(key: key);

  @override
  _ZDropdownButtonState<T> createState() => _ZDropdownButtonState<T>();
}

class _ZDropdownButtonState<T> extends State<ZDropdownButton<T>> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(height: widget.height),
      child: RawMaterialButton(
        child: _buildContent(context),
        visualDensity: VisualDensity.compact,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        padding: EdgeInsets.zero,
        fillColor: widget.fillColor,
        elevation: 0,
        hoverElevation: widget.hoverElevation,
        highlightElevation: widget.hoverElevation,
        onPressed: widget.enable ? _showMenu : null,
      ),
    );
  }

  void _showMenu() {
    final popupMenuTheme = PopupMenuTheme.of(context);
    final button = context.findRenderObject() as RenderBox;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomLeft(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    showMenu<T>(
      context: context,
      elevation: 4,
      // widget.elevation ?? popupMenuTheme.elevation,
      initialValue: widget.initialValue,
      items: widget.items,
      position: position,
      shape: popupMenuTheme.shape,
      // widget.shape ?? popupMenuTheme.shape,
      color: popupMenuTheme.color, // widget.color ?? popupMenuTheme.color,
      // captureInheritedThemes: widget.captureInheritedThemes,
    ).then((T newValue) {
      if (!mounted) return null;
      if (newValue == null) {
        // if (widget.onCanceled != null) widget.onCanceled();
        return null;
      }
      if (widget.onSelected != null) {
        widget.onSelected(newValue);
      }
    });
  }

  Widget _buildContent(BuildContext context) {
    final iconColor = widget.enable ? Theme.of(context).iconTheme.color : Theme.of(context).disabledColor;
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: 110),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            widget.child,
            Expanded(child: Container()),
            Icon(Icons.arrow_drop_down, size: 14, color: iconColor)
          ],
        ),
      ),
    );
  }
}

/// Options to customize Embedding.
class EmbeddingOptions {
  const EmbeddingOptions({
    this.embedBuilder,
    this.embeddingPickActions = const EmbeddingPickActions(),
    this.embedPickSourceChooser,
  }) : assert(embeddingPickActions != null);

  /// builder for build each embed button base on its type.
  final embedButtonsBuilder embedBuilder;

  /// Actions which will be called after picking a data.
  final EmbeddingPickActions embeddingPickActions;

  /// Called when need to choose pick source.
  final ImageSource Function() embedPickSourceChooser;
}

class EmbeddingPickActions {
  const EmbeddingPickActions({
    this.onImagePicked,
    this.onVideoPicked,
    this.onFilePicked,
    this.onAudioPicked,
    this.onPickLocation,
  });

  /// Called after picking image.
  final Future<ImageData> Function(String imagePath) onImagePicked;

  /// Called after picking video.
  final Future<VideoData> Function(String videoPath) onVideoPicked;

  /// Called after picking file.
  final Future<FileData> Function(String filePath) onFilePicked;

  /// Called after picking audio.
  final Future<AudioData> Function(String audioPath) onAudioPicked;

  /// Called when click to pick location.
  final Future<LocationData> Function() onPickLocation;
}
