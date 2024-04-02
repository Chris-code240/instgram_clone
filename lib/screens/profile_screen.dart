import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:instgram_clone/resources/firestore_methods.dart';
import 'package:instgram_clone/utils/colors.dart';
import 'package:instgram_clone/utils/utils.dart';
import 'package:instgram_clone/widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLength = 0;
  bool isFollowing = false;
  bool isLoading = false;
  bool dataUpdated = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    try {
      setState(() {
        isLoading = true;
      });
      var userDocumentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      setState(() {
        userData = userDocumentSnapshot.data()!;
      });
      var postDocumentSnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      setState(() {
        postLength = postDocumentSnapshot.docs.length;
      });
      setState(() {
        isFollowing = userData['followers']
            .contains(FirebaseAuth.instance.currentUser!.uid);
      });
      setState(() {
        isLoading = false;
      });
      print(widget.uid == userData['uid']);
      print(userData['uid']);
      print(widget.uid);
      print(FirebaseAuth.instance.currentUser!.email);
      print(userData['email']);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: const CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(userData['username']),
              leading: GestureDetector(
                child: Icon(Icons.chevron_left),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              centerTitle: false,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage("${userData['imageURL']}"),
                            radius: 40,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  buildStatColumn(postLength, "Posts"),
                                  buildStatColumn(userData['followers'].length,
                                      "Followers"),
                                  buildStatColumn(userData['following'].length,
                                      "Following"),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  FirebaseAuth.instance.currentUser!.uid ==
                                          userData['uid']
                                      ? FollowButton(
                                          backgroundColor:
                                              mobileBackgroundColor,
                                          borderColor: Colors.grey,
                                          text: "Edit profile",
                                          textColor: primaryColor,
                                          function: () {},
                                        )
                                      : isFollowing
                                          ? FollowButton(
                                              backgroundColor: primaryColor,
                                              borderColor: Colors.grey,
                                              text: "Unfollow",
                                              textColor: mobileBackgroundColor,
                                              function: () async {
                                                FireStoreMethods().followUser(
                                                    userData['uid'],
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid,
                                                    userData['followers']);
                                                setState(() {
                                                  isFollowing = false;
                                                  dataUpdated = true;
                                                });
                                              },
                                            )
                                          : FollowButton(
                                              backgroundColor: blueColor,
                                              borderColor: blueColor,
                                              text: "Follow",
                                              textColor: primaryColor,
                                              function: () async {
                                                FireStoreMethods().followUser(
                                                    userData['uid'],
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid,
                                                    userData['followers']);
                                                setState(() {
                                                  isFollowing = true;
                                                  dataUpdated = true;
                                                });
                                              },
                                            )
                                ],
                              ),
                            ]),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          userData['username'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 1),
                        child: Text(
                          userData['bio'],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
  }
}

Column buildStatColumn(int num, String label) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        num.toString(),
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      Container(
        margin: const EdgeInsets.only(top: 4, right: 16),
        child: Text(
          label,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey),
        ),
      )
    ],
  );
}
