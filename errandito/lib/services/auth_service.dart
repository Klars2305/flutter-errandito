import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService._();

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static User? get currentUser => _auth.currentUser;
  static String? get currentUserId => _auth.currentUser?.uid;

  static Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  static Future<UserCredential> signUp({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    final UserCredential credential = await _auth
        .createUserWithEmailAndPassword(
          email: email.trim(),
          password: password,
        );

    final User? user = credential.user;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-created',
        message: 'Account was not created. Please try again.',
      );
    }

    await user.updateDisplayName(fullName.trim());

    await _firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'fullName': fullName.trim(),
      'email': email.trim(),
      'phone': phone.trim(),
      'role': null,
      'isVerified': false,
      'isOnline': false,
      'averageRating': 0.0,
      'ratingCount': 0,
      'completedErrands': 0,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return credential;
  }

  static Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = credential.user;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'fullName': user.displayName ?? user.email?.split('@').first ?? 'User',
        'isOnline': true,
        'lastLoginAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    return credential;
  }

  static Future<void> updateUserRole(String role) async {
    final User? user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'no-current-user',
        message: 'No logged-in user found.',
      );
    }

    await _firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'email': user.email,
      'fullName': user.displayName ?? user.email?.split('@').first ?? 'User',
      'role': role,
      'isOnline': true,
      'averageRating': FieldValue.increment(0),
      'ratingCount': FieldValue.increment(0),
      'completedErrands': FieldValue.increment(0),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> currentUserStream() {
    final User? user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'no-current-user',
        message: 'No logged-in user found.',
      );
    }
    return _firestore.collection('users').doc(user.uid).snapshots();
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>> getCurrentUserDoc() {
    final User? user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'no-current-user',
        message: 'No logged-in user found.',
      );
    }
    return _firestore.collection('users').doc(user.uid).get();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> runnersStream() {
    return _firestore
        .collection('users')
        .where('role', isEqualTo: 'runner')
        .snapshots();
  }

  static Future<void> signOut() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'isOnline': false,
        'lastSeenAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
    await _auth.signOut();
  }
}
