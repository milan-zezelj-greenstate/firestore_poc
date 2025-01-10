import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firestore_poc/data/local/repository/localization_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());
}

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

class MainApp extends HookWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController();
    final auth = FirebaseAuth.instance;
    final db = FirebaseFirestore.instance;

    final currentUserUID = useState(auth.currentUser?.uid);

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("CURRENT USER: ${currentUserUID.value}"),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final collection = db.collection("projects");

                  collection.get().then(
                    (event) {
                      for (var doc in event.docs) {
                        final encoder = JsonEncoder.withIndent('  ');

                        print("${doc.id} => ${encoder.convert(doc.data())}");
                      }
                    },
                  );

                  collection.doc("greenstate").snapshots().listen(
                    (event) {
                      print("NEW TRANSLATION");
                      print(event.data());
                    },
                  );
                },
                child: Text("Load"),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final user = await signInWithGoogle();

                  print(user.user?.displayName);
                  print(user.user?.email);
                  print(user.user?.uid);
                  currentUserUID.value = user.user?.uid;

                  final usersDB = db.collection('users');
                  final users = await usersDB.get();

                  if (users.docs.indexWhere((element) =>
                          element.data()["uid"] == user.user?.uid) ==
                      -1) {
                    usersDB.add({
                      "uid": user.user?.uid,
                      "displayName": user.user?.displayName,
                      "email": user.user?.email
                    });
                  }
                },
                child: Text("Login"),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final collection = db.collection("projects");
                  final document =
                      await collection.doc("qsDyM2g8Cd0g3Gk31wD9").get();

                  localizeJson(json: document.data()!);
                },
                child: Text("Localize JSON"),
              ),
              SizedBox(height: 50),
              TextFormField(controller: textController),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  if (textController.text.isNotEmpty) {
                    final collection = db.collection("projects");

                    collection.doc().set({
                      "name": textController.text,
                      "admin": auth.currentUser?.uid
                    });
                  }
                },
                child: Text("Make new project"),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (textController.text.isNotEmpty) {
                    final collection = db.collection("projects");
                    print("Editing with: ${auth.currentUser?.uid}");
                    collection.doc("RlD3NN5GoskSPfe7JQuP").update(
                      {
                        "name": textController.text,
                      },
                    );
                  }
                },
                child: Text("Edit project"),
              ),
              ElevatedButton(
                onPressed: () async {
                  print((await db
                          .collection("projects")
                          .where(
                            Filter.or(
                              Filter("admin", isEqualTo: currentUserUID.value),
                              Filter("sharedWith",
                                  arrayContains: currentUserUID.value),
                            ),
                          )
                          .get())
                      .docs
                      .map(
                        (e) => e.id,
                      ));
                },
                child: Text("Get projects"),
              ),
              ElevatedButton(
                onPressed: () {
                  auth.signOut().then((_) {
                    currentUserUID.value = null;
                  });
                },
                child: Text("Logout"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (currentUserUID.value != null) {
                    final collection = db.collection("projects");
                    print("Uploading with: ${auth.currentUser?.uid}");

                    final translation = jsonExample;

                    translation.addAll({"admin": currentUserUID.value!});
                    collection.doc().set(translation);
                  }
                },
                child: Text("Upload translation"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (currentUserUID.value != null) {
                    final collection = db.collection("projects");
                    final documentId = "qsDyM2g8Cd0g3Gk31wD9";
                    final inviteeUID = "hAdOb4d2NMYhjlI7ydhMeN1Y2gs2";

                    collection.doc(documentId).update({
                      "sharedWith": [inviteeUID]
                    });
                  }
                },
                child: Text("Share project"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
