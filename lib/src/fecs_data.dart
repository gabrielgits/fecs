abstract class FecsData {
  Future<Map<String, dynamic>> signinWithEmail({
    required String email,
    required String password,
  });
  Future<Map<String, dynamic>> signupWithEmail(Map<String, dynamic> user);
  Future<void> signinWithPhone(String phoneNumber,
      {required Future<String> Function() onCodeSent,
      required void Function(Map<String, dynamic> user) onVerificationCompleted,
      required void Function(Exception exception) onVerificationFailed,
      required void Function(String verification) onCodeAutoRetrievalTimeout});
  Future<Map<String, dynamic>> signinWithGoogle();
  Future<bool> logout();
  Future<bool> recoveryPassword(String email);
  Future<bool> confirmPasswordReset(
      {required String code, required String newPassword});
  Future<bool> removeUser({required String email, required String password});
  Future<bool> changePassword(String newPassword);
  //--crud--//
  Future<String> delete({required String id, required String table});
  Future<Map<String, dynamic>> get({required String id, required String table});
  Future<Map<String, dynamic>> getAll(String table);
  Future<Map<String, dynamic>> post(
      {required String table, required Map<String, dynamic> body});
  Future<Map<String, dynamic>> put(
      {required String id,
      required String table,
      required Map<String, dynamic> body});
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
  });
  Future<Map<String, dynamic>> search({
    required String table,
    required String criteria,
  });
}
