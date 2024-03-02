part of 'topic_of_subject_bloc.dart';

@immutable
abstract class TopicOfSubjectState {}

class TopicOfSubjectInitial extends TopicOfSubjectState {}

class TopicGetState extends TopicOfSubjectState {
  List allTopic = [];
  TopicGetState({required this.allTopic});
}
