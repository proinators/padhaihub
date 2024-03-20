import 'package:equatable/equatable.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

/// {@template user}
/// User model
///
/// [UserModel.empty] represents an unauthenticated user.
/// {@endtemplate}
class UserModel extends Equatable {
  /// {@macro user}
  const UserModel({
    required this.id,
    this.email,
    this.name,
    this.photo,
  });

  final String? email;
  final String id;
  final String? name;
  final String? photo;

  static const empty = UserModel(id: '');
  bool get isEmpty => this == UserModel.empty;
  bool get isNotEmpty => this != UserModel.empty;

  @override
  List<Object?> get props => [email, id, name, photo];

  factory UserModel.fromJSON(Map<String, dynamic> json) {
    return UserModel(id: json["id"], email: json["email"] ?? "", name: json["name"] ?? "", photo: json["photo"] ?? "");
  }

  types.User toChatUser() {
    return types.User(
      firstName: name,
      id: id, // UID from Firebase Authentication
      imageUrl: photo,
    );
  }

  Map<String, dynamic> toJSON() {
    return {"id": id, "email": email, "name": name, "photo": photo};
  }
}