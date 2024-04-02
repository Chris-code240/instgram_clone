import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instgram_clone/models/post.dart';
import 'package:instgram_clone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String username, Uint8List file, String description,
      String uid, String profileImageURL) async {
    try {
      String imageURL =
          await StorageMethods().uploadToStorage('posts', file, true);
      String postID = Uuid().v1();
      Post post = Post(
        datePublished: DateTime.now(),
        username: username,
        postID: postID,
        postImageURL: imageURL,
        profileImageURL: profileImageURL,
        description: description,
        uid: uid,
        likes: [],
      );

      _firebaseFirestore.collection('posts').doc(postID).set(post.toJson());
      return "success";
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> likePost(String uid, String postID, List likes) async {
    try {
      if (likes.contains(uid)) {
        //dislike
        await _firebaseFirestore.collection('posts').doc(postID).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        //like
        await _firebaseFirestore.collection('posts').doc(postID).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> followUser(
      String uidOfUserToFollow, String uidOfCurrentUser, List followers) async {
    if (followers.contains(uidOfCurrentUser)) {
      //unfollow
      await _firebaseFirestore
          .collection('users')
          .doc(uidOfUserToFollow)
          .update({
        'likes': FieldValue.arrayRemove([uidOfCurrentUser])
      });
      //remove target user's uid from current users following array
      await _firebaseFirestore
          .collection('users')
          .doc(uidOfUserToFollow)
          .update({
        'following': FieldValue.arrayRemove([uidOfUserToFollow])
      });
    } else {
      //follow
      await _firebaseFirestore
          .collection('users')
          .doc(uidOfUserToFollow)
          .update({
        'likes': FieldValue.arrayUnion([uidOfCurrentUser])
      });
      //add target user's uid from current users following array
      await _firebaseFirestore
          .collection('users')
          .doc(uidOfUserToFollow)
          .update({
        'following': FieldValue.arrayUnion([uidOfUserToFollow])
      });
    }
  }

  Future<String> postComment(String postID, String uid, String text,
      String username, String profileImageURL) async {
    try {
      if (text.isNotEmpty) {
        String commentID = Uuid().v1();
        await _firebaseFirestore
            .collection('posts')
            .doc(postID)
            .collection('comments')
            .doc(commentID)
            .set({
          'profileIamgeURl': profileImageURL,
          'commentID': commentID,
          'uid': uid,
          'username': username,
          'text': text,
          'datePublished': DateTime.now(),
        });
        return "success";
      }
      return "Comment is empty";
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  //Deleting a post

  Future<void> deletePost(String postID) async {
    try {
      await _firebaseFirestore.collection('posts').doc(postID).delete();
    } catch (e) {
      print(e.toString());
    }
  }
}
