import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instgram_clone/models/user.dart';
import 'package:instgram_clone/providers/user_provider.dart';
import 'package:instgram_clone/resources/firestore_methods.dart';
import 'package:instgram_clone/screens/comments_screen.dart';
import 'package:instgram_clone/screens/profile_screen.dart';
import 'package:instgram_clone/utils/colors.dart';
import 'package:instgram_clone/utils/utils.dart';
import 'package:instgram_clone/widgets/like_animation.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  bool isLiked = false;
  int commentsTotal = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getComments();
  }

  void getComments() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postID'])
          .collection('comments')
          .get();
      setState(() {
        commentsTotal = querySnapshot.docs.length;
      });
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: mobileBackgroundColor,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                InkWell(
                  child: CircleAvatar(
                    radius: 16,
                    backgroundImage:
                        NetworkImage(widget.snap['profileImageURL']),
                  ),
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) =>
                            ProfileScreen(uid: widget.snap['uid'])));
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.snap['username'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => Dialog(
                                child: ListView(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shrinkWrap: true,
                                  children: ['Delete']
                                      .map((e) => InkWell(
                                            onTap: () async {
                                              FireStoreMethods().deletePost(
                                                  widget.snap['postID']);

                                              Navigator.of(context).pop();
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 16),
                                              child: Text(e),
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ));
                    },
                    icon: Icon(Icons.more_vert)),
              ],
            ),
          ),
          // POST Image

          InkWell(
            onDoubleTap: () async {
              await FireStoreMethods().likePost(
                  user.uid, widget.snap['postID'], widget.snap['likes']);
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(alignment: Alignment.center, children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                child: Image.network(
                  widget.snap['postImageURL'],
                  fit: BoxFit.fill,
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                opacity: isLikeAnimating ? 1 : 0,
                child: Center(
                  child: LikeAnimation(
                    child: Icon(Icons.favorite, color: Colors.red),
                    isAnimating: isLikeAnimating,
                    animationDuration: Duration(
                      milliseconds: 400,
                    ),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                  ),
                ),
              )
            ]),
          ),

          Row(
            children: [
              LikeAnimation(
                  isSmallLike: true,
                  isAnimating: widget.snap['likes'].contains(user.uid),
                  child: IconButton(
                      onPressed: () async {
                        await FireStoreMethods().likePost(user.uid,
                            widget.snap['postID'], widget.snap['likes']);
                      },
                      icon: widget.snap['likes'].contains(user.uid)
                          ? Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : Icon(Icons.favorite_border))),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) =>
                            CommentsScreen(snap: widget.snap)));
                  },
                  icon: Icon(Icons.mode_comment_outlined)),
              Expanded(
                  child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                    onPressed: () {}, icon: Icon(Icons.bookmark_border)),
              )),
            ],
          ),

          // Description Section

          Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DefaultTextStyle(
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontWeight: FontWeight.w900),
                      child: Text("${widget.snap['likes'].length} likes",
                          style: Theme.of(context).textTheme.bodyMedium),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 8),
                      child: RichText(
                          text: TextSpan(
                              style: TextStyle(color: primaryColor),
                              children: [
                            TextSpan(
                                text: widget.snap['username'],
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: " "),
                            TextSpan(text: widget.snap['description']),
                          ])),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => CommentsScreen(
                                  snap: widget.snap,
                                )));
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            commentsTotal > 1
                                ? "View all ${commentsTotal} comments"
                                : commentsTotal == 1
                                    ? "View the comment"
                                    : "Add a comment",
                            style:
                                TextStyle(color: secondaryColor, fontSize: 16),
                          )),
                    ),
                    Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          "2hrs ago",
                          style: TextStyle(color: secondaryColor, fontSize: 16),
                        )),
                  ])),
        ],
      ),
    );
  }
}
