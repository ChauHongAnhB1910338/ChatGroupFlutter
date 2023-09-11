import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myproject_app/firebaseHelper.dart';
import 'package:myproject_app/profileScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';


var loginUser = FirebaseAuth.instance.currentUser;

class ChatScreen extends StatefulWidget{
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Service service = Service();
  final storeMessage = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  TextEditingController msg = TextEditingController();

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
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen()));
          }, icon: Icon(Icons.account_box)),
          IconButton(onPressed: ()async{
            service.signOut(context);
            //remove email from key when user logout
            SharedPreferences pref = await SharedPreferences.getInstance();
            pref.remove("email");
          }, icon: Icon(Icons.logout))
        ],
        title: Text("Hello "+loginUser!.email.toString()),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 350,
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              reverse: true,
              child: ShowMessages())),
          Row(children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.black,width: 0.2)
                  )
                ),
                child: TextField(
                  controller: msg,
                  decoration: InputDecoration(hintText: "Enter Message")),
              )
            ),
            IconButton(onPressed: (){
              if(msg.text.isNotEmpty){
                storeMessage.collection("Messages").doc().set({
                  "messages":msg.text.trim(),
                  "user":loginUser!.email.toString(),
                  "time":DateTime.now()
                });
                msg.clear();
              }
              
            }, icon: Icon(Icons.send,color: Colors.yellow[700],))
          ],
          )
        ],
      ),
    );
  }
}

class ShowMessages extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("Messages").orderBy("time").snapshots(),
      builder: (context,snapshot){
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              primary: true,
              physics: ScrollPhysics(),
              itemBuilder: (context, i) {
                QueryDocumentSnapshot x = snapshot.data!.docs[i];
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) async {
                    await FirebaseFirestore.instance
                        .collection('Messages')
                        .doc(x.id)
                        .delete();
                    await FirebaseFirestore.instance
                        .collection('Messages')
                        .doc(x.id)
                        .delete()
                        .then(
                          (value) => Fluttertoast.showToast(
                              msg: "Message is deleted sucessfully!",
                              gravity: ToastGravity.TOP,
                              backgroundColor: Colors.red,
                              textColor: Colors.white),
                        );
                  },
                  child: ListTile(
                    // title: Text(x['user']),
                    title: Column(
                      //if user is a seft - text in the end else text in start
                      crossAxisAlignment: loginUser!.email == x['user']
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                              color: loginUser!.email == x['user']
                                  ? Colors.yellow[400]
                                  : Colors.pink[100],
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(x['messages']),
                              // SizedBox(
                              //   height: 5,
                              // ),
                              Text(
                                "User:" + x['user'],
                                style: TextStyle(
                                    fontSize: 13, color: Colors.black),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              });
      }
    );
  }
} 