import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../fecs_data.dart';

class FecsDataFirebase implements FecsData {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Map<String, dynamic>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? account = userCredential.user;
      if (account != null) {
        final value =
            await _firestore.collection('users').doc(account.uid).get();
        return {'user': value.data()};
      } else {
        throw Exception('Login failed');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> signupWithEmail(
      Map<String, dynamic> user) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: user['email'],
        password: user['password'],
      );

      final User? firebaseUser = userCredential.user;

      user.remove('password');
      if (firebaseUser != null) {
        await _firestore.collection('users').doc(firebaseUser.uid).set(user);
        return {'user': user};
      } else {
        // Handle the case when the user is null (signup failed)
        throw Exception('Signup failed');
      }
    } catch (e) {
      // Handle signup errors
      rethrow;
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await _auth.signOut();
      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> recoveryPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> confirmPasswordReset(
      {required String code, required String newPassword}) async {
    try {
      await _auth.confirmPasswordReset(
        code: code,
        newPassword: newPassword,
      );
      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> removeUser({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? account = userCredential.user;
      if (account != null) {
        await _firestore.collection('users').doc(account.uid).delete();
        account.delete();
        return true;
      } else {
        throw Exception('Login failed');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> changePassword(String newPassword) async {
    try {
      await _auth.currentUser!.updatePassword(newPassword);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  //--crud--//
  @override
  Future<String> delete({required String id, required String table}) async {
    try {
      await _firestore.collection(table).doc(id).delete();
      return id;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> get(
      {required String id, required String table}) async {
    try {
      final value = await _firestore.collection(table).doc(id).get();
      return {table: value.data()};
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> post(
      {required String table, required Map<String, dynamic> body}) async {
    try {
      final value = await _firestore.collection(table).add(body);
      return {table: value};
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> put(
      {required String id,
      required String table,
      required Map<String, dynamic> body}) async {
    try {
      await _firestore.collection(table).doc(id).update(body);
      return {table: body};
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> search(
      {required String table, required String criteria}) async {
    try {
      final value = await _firestore
          .collection(table)
          .where(criteria, isEqualTo: true)
          .get();
      return {table: value};
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> searchAll(
      {required String table,
      required String criteria,
      List<Object?>? criteriaListData}) async {
    try {
      final values = await _firestore
          .collection(table)
          .where(criteria, isEqualTo: true)
          .get();
      return {table: values};
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> signupWithEmailGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      try {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final User userDetails =
            (await _auth.signInWithCredential(credential)).user!;
        // return userDetails as Map<String, dynamic>;
        return {
          'id': 1,
          'number': userDetails.uid,
          'name': userDetails.displayName,
          'email': userDetails.email,
          'picture': userDetails.photoURL,
          'type':
              2, // 1 for phone, 2 for google, 3 for facebook, 0 for anoymous
        };
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "account-exists-with-different-credential":
            throw Exception(
              "You already have an account with us. Use correct provider",
            );

          case "null":
            throw Exception("Some unexpected error while trying to sign in");
          default:
            throw Exception(e.toString());
        }
      }
    } else {
      throw Exception('Sign up with google failed');
    }
  }

  @override
  Future<void> signupWithPhone(String phoneNumber,
      {required String Function() onCodeSent,
      required void Function(Map<String, dynamic> user) onVerificationCompleted,
      required void Function(Exception exception) onVerificationFailed,
      required void Function(String verification)
          onCodeAutoRetrievalTimeout}) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      codeSent: (verificationId, forceResendingToken) async {
        final code = onCodeSent();
        final credential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: code);
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (exception) => onVerificationFailed(exception),
      codeAutoRetrievalTimeout: (verification) =>
          onCodeAutoRetrievalTimeout(verification),
      verificationCompleted: (credential) async {
        final User userDetails =
            (await _auth.signInWithCredential(credential)).user!;
        final userMap = {
          'id': 1,
          'number': userDetails.uid,
          'name': userDetails.displayName,
          'email': userDetails.email,
          'picture': userDetails.photoURL,
          'type':
              1, // 1 for phone, 2 for google, 3 for facebook, 0 for anoymous
        };
        onVerificationCompleted(userMap);
      },
    );
  }
}
