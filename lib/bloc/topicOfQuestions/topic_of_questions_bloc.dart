import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quiz/services/repo/repositores.dart';
import 'dart:developer' as a;

part 'topic_of_questions_event.dart';
part 'topic_of_questions_state.dart';

class TopicOfQuestionsBloc extends Bloc<TopicOfQuestionsEvent, TopicOfQuestionsState> {
  String slug = '';
  TopicOfQuestionsBloc() : super(TopicOfQuestionsInitial()) {
    on<TopicofQuestionsSlugReciveEvent>(topicofQuestionsSlugReciveEvent);
    on<TopicOfQuestonsGetEvent>(topicOfQuestonsGetEvent);
  }

  FutureOr<void> topicofQuestionsSlugReciveEvent(TopicofQuestionsSlugReciveEvent event, Emitter<TopicOfQuestionsState> emit) {
    print("questne senvt ");
    slug = event.QuestionsOFSlug;
    print(event.QuestionsOFSlug);
  }

  FutureOr<void> topicOfQuestonsGetEvent(TopicOfQuestonsGetEvent event, Emitter<TopicOfQuestionsState> emit) async {
    Map allQuestionsData = await Repositores().topicsOfQuestions(slug,1);

    emit(TopicOfQuestionsGetState(allQuestionsData: allQuestionsData['data']['questions']['data']));
    // print("bbbbbbbbbbbbbbbb${topicData}");
  }
}
