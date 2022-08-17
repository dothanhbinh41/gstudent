class AnswerSubmit{
  AnswerSubmit({
    this.id,
    this.answers,
    this.images,
    this.type
  });

  int id;
  dynamic answers;
  String type;
  String images;
  Map<String, dynamic> toJson() => {
    "id": id,
    "answers": answers,
    "images": images,
    "type" : type
  };
}