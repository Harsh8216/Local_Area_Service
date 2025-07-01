import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_notebook/Dashboard_Activity.dart';
import 'package:my_notebook/SignIn_With_Phone.dart';
import 'package:my_notebook/SignUp_Page.dart';

class LoginAuth extends StatefulWidget{
  @override
  State<LoginAuth> createState() => _LoginAuth();

}

class _LoginAuth extends State<LoginAuth>{
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  bool isPasswordVisible = false;

  Future<void> login() async{
    setState(() {
      isLoading = true;
    });

    try{
      UserCredential userCredential = await FirebaseAuth.instance.
      signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());

      if(userCredential.user != null){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login Successful!'))
        );

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard()));

      }


    }on FirebaseAuthException catch(e){
      String message = 'Login Failed';
      if(e.code == 'user-not-found'){
        message = 'No user found for that email.';
      }else
        if(e.code == 'wrong-password'){
        message = 'Wrong password provided';
      }else{
          message = 'Error: ${e.code}';
          print("${e.code}");
        }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message))
      );

    } finally{
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        title: Text('User Login',
          style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold
        ),),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Container(
                    height: 80,
                    width: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('LA',
                          style: TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Sora',
                            color: Colors.white
                          ),
                        ),

                        Container(
                          width: 80,
                          child: Text('Services',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold
                            ),
                            textAlign: TextAlign.center,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10))
                          ),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                ),

                SizedBox(
                  height: 50,
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(
                          Icons.account_circle_rounded,
                          color: Colors.deepPurple
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)

                      )
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20),
                  child: TextField(
                    controller: passwordController,
                    obscureText: !isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon:IconButton(
                          onPressed: (){
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;

                            });
                          },
                          icon: Icon(
                              isPasswordVisible ? Icons.visibility : Icons.visibility_off,color: Colors.deepPurple
                          )),
                      prefixIcon: Icon(Icons.lock,color: Colors.deepPurple,),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                      )
                    ),

                  ),
                ),
                SizedBox(height: 40,),
                isLoading ? CircularProgressIndicator() : ElevatedButton(
                    onPressed: login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: EdgeInsets.symmetric(
                        horizontal: 80,
                        vertical: 15
                      )
                    ),
                    child: Text('LOGIN',style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),)),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: InkWell(
                    onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUp()));
                    },
                    child: Text('SIGN UP',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25,),

                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.grey  ,
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10),
                        child: Text('OR',
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25,),

                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn_Via_phone()));
                  },
                  child: Center(
                    child: Container(
                      height: 45,
                      width: 250,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Icon(Icons.phone,color: Colors.deepPurple,),
                          ),
                          Text("Sign In with Phone",
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                          )),
                        ],
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                            color: Colors.deepPurple,
                            width: 2
                        ),

                      ),
                    ),

                  ),
                )
              ],
            ),
          ),
        ),
      ),

    );
  }

}