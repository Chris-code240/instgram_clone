import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:instgram_clone/models/user.dart';
import 'package:instgram_clone/providers/user_provider.dart';
import 'package:instgram_clone/utils/colors.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({super.key, required this.snap});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage:
                NetworkImage(widget.snap['profileIamgeURl'].toString()),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: widget.snap['username'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: primaryColor)),
                    TextSpan(
                        text: widget.snap['text'].toString(),
                        style: TextStyle(color: primaryColor)),
                  ])),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '01/04/24', //use intl package -> DateFormat.yMMMd().format(datetime_value).toDate();

                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: Icon(Icons.favorite_border),
          )
        ],
      ),
    );
  }
}
