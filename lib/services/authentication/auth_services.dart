import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delta_squad_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices with ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = "_hidden"; // TODO: ???
  bool get isLoading => _isLoading;

  String get errorMessage => _errorMessage;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // Google
  var _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? googleSignInAccount;
  UserModel? userDetails;

  Future? register(
      String email, String password, String name, String surname) async {
    try {
      setLoading(true);
      UserCredential authResult = (await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestoreRegister(name, surname)})
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      })) as UserCredential;
      User? user = authResult.user;
      setLoading(false);

      return user;
    } on SocketException {
      setLoading(false);
      setMessage("Brak połączenia z internetem.");
    } on FirebaseAuthException catch (e) {
      setLoading(false);
      setMessage(e.message);
    } catch (e) {
      setLoading(false);
      setMessage("Wystąpił nieznany błąd.");
    }

    notifyListeners();
  }

  postDetailsToFirestoreRegister(String name, String surname) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = firebaseAuth.currentUser;

    UserModel userModel = UserModel();
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.imie = name;
    userModel.nazwisko = surname;

    await firebaseFirestore
        .collection("users")
        .doc(userModel.email)
        .set(userModel.sendToServerRegister());
    Fluttertoast.showToast(msg: "Utworzono konto ");
  }

  postDetailsToFirestore(UserModel model) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    print("zapis do firestore");


    await firebaseFirestore
        .collection("users")
        .doc(model.email).get().then((value) async {
          if(!value.exists) {
            await firebaseFirestore
                .collection("users")
                .doc(model.email).set(model.sendToServerRegister());
            Fluttertoast.showToast(msg: "Utworzono konto ");
          }
    });
  }

  Future? loginWithEmail(String email, String password) async {
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
    } on FirebaseAuthException catch (e) {
      setLoading(false);
      print(e.message);
      setMessage(e.message);
    } catch (e) {
      setLoading(false);
      setMessage("Wystąpił nieznany błąd.");
    }

    notifyListeners();
  }

  Future? loginWithGoogle() async {
    this.googleSignInAccount = await _googleSignIn.signIn();
    // inserting values to our user details model

    List<String> name = googleSignInAccount!.displayName!.split(' ');

    userDetails = UserModel(
      imie: name[0],
      nazwisko: name[1],
      email: googleSignInAccount!.email,
    );

    // call
    notifyListeners();
    print(userDetails!.email);
    print(userDetails!.imie);
    Fluttertoast.showToast(msg: "Zalogowano z Google");

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    await firebaseAuth.signInWithCredential(credential);
    userDetails!.uid = firebaseAuth.currentUser!.uid;

    await postDetailsToFirestore(userDetails!);
  }

  Future? loginWithFacebook() async {
    var result = await FacebookAuth.i.login(
      permissions: ["public_profile", "email"],
    );

    print(result.message);



    // check the status of our login
    if (result.status == LoginStatus.success) {
      final requestData = await FacebookAuth.i.getUserData(
        fields: "email, name, picture",
      );

      List<String> name =requestData["name"].toString().split(' ');

      userDetails = UserModel(
        imie: name[0],
        nazwisko: name[1],
        email: requestData["email"],
      );


      notifyListeners();
      print(userDetails!.email);
      print(userDetails!.imie);
      Fluttertoast.showToast(msg: "Zalogowano z Facebook");

      final AuthCredential facebookCredential =
          FacebookAuthProvider.credential(result.accessToken!.token);

      await firebaseAuth.signInWithCredential(facebookCredential);

      userDetails!.uid = firebaseAuth.currentUser!.uid;

      await postDetailsToFirestore(userDetails!);
    }
  }

  Future logout() async {
    this.googleSignInAccount = await _googleSignIn.signOut();
    await FacebookAuth.i.logOut();
    await firebaseAuth.signOut();
    userDetails = null;
    notifyListeners();
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
