import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_notebook/LoginAuth.dart';
import 'package:my_notebook/ZigzagClipper.dart';

import 'MyDataEntry.dart';

class MyDataList extends StatefulWidget{
  @override
  State<MyDataList> createState() => _MyDataListState();
}

class _MyDataListState extends State<MyDataList> {
  void _logoout() async{
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginAuth()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Data List',
        style: TextStyle(
          color: Colors.white
        ),),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            onPressed: _logoout,
            icon: Icon(Icons.logout,color: Colors.white,),
            tooltip: 'Logout',
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('user').orderBy('timestamp',descending: true).snapshots(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
            return Center(
              child: Text('No Data Found'));
          }

          final userDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: userDocs.length,
              itemBuilder: (context,index){
              final userData = userDocs[index].data() as Map<String, dynamic>;

              final name = userData['Name'] ?? 'N/A';
              final age = userData['Age'] ?? 'N/A';
              final dob = userData['Date of Birth'] ?? 'N/A';
              final gender = userData['Gender'] ?? 'N/A';
              final contact = userData['Contact No.'] ?? 'N/A';
              final email = userData['Email'] ?? 'N/A';
              final address = userData['Address'] ?? 'N/A';

              return Card(
                color: Colors.white,
                margin: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipPath(
                      clipper: ZigzagClipper(),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withOpacity(0.2),
                          borderRadius:BorderRadius.only(
                            topLeft:Radius.circular(8.0),
                            topRight: Radius.circular(8.0)
                          )

                        ),
                        child: Center(
                          child: Text('$name',
                            style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Age',style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.bold,
                                fontSize: 10
                              ),),
                              Text('$age',style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14
                              ),),

                            ],
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Date of Birth',style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                              ),),
                              Text('$dob',style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                              ),),

                            ],
                          )
                        ]
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Gender',style: TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10
                                ),),
                                Text('$gender',style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14
                                ),),

                              ],
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Contact No.',style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),),
                                Text('$contact',style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),),

                              ],
                            )
                          ]
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Email',style: TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10
                                ),),
                                Text('$email',style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14
                                ),),

                              ],
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Address',style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),),
                                  Text('$address',style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),),

                                ],
                              ),
                            )
                          ]
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        TextButton.icon(
                            onPressed: () async {
                              await FirebaseFirestore.instance.collection('user').doc(userDocs[index].id).delete();
                              
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Record deleted')));

                            },
                            icon: Icon(Icons.delete,color: Colors.red,),
                            label: Text('Delete',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ))
                      ],
                    )
                  ]
                ),

              );

              }
          );
        }
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MyDataEntryPage())),
        child: Icon(Icons.add,color: Colors.white,),
        tooltip: "Entry Page",
        backgroundColor: Colors.deepPurple,

      ),
    );
  }
}