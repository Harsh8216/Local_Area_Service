import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_notebook/MyDataEntry.dart';
import 'package:my_notebook/MyDataList.dart';

class SignUp extends StatefulWidget{
  @override
  State<StatefulWidget> createState()  => _SignUp();

}

class _SignUp extends State<SignUp>{
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Create Account',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18

        ),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Enter Your Email Id',
                  prefixIcon: Icon(Icons.account_circle_rounded,color: Colors.deepPurple,),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                  )
                ),
              ),
              SizedBox(height: 20,),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Enter Your Password',
                  prefixIcon: Icon(Icons.password,color: Colors.deepPurple,),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                  )
                  )
                ),

              SizedBox(height: 20,),

              TextField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Your Password',
                  prefixIcon: Icon(Icons.password,color: Colors.deepPurple,),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
              ))),
              SizedBox(height: 40,),

              ElevatedButton(
                onPressed: signUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(
                    horizontal: 80,
                    vertical: 20
              )), child: Text('Next',
                  style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold
              )),),
              SizedBox(height: 40,),

              InkWell(
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyDataList()));
                },
                child: Text('Already have an account?',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  ),
                ),
              ),

            ],
          ),
        ),
      ));
  }

  Future<void> signUp() async{
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if(email.isEmpty || password.isEmpty || confirmPassword.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all the fields'))
      );
      return;
    }
    if(password != confirmPassword){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password does not match'))
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try{
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      if(userCredential.user != null){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Moving to Registration Page'))
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyDataEntryPage()));
      }

    } on FirebaseAuthException catch (e){
      String message = 'Something went wrong';
      if(e.code == 'email-already-in-use'){
        message = 'Email already in use';

      }else if(e.code == 'invalid-email'){
        message = 'Invalid Email';

      }else if(e.code == 'weak-password'){
        message = 'Password is too weak';

      }else{
        message = 'Error: ${e.code}';

      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)));
    }
    finally{
      setState(() {
        isLoading = false;

      });
    }
  }

}