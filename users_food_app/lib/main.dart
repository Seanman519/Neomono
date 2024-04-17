import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:users_food_app/assistantMethods/address_changer.dart';
import 'package:users_food_app/assistantMethods/cart_item_counter.dart';
import 'package:users_food_app/assistantMethods/total_amount.dart';
import '/global/global.dart';
import 'package:users_food_app/splash_screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: ((c) => CartItemCounter()),
        ),
        ChangeNotifierProvider(
          create: ((c) => TotalAmount()),
        ),
        ChangeNotifierProvider(
          create: ((c) => AddressChanger()),
        )
      ],
      child: MaterialApp(
        title: 'Users App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        home: const SplashScreen(),
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
        ],
      ),
    );
  }
}
