class AnswerSubmitHomework {
  AnswerSubmitHomework(
      {this.question, this.answer, this.images, this.position, this.records});

  int question;
  String answer;
  String position;
  String images;
  String records;


  factory AnswerSubmitHomework.fromJson(Map<String, dynamic> json) => AnswerSubmitHomework(
    question: json["question"],
    answer: json["answer"],
    records: json["records"],
    images: json["images"],
    position: json["position"],
  );

  Map<String, dynamic> toJson() => {
    "question": question,
    "answer": answer,
    "records": records,
    "images": images,
    "position": position,
  };
}
