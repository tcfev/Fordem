import 'comment.dart';
import 'post.dart';
import 'reaction.dart';

class Author {
  /// anonymous users will be identified with this id (IMEI code, ... todo
  String id;
  IdentificationCode idCode;
  String firstName;
  String lastName;
  String country;
  String city;
  String state;
  String street;
  String houseNumber;
  String floor;
  String zip;
  double latitude;
  double longitude;
  String photo;
  List<String> networkOfAuthors;
  List<Post> posts;
  List<Reaction> reaction;
  List<Comment> comments;
  DateTime lastLogin;
  List<String> sharedSocialMedia;
}

class IdentificationCode {
  /// if the QrCode is scanned outside the app it'll lead the user to a website
  /// that informs the user about (the purpose of the) app. And information
  /// where to download and install it.
  /// https://fuerdem/{$code}
  String url;

  /// to identify the address the code was delivered to (send by post) & will be
  /// used to level anonymous users to registered
  String code;

  /// every person who receives a code can request more for their family members
  /// who live with them or are (d)igitally (il)literate. The Dils then will be
  /// approached through other means including interactive voice repose, mail &
  /// in person.
  List<IdentificationCode> shared;
}
