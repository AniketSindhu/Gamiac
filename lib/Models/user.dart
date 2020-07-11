import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String gamer_tag;
  final String uid;
  final String email;
  final String name;
  final String photoUrl;
  final String bio;

  User(
      {this.gamer_tag,
      this.uid,
      this.photoUrl,
      this.email,
      this.name,
      this.bio});

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
        gamer_tag: doc['gamer_Tag'],
        uid: doc['uid'],
        email: doc['email'],
        name: doc['name'],
        photoUrl: doc['profile_pic'],
        bio: doc['bio']);
  }
}