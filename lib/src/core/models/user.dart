import 'package:flutter/foundation.dart';

class User {
  final String uid;
  final String displayName;
  final String firstName;
  final String lastName;
  final String email;
  final bool isAdmin;
  final String photoURL;

  User(
      {Key key,
      this.uid,
      this.displayName,
      this.firstName,
      this.lastName,
      this.email,
      this.isAdmin,
      this.photoURL});

  User.fromJson(Map<String, dynamic> data)
      : uid = data['uid'],
        displayName = data['displayName'],
        firstName = data['firstName'],
        lastName = data['lastName'],
        email = data['email'],
        isAdmin = data['isAdmin'],
        photoURL = data['photoURL'];

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'displayName': displayName,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'isAdmin': isAdmin,
      'photoURL': photoURL,
    };
  }
}
