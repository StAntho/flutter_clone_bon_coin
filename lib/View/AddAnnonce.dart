import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clone_bon_coin/Services/FirestoreHelper.dart';
import 'package:random_string/random_string.dart';

class AddAnnonce extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddAnnonceState();
  }
}

class AddAnnonceState extends State<AddAnnonce> {
  String mail = "";
  String password = "";
  String prenom = "";
  String nom = "";
  String? nomImage;
  String? urlImage;
  Uint8List? bytesImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Ajouter annonce"),
          backgroundColor: Colors.blue,
        ),
        backgroundColor: Colors.white,
        body: AnnonceForm());
  }

  Widget AnnonceForm() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 10),
          //Afficher le nom suivant les différents cas
          TextField(
              decoration: InputDecoration(
                  hintText: "Titre de l'annonce",
                  icon: const Icon(Icons.create),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
              onChanged: (String value) {
                setState(() {
                  nom = value;
                });
              }),
          const SizedBox(height: 10),
          TextField(
              decoration: InputDecoration(
                  hintText: "Description de l'annonce",
                  icon: const Icon(Icons.library_books),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
              onChanged: (String value) {
                setState(() {
                  prenom = value;
                });
              }),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.panorama),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red, // background
                  onPrimary: Colors.white, // foreground
                ),
                onPressed: () {
                  pickImage();
                },
                child: Text('Image'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
              decoration: InputDecoration(
                  hintText: "Prix",
                  icon: const Icon(Icons.euro_symbol),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
              onChanged: (String value) {
                setState(() {
                  mail = value;
                });
              }),

          //Bouton
          const SizedBox(height: 10),

          ElevatedButton(
              onPressed: () {
                Map<String, dynamic> map;
                String uid_annonce = randomAlphaNumeric(20);
                // FirestoreHelper().addAnnonce(uid_annonce, map)
              },
              child: Text("Validation"))
        ],
      ),
    );
  }

  //Fonction

  //Choisir l'image
  Future pickImage() async {
    FilePickerResult? resultat = await FilePicker.platform
        .pickFiles(withData: true, type: FileType.image);
    if (resultat != null) {
      nomImage = resultat.files.first.name;
      bytesImage = resultat.files.first.bytes;
      MyPopUp();
    }
  }

  //Création de notre popUp
  MyPopUp() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Mon image"),
            content: Image.memory(bytesImage!),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Annuler"),
              ),
              ElevatedButton(
                onPressed: () {
                  //Stocker et on va récupérer son url
                  FirestoreHelper()
                      .stockageImage(bytesImage!, nomImage!)
                      .then((value) {
                    setState(() {
                      //GlobalUser.avatar = value;
                      urlImage = value;
                    });
                    //Mettre à jour notre base de donnée en stockant l'url
                    Map<String, dynamic> map = {
                      //Key : Valeur
                      "IMAGE": urlImage
                    };
                    //FirestoreHelper().updateUser(GlobalUser.id, map);
                    Navigator.pop(context);
                  });
                },
                child: const Text("Enregistrement"),
              ),
            ],
          );
        });
  }
}
