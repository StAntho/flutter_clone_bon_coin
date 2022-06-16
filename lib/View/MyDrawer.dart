import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clone_bon_coin/Services/FirestoreHelper.dart';
import 'package:flutter_clone_bon_coin/Services/global.dart';
import 'package:flutter_clone_bon_coin/View/AddAnnonce.dart';

class MyDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyDrawerState();
  }
}

class MyDrawerState extends State<MyDrawer> {
  //Variable
  String? nomImage;
  String? urlImage;
  Uint8List? bytesImage;
  bool isEditing = false;
  String pseudoTempo = "";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
        child: Container(
      padding: EdgeInsets.all(20),
      child: Center(
        child: Column(
          children: [
            //Avatar cliquable
            InkWell(
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(GlobalUser.avatar!),
                      fit: BoxFit.fitHeight),
                ),
              ),
              onTap: () {
                print("J'ai cliquer sur l'image");
                pickImage();
              },
            ),
            SizedBox(
              height: 10,
            ),

            //Pseudo qui pourra changer
            TextButton.icon(
                onPressed: () {
                  if (isEditing == true) {
                    setState(() {
                      GlobalUser.pseudo = pseudoTempo;
                      Map<String, dynamic> map = {"PSEUDO": pseudoTempo};
                      FirestoreHelper().updateUser(GlobalUser.id, map);
                    });
                  }
                  setState(() {
                    isEditing = !isEditing;
                  });
                },
                icon: (isEditing)
                    ? const Icon(
                        Icons.check,
                        color: Colors.green,
                      )
                    : const Icon(Icons.edit),
                label: (isEditing)
                    ? TextField(
                        decoration: const InputDecoration(
                          hintText: "Entrer le pseudo",
                        ),
                        onChanged: (newValue) {
                          setState(() {
                            pseudoTempo = newValue;
                          });
                        },
                      )
                    : Text(GlobalUser.pseudo!)),
            // nom et prénom complet
            Text(GlobalUser.nomComplet()),
            // adresee mail
            Text(GlobalUser.mail),
            ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.exit_to_app_sharp),
                label: const Text("Fermer")),
            ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AddAnnonce();
                  }));
                },
                icon: const Icon(Icons.exit_to_app_sharp),
                label: const Text("Ajouter"))
          ],
        ),
      ),
    ));
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
          if (Platform.isIOS) {
            return CupertinoAlertDialog(
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
                        GlobalUser.avatar = value;
                        urlImage = value;
                      });
                      //Mettre à jour notre base de donnée en stockant l'url
                      Map<String, dynamic> map = {
                        //Key : Valeur
                        "AVATAR": urlImage
                      };
                      FirestoreHelper().updateUser(GlobalUser.id, map);
                      Navigator.pop(context);
                    });
                  },
                  child: const Text("Enregistrement"),
                ),
              ],
            );
          } else {
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
                        GlobalUser.avatar = value;
                        urlImage = value;
                      });
                      //Mettre à jour notre base de donnée en stockant l'url
                      Map<String, dynamic> map = {
                        //Key : Valeur
                        "AVATAR": urlImage
                      };
                      FirestoreHelper().updateUser(GlobalUser.id, map);
                      Navigator.pop(context);
                    });
                  },
                  child: const Text("Enregistrement"),
                ),
              ],
            );
          }
        });
  }
}
