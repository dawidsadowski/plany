

class UserModel {
  String? uid;
  String? email;
  String? imie;
  String? nazwisko;
  String? wydzial;
  String? kierunek;




  UserModel({this.uid, this.email, this.imie, this.nazwisko, this.wydzial, this.kierunek});

  // from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
    );
  }

  // to server
  Map<String, dynamic> sendToServerRegister() {
    return {
      'uid': uid,
      'email': email,
      'imie':'Przejdź do ustawień by ustawić',
      'nazwisko':'Przejdź do ustewień by ustawić',
      'wydzial':'Przejdź do ustawień by ustawić',
      'kierunek': 'Przejdź do ustawień by ustawić',
    };
  }
}