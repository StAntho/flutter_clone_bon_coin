import 'package:cloud_firestore/cloud_firestore.dart';

// Constructeur de la classe utilisateur via Firebase

class Utilisateur {
  //Attributs
  late String id;
  late String nom;
  late String prenom;
  late String mail;
  String? avatar;
  String? pseudo;
  DateTime birthday = DateTime.now();
  List? annonces;
  List? favoris;

  //Constructeur
  Utilisateur(DocumentSnapshot snapshot) {
    String? provisoire;
    id = snapshot.id;
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
    nom = map["NOM"];
    prenom = map["PRENOM"];
    mail = map["MAIL"];
    provisoire = map["AVATAR"];
    if (provisoire == null) {
      // Une image spécifique que je vais luis donner
      avatar =
          "https://firebasestorage.googleapis.com/v0/b/ipssia3bdfirstapplication.appspot.com/o/icon.png?alt=media&token=c3d7cb1c-1d44-4bca-aeb8-63f08d559926";
    } else {
      avatar = provisoire;
    }
    provisoire = map["PSEUDO"];
    if (provisoire == null) {
      pseudo = "";
    } else {
      pseudo = provisoire;
    }
    Timestamp timestamp = map["BIRTHDAY"];
    birthday = timestamp.toDate();
    provisoire = map["ANNONCES"];
    if (provisoire == null) {
      annonces = [];
    } else {
      annonces = [provisoire];
    }
    provisoire = map["FAVORIS"];
    if (provisoire == null) {
      favoris = [];
    } else {
      favoris = [provisoire];
    }
  }

  //Deuxième constructeur qui affecter les valeurs à vide
  Utilisateur.empty() {
    id = "";
    nom = "";
    prenom = "";
    mail = "";
    avatar = "";
    pseudo = "";
    birthday = DateTime.now();
    annonces = [];
    favoris = [];
  }

  String nomComplet() {
    return prenom + " " + nom;
  }
}
