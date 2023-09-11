import 'package:flutter/material.dart';
import 'package:myproject_app/firebaseHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
                "Register Page",
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
                    service.createUser(context, emailController.text, passwordController.text);
                    //same login
                    pref.setString("email", emailController.text);
                  }else{
                    service.errorBox(context, "Fields must not empty!");
                  }
                },
                 child: Text("Register")
              ),
              TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
              },
               child: Text("Already have account?"))
            ],
          ),
        ) 
      ),
    );
  }
}
