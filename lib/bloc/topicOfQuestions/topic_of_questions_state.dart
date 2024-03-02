part of 'topic_of_questions_bloc.dart';

@immutable
abstract class TopicOfQuestionsState {}

class TopicOfQuestionsInitial extends TopicOfQuestionsState {}

class TopicOfQuestionsGetState extends TopicOfQuestionsState {
  List allQuestionsData = [];
  TopicOfQuestionsGetState({required this.allQuestionsData});
}
