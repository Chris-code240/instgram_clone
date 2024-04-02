import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:instgram_clone/models/user.dart';
import 'package:instgram_clone/providers/user_provider.dart';
import 'package:instgram_clone/resources/firestore_methods.dart';
import 'package:instgram_clone/resources/storage_methods.dart';
import 'package:instgram_clone/utils/colors.dart';
import 'package:instgram_clone/widgets/comment_card.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  final snap;
  const CommentsScreen({super.key, required this.snap});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
        centerTitle: false,
        backgroundColor: mobileBackgroundColor,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.chevron_left)),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .doc(widget.snap['postID'])
              .collection('comments')
              .orderBy('datePublished', descending: true)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: const CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) =>
                    CommentCard(snap: snapshot.data!.docs[index].data()));
          }),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          padding: const EdgeInsets.only(left: 16, right: 8),
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(user.imageURL),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 8.0),
                child: TextField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                      hintText: 'Comment as ${user.username}...',
                      border: InputBorder.none),
                ),
              )),
              IconButton(
                  onPressed: () async {
                    await FireStoreMethods().postComment(
                        widget.snap['postID'],
                        user.uid,
                        _textEditingController.text,
                        user.username,
                        user.imageURL);

                    setState(() {
                      _textEditingController.text = "";
                    });
                  },
                  icon: Icon(Icons.send))
            ],
          ),
        ),
      ),
    );
  }
}
