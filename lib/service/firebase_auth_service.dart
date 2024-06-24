import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../Screen/Auth/toggle.dart';
import '../Widgets/snackbar.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;
  FirebaseAuthMethods(this._auth);

  User get user => _auth.currentUser!;

  Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();

  Future<bool> signUpWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then(
        (value) {
          if (value.user != null) {
            return true;
          } else {
            return false;
          }
        },
      );
      return true;
    } on FirebaseAuthException catch (e) {
      // if you want to display your own custom error message
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      showSnackBar(
          context, e.message!); // Displaying the usual firebase error message
      return false;
    }
  }

  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      _auth.currentUser!.sendEmailVerification();
      showSnackBar(context, 'Email verification sent!');
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Display error message
    }
  }

  // EMAIL LOGIN
  Future<bool> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) {
        if (value.user != null) {
          return true;
        } else {
          return false;
        }
      });
      return true;
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
      return false;
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
    }
  }

  Future<void> deleteAccount(BuildContext context) async {
    try {
      await _auth.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
    }
  }
}



// Future<bool?> phoneSignIn(
  //   BuildContext context, {
  //   required String phoneNumber,
  // }) async {
  //   TextEditingController codeController = TextEditingController();

  //   if (kIsWeb) {
  //     try {
  //       print('its in kIsWeb');
  //       ConfirmationResult confirmationResult =
  //           await _auth.signInWithPhoneNumber(phoneNumber);
  //       showOTPDialog(
  //           context: context,
  //           codeController: codeController,
  //           onPressed: () async {
  //             PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //                 verificationId: confirmationResult.verificationId,
  //                 smsCode: codeController.text.trim());
  //             try {
  //               await _auth
  //                   .signInWithCredential(credential)
  //                   .then((value) => Navigator.pop(context))
  //                   .then((value) {
  //                 return true;
  //               });
  //             } on FirebaseAuthException catch (e) {
  //               Navigator.pop(context);
  //               showSnackBar(context, e.message.toString());
  //             }
  //             // await _auth.signInWithCredential(credential).then((value) {
  //             //   Navigator.pop(context);
  //             //   if (value != null && value != '') {
  //             //     authService.signUpUser(
  //             //         context: context,
  //             //         phoneNumber: phoneNumber,
  //             //         password: password,
  //             //         userName: userName);
  //             //   } else {
  //             //     showSnackBar(context, 'Enter a valid OTP');
  //             //   }
  //             // });
  //           });
  //       //  return true;
  //     } on FirebaseAuthException catch (e) {
  //       showSnackBar(context, 'snackbar error msg :${e.message.toString()}');
  //       return false;
  //     }
  //   }

  //   try {
  //     await _auth.verifyPhoneNumber(
  //       phoneNumber: phoneNumber,
  //       verificationCompleted: (PhoneAuthCredential credential) async {
  //         await _auth.signInWithCredential(credential);
  //       },
  //       verificationFailed: (e) {
  //         showSnackBar(context, e.message.toString());
  //       },
  //       codeAutoRetrievalTimeout: (String verificationId) {},
  //       codeSent: (String verificationId, int? forceResendingToken) async {
  //         showOTPDialog(
  //             context: context,
  //             codeController: codeController,
  //             onPressed: () async {
  //               PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //                   verificationId: verificationId,
  //                   smsCode: codeController.text.trim());

  //               // await _auth.signInWithCredential(credential);
  //               // Navigator.pop(context);
  //               try {
  //                 await _auth.signInWithCredential(credential).then((value) {
  //                   Navigator.pop(context);
  //                 }).then((value) {
  //                   return true;
  //                 });
  //               } on FirebaseAuthException catch (e) {
  //                 Navigator.pop(context);
  //                 showSnackBar(context, e.message.toString());
  //               }
  //             });
  //         // notifyListeners();
  //       },
  //     );
  //     return false;
  //   } on FirebaseAuthException catch (e) {
  //     showSnackBar(context, e.message.toString());
  //     return false;
  //   }
  // }

  // Future<void> signInWithGoogle(BuildContext context) async {
  //   try {
  //     if (kIsWeb) {
  //       GoogleAuthProvider googleProvider = GoogleAuthProvider();

  //       googleProvider
  //           .addScope('https://www.googleapis.com/auth/contacts.readonly');

  //       await _auth.signInWithPopup(googleProvider);
  //     } else {
  //       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  //       final GoogleSignInAuthentication? googleAuth =
  //           await googleUser?.authentication;

  //       if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
  //         // Create a new credential
  //         final credential = GoogleAuthProvider.credential(
  //           accessToken: googleAuth?.accessToken,
  //           idToken: googleAuth?.idToken,
  //         );
  //         UserCredential userCredential =
  //             await _auth.signInWithCredential(credential);
  //         print('/////////////////////');
  //         print("the user uid in firebase_auth is ${userCredential.user!.uid}");
  //         print('/////////////////////');
  //       }
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     showSnackBar(context, e.message!); // Displaying the error message
  //   }
  // }

  // Future<bool> signInWithGoogle(BuildContext context) async {
  //   try {
  //     if (kIsWeb) {
  //       GoogleAuthProvider googleProvider = GoogleAuthProvider();

  //       googleProvider
  //           .addScope('https://www.googleapis.com/auth/contacts.readonly');

  //       await _auth.signInWithPopup(googleProvider).then((value) {
  //         return true;
  //       });
  //       return false;
  //     } else {
  //       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  //       final GoogleSignInAuthentication? googleAuth =
  //           await googleUser?.authentication;

  //       if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
  //         // Create a new credential
  //         final credential = GoogleAuthProvider.credential(
  //           accessToken: googleAuth?.accessToken,
  //           idToken: googleAuth?.idToken,
  //         );

  //         await _auth.signInWithCredential(credential).then((value) {
  //           if (value.user != null) {
  //             print('/////////////////////');
  //             print("the user uid in firebase_auth is ${value.user!.uid}");
  //             print('/////////////////////');
  //             return true;
  //           }
  //         });
  //       }
  //       return false;
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     showSnackBar(context, e.message!);
  //     return false; // Displaying the error message
  //   }
  // }

