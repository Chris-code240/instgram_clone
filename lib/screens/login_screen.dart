import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instgram_clone/resources/auth_methods.dart';
import 'package:instgram_clone/responsive/mobile_screen_layout.dart';
import 'package:instgram_clone/responsive/responsive_layout_screen.dart';
import 'package:instgram_clone/responsive/web_screen_layout.dart';
import 'package:instgram_clone/screens/home_screen.dart';
import 'package:instgram_clone/screens/sign_up_screen.dart';
import 'package:instgram_clone/utils/colors.dart';
import 'package:instgram_clone/widgets/text_field_input.dart';
import 'package:instgram_clone/utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailInputController = TextEditingController();
  final TextEditingController _passwordInputController =
      TextEditingController();

  bool _isLoading = false;

  Future<void> handleLogin() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailInputController.text,
        password: _passwordInputController.text);

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

  void navigateToSignUp() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SignUpScreen()));
  }

  @override
  void dispose() {
    super.dispose();
    _emailInputController.dispose();
    _passwordInputController.dispose();
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
            height: 64,
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
            hintText: "Enter your password",
            textInputType: TextInputType.text,
            textEditingController: _passwordInputController,
            isPassword: true,
          ),
          SizedBox(
            height: 24,
          ),
          InkWell(
            onTap: handleLogin,
            child: Container(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    )
                  : Text("Log in"),
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
                child: Text("Not a member yet?"),
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              GestureDetector(
                onTap: navigateToSignUp,
                child: Container(
                  child: Text(
                    "Sign up",
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
