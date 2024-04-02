import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String username;
  final String uid;
  final String postID;
  final String description;
  final likes;
  final String postImageURL;
  final String profileImageURL;
  final datePublished;

  Post(
      {required this.username,
      required this.uid,
      required this.description,
      required this.postID,
      required this.likes,
      required this.postImageURL,
      required this.datePublished,
      required this.profileImageURL});

  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'description': description,
        'profileImageURL': profileImageURL,
        'postImageURL': postImageURL,
        'datePublished': datePublished,
        'postID': postID,
        'likes': likes,
      };

  static Post fromSnapshotToPost(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> mapped =
        documentSnapshot.data()! as Map<String, dynamic>;
    return Post(
        uid: mapped['uid'],
        username: mapped['username'],
        postID: mapped['postID'],
        description: mapped['description'],
        postImageURL: mapped['postImageURL'],
        likes: mapped['likes'],
        profileImageURL: mapped['profileImageURL'],
        datePublished: mapped['datePublished']);
  }
}
