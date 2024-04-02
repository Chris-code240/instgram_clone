import 'package:flutter/material.dart';
import 'package:instgram_clone/providers/user_provider.dart';
import 'package:instgram_clone/utils/global_variables.dart';
import 'package:provider/provider.dart';

class ResponsiveScreen extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const ResponsiveScreen(
      {super.key,
      required this.webScreenLayout,
      required this.mobileScreenLayout});

  @override
  State<ResponsiveScreen> createState() => _ResponsiveScreenState();
}

class _ResponsiveScreenState extends State<ResponsiveScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    addData();
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > webScreen) {
        return widget.webScreenLayout;
      }
      return widget.mobileScreenLayout;
    });
  }
}
