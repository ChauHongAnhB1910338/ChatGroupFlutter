import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myproject_app/chatScreen.dart';
import 'package:myproject_app/firebaseHelper.dart';
import 'package:myproject_app/profileScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';


var loginUser = FirebaseAuth.instance.currentUser;

class EditScreen extends StatefulWidget{
  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  Service service = Service();
  final storeEdit = FirebaseFirestore.instance;
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
        title: Text("Edit Profile User"),
      ),
      body: Column(
        children: [
          Container(
            height: 350,
            child: SingleChildScrollView(
              child: ShowEdit())),
        ],
      ),
    );
  }
}

class ShowEdit extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("Profile").where("user",isEqualTo: loginUser!.email.toString()).snapshots(),
      builder: (context,snapshot){
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          shrinkWrap: true, // Nếu ko đặt thì nó sẽ lớn bằng ListView gốc còn đặt thì nó sẽ lớn nhất có thể 
          itemBuilder: (context,i){
          QueryDocumentSnapshot x = snapshot.data!.docs[i];
          final collection = FirebaseFirestore.instance.collection("Profile").where("user",isEqualTo: loginUser!.email.toString());
          TextEditingController nameController = TextEditingController(text: x['FullName']);
          TextEditingController phoneController = TextEditingController(text: x['PhoneNumber']); 
              return Container(
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(label: Text("Full name"), prefixIcon: Icon(Icons.person_outline_rounded)),
                      ),
                      const SizedBox(height: 10),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: phoneController,
                        decoration: const InputDecoration(label: Text("Phone Number"), prefixIcon: Icon(Icons.phone)),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(onPressed: (){
                        final document = x.id;
                        final doc = FirebaseFirestore.instance.collection("Profile").doc(document.toString());
                        doc.update({
                          'FullName': nameController.text,
                          'PhoneNumber': phoneController.text
                        });
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen()));
                      }, child: Text('Submit'))
                    ],
                  ),
                ),
              );
          }
        );
        }
        
      }
    );
  }
} 