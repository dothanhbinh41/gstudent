
import '../../../api/dtos/Training/vocab/vocab.dart';

class VocabNavigationParams{
  VocabNavigationParams({this.answers,this.answerRight,this.totalQs,this.time});

  int answerRight;
  int totalQs;
  int time;
List<AnswerVocab> answers;
}