part of 'picture_bloc.dart';

@immutable
abstract class PictureEvent extends Equatable{
  const PictureEvent();

  @override
  List<Object> get props => [];
}

class ImageChangedEvent extends PictureEvent {  
  
}