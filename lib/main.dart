import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instgram_clone/firebase_options.dart';
import 'package:instgram_clone/providers/user_provider.dart';
import 'package:instgram_clone/responsive/mobile_screen_layout.dart';
import 'package:instgram_clone/responsive/web_screen_layout.dart';
import 'package:instgram_clone/responsive/responsive_layout_screen.dart';
import 'package:instgram_clone/screens/login_screen.dart';
// import 'package:instgram_clone/screens/sign_up_screen.dart';
import 'package:instgram_clone/utils/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: MaterialApp(
        title: 'Hola',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark()
            .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
        // home: const ResponsiveScreen(
        //    webScreenLayout: WebScreenLayout(),
        //    mobileScreenLayout: MobileScreenLayout()),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return const ResponsiveScreen(
                      webScreenLayout: WebScreenLayout(),
                      mobileScreenLayout: MobileScreenLayout());
                } else if (snapshot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Container(
                        child: Text("${snapshot.error.toString()}"),
                      ),
                    ),
                  );
                }
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  body: Center(
                    child: Container(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    ),
                  ),
                );
              }

              return LoginScreen();
            }),
      ),
    );
  }
}
