import 'package:equatable/equatable.dart';

/// {@template user}
/// User model
///
/// [User.empty] represents an unauthenticated user.
/// {@endtemplate}
class User extends Equatable {
  /// {@macro user}
  const User({
    required this.id,
    this.email,
    this.name,
    this.photo,
  });

  final String? email;
  final String id;
  final String? name;
  final String? photo;

  static const empty = User(id: '');
  bool get isEmpty => this == User.empty;
  bool get isNotEmpty => this != User.empty;

  @override
  List<Object?> get props => [email, id, name, photo];

  factory User.fromJSON(Map<String, dynamic> json) {
    return User(id: json["id"], email: json["email"] ?? "", name: json["name"] ?? "", photo: json["photo"] ?? "");
  }

  Map<String, dynamic> toJSON() {
    return {"id": id, "email": email, "name": name, "photo": photo};
  }
}