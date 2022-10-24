class CommentReaction {
  String id;
  String authorId;
  String postId;

  /// 1: upVote, 0: downVote
  int reaction;
  DateTime castTime; //timeStamp
}

class Comment {
  String id; // will be referenced by this id
  Comment parentComment;
  CommentsCollection childrenComments;
  CommentsCollection linkedComments;

  String body;
  int author;

  int upVotes = 0;
  int downVotes = 0;

  /// reactions are listed for analytic purposes.
  List<CommentReaction> _reactions;

  List<AbuseReport> abuseReports;
}

class CommentsCollection {
  String id;
  List<Comment> comments;
}

class AbuseReport {
  int id;
  String authorId;
  String postId;
  DateTime castTime;
  String explanation;

  List<String> category = [
    'harassment',
    'threatening others',
    'unlawfully acquired information'
  ];
}

class Category {
  String id;
  String name;
}

class SocialMedia {
  String name;
  String config;
}
