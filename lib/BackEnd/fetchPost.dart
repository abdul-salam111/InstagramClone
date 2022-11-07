import 'package:cloud_firestore/cloud_firestore.dart';

class FetchPost {
  final firestore = FirebaseFirestore.instance;
  Future getDocs() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("posts").get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      print(a.id);
    }
  }
}
