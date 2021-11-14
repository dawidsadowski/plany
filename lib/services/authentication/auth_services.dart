import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delta_squad_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthServices with ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = "Test"; // TODO: ???
  bool get isLoading => _isLoading;

  String get errorMessage => _errorMessage;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future? register(String email, String password) async {

    try {
      setLoading(true);
      UserCredential authResult = (await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password).then((value) => {postDetailsToFirestore()})
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      })) as UserCredential;
      User? user = authResult.user;
      setLoading(false);
      return user;
    } on SocketException {
      setLoading(false);
      setMessage("Brak połączenia z internetem.");
    } on FirebaseAuthException catch(e) {
      setLoading(false);
      setMessage(e.message);
    } catch(e) {
      setLoading(false);
      setMessage("Wystąpił nieznany błąd.");
    }

    notifyListeners();
  }

  postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = firebaseAuth.currentUser;

    UserModel userModel = UserModel();
    userModel.email = user!.email;
    userModel.uid = user.uid;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Utworzono konto ");
  }

  Future? login(String email, String password) async {
    setLoading(true);

    try {
      UserCredential authResult = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = authResult.user;
      setLoading(false);
      return user;
    } on SocketException {
      setLoading(false);
      setMessage("Brak połączenia z internetem.");
    } on FirebaseAuthException catch(e) {
      setLoading(false);
      print(e.message);
      setMessage(e.message);
    } catch(e) {
      setLoading(false);
      setMessage("Wystąpił nieznany błąd.");
    }

    notifyListeners();
  }

  Future logout() async {
    await firebaseAuth.signOut();
  }

  void setLoading(val) {
    _isLoading = val;
    notifyListeners();
  }

  void setMessage(message) {
    _errorMessage = message;
    notifyListeners();
  }

  Stream<User?> get user =>
      firebaseAuth.authStateChanges().map((event) => event);
}
