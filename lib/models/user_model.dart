

class UserModel {
  String? uid;
  String? email;
  String? imie;
  String? nazwisko;
  String? wydzial;
  String? kierunek;




  UserModel({this.uid, this.email, this.imie='Przejdź do ustawień by ustawić', this.nazwisko='Przejdź do ustawień by ustawić', this.wydzial='Przejdź do ustawień by ustawić', this.kierunek='Przejdź do ustawień by ustawić'});

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
      imie: map['imie'],
      nazwisko: map['nazwisko'],
      wydzial: map['wydzial'],
      kierunek: map['kierunek'],
    );
  }

  // to server
  Map<String, dynamic> sendToServerRegister() {
    return {
      'uid': uid,
      'email': email,
      'imie':imie,
      'nazwisko':nazwisko,
      'wydzial':wydzial,
      'kierunek': kierunek,
    };
  }
}