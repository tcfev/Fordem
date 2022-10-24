import 'author.dart';

class Message {
  List<Author> senders;
  List<Author> recipients;
  String message;
  StatusOfMessage status;
}

class StatusOfMessage {
  bool seen;
  DateTime sendingTime;
  DateTime deliveryTime;
}
