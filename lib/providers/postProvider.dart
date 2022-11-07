import 'package:flutter/cupertino.dart';
import 'package:instagram_clone/BackEnd/FetchPost.dart';
import 'package:instagram_clone/Modals/PostModal.dart';

class PostProvider with ChangeNotifier {
  FetchPost fetchPost = FetchPost();
  PostModal _postModal = PostModal();
  PostModal get getposts => _postModal;
  // Future<void> fetchAllPosts() async {
  //   try {
  //     _postModal = await fetchPost.fetchposts();
  //     notifyListeners();
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
