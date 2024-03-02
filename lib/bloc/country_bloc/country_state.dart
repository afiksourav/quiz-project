part of 'country_bloc.dart';

@immutable
abstract class CountryState {}

class CountryInitial extends CountryState {}

class CountryGetState extends CountryState {
  List countrylist = [];
  CountryGetState({required this.countrylist});
}
