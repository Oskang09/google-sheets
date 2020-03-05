import 'dart:mirrors';

class Column {
  final String name;
  final int index;
  final dynamic Function(String) parser;

  const Column({this.name, this.index, this.parser});
}

List<T> applyValue<T>(List<String> values, List<String> headers) {
  Map<Symbol, Column> annotations = Map();
  List<T> instances = List();
  ClassMirror clazz = reflectClass(T);

  for (var field in clazz.declarations.values) {
    if (field is VariableMirror) {
      Iterable<InstanceMirror> metadata = field.metadata.where(
        (InstanceMirror meta) {
          return meta.reflectee.runtimeType ==
              reflectClass(Column).reflectedType;
        },
      );
      annotations[field.simpleName] = metadata.first.reflectee as Column;
    }
  }

  for (String value in values) {
    InstanceMirror instance = clazz.newInstance(Symbol(''), []);
    List<String> csv = value.split(',');

    annotations.forEach((Symbol name, Column column) {
      int index = column.index ?? headers.indexOf(column.name);
      instance.setField(name, column.parser(csv[index]));
    });
    instances.add(instance.reflectee);
  }

  return instances;
}
