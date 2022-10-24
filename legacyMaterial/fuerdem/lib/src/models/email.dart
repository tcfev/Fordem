import 'author.dart';

class Email {
  List<Author> senders;
  List<Author> recipients;
  String body;
  String subject;
  List<dynamic> attachments;
  StatusOfEmail status;
  bool secret;
}

class StatusOfEmail {
  bool read;
  bool marked;
  DateTime sendingTime;
  DateTime deliveryTime;
}
