import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String username;
  final String uid;
  final String imageURL;
  final String email;
  final String bio;
  final List followers;
  final List following;

  User(
      {required this.username,
      required this.uid,
      required this.email,
      required this.bio,
      required this.imageURL,
      required this.followers,
      required this.following});

  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'bio': bio,
        'email': email,
        'followers': followers,
        'following': following,
        'imageURL': imageURL
      };

  // static User fromSnapshotToUser(DocumentSnapshot documentSnapshot) {
  //   Map<String, dynamic> mapped = (documentSnapshot as Map<String, dynamic>);
  //   return User(
  //       uid: mapped['uid'],
  //       username: mapped['username'],
  //       email: mapped['email'],
  //       bio: mapped['bio'],
  //       followers: mapped['followers'],
  //       following: mapped['following'],
  //       imageURL: mapped['imageURL']);
  // }
  static User fromSnapshotToUser(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> mapped =
        documentSnapshot.data()! as Map<String, dynamic>;
    return User(
        uid: mapped['uid'],
        username: mapped['username'],
        email: mapped['email'],
        bio: mapped['bio'],
        followers: mapped['followers'],
        following: mapped['following'],
        imageURL: mapped['imageURL']);
  }
}
