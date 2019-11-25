import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'models.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);
  Future<String> signUp(String email, String password, String firstname, String lastname);
  Future<FirebaseUser> getCurrentUser();
  Future<void> signOut();
}

class Auth extends BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  Future<FirebaseUser> get getUser => _firebaseAuth.currentUser();

  Stream<FirebaseUser> get user => _firebaseAuth.onAuthStateChanged;

  Future<FirebaseUser> onRegistration(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;
    return user;
  }  
  
  @override
  Future<String> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  Future<void> updateUserData(String uid, String firstname, String lastname) {
    DocumentReference userRef = _db.collection('users').document(uid);
    return userRef.setData({
      'uid': uid,
      'firstname': firstname,
      'lastname': lastname,
      'lastActivity': DateTime.now(),
    }, merge: true);
  } 

  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  @override
  Future<FirebaseUser> getCurrentUser() async{
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  @override
  Future<String> signUp(String email, String password, String firstname, String lastname) async{
   AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    updateUserData(user.uid, firstname, lastname);
    return user.uid;
  }

}