// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instgram_clone/models/user.dart';
import 'package:instgram_clone/providers/user_provider.dart';
import 'package:instgram_clone/resources/firestore_methods.dart';
import 'package:instgram_clone/utils/colors.dart';
import 'package:instgram_clone/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  bool _isUploading = false;
  TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _textEditingController.dispose();
  }

  void clearFile() {
    setState(() {
      _file = null;
    });
  }

  void postImage(
      {required String uid,
      required String username,
      required String profileImageURL}) async {
    try {
      setState(() {
        _isUploading = true;
      });
      String res = await FireStoreMethods().uploadPost(
          username, _file!, _textEditingController.text, uid, profileImageURL);
      setState(() {
        _isUploading = true;
      });

      if (res == "success") {
        showSnackBar(res, context);
        clearFile();
      } else {
        showSnackBar(res, context);
      }
    } catch (e) {
      setState(() {
        _isUploading = true;
      });
      showSnackBar(e.toString(), context);
    }
  }

  _selectImage(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("Create a post"),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: Text("Take a photo"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera);

                  setState(() {
                    _file = file;
                  });
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return _file == null
        ? Center(
            child: IconButton(
                onPressed: () async {
                  return showDialog(
                      context: context,
                      builder: (context) {
                        return SimpleDialog(
                          title: Text("Create a post"),
                          children: [
                            SimpleDialogOption(
                              padding: const EdgeInsets.all(20),
                              child: Text("Take a photo"),
                              onPressed: () async {
                                Navigator.of(context).pop();
                                Uint8List file =
                                    await pickImage(ImageSource.camera);

                                setState(() {
                                  _file = file;
                                });
                              },
                            ),
                            SimpleDialogOption(
                              padding: const EdgeInsets.all(20),
                              child: Text("Choose from gallery"),
                              onPressed: () async {
                                Navigator.of(context).pop();
                                Uint8List file =
                                    await pickImage(ImageSource.gallery);

                                setState(() {
                                  _file = file;
                                });
                              },
                            ),
                            SimpleDialogOption(
                              padding: const EdgeInsets.all(20),
                              child: Text("Cancel"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      });
                },
                icon: Icon(Icons.file_upload_outlined)),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                  onPressed: () {
                    setState(() {
                      _file = null;
                    });
                  },
                  icon: Icon(Icons.chevron_left)),
              title: Text(
                "Post to",
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: false,
              actions: [
                TextButton(
                    onPressed: () => postImage(
                        profileImageURL: user.imageURL,
                        uid: user.uid,
                        username: user.username),
                    child: Text(
                      "Post",
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold),
                    ))
              ],
            ),
            body: Column(
              children: [
                _isUploading
                    ? LinearProgressIndicator()
                    : Padding(padding: const EdgeInsets.only(top: 0.0)),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage("${user.imageURL}"),
                      radius: 20,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextField(
                        controller: _textEditingController,
                        decoration: InputDecoration(
                            hintText: "Write a caption...",
                            border: InputBorder.none),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: MemoryImage(_file!),
                                  fit: BoxFit.fill,
                                  alignment: FractionalOffset.topCenter)),
                        ),
                      ),
                    ),
                    Divider(),
                  ],
                ),
              ],
            ),
          );
  }
}
