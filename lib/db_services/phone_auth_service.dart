import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PhoneAuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static String? _verificationId;

  static Future<void> verifyPhoneNumber(String phoneNumber) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        throw Exception(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  static Future<UserCredential?> verifyOtp(String otp) async {
    if (_verificationId == null) return null;

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: otp,
    );

    UserCredential userCredential =
        await _auth.signInWithCredential(credential);

    // 🔥 Save user in Firestore
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userCredential.user!.uid)
        .set({
      "phone": userCredential.user!.phoneNumber,
      "createdAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return userCredential;
  }
}
