import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:thinkdebug/google_auth.dart';


class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();

  var otpcontroller = OtpFieldController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool? isCheck = false;
  bool showloading = false;
  String verificationIDget = "";
  String otp = "";
  bool state = true;
  int start = 60;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF083663),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              Container(
                height: 290,
                width: 500,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage("assets/login.png"))),

                //color: Colors.red
              ),
              state == true ? Signup() : otpfield()
            ],
          ),
        ));
  }

//SignUP Widget

  Widget Signup() {
    return Column(
      children: [
        Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(children: [
            Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30),
                child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.green,
                    ),
                    child: TextFormField(
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                      textAlign: TextAlign.center,
                      cursorColor: Colors.white,
                      controller: name,
                      decoration: const InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        hintStyle: TextStyle(fontSize: 14, color: Colors.white),
                        hintText: 'Name',
                      ),
                      validator: (input) {
                        if (input!.isEmpty) {
                          return 'Enter your name';
                        }
                      },
                    ))),
            Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30, top: 16),
                child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.green,
                    ),
                    child: TextFormField(
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                      textAlign: TextAlign.center,
                      cursorColor: Colors.white,
                      controller: email,
                      decoration: const InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        hintStyle: TextStyle(fontSize: 14, color: Colors.white),
                        hintText: 'Email id',
                      ),
                      validator: (input) {
                        if (input!.isEmpty) {
                          return 'Enter your email';
                        }
                      },
                    ))),
            Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30, top: 16),
                child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.green,
                    ),
                    child: Center(
                      child: TextFormField(
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                        textAlign: TextAlign.center,
                        cursorColor: Colors.white,
                        controller: phone,
                        decoration: const InputDecoration(
                          //prefixText: "+91",
                          contentPadding: EdgeInsets.only(left: 20),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          hintStyle:
                              TextStyle(fontSize: 14, color: Colors.white),
                          hintText: 'Mobile Number',
                        ),
                        validator: (input) {
                          if (input!.isEmpty ||
                              input.length > 15 ||
                              input.length < 10) {
                            return 'Enter valid mobile number';
                          }
                        },
                      ),
                    ))),
            Container(
              margin: const EdgeInsets.only(top: 20, left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                      side: const BorderSide(color: Colors.white),
                      checkColor: Colors.white,
                      value: isCheck,
                      onChanged: (bool? c) {
                        setState(() {
                          isCheck = c;
                        });
                      }),
                  const FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        'I have read the privacy policy and \n accept terms and conditions',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      )),
                ],
              ),
            ),
          ]),
        ),
        const SizedBox(
          height: 40,
        ),
        ElevatedButton(
            onPressed: () async {
              FirebaseService service = FirebaseService();
              try {
                await service.signInwithGoogle();

                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: Colors.black,
                    content: Text(
                      'User Created',
                      style: TextStyle(color: Colors.white),
                    )));
              } catch (e) {
                if (e is FirebaseAuthException) {
                  Text(e.message!);
                }
              }
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                      side: const BorderSide(color: Colors.grey)),
                )),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Image(
                      image: AssetImage("assets/google_logo.png"),
                      height: 25.0),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      'Sign in with Google',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w400),
                    ),
                  )
                ],
              ),
            )),
        Padding(
          padding:
              const EdgeInsets.only(left: 14.0, right: 14, top: 40, bottom: 14),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              height: 35,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() && isCheck != false) {
                    setState(() {
                      state = false;
                    });

                    starttimer();
                    verifyNumber();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(
                          'Please fill all the fields',
                          style: TextStyle(color: Colors.white),
                        )));
                  }
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.amber)),
                child: const Text(
                  'SIGNUP',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  'Not Available now',
                  style: TextStyle(color: Colors.white),
                )));
          },
          child: const Center(
            child: Text(
              'LOGIN',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        )
      ],
    );
  }

// OTP Timer function

  void starttimer() {
    const onsec = Duration(seconds: 1);
    Timer timer = Timer.periodic(onsec, (timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }

//OTP Screen Widget

  Widget otpfield() {
    return Column(
      children: [
        const SizedBox(
          height: 60,
        ),
        RichText(
            text: TextSpan(children: [
          const TextSpan(
              text: "Enter OTP",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w400)),
          TextSpan(
              text: " (00:0$start) ",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w400))
        ])),
        Container(
          height: 80,
          child: OTPTextField(
            controller: otpcontroller,
            length: 6,
            contentPadding: const EdgeInsets.only(left: 20, top: 1, right: 20),
            width: MediaQuery.of(context).size.width - 34,
            fieldWidth: 50,
            style: const TextStyle(fontSize: 16, color: Colors.white),
            fieldStyle: FieldStyle.box,
            otpFieldStyle:
                OtpFieldStyle(backgroundColor: Colors.green.shade400),
            onCompleted: (pin) {
              print("completed" + pin);
              setState(() {
                otp = pin;
              });

            
            },
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 14.0, right: 14, top: 40, bottom: 14),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              height: 35,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  try {
                    PhoneAuthCredential phoneAuthCredential =
                        PhoneAuthProvider.credential(
                            verificationId: verificationIDget, smsCode: otp);
                    signInWithPhoneAuthCredential(phoneAuthCredential);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      duration: Duration(seconds: 1),
                      backgroundColor: Colors.black,
                      content: Text(
                        'User Created',
                        style: TextStyle(color: Colors.white),
                      ),
                    ));
                  } on FirebaseAuthException catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      duration: Duration(seconds: 1),
                      backgroundColor: Colors.red,
                      content: Text(
                        e.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ));
                  }
                  name.clear();
                  email.clear();
                  phone.clear();
                  setState(() async {
                    isCheck = false;
                    state = true;
                  });
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.amber)),
                child: const Text(
                  'VERIFY',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

//Phone Authentication Function

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    try {
      final authCredential =
          await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);

      if (authCredential.user != null) {
        Signup();
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            e.toString(),
            style: const TextStyle(color: Colors.white),
          )));
    }
  }

//Verify Number Function

  void verifyNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          setState(() {
            showloading = false;
          });
          signInWithPhoneAuthCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) async {
          setState(() {
            showloading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.black,
              content: Text(
                e.message.toString(),
                style: TextStyle(color: Colors.white),
              )));
        },
        codeSent: (String verificationID, int? resendToken) {
          verificationIDget = verificationID;
        },
        codeAutoRetrievalTimeout: (String verificationID) {});
  }
}
