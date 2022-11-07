import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_clone/Modals/stories.dart';

class Stories {
  Future uploadStories(image, filepath, userId, userName) async {
    try {
      if (image != null) {
        Reference reference =
            FirebaseStorage.instance.ref().child("Stories/$filepath");
        UploadTask uploadTask = reference.putFile(image!);
        uploadTask.then((res) async {
          UserStories stories = UserStories();
          stories.uid = FirebaseAuth.instance.currentUser!.uid;
          stories.userName = userName;
          stories.image = await res.ref.getDownloadURL();
          FirebaseFirestore.instance
              .collection("stories")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .set(stories.tojson());
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
