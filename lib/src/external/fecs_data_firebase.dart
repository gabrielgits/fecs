import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../fecs_data.dart';

class FecsDataFirebase implements FecsData {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Map<String, dynamic>> signinWithEmail({
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
      final data = <String, dynamic>{};
      if (account != null) {
        final value =
            await _firestore.collection('users').doc(account.uid).get();
        data['status'] = true;
        data['data'] = value.data();
      } else {
        data['status'] = false;
        data['error'] = 'Login failed';
      }
      return data;
    } catch (e) {
      return {
        'status': false,
        'error': e.toString(),
      };
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
      final data = <String, dynamic>{};
      if (firebaseUser != null) {
        await _firestore.collection('users').doc(firebaseUser.uid).set(user);
        data['status'] = true;
        data['data'] = user;
      } else {
        data['status'] = false;
        data['error'] = 'Signup failed';
      }
      return data;
    } catch (e) {
      return {
        'status': false,
        'error': e.toString(),
      };
    }
  }

  @override
  Future<bool> logout() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      googleSignIn.signOut();
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
      final data = <String, dynamic>{};
      data['data'] = value.data();
      data['data']['id'] = value.id;
      data['status'] = true;
      return data;
    } catch (e) {
      return {
        'status': false,
        'error': e.toString(),
      };
    }
  }

  @override
  Future<Map<String, dynamic>> getAll(String table) async {
    try {
      final value = await _firestore.collection(table).get();
      final data = <String, dynamic>{};
      data['data'] = value.docs.map((e) {
        final value = e.data();
        value['id'] = e.id;
        return value;
      }).toList();
      data['status'] = true;
      return data;
    } catch (e) {
      return {
        'status': false,
        'error': e.toString(),
      };
    }
  }

  @override
  Future<Map<String, dynamic>> post(
      {required String table, required Map<String, dynamic> body}) async {
    try {
      final value = await _firestore.collection(table).add(body);
      final data = <String, dynamic>{};
      data['data'] = value;
      data['status'] = true;
      return data;
    } catch (e) {
      return {
        'status': false,
        'error': e.toString(),
      };
    }
  }

  @override
  Future<Map<String, dynamic>> put(
      {required String id,
      required String table,
      required Map<String, dynamic> body}) async {
    try {
      await _firestore
          .collection(table)
          .doc(id)
          .set(body, SetOptions(merge: true));
      final data = <String, dynamic>{};
      data['data'] = body;
      data['status'] = true;
      return data;
    } catch (e) {
      return {
        'status': false,
        'error': e.toString(),
      };
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
      final data = <String, dynamic>{};
      data['data'] = value;
      data['status'] = true;
      return data;
    } catch (e) {
      return {
        'status': false,
        'error': e.toString(),
      };
    }
  }

  @override
  Future<Map<String, dynamic>> searchAll({
    required Object field,
    required String table,
    Object? isEqualTo,
    Object? isNotEqualTo,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    Object? arrayContains,
    Iterable<Object?>? arrayContainsAny,
    Iterable<Object?>? whereIn,
    Iterable<Object?>? whereNotIn,
  }) async {
    try {
      final values = await _firestore
          .collection(table)
          .where(field,
              isEqualTo: isEqualTo,
              isNotEqualTo: isNotEqualTo,
              isLessThan: isLessThan,
              isLessThanOrEqualTo: isLessThanOrEqualTo,
              isGreaterThan: isGreaterThan,
              isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
              arrayContains: arrayContains,
              arrayContainsAny: arrayContainsAny,
              whereIn: whereIn,
              whereNotIn: whereNotIn)
          .get();
      final data = <String, dynamic>{};
      data['data'] = values.docs.map((e) {
        final value = e.data();
        value['id'] = e.id;
        return value;
      }).toList();
      data['status'] = true;
      return data;
    } catch (e) {
      return {
        'status': false,
        'error': e.toString(),
      };
    }
  }

  @override
  Query<Map<String, dynamic>> searchAllQuery({
    required Object field,
    required String table,
    Object? isEqualTo,
    Object? isNotEqualTo,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    Object? arrayContains,
    Iterable<Object?>? arrayContainsAny,
    Iterable<Object?>? whereIn,
    Iterable<Object?>? whereNotIn,
  }) {
    final values = _firestore.collection(table).where(field,
        isEqualTo: isEqualTo,
        isNotEqualTo: isNotEqualTo,
        isLessThan: isLessThan,
        isLessThanOrEqualTo: isLessThanOrEqualTo,
        isGreaterThan: isGreaterThan,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
        arrayContains: arrayContains,
        arrayContainsAny: arrayContainsAny,
        whereIn: whereIn,
        whereNotIn: whereNotIn);
    return values;
  }

  @override
  Future<Map<String, dynamic>> signinWithGoogle() async {
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
        final data = <String, dynamic>{};
        data['status'] = true;
        data['data'] = {
          'id': userDetails.uid,
          'number': userDetails.uid,
          'name': userDetails.displayName,
          'email': userDetails.email,
          'picture': userDetails.photoURL,
          'type':
              2, // 1 for phone, 2 for google, 3 for facebook, 0 for anoymous
        };
        return data;
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "account-exists-with-different-credential":
            return {
              'status': false,
              'error':
                  "You already have an account with us. Use correct provider",
            };
          case "null":
            return {
              'status': false,
              'error': "Something went wrong. Please try again later",
            };
          default:
            return {
              'status': false,
              'error': e.toString(),
            };
        }
      }
    } else {
      return {
        'status': false,
        'error': "Sign up with google failed",
      };
    }
  }

  @override
  Future<void> signinWithPhone(String phoneNumber,
      {required Future<String> Function() onCodeSent,
      required void Function(Map<String, dynamic> user) onVerificationCompleted,
      required void Function(Exception exception) onVerificationFailed,
      required void Function(String verification)
          onCodeAutoRetrievalTimeout}) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      codeSent: (verificationId, forceResendingToken) async {
        final code = await onCodeSent();
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
          'id': userDetails.uid,
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
