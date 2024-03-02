part of 'topic_of_subject_bloc.dart';

@immutable
abstract class TopicOfSubjectEvent {}

class TopicSlugReciveEvent extends TopicOfSubjectEvent {
  final String subjectOFSlug;
   TopicSlugReciveEvent({required this.subjectOFSlug});
   
}

class TopicGetEvent extends TopicOfSubjectEvent {}
