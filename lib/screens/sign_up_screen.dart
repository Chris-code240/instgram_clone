import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instgram_clone/resources/auth_methods.dart';
import 'package:instgram_clone/responsive/mobile_screen_layout.dart';
import 'package:instgram_clone/responsive/responsive_layout_screen.dart';
import 'package:instgram_clone/responsive/web_screen_layout.dart';
import 'package:instgram_clone/screens/login_screen.dart';
import 'package:instgram_clone/utils/colors.dart';
import 'package:instgram_clone/utils/utils.dart';
import 'package:instgram_clone/widgets/text_field_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailInputController = TextEditingController();
  final TextEditingController _passwordInputController =
      TextEditingController();
  final TextEditingController _bioInputController = TextEditingController();
  final TextEditingController _usernameInputController =
      TextEditingController();

  Uint8List? _image;
  bool _isLoading = false;

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);

    setState(() {
      _image = im;
    });
  }

  void handleSignUp() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
        email: _emailInputController.text,
        password: _passwordInputController.text,
        bio: _bioInputController.text,
        username: _usernameInputController.text,
        file: _image!);
    setState(() {
      _isLoading = false;
    });
    if (res != "success") {
      showSnackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ResponsiveScreen(
              webScreenLayout: WebScreenLayout(),
              mobileScreenLayout: MobileScreenLayout())));
    }
  }

  void navigateToLoginScreen() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  void dispose() {
    super.dispose();
    _emailInputController.dispose();
    _passwordInputController.dispose();
    _bioInputController.dispose();
    _usernameInputController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Container(),
            flex: 2,
          ),
          SvgPicture.asset(
            'logo.svg',
            height: 64,
          ),
          SizedBox(
            height: 60,
          ),
          Stack(
            children: [
              _image != null
                  ? CircleAvatar(
                      backgroundImage: MemoryImage(_image!),
                      radius: 60,
                    )
                  : CircleAvatar(
                      backgroundImage: AssetImage('avatar.png'),
                      radius: 60,
                    ),
              Positioned(
                child: IconButton(
                  onPressed: selectImage,
                  icon: Icon(Icons.add_a_photo),
                ),
                bottom: -9,
                left: 75,
              )
            ],
          ),
          SizedBox(height: 24),
          TextFieldInput(
            hintText: "Enter username",
            textInputType: TextInputType.text,
            textEditingController: _usernameInputController,
          ),
          SizedBox(
            height: 24,
          ),
          TextFieldInput(
            hintText: "Enter your Email",
            textInputType: TextInputType.emailAddress,
            textEditingController: _emailInputController,
          ),
          SizedBox(
            height: 24,
          ),
          TextFieldInput(
            hintText: "Enter your bio",
            textInputType: TextInputType.text,
            textEditingController: _bioInputController,
          ),
          SizedBox(
            height: 24,
          ),
          TextFieldInput(
            hintText: "Enter your password",
            textInputType: TextInputType.text,
            textEditingController: _passwordInputController,
            isPassword: true,
          ),
          SizedBox(
            height: 24,
          ),
          InkWell(
            onTap: handleSignUp,
            child: Container(
              child: _isLoading
                  ? CircularProgressIndicator(
                      color: primaryColor,
                    )
                  : Text("Sign Up"),
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const ShapeDecoration(
                  color: blueColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)))),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Flexible(
            child: Container(),
            flex: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Text("Already a member?"),
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              GestureDetector(
                onTap: navigateToLoginScreen,
                child: Container(
                  child: Text(
                    "Log in",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
              )
            ],
          ),
        ],
      ),
    )));
  }
}
