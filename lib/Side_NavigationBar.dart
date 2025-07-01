import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_notebook/LoginAuth.dart';
import 'package:package_info_plus/package_info_plus.dart';


class SideNavigationBar extends StatefulWidget{
  @override
  State<SideNavigationBar> createState() => _SideNavigationBarState();
}

class _SideNavigationBarState extends State<SideNavigationBar> {
  String _versionName = "";
  String userName = "User";
  String userMailId = "User Mail Id";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserData();
    fetchVersionName();

  }

  void fetchVersionName() async{
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _versionName = info.version;
    });

  }

  void fetchUserData() async {
    try{
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        print('User is not logged in.');
        return;
      }
      final doc = await FirebaseFirestore.instance.collection('user').doc(uid).get();
      if(doc.exists){
        final data = doc.data();
        if(data != null && data.containsKey('Name')){

          setState(() {
            userName = data['Name'] ?? 'N/A';
            userMailId = data['Email'] ?? 'N/A';
          });
        }else{
          print('No document found for this user.');
        }
      }

    }catch(e){
      print('Error fetching user data: $e');
    }
  }

  void _logoout() async{
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginAuth()));
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
              accountName: Text(userName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),

              ),
              accountEmail: Text(userMailId,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold

              ),
              ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage('assets/images/user_profile.png'),
            ),
          ),

          ListTile(
            title: Text('Home'),
            leading: Icon(
              Icons.home,
              color: Colors.deepPurple,
            ),
            onTap: (){
              Navigator.pop(context);
            },
          ),

          ListTile(
            title: Text('Profile'),
            leading: Icon(
              Icons.person,
              color: Colors.deepPurple,),
            onTap: (){
              Navigator.pop(context);
            },
          ),

          ListTile(
            title: Text('Settings'),
            leading: Icon(
              Icons.settings,
              color: Colors.deepPurple,),
            onTap: (){

            },
          ),

          ListTile(
            title: Text('Payment Method'),
            leading: Icon(
                Icons.add_card,
                color: Colors.deepPurple),
            onTap: (){

            }
          ),
          ListTile(
            title: Text('Wallet'),
            leading: Icon(
                Icons.wallet,
                color: Colors.deepPurple),

          ),

          ListTile(
            title: Text('Your Location'),
            leading: Icon(
                Icons.location_on,
                color: Colors.deepPurple),

          ),

          ListTile(
            title: Text('Help & Support'),
            leading: Icon(
                Icons.headset_mic,
                color: Colors.deepPurple),

          ),

          ListTile(
            title: Text('More About Company'),
            leading: Icon(
                Icons.location_city,
                color: Colors.deepPurple),

          ),


          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                  onPressed: (){
                    _logoout();
                  },
                  child: Text('Logout',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  )),
            ),
          ),

          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text('Version : $_versionName',
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 14,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          )
        ],
      ),

    );
  }
}