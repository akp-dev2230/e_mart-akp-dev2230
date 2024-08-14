import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_mart/consts/consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController{

  var isloading = false.obs;

  //text controllers
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  //login method
  Future<UserCredential?> loginMethod({context}) async{
    UserCredential? userCredential;

    try{
      userCredential = await auth.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
    return userCredential;

  }

  //signup method
  Future<UserCredential?> signupMethod({name,email, password, context}) async {
    UserCredential? userCredential;

    try {
      userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await storeUserData(name: name, email: email, password: password);
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
    return userCredential;

  }

  //storing data method in firebase
  Future<void> storeUserData({name, email, password}) async {
    DocumentReference store = firestore.collection(usersCollection).doc(auth.currentUser!.uid);
    await store.set({
      'name': name,
      'password': password,
      'email': email,
      'imageUrl': '',
      'id': currentUser!.uid,
      'cart_count': '00',
      'order_count': '00',
      'wishlist_count': '00',
    });
  }

  //signout method
  Future<void> signoutMethod({context}) async{
    try {
      await auth.signOut();
      VxToast.show(context, msg: signout);
    } catch (e) {
      VxToast.show(context, msg: 'Sign out failed: ${e.toString()}');
    }
  }

}