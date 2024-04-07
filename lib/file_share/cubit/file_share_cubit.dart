import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'file_share_state.dart';

class FileShareCubit extends Cubit<FileShareState> {
  FileShareCubit() : super(FileShareInitial());
}
