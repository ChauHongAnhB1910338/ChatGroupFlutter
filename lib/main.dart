import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myproject_app/chatScreen.dart';
import 'package:myproject_app/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //check if the user email is present in the key
  SharedPreferences pref = await SharedPreferences.getInstance();
  //get email from email key
  var email = pref.getString("email");
  
  if(email == null){
    runApp(const MyApp());
  }else{
    runApp(const MyApp1());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 21), 
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.yellow,
        iconTheme: IconThemeData(color: Colors.black)
        )
      ),
      home: const LoginPage(),
    );
  }
}

class MyApp1 extends StatelessWidget {
  const MyApp1({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 21), 
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.yellow,
        iconTheme: IconThemeData(color: Colors.black)
        )
      ),
      home: ChatScreen(),
    );
  }
}
