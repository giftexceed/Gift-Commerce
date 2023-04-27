import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gift_mart/Auth/WelcomeScreen.dart';
import 'package:gift_mart/Pages/CartPage.dart';
import 'package:gift_mart/Pages/HomeScreen.dart';
import 'package:provider/provider.dart';
import 'Auth/LoginScreen.dart';
import 'Pages/MainScreen.dart';
import 'Pages/Map_Screen.dart';
import 'Pages/ProductDetails.dart';
import 'Pages/ProductList.dart';
import 'Pages/ProfileScreen.dart';
import 'Pages/ProfileUpdate.dart';
import 'Pages/SetDeliveryAddress.dart';
import 'Pages/SplashScreen.dart';
import 'Pages/VendorHomeScreen.dart';
import 'Providers/Auth_Provider.dart';
import 'Providers/CartProvider.dart';
import 'Providers/CouponProvider.dart';
import 'Providers/Location_Provider.dart';
import 'Providers/OrderProvider.dart';
import 'Providers/ProductProvider.dart';
import 'Providers/StoreProvider.dart';
import 'Services/OnlinePayment.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => LocationProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => StoreProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => CartProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => CouponProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => OrderProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => ProductProvider(),
    )
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData(primaryColor: Colors.green, fontFamily: 'Lato'),

      theme:
          ThemeData(primaryColor: const Color(0xFF84c225), fontFamily: 'Lato'),
      debugShowCheckedModeBanner: false,
      // home: SplashScreen(),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        MapScreen.id: (context) => MapScreen(),
        SetDeliveryLocation.id: (context) => SetDeliveryLocation(),
        LoginScreen.id: (context) => LoginScreen(),
        MainScreen.id: (context) => MainScreen(),
        VendorHomeScreen.id: (context) => VendorHomeScreen(),
        ProductList.id: (context) => ProductList(),
        ProfileScreen.id: (context) => ProfileScreen(),
        UpdateProfile.id: (context) => UpdateProfile(),
        OnlinePayment.id: (context) => OnlinePayment(),
      },
      builder: EasyLoading.init(),
    );
  }
}
