import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Pages/HomeScreen.dart';
import '../Services/UserServices.dart';

class AuthProvider with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String? smsOtp;
  String? verificationId;
  String? error = '';
  UserServices _userServices = UserServices();
  bool loading = false;
  // LocationProvider locationData = LocationProvider();
  String? screen;
  String? address;
  String? city;
  String? state;
  DocumentSnapshot? snapshot;

  Future<void> verifyPhoneNumber(
      {BuildContext? context, String? number}) async {
    loading = true;
    notifyListeners();
    verificationCompleted(PhoneAuthCredential credential) async {
      loading = false;
      notifyListeners();
      await _auth.signInWithCredential(credential);
    }

    verificationFailed(FirebaseAuthException e) {
      loading = false;
      print(e.code);
      error = e.toString();
      notifyListeners();
    }

    smsOtpSend(String? verId, int? resendToken) async {
      verificationId = verId;

      //Enter otp dialog
      smsOtpDialog(context!, number!);
    }

    try {
      _auth.verifyPhoneNumber(
          phoneNumber: number,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: smsOtpSend,
          codeAutoRetrievalTimeout: (String veriId) {
            verificationId = veriId;
          });
    } catch (e) {
      error = e.toString();
      loading = false;
      notifyListeners();
    }
  }

  Future smsOtpDialog(BuildContext context, String number) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: const [
                Text('Verification Code'),
                SizedBox(
                  height: 6,
                ),
                Text(
                  'Enter the 6 digit OTP sent to your phone number',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            content: Container(
              height: 85,
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 6,
                onChanged: (value) {
                  smsOtp = value;
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  try {
                    PhoneAuthCredential phoneAuthCredential =
                        PhoneAuthProvider.credential(
                            verificationId: verificationId!, smsCode: smsOtp!);

                    final User? user =
                        (await _auth.signInWithCredential(phoneAuthCredential))
                            .user;

                    if (user != null) {
                      loading = false;
                      notifyListeners();
                      _userServices.getUserById(user.uid).then((snapshot) {
                        if (snapshot.exists) {
                          if (screen == 'Login') {
                            //if user data exists in db, will update
                            Navigator.pushReplacementNamed(
                                context, HomeScreen.id);
                          } else {
                            updateUser(
                              id: user.uid,
                              number: user.phoneNumber,
                            );
                            Navigator.pushReplacementNamed(
                                context, HomeScreen.id);
                          }
                        } else {
                          //create new user
                          _createUser(id: user.uid, number: user.phoneNumber);
                          Navigator.pushReplacementNamed(
                              context, HomeScreen.id);
                        }
                      });
                    } else {
                      print('Login failed');
                    }

                    // if (user != null) {
                    //   print(this.screen);
                    // }
                  } catch (e) {
                    error = 'Invalid OTP';
                    notifyListeners();
                    print(e.toString());
                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  'Done',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              )
            ],
          );
        }).whenComplete(() {
      loading = false;
      notifyListeners();
    });
  }

  void _createUser({String? id, String? number}) {
    _userServices.createUserData({
      'id': id,
      'number': number,
      'address': address,
      // 'latitude': this.latitude,
      // 'longitude': this.longitude,
    });
    loading = false;
    notifyListeners();
  }

  Future<bool> updateUser({String? id, String? number}) async {
    try {
      _userServices.updateUserData({
        'id': id,
        'number': number,
        'address': address,
        // 'latitude': this.latitude,
        // 'longitude': this.longitude,
      });
      loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateDeliveryLocation(
      {String? id,
      String? number,
      String? address,
      String? city,
      String? state}) async {
    try {
      _userServices.updateUserData({
        'id': id,
        'number': number,
        'address': address,
        'city': city,
        'state': state,
      });
      loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  getUserDetails() async {
    DocumentSnapshot result = await FirebaseFirestore.instance
        .collection('Ahia Users')
        .doc(_auth.currentUser!.uid)
        .get();
    if (result != null) {
      snapshot = result;
      notifyListeners();
    } else {
      snapshot;
      notifyListeners();
    }
    return result;
  }
}
