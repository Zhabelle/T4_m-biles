part of 'cuenta_bloc.dart';

@immutable
abstract class CuentaEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class CuentaChangedEvent extends CuentaEvent {
  
}
