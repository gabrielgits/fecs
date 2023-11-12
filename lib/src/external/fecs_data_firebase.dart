import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
}
