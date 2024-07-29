// TODO: Put public facing types in this file.

// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

class GUIWidget extends StatefulWidget {
  double width;
  GUI gui;
  GUIWidget({
    super.key,
    required this.gui,
    this.width = 300,
  });

  @override
  State<GUIWidget> createState() => GUIState();
}

class GUIState extends State<GUIWidget> {
  @override
  void initState() {
    super.initState();
  }

  children() {
    widget.gui.children.map;
    // _children;
  }

  ControllerChildren(List<Controller> controllers) => controllers
      .map(
        (x) {
          Widget getWiget(BoxConstraints constraints) {
            Widget w = Text('${x.runtimeType}');
            switch (x.runtimeType) {
              case NumberController:
                var ctr = x as NumberController;
                final value = ctr.value_ is num ? ctr.value_ : 0;
                w = Slider(
                  min: ctr.min_,
                  max: ctr.max_,
                  divisions: (ctr.max_ * ctr.step_).round(),
                  value: value,
                  label: value.round().toString(),
                  secondaryTrackValue: value,
                  onChanged: (double newValue) {
                    ctr.value(newValue);
                    setState(() {});
                  },
                );
                break;
              case BoolController:
                var ctr = x as BoolController;
                final value = ctr.value_ is bool ? ctr.value_ : false;
                w = Checkbox(
                  tristate: true,
                  value: value,
                  onChanged: (bool? newValue) {
                    ctr.value(newValue);
                    setState(() {});
                  },
                );
                break;

              case OptionController:
                var ctr = x as OptionController;
                final value = ctr.value_;
                w = Container(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black38, width: 1),
                    //边框圆角设置
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  height: constraints.maxHeight,
                  child: DropdownButton(
                    value: value,
                    underline: Container(color: Colors.transparent),
                    style: TextStyle(fontSize: 14),
                    items: ctr.options_.map<DropdownMenuItem>((v) {
                      return DropdownMenuItem(
                        value: v.value,
                        child: Text(v.label),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      ctr.value(newValue);
                      setState(() {});
                    },
                  ),
                );
                break;

              case ColorController:
                var ctr = x as ColorController;
                final value = ctr.value_;
                w = Container(
                  width: constraints.maxHeight,
                  height: constraints.maxHeight,
                  child: ColorIndicator(
                    width: constraints.maxHeight,
                    height: constraints.maxHeight,
                    borderRadius: 6,
                    color: value,
                    onSelect: () {
                      late Color color;
                      final a = ColorPicker(
                        onColorChanged: (Color value) {
                          color = value;
                        },
                      );
                      a.showPickerDialog(context).then((isOk) {
                        ctr.value(color);
                        setState(() {});
                      });
                    },
                  ),
                );
                break;
            }
            return w;
          }

          return Column(
            children: [
              Row(
                children: [
                  Expanded(flex: 1, child: Text('${x.label}')),
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: 30,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return getWiget(constraints);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
            ],
          );
        },
      )
      .cast<Widget>()
      .toList();

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.width,
        alignment: Alignment.centerLeft,
        child: IntrinsicHeight(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [...ControllerChildren(widget.gui.controllers)],
          ),
        ));
  }
}

class GUI {
  /// 包含此文件夹的GUI。如果这是根GUI，则为空
  ///
  /// The GUI containing this folder, or null if this is the root GUI.
  GUI? parent;

  /// 根GUI
  ///
  /// root GUI.
  GUI? root;

  /// 子 GUI
  ///
  /// children GUI
  List<GUI> children = [];

  List<Controller> controllers = [];

  /// The list of folders contained by this GUI.
  List<GUI> folders = [];

  /// Used to determine if the GUI is closed. Use `gui.open()` or `gui.close()` to change this.
  // bool _closed = false;

  /// Used to determine if the GUI is hidden. Use `gui.show()` or `gui.hide()` to change this.
  // bool _hidden = false;
  String? label;

