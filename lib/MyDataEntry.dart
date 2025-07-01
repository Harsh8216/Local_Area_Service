import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_notebook/LoginAuth.dart';

class MyDataEntryPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _MyDataEntryPage();
  }

}

class _MyDataEntryPage extends State<MyDataEntryPage> {
  final NameController = TextEditingController();
  final AgeController = TextEditingController();
  final ContactController = TextEditingController();
  final EmailController = TextEditingController();
  final AddressController = TextEditingController();
  final DOBController = TextEditingController();

  String ? selectGender;
  final List<String> genderItems = ['Male','Female','Transgender'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration',
          style: TextStyle(
            color: Colors.white

        ),),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: NameController,
                    decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                        )
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: AgeController,
                    decoration: InputDecoration(
                        labelText: 'Age',
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                        )
                    ),
                  ),
                ),
        
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      )
                    ),
                      items: genderItems.map((String value){
                        return DropdownMenuItem<String>(
                          value: value,
                            child: Text(value));
                      }).toList(),
                      onChanged: (newValue){
                        setState(() {
                          selectGender = newValue;
                        });
                      }
                  ),
                ),
        
        
        
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: ContactController,
                    decoration: InputDecoration(
                        labelText: 'Contact No.',
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                        )
                    ),
                  ),
                ),
        
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: EmailController,
                    decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                        )
                    ),
                  ),
                ),
        
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: AddressController,
                    decoration: InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                        )
                    ),
                  ),
                ),
        
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: DOBController,
                    readOnly: true,
                    decoration: InputDecoration(
                        labelText: 'Date of Birth',
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                        ),suffixIcon: Icon(Icons.calendar_month)
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now());

                      if(pickedDate != null){
                        String formattedDate = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                        setState(() {
                          DOBController.text = formattedDate;
                        });
                      }
                    },
                  ),
                ),
        
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    onPressed: () => saveData(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: EdgeInsets.symmetric(
                          horizontal: 80,
                          vertical: 15
                        )
                      ),
                      child: Text('SUBMIT',
                        style: TextStyle(
                        color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                      ),
                      ),
                  ),
                ),
        
              ]
          ),
        ),
      ),

    );
  }

  saveData(BuildContext context) async{
    String name = NameController.text;
    String age = AgeController.text;
    String dob = DOBController.text;
    String gender = selectGender ?? '';
    String contact = ContactController.text;
    String email = EmailController.text;
    String address = AddressController.text;

    if(name.isEmpty || age.isEmpty || dob.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill all fields!'))
      );
      return;

    }

    try{
      final uid = FirebaseAuth.instance.currentUser?.uid;
      await FirebaseFirestore.instance.collection('user').doc(uid).set({
        'Name': name,
        'Age': age,
        'Date of Birth': dob,
        'Gender': gender,
        'Contact No.': contact,
        'Email': email,
        'Address': address,
        'timestamp' : FieldValue.serverTimestamp()

      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Successfully Signup'))
      );
      
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginAuth()));

      NameController.clear();
      AgeController.clear();
      DOBController.clear();
      ContactController.clear();
      EmailController.clear();
      AddressController.clear();
      setState(() {
        selectGender = null;
      });


    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving data! :  $e'))
      );
      print('Firebase Error: $e');
    }
  }

}
