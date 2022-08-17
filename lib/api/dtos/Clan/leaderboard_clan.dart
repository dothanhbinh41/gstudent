
import 'dart:convert';

List<LeaderBoardClan> leaderBoardClanFromJson(String str) => List<LeaderBoardClan>.from(json.decode(str).map((x) => LeaderBoardClan.fromJson(x)));

String leaderBoardClanToJson(List<LeaderBoardClan> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LeaderBoardClan {
  LeaderBoardClan({
    this.id,
    this.totalNumberTrue,
    this.totalTime,
  });

  int id;
  int totalNumberTrue;
  int totalTime;

  factory LeaderBoardClan.fromJson(Map<String, dynamic> json) => LeaderBoardClan(
    id: json["student_id"],
    totalNumberTrue: json["answer_true"] != null ? json["answer_true"] : 0,
    totalTime: json["time"]  != null ? json["time"] : 0,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "total_number_true": totalNumberTrue,
    "total_time": totalTime,
  };
}



List<LeaderBoardClanEachQuestion> LeaderBoardClanEachQuestionFromJson(String str) => List<LeaderBoardClanEachQuestion>.from(json.decode(str).map((x) => LeaderBoardClan.fromJson(x)));

String LeaderBoardClanEachQuestionToJson(List<LeaderBoardClanEachQuestion> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));



class LeaderBoardClanEachQuestion {
  LeaderBoardClanEachQuestion({
    this.id,
    this.totalNumberTrue,
    this.totalTime,
  });

  int id;
  int totalNumberTrue;
  int totalTime;

  factory LeaderBoardClanEachQuestion.fromJson(Map<String, dynamic> json) => LeaderBoardClanEachQuestion(
    id: json["student_id"],
    totalNumberTrue: json["total_number_true"] != null ? json["total_number_true"] : 0,
    totalTime: json["time"]  != null ? json["time"] : 0,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "total_number_true": totalNumberTrue,
    "total_time": totalTime,
  };
}
