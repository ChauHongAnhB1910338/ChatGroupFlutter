import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myproject_app/addScreen.dart';
import 'package:myproject_app/chatScreen.dart';
import 'package:myproject_app/editScreen.dart';
import 'package:myproject_app/firebaseHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';


var loginUser = FirebaseAuth.instance.currentUser;

class ProfileScreen extends StatefulWidget{
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Service service = Service();
  final storeProfile = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  TextEditingController prf = TextEditingController();

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
        title: Text("Profile User"),
      ),
      body: Column(
        children: [
          Container(
            height: 350,
            child: SingleChildScrollView(
              child: ShowProfile())),
        ],
      ),
      
    );
  }
}

class ShowProfile extends StatelessWidget{
  @override
  Widget build(BuildContext context){
      return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("Profile").where('user',isEqualTo: loginUser!.email).snapshots(),
      builder: (context,snapshot){
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator(),);
        }
        if(snapshot.data!.docs.length.toString() == "1") {
          return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          shrinkWrap: true, // Nếu ko đặt thì nó sẽ lớn bằng ListView gốc còn đặt thì nó sẽ lớn nhất có thể 
          itemBuilder: (context,i){
            QueryDocumentSnapshot x = snapshot.data!.docs[i];
            int ProfileCount = snapshot.data!.docs.length;
              return Container(
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        initialValue: x["FullName"],
                        decoration: const InputDecoration(label: Text("User name"), prefixIcon: Icon(Icons.person_outline_rounded)),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue: x["user"],
                        decoration: const InputDecoration(label: Text("Email"), prefixIcon: Icon(Icons.email_outlined)),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue: x["PhoneNumber"],
                        decoration: const InputDecoration(label: Text("Phone Number"), prefixIcon: Icon(Icons.phone)),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue: loginUser!.uid.toString(),
                        decoration: const InputDecoration(label: Text("UID user"), prefixIcon: Icon(Icons.password)),
                      ),
                      const SizedBox(height: 10),
                      IconButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>EditScreen()));
                      }, icon: Icon(Icons.edit)),
                    ],
                  ),
                ),
              );
          }
        );
        }else{
          return Container(
            child: IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddScreen()));
            }, icon: Icon(Icons.add)),
          );
        }
        
        }
    );
    
  }
} 