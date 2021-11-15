

class UserModel {
  String? uid;
  String? email;
  String? imie;
  String? nazwisko;
  String? wydzial;
  String? kierunek;




  UserModel({this.uid, this.email, this.imie, this.nazwisko, this.wydzial, this.kierunek});

  UserModel.fromJson(Map<String,String> json){
    imie = json["displayName"];
    email = json["email"];
  }

  Map<String,String> toJson(){

    final Map<String, String> data = new Map<String, String>();
    data['displayName'] = imie!;
    data['email'] = email!;

    return data;
  }

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