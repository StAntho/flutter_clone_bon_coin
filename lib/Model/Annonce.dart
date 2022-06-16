// import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class Annonce {
  late String id;
  late String title;
  late String description;
  late String image;
  DateTime upload = DateTime.now();
  DateTime? updated;
  late double price;

  Annonce(DocumentSnapshot snapshot) {
    Timestamp? provisoire;
    id = snapshot.id;
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
    title = map["TITLE"];
    description = map["DESCRIPTION"];
    image = map["IMAGE"];

    Timestamp timestamp = map["UPLOAD"];
    upload = timestamp.toDate();

    provisoire = map["UPDATED"];
    if (provisoire == null) {
      updated = null;
    } else {
      updated = provisoire.toDate();
    }

    price = map["PRICE"];
  }

  Annonce.empty() {
    id = "";
    title = "";
    description = "";
    image = "";
    upload = DateTime.now();
    price = 0;
  }
}
