import 'dart:developer';

import 'package:artnext/models/myuser.dart';
import 'package:artnext/pages/events/DisplayEvenementScreen.dart';
import 'package:artnext/pages/events/ListEventsScreen.dart';
import 'package:artnext/pages/events/manage/CreateEvenementScreen.dart';
import 'package:artnext/pages/events/manage/MyEvents.dart';
import 'package:artnext/pages/events/manage/UpdateEvenementScreen.dart';
import 'package:artnext/pages/login/loginScreen.dart';
import 'package:artnext/pages/user/UserInfo.dart';
import 'package:artnext/pages/wrapper.dart';
import 'package:artnext/services/AuthenticationService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

/**
 * Flutterfire init guide =>
 * https://firebase.flutter.dev/docs/overview#initializing-flutterfire
 */

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool _initialized = false;
  bool _error = false;

  void initializeFlutterFire() async {
    log('initializeFlutterFire - start');
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
      log('initializeFlutterFire - _initialized = true');
    } catch (e) {
      log('initializeFlutterFire - error');
      setState(() {
        _error = true;
      });
    }
    log('initializeFlutterFire - end');
  }

  @override
  void initState() {
    initializeFlutterFire();
    Intl.defaultLocale = 'fr_CH';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (_error) {
      // TODO: handle error
    }

    if (!_initialized) {
      // TODO: handle initialization error
    }

    return StreamProvider<MyUser?>.value(
        value: AuthenticationService().user,
        initialData: null,
        catchError: (_, __) => null,
        child: MaterialApp(
            title: 'NextArt',
            //theme: ThemeData.light(),
            debugShowCheckedModeBanner: false,
            // Start the app with the "/" named route. In this case, the app starts
            // on the FirstScreen widget.
            //initialRoute: LoginScreen.routeName,
            home: Wrapper(),
            routes: {
              LoginScreen.routeName: (context) => LoginScreen(),
              // /login
              ListEventsScreen.routeName: (context) => ListEventsScreen(),
              // /events
              DisplayEvenementScreen.routeName: (context) =>
                  DisplayEvenementScreen(),
              // /events/details
              CreateEvenementScreen.routeName: (context) =>
                  CreateEvenementScreen(),
              UpdateEvenementScreen.routeName: (context) =>
                  UpdateEvenementScreen(),
              UserInfo.routeName: (context) => UserInfo(),
              MyEvents.routeName: (context) => MyEvents()
            }));
  }
}
