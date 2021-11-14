import 'package:delta_squad_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController with ChangeNotifier {
  // object
  var _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? googleSignInAccount;
  UserModel? userDetails;

  // fucntion for google login
  googleLogin() async {
    this.googleSignInAccount = await _googleSignIn.signIn();
    // inserting values to our user details model

    userDetails = UserModel(
      imie: googleSignInAccount!.displayName,
      email: googleSignInAccount!.email,
    );

    // call
    notifyListeners();
    print(userDetails!.email);
    print(userDetails!.imie);
    Fluttertoast.showToast(msg: "ZALOGOWANO");

  }

  // function for facebook login

  // logout

  logout() async {
    this.googleSignInAccount = await _googleSignIn.signOut();
    userDetails = null;
    notifyListeners();
  }
}
