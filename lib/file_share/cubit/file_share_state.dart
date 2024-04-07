part of 'file_share_cubit.dart';

sealed class FileShareState extends Equatable {
  const FileShareState();
}

final class FileShareInitial extends FileShareState {
  @override
  List<Object> get props => [];
}
