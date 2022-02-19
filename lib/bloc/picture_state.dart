part of 'picture_bloc.dart';

@immutable
abstract class PictureState extends Equatable {
  const PictureState();

  @override
  List<Object> get props => [];
}

class PictureInitial extends PictureState {}

class PictureSelected extends PictureState {
  final File pic;

  PictureSelected({required this.pic});

  @override
  List<Object> get props => [pic];
}

class PictureError extends PictureState {
  final String err;

  PictureError({required this.err});
  @override
  List<Object> get props => [err];
}
