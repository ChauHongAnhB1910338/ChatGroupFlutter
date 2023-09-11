import 'package:flutter/material.dart';
import 'package:myproject_app/firebaseHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Service service = Service();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Login Page",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "Enter Your Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                child: TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: "Enter Your Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 80)
                ),
                onPressed: () async{
                  SharedPreferences pref = await SharedPreferences.getInstance();
                  if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty){
                    service.loginUser(context, emailController.text, passwordController.text);
                    
                    //save user email in email key
                    //check if email is present in the key goto chatScreen else loginScreen

                    pref.setString("email", emailController.text);
                  }else{
                    service.errorBox(context, "Fields must not empty!");
                  }
                },
                 child: Text("Login")
              ),
              TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterPage()));
              },
               child: Text("I don't have any account?"))
            ],
          ),
        ) 
      ),
    );
  }
}
