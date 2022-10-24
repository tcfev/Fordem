class NotusAlignment {
  const NotusAlignment.right() : _value = 'r';

  const NotusAlignment.left() : _value = 'l';

  const NotusAlignment.center() : _value = 'c';

  factory NotusAlignment.fromString(String value) {
    assert(value == 'r' || value == 'l' || value == 'c', 'value $value is not valid');
    return value == 'r'
        ? NotusAlignment.right()
        : value == 'l'
            ? NotusAlignment.left()
            : NotusAlignment.center();
  }

  final String _value;

  String get value => _value;

  bool get isRight => _value == 'r';

  bool get isLeft => _value == 'l';

  bool get isCenter => _value == 'c';
}
