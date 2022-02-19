part of 'cuenta_bloc.dart';

@immutable
abstract class CuentaState extends Equatable{
  const CuentaState();

  @override
  List<Object?> get props => [];
}

class CuentaInitial extends CuentaState {}

class CuentaSelected extends CuentaState {
  final Map cuentas;

  @override
  List<Object> get props => [cuentas];

  CuentaSelected({required this.cuentas});
}

class CuentaError extends CuentaState {
  final String err;
  @override
  List<Object> get props => [err];

  CuentaError({required this.err});
}
