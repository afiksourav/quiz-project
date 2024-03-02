part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileGetState extends ProfileState {
  Map UserProfile = {};
  ProfileGetState({required this.UserProfile});
}
