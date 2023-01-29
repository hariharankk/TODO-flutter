import 'package:flutter/material.dart';
import 'package:todolist/UI/pages/authenticate/signup_page.dart';
import 'package:todolist/UI/pages/home_page.dart';
import 'package:flutter/services.dart';
import 'package:todolist/UI/pages/authenticate/login_page.dart';
import 'package:todolist/UI/pages/sidebar_pages/create_new_group_page.dart';
import 'package:todolist/bloc/blocs/user_bloc_provider.dart';
import 'package:todolist/bloc/resources/repository.dart';
import 'package:todolist/bloc/resources/injection.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  initGetIt();
  runApp(MyApp());
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelGroupKey: 'reminders',
        channelKey: 'instant_notification',
        channelName: 'Basic Instant Notification',
        channelDescription:
        'Notification channel that can trigger notification instantly.',
        defaultColor: Colors.blue,
        ledColor: Colors.white,
      ),
    ],
  );
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
        LoginPage.routeName: (BuildContext context) => LoginPage(),
        SignupPage.routeName: (BuildContext context) => SignupPage(),
        HomePage.routeName: (BuildContext context) => HomePage(),
        CreateGroupPage.routeName: (BuildContext context) => CreateGroupPage(),
      },
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

  @override
  void initState() {
    super.initState();
    loadFromFuture().then(
        (navigateTo) => Navigator.of(context).pushReplacementNamed(navigateTo));
  }

  /// Update Group list from server, then load homepage.
  Future<String> loadFromFuture() async {
    apiKey = await repository.getApiKey();
    if (apiKey.isNotEmpty && apiKey.length > 0) {
      try {
        userBloc.signinUser("", "", apiKey);
        // <fetch data from server. ex. login>
      } catch (e) {
        print(e);
      }
      return HomePage.routeName;
    } else
      return LoginPage.routeName;
  }

  @override
  Widget build(BuildContext context) {
    unitHeightValue = MediaQuery.of(context).size.height * 0.001;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Colors.white],
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    "ToDo",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0 * unitHeightValue),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black54),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
