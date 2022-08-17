class ClanModel {
  ClanModel({
    this.id,
    this.name,
    this.generalId,
    this.rank,
    this.attackStatus,
    this.approveStatus,
    this.numAttackRequest,
    this.classroomId,
    this.courseId,
    this.win,
    this.lose,
  });

  int id;
  String name;
  int generalId;
  dynamic rank;
  int attackStatus;
  int approveStatus;
  dynamic numAttackRequest;
  int classroomId;
  int courseId;
  dynamic win;
  dynamic lose;

  factory ClanModel.fromJson(Map<String, dynamic> json) => ClanModel(
    id: json["id"],
    name: json["name"],
    generalId: json["general_id"],
    rank: json["rank"],
    attackStatus: json["attack_status"],
    approveStatus: json["approve_status"],
    numAttackRequest: json["num_attack_request"],
    classroomId: json["classroom_id"],
    courseId: json["course_id"],
    win: json["win"],
    lose: json["lose"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "general_id": generalId,
    "rank": rank,
    "attack_status": attackStatus,
    "approve_status": approveStatus,
    "num_attack_request": numAttackRequest,
    "classroom_id": classroomId,
    "course_id": courseId,
    "win": win,
    "lose": lose,
  };
}