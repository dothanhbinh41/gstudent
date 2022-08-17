
//exam type
enum ExamType { GIAOTIEP , TOEIC , IELTS }

final examTypeValues = EnumValues({
  "toeic": ExamType.TOEIC,
  "giaotiep": ExamType.GIAOTIEP,
  "ielts": ExamType.IELTS
});

//group qs type
enum GroupQuestionType { TEXT, EMPTY, SOUND , TRUE_FALSE_NOTGIVEN, TABLE,  SELECT_MULTIPLE, YES_NO_NOTGIVEN, COMPLETE_SUMMARY, BORDER, FORM, LECTURES_COMMENTS,FILL_IMAGE, FILL_LIMIT_WORD,DIAGRAM }

final groupQuestionTypeValues = EnumValues({
  "": GroupQuestionType.EMPTY,
  "sound": GroupQuestionType.SOUND,
  "text": GroupQuestionType.TEXT,
  "complete-summary": GroupQuestionType.COMPLETE_SUMMARY,
  "select-multiple": GroupQuestionType.SELECT_MULTIPLE,
  "table": GroupQuestionType.TABLE,
  "true-false-notgiven": GroupQuestionType.TRUE_FALSE_NOTGIVEN,
  "yes-no-notgiven": GroupQuestionType.YES_NO_NOTGIVEN,
  "border": GroupQuestionType.BORDER,
  "form": GroupQuestionType.FORM,
  "lectures-comments": GroupQuestionType.LECTURES_COMMENTS,
  "fill-image": GroupQuestionType.FILL_IMAGE,
  "fill-limit-word": GroupQuestionType.FILL_LIMIT_WORD,
  "diagram" : GroupQuestionType.DIAGRAM
});

//question type

enum QuestionMediaType { GROUP_QUESTION_IMAGE, EMPTY, IMAGE, BORDER , TEXT }

final questionMediaTypeValues = EnumValues({
  "border": QuestionMediaType.BORDER,
  "": QuestionMediaType.EMPTY,
  "group_question_image": QuestionMediaType.GROUP_QUESTION_IMAGE,
  "image": QuestionMediaType.IMAGE,
  "text": QuestionMediaType.TEXT
});


enum QuestionType { GENERAL_TEST, LISTENING, READING }

final questionTypeValues = EnumValues({
  "general test": QuestionType.GENERAL_TEST,
  "listening": QuestionType.LISTENING,
  "reading": QuestionType.READING
});


//section type
enum Section {
  EMPTY,
  LISTENING_1,
  LISTENING_2,
  LISTENING_3,
  READING_1,
  READING_2,
  SECTION_1, SECTION_2, SECTION_3, SECTION_4,
  READING_PASSAGE_1, READING_PASSAGE_2, READING_PASSAGE_3
}

final sectionValues = EnumValues({
  "": Section.EMPTY,
  "LISTENING 1": Section.LISTENING_1,
  "LISTENING 2": Section.LISTENING_2,
  "LISTENING 3": Section.LISTENING_3,
  "READING 1": Section.READING_1,
  "READING 2": Section.READING_2,
  "SECTION 1": Section.SECTION_1,
  "SECTION 2": Section.SECTION_2,
  "SECTION 3": Section.SECTION_3,
  "SECTION 4": Section.SECTION_4,
  "READING PASSAGE 1": Section.READING_PASSAGE_1,
  "READING PASSAGE 2": Section.READING_PASSAGE_2,
  "READING PASSAGE 3.": Section.READING_PASSAGE_3
});

//answer type

enum AnswerType { EMPTY, FILL, MULTIPLE_CHOICE, TITLE, CHOOSE }

final answerTypeValues = EnumValues({
  "choose": AnswerType.CHOOSE,
  "": AnswerType.EMPTY,
  "fill": AnswerType.FILL,
  "multiple-choice": AnswerType.MULTIPLE_CHOICE,
  "title": AnswerType.TITLE
});

enum SectionMediaType { SOUND }

final sectionMediaTypeValues = EnumValues({
  "sound": SectionMediaType.SOUND
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
