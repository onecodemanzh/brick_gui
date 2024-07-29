import 'package:brick_gui/brick_gui.dart';

void main() {
  // var awesome = Awesome();
  // print('awesome: ${awesome.isAwesome}');
  Map<String, String> c = {'s': 's'};
  var object = {};
  // object.addEntries({'a': 1}.entries);
  var gui = GUI();
  gui.add(object, 'number', min: 0, max: 100, value: 1);
  gui.add(object, 'arr', options: [1, 2, 3], value: 1);
  gui.add(
    object,
    'obj',
    options: [
      {'label': 'label a', 'value': 'a'},
      {'label': 'label b', 'value': 'b'},
      {'label': 'label c', 'value': 'c'},
    ],
    value: 'a',
  );

  gui.onChange((value) {});
  // var a = O();
  // var g = GUI();

  // a['b'] = '22';
  // g.add(a, 'a', min: 0, max: 100, value: 1);
  // a.get();
  // print('a.runtimeType, ${a.runtimeType.runtimeType}');
  // print('c.runtimeType, ${object.runtimeType}');
  // print('object.runtimeType, ${object.runtimeType}');
  // print('object.runtimeType, ${a is Object}');
  // print('object.runtimeType, ${c is Object}');
  // print('object.runtimeType, ${object is Object}');
  // print('object.runtimeType, ${object.runtimeType.runtimeType}');
  // a.set('a', 20);
  // print('Json, ${a.a}');
  // print('Json, ${a["b"]}');
  print('Json, ${object.toJson()}');
}


