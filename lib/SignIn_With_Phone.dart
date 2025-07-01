import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_notebook/Dashboard_Activity.dart';

class SignIn_Via_phone extends StatefulWidget{
  @override
  State<SignIn_Via_phone> createState() => _SignIn_Via_phoneState();
}

class _SignIn_Via_phoneState extends State<SignIn_Via_phone> {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  String? verificationId;

  bool isOtpSent = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In Via Phone"),
      ),
      body: isLoading ? Center(child: CircularProgressIndicator())
          : Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    prefixText: '+91',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                  ),
                ),
                SizedBox(height: 20),
                if(isOtpSent)
                TextField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Enter OTP",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isOtpSent ? verifyOTP : sendOTP,
                  child: Text(isOtpSent ? "Verify OTP" : "Send OTP"),
                )
              ],
            ),
          ),
        ),
      ),

    );
  }

  void showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void sendOTP() async {
    setState(() {
      isLoading = true;
    });

    try{
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+91${phoneController.text}",
          verificationCompleted: (PhoneAuthCredential credential) async{
          await FirebaseAuth.instance.signInWithCredential(credential);
          setState(() => isLoading = false);
          showSnack("Auto-verified and logged in!");

          },
          verificationFailed: (FirebaseAuthException e){
            setState(() => isLoading = false);
            showSnack("Error: ${e.message}");
          },
          codeSent: (String verId, int? resendToken){
          setState(() {
            verificationId = verId;
            isOtpSent = true;
            isLoading = false;
          });
          showSnack("OTP sent!");

          },
          codeAutoRetrievalTimeout: (String verId){
          verificationId = verId;
          });

    }catch(e){
      setState(() => isLoading = false);
      showSnack("Error: ${e.toString()}");
    }
  }

  void verifyOTP() async {
    setState(() => isLoading = true);
    try {
      final credential = PhoneAuthProvider.credential(
          verificationId: verificationId!,
          smsCode: otpController.text);

      await FirebaseAuth.instance.signInWithCredential(credential);
      setState(() => isLoading = false);
      showSnack("Login Successful!");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard()));

    } catch (e) {
      showSnack("Invalid OTP");

    }finally{
      setState(() => isLoading = false);
    }
  }
}