  /// ```dart
  /// gui.add( object, 'property' );
  ///
  /// gui.add( object, 'number', min: 0, max: 100, value: 1 );
  ///
  /// gui.add( object, 'isShow', value: false );
  ///
  /// gui.add( object, 'options', [ 1, 2, 3 ] );
  ///
  /// gui.add( object, 'options', [ 1, 2, 3 ], value: 1);
  ///
  /// gui.add( object, 'options', [{ 'label': any, value: any }] );
  /// ```
  ///
  Controller add(
    Map object,
    String str, {
    List<dynamic>? options,
    double? min,
    double? max,
    dynamic value,
    int? step,
  }) {
    Controller ctr = Controller();
    if (options != null && options.isNotEmpty) {
      final isMap = options.every((x) => x is Map);
      if (isMap) {
        final hasLabelValue = options
            .every((x) => x.containsKey('label') && x.containsKey('value'));
        if (hasLabelValue) {
          /// [{'label': 'label a', 'value': 'a'}]
          ctr = OptionController(
            parent: this,
            value_: value,
            options_: options
                .map((x) => _KV(label: x['label'], value: x['value']))
                .toList(),
          );
        } else {
          throw UnsupportedError('${options[0].toString()}, is not supported!');
        }
      } else {
        /// [ 1, 2, 3 ] Or ['1', '2', '3']
        ctr = OptionController(
          parent: this,
          value_: value,
          options_: options.map((x) => _KV(label: '$x', value: x)).toList(),
        );
      }
    } else if (min != null && max != null) {
      /// number
      ctr = NumberController(
        parent: this,
        max_: max,
        min_: min,
        step_: step ?? 1,
        value_: value,
      );
    } else if (value != null && value is bool) {
      /// bool
      ctr = BoolController(
        value_: value,
        parent: this,
      );
    } else if (value != null && value is Color) {
      ctr = ColorController(
        value_: value,
        parent: this,
      );
    }
    ctr.name(str);
    controllers.add(ctr);
    object.set(str, value);
    return ctr;
  }

  addColor() {
    return this;
  }

  addFolder() {
    children.add(GUI());
    return this;
  }

  /// set name
  name(String n) {
    label = n;
    return this;
  }

  GUI onChange(v) {
    print('v,$v}');
    return this;
  }

  Widget build(BuildContext context) {
    return Stack(
      children: [],
    );
  }
}

typedef Callback = void Function(dynamic value);

extension GetSetExtension on Map {
  Map<String, dynamic> _toMap() {
    var json = jsonEncode(this);
    return Map.from(jsonDecode(json));
  }

  dynamic get(String propertyName) {
    var mapRep = _toMap();
    if (mapRep.containsKey(propertyName)) {
      return mapRep[propertyName];
    }
    throw ArgumentError('$propertyName, propery not found');
  }

  String toJson() {
    return jsonEncode(this);
  }

  set(String propertyName, value) {
    this[propertyName] = value;
  }
}

class Controller {
  /// 包含此文件夹的GUI。如果这是根GUI，则为空
  ///
  /// The GUI containing this folder, or null if this is the root GUI.
  GUI? parent;

  /// Used to determine if the GUI is closed. Use `gui.open()` or `gui.close()` to change this.
  // bool _closed = false;

  /// Used to determine if the GUI is hidden. Use `gui.show()` or `gui.hide()` to change this.
  // bool _hidden = false;
  dynamic value_;
  String? label;
  Callback? onChange;
  Controller({
    this.parent,
    this.value_,
  });
  hide() {
    // _hidden = true;
    return this;
  }

  show() {
    // _hidden = false;
    return this;
  }

  /// set value
  value(dynamic n) {
    value_ = n;
    onChange!(value_);
    return this;
  }

  /// set name
  name(String n) {
    label = n;
    return this;
  }
}

class BoolController extends Controller {
  BoolController({
    super.parent,
    super.value_,
  });
}

class NumberController extends Controller {
  double min_;
  double max_;
  int step_;

  NumberController({
    super.parent,
    super.value_,
    this.min_ = 0,
    this.max_ = 100,
    this.step_ = 1,
  });

  /// set min
  min(double n) {
    min_ = n;
    return this;
  }

  /// set max
  max(double n) {
    max_ = n;
    return this;
  }

  /// set step
  step(int n) {
    step_ = n;
    return this;
  }
}

class OptionController extends Controller {
  List<_KV> options_ = [];
  OptionController({
    super.parent,
    required this.options_,
    super.value_,
  });
}

class ColorController extends Controller {
  ColorController({
    super.parent,
    super.value_,
  });
}

class _KV {
  String label;
  dynamic value;
  _KV({
    required this.label,
    required this.value,
  });
}
