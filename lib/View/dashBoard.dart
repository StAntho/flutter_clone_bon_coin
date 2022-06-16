import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clone_bon_coin/Model/Utilisateur.dart';
import 'package:flutter_clone_bon_coin/Model/Annonce.dart';
import 'package:flutter_clone_bon_coin/Services/FirestoreHelper.dart';
import 'package:flutter_clone_bon_coin/Services/librairie.dart';
import 'package:flutter_clone_bon_coin/View/MyDrawer.dart';

class dashBoard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return dashboardState();
  }
}

class dashboardState extends State<dashBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: MyDrawer(),
        ),
        appBar: AppBar(
          title: const Text("Ma deuxième page"),
          backgroundColor: Colors.blue,
        ),
        backgroundColor: Colors.white,
        body: bodyPage());
  }

  Widget bodyPage() {
    return StreamBuilder<QuerySnapshot>(
        //On cherche tous les documentssnpshots de l'utilisateur dans la bdd
        stream: FirestoreHelper().annonce.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            // Il n'y aucune donnée dans la BDD
            return const CircularProgressIndicator.adaptive();
          } else {
            //
            List documents = snapshot.data!.docs;
            return ListView.builder(
              //gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              padding: EdgeInsets.all(20),
              itemCount: documents.length,
              itemBuilder: (context, index) {
                Annonce annonce = Annonce(documents[index]);
                if (GlobalAnnonce.id != annonce.id) {
                  return Dismissible(
                    direction: DismissDirection.endToStart,
                    onDismissed: (DismissDirection direction) {
                      FirestoreHelper().deleteUser(annonce.id);
                    },
                    key: Key(annonce.id),
                    child: Card(
                      elevation: 10,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        onTap: () {
                          //Détail de l'utilisateur
                        },
                        title: Text(annonce.title),
                        subtitle: Text(annonce.description),
                        leading: Image.network(annonce.image),
                        trailing: double(annonce.price),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            );
          }
        });
  }
}
