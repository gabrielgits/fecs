abstract class FecsData {
  Future<Map<String, dynamic>> loginWithEmail({
    required String email,
    required String password,
  });
  Future<Map<String, dynamic>> signupWithEmail(Map<String, dynamic> user);
  Future<bool> logout();
  Future<bool> recoveryPassword(String email);
  Future<bool> confirmPasswordReset(
      {required String code, required String newPassword});
  Future<bool> removeUser({required String email, required String password});
  Future<bool> changePassword(String newPassword);
  //--crud--//
  Future<String> delete({required String id, required String table});
  Future<Map<String, dynamic>> get({required String id, required String table});
  Future<Map<String, dynamic>> post(
      {required String table, required Map<String, dynamic> body});
  Future<Map<String, dynamic>> put(
      {required String id,
      required String table,
      required Map<String, dynamic> body});
  Future<Map<String, dynamic>> searchAll({
    required String table,
    required String criteria,
    List<Object?>? criteriaListData,
  });
  Future<Map<String, dynamic>> search({
    required String table,
    required String criteria,
  });
}
