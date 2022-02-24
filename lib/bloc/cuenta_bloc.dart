import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart';

part 'cuenta_event.dart';
part 'cuenta_state.dart';

class CuentaBloc extends Bloc<CuentaEvent, CuentaState> {
  CuentaBloc() : super(CuentaInitial()) {
    on<CuentaChangedEvent>(_onCuenta);
  }

  void _onCuenta(CuentaEvent event, Emitter emit) async{
    try {
      Response res = await get(Uri.parse("https://api.sheety.co/45bbff10f31a1b93c22c6fae997c9cf2/apiT4/cuentas"));
      if(res.statusCode == HttpStatus.ok)
        emit(CuentaSelected(cuentas: jsonDecode(res.body)));
      else
        emit(CuentaError(err: "Network error"));
    } catch (e) {
        emit(CuentaError(err: e.toString()));
    }
  }
}
