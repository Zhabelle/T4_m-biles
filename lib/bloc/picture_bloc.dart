import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'picture_event.dart';
part 'picture_state.dart';

class PictureBloc extends Bloc<PictureEvent, PictureState> {
  PictureBloc() : super(PictureInitial()) {
    on<ImageChangedEvent>(_onImageChanged);
  }

  void _onImageChanged(PictureEvent event, Emitter emit) async{
    try {
      File? img = await _pickImg();
      if(img!=null) emit(PictureSelected(pic: img));
      else emit(PictureError(err: "Img not found"));
    } catch (e) {print(e); emit(PictureError(err: "Img err"));}

  }

  Future<File?> _pickImg() async{
    ImagePicker ip = ImagePicker();
    XFile? image = await ip.pickImage(source: ImageSource.camera, maxHeight: 720, maxWidth: 720, imageQuality: 85,);
    return image != null ? File(image.path) : null;
  }
}
