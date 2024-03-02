import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quiz/services/repo/repositores.dart';

part 'country_event.dart';
part 'country_state.dart';

class CountryBloc extends Bloc<CountryEvent, CountryState> {
  CountryBloc() : super(CountryInitial()) {
    on<CountryGetEvent>(countryGetEvent);
  }

  FutureOr<void> countryGetEvent(CountryGetEvent event, Emitter<CountryState> emit) async {
    List countries = [];
    Map<String, dynamic> country = await Repositores().countriesGet();
    countries = country["data"];
    print("blockcccc$countries");
    emit(CountryGetState(countrylist: countries));
  }
}
