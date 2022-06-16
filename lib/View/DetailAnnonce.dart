import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clone_bon_coin/Model/Annonce.dart';
import 'package:flutter_clone_bon_coin/Services/FirestoreHelper.dart';

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
              title: Text(heading),
              subtitle: Text(subheading),
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
              child: Text(supportingText),
            ),
            ButtonBar(
              children: [
                TextButton(
                  child: const Text('Editer'),
                  onPressed: () {},
                ),
                TextButton(
                  child: const Text('Supprimer'),
                  onPressed: () {
                    FirestoreHelper().deleteAnnonce(widget.annonce.id);
                  },
                )
              ],
            )
          ],
        ));
  }

// Widget Detail() {
//   return SingleChildScrollView(
//       body: Center(
//           child: Column(
//             children: <Widget>[],
//           )));
//   /*child: Card(
//       elevation: 45,
//       color: Colors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: ListTile(
//         title: Text(widget.annonce.title),
//         subtitle: Text(widget.annonce.description),
//         leading: Image.network(widget.annonce.image),
//         trailing: Text(widget.annonce.price.toString()),
//       ),
//     ),*/
//
//   /*ElevatedButton(onPressed: () {}, child: Text("Validation"))
//     ],
//   ),*/
// }
}
