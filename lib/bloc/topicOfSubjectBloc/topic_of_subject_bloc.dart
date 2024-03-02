import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quiz/services/repo/repositores.dart';

part 'topic_of_subject_event.dart';
part 'topic_of_subject_state.dart';

class TopicOfSubjectBloc extends Bloc<TopicOfSubjectEvent, TopicOfSubjectState> {
  String slug = '';
  TopicOfSubjectBloc() : super(TopicOfSubjectInitial()) {
    on<TopicOfSubjectEvent>((event, emit) {});
    on<TopicSlugReciveEvent>(topicSlugReciveEvent);
    on<TopicGetEvent>(topicGetEvent);
  }

  FutureOr<void> topicSlugReciveEvent(TopicSlugReciveEvent event, Emitter<TopicOfSubjectState> emit) {
    print("XXXXXXXXXXXXX");
    slug = event.subjectOFSlug;
    print(slug);
  }

  FutureOr<void> topicGetEvent(TopicGetEvent event, Emitter<TopicOfSubjectState> emit) async {
    // Map topic = await Repositores().topicsOfSubject(slug);
    // print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa${topic['data']['data']}");
    // List<dynamic> topicData = [];
    // topicData = topic['data']['data'];
    // print("bbbbbbbbbbbbbbbb${topicData}");
    // emit(TopicGetState(allTopic: topicData));
  }
}
