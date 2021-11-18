import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/screen/myDetails/myDetailsView.dart';

class SignUPView extends StatefulWidget {
  @override
  SignUPViewState createState() => SignUPViewState();
}

class SignUPViewState extends State<SignUPView> {
  final _auth = FirebaseAuth.instance;
  String _email = "";
  String _password = "";
  String _phoneNo = "";
  String _verificationID = "";
  String _otpCode = "";

  bool _isSendCode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
                onChanged: (value) {
                  _email = value;
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
                maxLines: 1,
                onChanged: (value) {
                  _password = value;
                },
                obscureText: true,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: Text('------------ OR ------------'),
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Phone number',
                ),
                maxLines: 1,
                maxLength: 10,
                onChanged: (value) {
                  _phoneNo = value;
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              Visibility(
                  visible: _isSendCode,
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'OTP',
                        ),
                        maxLines: 1,
                        maxLength: 6,
                        onChanged: (value) {
                          if (value.length == 6) {
                            _otpCode = value;
                            _loginWithNumber();
                          }
                        },
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                    ],
                  )),
              SizedBox(
                height: 20.0,
              ),
              RaisedButton(
                  color: Colors.black,
                  child: Text(
                    "SignUp",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    try {
                      if (_email.isNotEmpty) {
                        if (_password.length > 5) {
                          final newUser =
                              await _auth.createUserWithEmailAndPassword(
                                  email: _email, password: _password);
                          if (newUser != null) {
                            Get.off(MyDetailsView(
                              email: _email,
                              password: _password,
                            ));
                          }
                        } else
                          Get.snackbar(
                            "Alert",
                            "Password must be more then 5 character!",
                          );
                      } else {
                        if (_phoneNo.length == 10)
                          phoneSignIn(phoneNumber: _phoneNo);
                        else {
                          Get.snackbar(
                            "Alert",
                            "Please enter valid phone number!",
                          );
                        }
                      }
                    } catch (e) {
                      print(e);
                    }
                    //call method flutter upload
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> phoneSignIn({required String phoneNumber}) async {
    await _auth.verifyPhoneNumber(
        phoneNumber: '+91$phoneNumber',
        timeout: Duration(seconds: 60),
        verificationCompleted: _onVerificationCompleted,
        verificationFailed: _onVerificationFailed,
        codeSent: _onCodeSent,
        codeAutoRetrievalTimeout: _onCodeTimeout);
  }

  _onVerificationCompleted(PhoneAuthCredential authCredential) async {
    print("verification completed ${authCredential.smsCode}");
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      _otpCode = authCredential.smsCode!;
    });
    if (authCredential.smsCode != null) {
      try {
        UserCredential credential =
            await user!.linkWithCredential(authCredential);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'provider-already-linked') {
          await _auth.signInWithCredential(authCredential);
        }
      }
      setState(() {
        //isLoading = false;
      });
      /*Navigator.pushNamedAndRemoveUntil(
          context, Constants.homeNavigate, (route) => false);*/
    }
  }

  _onVerificationFailed(FirebaseAuthException exception) {
    if (exception.code == 'invalid-phone-number') {
      print("The phone number entered is invalid!");
      // showMessage("The phone number entered is invalid!");
    }
  }

  _onCodeSent(String verificationId, int? forceResendingToken) {
    _verificationID = verificationId;
    print(forceResendingToken);
    print("code sent");
    setState(() {
      _isSendCode = true;
    });
  }

  _onCodeTimeout(String timeout) {
    return null;
  }

  _loginWithNumber() async {
    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationID, smsCode: _otpCode);

    // Sign the user in (or link) with the credential
    final newUser = await _auth.signInWithCredential(credential);
    if (newUser != null) {
      Get.off(MyDetailsView(
        email: _email,
        password: _password,
      ));
    }
  }
}
