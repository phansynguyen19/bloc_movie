// import 'package:equatable/equatable.dart';

// class User extends Equatable {
//   const User(this.id);

//   final String id;

//   @override
//   List<Object> get props => [id];

//   static const empty = User('-');
// }

// class User {
//   User(
//     this.id,
//     this.name,
//     this.username,
//   );

//   final String id;
//   final String name;
//   final String username;

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       json['id'],
//       json['name'],
//       json['username'],
//     );
//   }
// }

class User {
  final String hash;
  final String? avatar_path;
  final int id;
  final String iso_639_1;
  final String iso_3166_1;
  final String name;
  final bool include_adult;
  final String username;

  User(
    this.hash,
    this.avatar_path,
    this.id,
    this.iso_639_1,
    this.iso_3166_1,
    this.name,
    this.include_adult,
    this.username,
  );

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['avatar']['gravatar']['hash'],
      json['avatar']['tmdb']['avatar_path'],
      json['id'],
      json['iso_639_1'],
      json['iso_3166_1'],
      json['name'],
      json['include_adult'],
      json['username'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
      };
}
