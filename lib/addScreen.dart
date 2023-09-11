import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myproject_app/chatScreen.dart';
import 'package:myproject_app/firebaseHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';


var loginUser = FirebaseAuth.instance.currentUser;

class AddScreen extends StatefulWidget{
  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  Service service = Service();
  final storeAdd = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;


  //for current user
  getCurrentUser(){
    final user = auth.currentUser;
    if(user!=null){
      loginUser = user;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: ()async{
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen()));
          }, icon: Icon(Icons.message)),
          IconButton(onPressed: ()async{
            service.signOut(context);
            //remove email from key when user logout
            SharedPreferences pref = await SharedPreferences.getInstance();
            pref.remove("email");
          }, icon: Icon(Icons.logout))
        ],
        title: Text("Add Profile User"),
      ),
      body: Column(
        children: [
          Container(
            height: 350,
            child: SingleChildScrollView(
              child: ShowAdd())),
        ],
      ),
    );
  }
}

class ShowAdd extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    TextEditingController controllerName = TextEditingController();
    TextEditingController controllerPhone = TextEditingController();
    return Container(
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: controllerName,
              decoration: const InputDecoration(label: Text("Full name"), prefixIcon: Icon(Icons.person_outline_rounded)),
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 10),
            TextFormField(
              controller: controllerPhone,
              decoration: const InputDecoration(label: Text("Phone Number"), prefixIcon: Icon(Icons.phone)),
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: (){
              Map<String,String> dataToSave={
                'FullName': controllerName.text,
                'PhoneNumber': controllerPhone.text,
                'user': loginUser!.email.toString(),
              };
              FirebaseFirestore.instance.collection('Profile').add(dataToSave);
            }, child: Text('Submit'))
          ],
        ),
      ),
    );
  }
} 