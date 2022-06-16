import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clone_bon_coin/Model/Annonce.dart';
import 'package:flutter_clone_bon_coin/Services/FirestoreHelper.dart';
import 'package:flutter_clone_bon_coin/View/EditAnnonce.dart';

class DetailAnnonce extends StatefulWidget {
  Annonce annonce;

  DetailAnnonce({required this.annonce});

  @override
  State<StatefulWidget> createState() {
    return DetailAnnonceState();
  }
}

class DetailAnnonceState extends State<DetailAnnonce> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Detail annonce"),
          backgroundColor: Colors.blue,
        ),
        backgroundColor: Colors.white,
        body: buildCard());
  }

  Card buildCard() {
    var heading = widget.annonce.title;
    var subheading = "Prix: " + widget.annonce.price.toString() + ' €';
    var cardImage = NetworkImage(widget.annonce.image);
    var supportingText = "Description: " + widget.annonce.description;

    return Card(
        elevation: 4.0,
        child: Column(
          children: [
            ListTile(
              title: Text(heading,
                  style: TextStyle(fontSize: 35, color: Colors.blue)),
              subtitle: Text(subheading,
                  style: TextStyle(fontSize: 20, color: Colors.black)),
              trailing: Icon(Icons.favorite_outline),
            ),
            Container(
              height: 200.0,
              child: Ink.image(
                image: cardImage,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              alignment: Alignment.centerLeft,
              child: Text(supportingText, style: TextStyle(fontSize: 20)),
            ),
            ButtonBar(
              children: [
                TextButton(
                  child: const Text(
                    'Editer',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return EditAnnonce(annonce: widget.annonce);
                    }));
                  },
                ),
                TextButton(
                  child: const Text(
                    'Supprimer',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    delete();
                  },
                )
              ],
            )
          ],
        ));
  }

  delete() {
    FirestoreHelper().deleteAnnonce(widget.annonce.id);
    Navigator.pop(context);
  }
}
