part of 'topic_of_questions_bloc.dart';

@immutable
abstract class TopicOfQuestionsEvent {}

class TopicofQuestionsSlugReciveEvent extends TopicOfQuestionsEvent {
  final String QuestionsOFSlug;
  TopicofQuestionsSlugReciveEvent({required this.QuestionsOFSlug});
}

class TopicOfQuestonsGetEvent extends TopicOfQuestionsEvent {}
