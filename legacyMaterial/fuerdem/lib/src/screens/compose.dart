import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fuerdem/src/config/constants/style.dart';
import 'package:fuerdem/src/config/router/router.dart';
import 'package:fuerdem/src/localization/languages/languages.dart';
import 'package:fuerdem/src/providers/compose_notifier.dart';
import 'package:fuerdem/src/widget/animateicons.dart';
import 'package:fuerdem/src/widget/appbar.dart';
import 'package:fuerdem/src/widget/buttons.dart';
import 'package:fuerdem/src/widget/color_selector.dart';
import 'package:fuerdem/src/widget/fields.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:zefyr/zefyr.dart';

///  Compose Page
class Compose extends StatefulWidget {
  @override
  _ComposeState createState() => _ComposeState();
}

class _ComposeState extends State<Compose> {
  TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) => Consumer<ComposeNotifier>(
        builder: (context, composeNotifier, child) => Scaffold(
          backgroundColor: Colors.white,
          appBar: simpleAppBar(context, title: Languages.of(context).addPost),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5,
                                  spreadRadius: 0.5)
                            ]),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset('assets/img/image.png')),
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: IconBtn<IconData>(
                          child: Icons.photo_size_select_actual_rounded,
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  DecoratedTextField(
                    placeholder: Languages.of(context).title,
                    maxLines: 1,
                    controller: titleController,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      PageRouter.namedNavigateTo(
                          context, PageRouter.composeEditorRoute);
                    },
                    child: IgnorePointer(
                      child: ZefyrTheme(
                        data: zefyrThemeData,
                        child: ZefyrField(
                          controller: composeNotifier.zefyrController,
                          focusNode: composeNotifier.focusNode,
                          decoration: furdemInputDecoration(
                              Languages.of(context).composeBodyHint, '', null),
                          maxHeight: 170,
                          minHeight: 170,
                          readOnly: true,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

/// Compose Page Editor
class ComposeEditor extends StatefulWidget {
  @override
  _ComposeEditorState createState() => _ComposeEditorState();
}

class _ComposeEditorState extends State<ComposeEditor> {
  @override
  Widget build(BuildContext context) =>
      Consumer<ComposeNotifier>(builder: (context, composeNotifier, child) {
        final title = Languages.of(context).edit;
        return Scaffold(
          appBar:
              simpleAppBar(context, title: title, icon: Icons.fullscreen_exit),
          body: ZefyrTheme(
            data: zefyrThemeData,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: ZefyrEditor(
                      controller: composeNotifier.zefyrController,
                      focusNode: composeNotifier.focusNode,
                      suggestionListBuilder: (trigger, value) => null,
                    ),
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  CustomToolbar(
                    controller: composeNotifier.zefyrController,
                    withShowOptionButton: true,
                  ),
                ],
              ),
            ),
          ),
        );
      });
}

/// Custom toolbar for zefyr widget
class CustomToolbar extends StatefulWidget {
  const CustomToolbar(
      {Key key, @required this.controller, this.withShowOptionButton = true})
      : super(key: key);
  final ZefyrController controller;
  final bool withShowOptionButton;

  @override
  _CustomToolbarState createState() => _CustomToolbarState();
}

class _CustomToolbarState extends State<CustomToolbar>
    with SingleTickerProviderStateMixin {
  bool showToolbar = false;
  AnimateIconController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimateIconController();
  }

  @override
  Widget build(BuildContext context) => Consumer<ComposeNotifier>(
        builder: (context, composeNotifier, child) => Container(
          child: Stack(
            children: [
              AnimatedOpacity(
                duration: Duration(milliseconds: 500),
                opacity: widget.withShowOptionButton
                    ? showToolbar
                        ? 1.0
                        : 0.0
                    : 1.0,
                curve: Curves.easeIn,
                child: Padding(
                  padding: widget.withShowOptionButton
                      ? EdgeInsets.only(left: 50)
                      : EdgeInsets.zero,
                  child: IgnorePointer(
                    ignoring:
                        widget.withShowOptionButton ? !showToolbar : false,
                    child: ZefyrToolbar.basic(
                      controller: widget.controller,
                      embeddingOptions: EmbeddingOptions(
                        embedBuilder: (type, child) {
                          if (type == EmbedType.image ||
                              type == EmbedType.video) {
                            return child;
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                        embeddingPickActions: EmbeddingPickActions(
                          onImagePicked: onImagePicked,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (widget.withShowOptionButton)
                Padding(
                    padding: EdgeInsets.only(top: 4, bottom: 8),
                    child: IconBtn<Widget>(
                      padding: 0,
                      child: AnimateIcons(
                        color: Colors.white,
                        duration: Duration(milliseconds: 500),
                        size: 20,
                        splashRadius: 1,
                        startTooltip: Languages.of(context).openOptions,
                        endTooltip: Languages.of(context).closeOptions,
                        startIcon: Icons.add,
                        endIcon: Icons.close,
                        controller: _animationController,
                        onStartIconPress: _handleButtonAnimation,
                        onEndIconPress: _handleButtonAnimation,
                      ),
                    )),
            ],
          ),
        ),
      );

  /// On Imaged Picked function
  Future<ImageData> onImagePicked(String path) async {
    final imageData = await showMaterialModalBottomSheet<ImageData>(
      context: context,
      enableDrag: false,
      isDismissible: false,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(8))),
      builder: (context) => OnImagePicked(
        imagePath: path,
        onDone: (data) async {
          Navigator.pop<ImageData>(context, data);
        },
      ),
    );
    return imageData;
  }

  bool _handleButtonAnimation() {
    setState(() {
      showToolbar = !showToolbar;
      if (showToolbar) {
        _animationController.animateToEnd();
      } else {
        _animationController.animateToStart();
      }
    });
    return true;
  }
}

/// On Image Picked in zefyr editor
class OnImagePicked extends StatefulWidget {
  const OnImagePicked({Key key, @required this.imagePath, this.onDone})
      : super(key: key);
  final String imagePath;
  final Function(ImageData data) onDone;

  @override
  _OnImagePickedState createState() => _OnImagePickedState();
}

class _OnImagePickedState extends State<OnImagePicked> {
  double width = 400, height = 200;
  String alignment = 'c';
  Radius simpleRadius = Radius.circular(8);
  double imageRadius = 4;
  Color borderColor = Colors.blue[700];
  double borderThickness = 0;

  TextEditingController widthController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController radiusController = TextEditingController();
  TextEditingController captionController = TextEditingController();
  TextEditingController thicknessController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widthController.text = width.toInt().toString();
    heightController.text = height.toInt().toString();
    radiusController.text = imageRadius.toInt().toString();
    thicknessController.text = borderThickness.toInt().toString();
  }

  @override
  Widget build(BuildContext context) => Consumer<ComposeNotifier>(
        builder: (context, composeNotifier, child) => Container(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ..._buildDemoImage(),
                  SizedBox(
                    height: 4,
                  ),
                  ..._buildInputs(),
                  _buildBorderOptions(),
                  _buildAlignment(),
                  SizedBox(
                    height: 8,
                  ),
                  _buildDoneButton()
                ],
              ),
            ),
          ),
        ),
      );

  Widget _buildDoneButton() => Row(
        children: [
          Expanded(
            child: FilledBtn(
              onTap: () {
                var imageData = ImageData(
                    width: width,
                    height: height,
                    localPath: widget.imagePath,
                    align: NotusAlignment.fromString(alignment),
                    saveRatio: false);
                widget.onDone(imageData);
              },
              child: Padding(
                padding: EdgeInsets.all(4),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        Languages.of(context).addImage,
                        style: TextStyle(color: Colors.white),
                      )
                    ]),
              ),
            ),
          ),
          SizedBox(
            width: 4,
          ),
          Expanded(
            child: OutlinedBtn(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: EdgeInsets.all(4),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [Text(Languages.of(context).cancel)]),
              ),
            ),
          ),
        ],
      );

  List<Widget> _buildDemoImage() => [
        Align(
          alignment: alignment == 'c'
              ? Alignment.center
              : alignment == 'r'
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
          child: Image.file(
            File(widget.imagePath),
            fit: BoxFit.fill,
            width: width,
            height: height,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
                Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: borderThickness, left: borderThickness),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(imageRadius),
                    child: child,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(imageRadius),
                    border:
                        Border.all(color: borderColor, width: borderThickness),
                  ),
                  child: Opacity(
                    opacity: 0,
                    child: child,
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          captionController.text,
          style: TextStyle(color: Colors.grey[500]),
        ),
      ];

  List<Widget> _buildInputs() => [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(4),
                child: DecoratedTextField(
                  maxLength: 3,
                  controller: widthController,
                  label: Languages.of(context).width,
                  keyboardType: TextInputType.numberWithOptions(
                      decimal: true, signed: false),
                  placeholder: '${Languages.of(context).width}',
                  counterText: '0-400',
                  onChange: (text) {
                    if (text.isNotEmpty) {
                      var w = double.parse(text.trim());
                      if (w <= 400) {
                        setState(() {
                          width = w;
                        });
                      }
                    }
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(4),
                child: DecoratedTextField(
                  maxLength: 3,
                  label: Languages.of(context).height,
                  controller: heightController,
                  keyboardType: TextInputType.number,
                  placeholder: '${Languages.of(context).height}',
                  counterText: '0-250',
                  onChange: (text) {
                    if (text.isNotEmpty) {
                      var h = double.parse(text.trim());

                      if (h <= 250) {
                        setState(() {
                          height = h;
                        });
                      }
                    }
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(4),
                child: DecoratedTextField(
                  controller: radiusController,
                  maxLength: 2,
                  label: Languages.of(context).radius,
                  keyboardType: TextInputType.number,
                  counterText: '0-99',
                  placeholder: '${Languages.of(context).radius}',
                  onChange: (text) {
                    if (text.isNotEmpty) {
                      setState(() {
                        imageRadius = double.parse(text.trim());
                      });
                    }
                  },
                ),
              ),
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.all(4),
          child: DecoratedTextField(
            controller: captionController,
            maxLength: 100,
            maxLines: 2,                  label: Languages.of(context).caption,

            keyboardType: TextInputType.text,
            placeholder: Languages.of(context).caption,
            onChange: (v) {
              setState(() {});
            },
          ),
        ),
      ];

  Widget _buildBorderOptions() => Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Center(
              child: ColorSelector(
                selectedColor: 0,
                spaceBetweenItems: 1,
                radius: 14,
                onSelect: (index, color) {
                  setState(() {
                    borderColor = color;
                  });
                },
                colors: [
                  Colors.blue[700],
                  Colors.blue[800],
                  Colors.blue[900],
                  Colors.red[700],
                  Colors.red[800],
                  Colors.red[900],
                  Colors.green[700],
                  Colors.green[800],
                  Colors.green[900],
                  Colors.purple[700],
                  Colors.purple[800],
                  Colors.purple[900],
                  Colors.yellow[700],
                  Colors.yellow[800],
                  Colors.yellow[900],
                  Colors.grey[700],
                  Colors.grey[800],
                  Colors.grey[900],
                  Colors.white,
                  Colors.black,
                  Colors.tealAccent
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4),
            child: DecoratedTextField(
              controller: thicknessController,
              maxLength: 1,
              maxLines: 1,
              label: Languages.of(context).thickness,
              counterText: '0-9',
              keyboardType: TextInputType.number,
              placeholder: Languages.of(context).thickness,
              onChange: (v) {
                if (v.isNotEmpty) {
                  setState(() {
                    borderThickness = double.parse(v.trim());
                  });
                }
              },
            ),
          )
        ],
      );

  Widget _buildAlignment() => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DynamicBtn(
            onTap: () {
              setState(() {
                alignment = 'l';
              });
            },
            buttonType: alignment == 'l' ? BtnTypes.filled : BtnTypes.outlined,
            radius: 0,
            borderRadius: BorderRadius.only(
                topLeft: simpleRadius, bottomLeft: simpleRadius),
            child: Icon(
              Icons.format_align_left,
              color: alignment == 'l' ? Colors.white : Colors.grey[900],
            ),
          ),
          DynamicBtn(
            onTap: () {
              setState(() {
                alignment = 'c';
              });
            },
            radius: 0,
            borderRadius: BorderRadius.zero,
            buttonType: alignment == 'c' ? BtnTypes.filled : BtnTypes.outlined,
            child: Icon(
              Icons.format_align_center_rounded,
              color: alignment == 'c' ? Colors.white : Colors.grey[900],
            ),
          ),
          DynamicBtn(
            onTap: () {
              setState(() {
                alignment = 'r';
              });
            },
            radius: 0,
            buttonType: alignment == 'r' ? BtnTypes.filled : BtnTypes.outlined,
            borderRadius: BorderRadius.only(
                topRight: simpleRadius, bottomRight: simpleRadius),
            child: Icon(
              Icons.format_align_right,
              color: alignment == 'r' ? Colors.white : Colors.grey[900],
            ),
          )
        ],
      );
}

class OnVideoPicked extends StatefulWidget {
  @override
  _OnVideoPickedState createState() => _OnVideoPickedState();
}

class _OnVideoPickedState extends State<OnVideoPicked> {
  @override
  Widget build(BuildContext context) => Container();
}
