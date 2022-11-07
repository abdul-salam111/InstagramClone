import 'package:flutter/cupertino.dart';
import 'package:instagram_clone/BackEnd/SignUp.dart';
import 'package:instagram_clone/Modals/userModal.dart';

class userProvider with ChangeNotifier {
  RegisterUser registerUser = RegisterUser();
  RegistrationModal _registrationModal = RegistrationModal();
  RegistrationModal get getUser => _registrationModal;
  Future<void> getUserDetail() async {
    try {
      _registrationModal = await registerUser.getUserDetails();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
