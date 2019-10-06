import 'package:flutter/foundation.dart';

class User {

  int id;//unique for every object

  final String name;
  final bool hasAuth;

  User({
    @required this.name,
    @required this.hasAuth,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'hasAuth': hasAuth,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'],
      hasAuth: map['hasAuth'],
    );
  }
}