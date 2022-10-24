import 'reaction.dart';

class Post {
  int id;
  List<String> coAuthors;
  List<String> linkedAuthors;
  List<String> categories;
  List<Reaction> reactions = []; //ids
  int headCommentId; // reference to the 1st comment
  int nos;
  int yeses;

// bool checkSpecificUserReaction(String authorId) {
//   bool result;
//   if (reactions.length != 0) {
//     for (Reaction reaction in reactions) {
//       if (reaction.authorId == authorId) {
//         result = true;
//       } else {
//         result = false;
//       }
//     }
//   } else {
//     result = false;
//   }
//   return result;
// }

}
