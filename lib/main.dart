import 'package:flutter/material.dart';
import 'package:todolist/UI/pages/home_page.dart';
import 'package:flutter/services.dart';
import 'package:todolist/bloc/resources/injection.dart';
import 'package:todolist/jwt.dart';
import 'package:todolist/ui/pages/authenticate/login_page.dart';
import 'dart:async';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  initGetIt();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      title: 'To Do List',
      debugShowCheckedModeBanner: false,
      initialRoute: Splash.routeName,
      routes: <String, WidgetBuilder>{
        Splash.routeName: (BuildContext context) => Splash(),
        HomePage.routeName: (BuildContext context) => HomePage(),},
    );
  }
}

/// Display Splash screen while loading User's groups. Then redirect to Homepage.
/// No arguments need to be passed when navigating to page Splash
class Splash extends StatefulWidget {
  static const routeName = '/';

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  late final String apiKey;
  late double unitHeightValue;
  JWT jwt= JWT();

  @override
  void initState() {
    super.initState();
    startTime();
  }
  startTime() async {
    var _duration = Duration(seconds: 2);
    return Timer(_duration, navigationPage);
  }

  // Navigate to root page after splash screen
  void navigationPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }


  /// Update Group list from server, then load homepage.

  @override
  Widget build(BuildContext context) {
    unitHeightValue = MediaQuery.of(context).size.height * 0.001;
    return Container();
  }
}
