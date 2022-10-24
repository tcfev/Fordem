class Reaction {
  String id; //to identify
  String authorId;
  String postId;
  int _vote; // 2: discussion, 1: yes, 0: no,
  int _claimedVotes;
  DateTime castTime;

  set vote(int decision) => _vote = decision;

  /// Voters can claim they have the votes of some other digitally illiterate
  /// people. This way they will be given the chance to go convince the people
  /// and we will validate the claim reaching out to those people the voter
  /// sends to us subsequently.Reaching out can mean: post(costs are covered
  /// somehow?), Interactive voice calls, going there physically...
  set claim(int numberOfVotes) => _claimedVotes = numberOfVotes;
}
