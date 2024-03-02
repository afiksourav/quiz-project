import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quiz/services/repo/repositores.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<ProfileGetEvent>(profileGetEvent);
  }

  FutureOr<void> profileGetEvent(ProfileGetEvent event, Emitter<ProfileState> emit) async {
    Map userProfile = await Repositores().GetProfile();
    if (userProfile['status'] == true) {
      emit(ProfileGetState(UserProfile: userProfile['data']['user']));
    }
  }
}
