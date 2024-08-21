import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_mart/consts/consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class ProfileController extends GetxController {
  var profileImgPath = ''.obs;

  var profileImageLink = '';

  var isloading = false.obs;



  var nameController = TextEditingController();
  var oldPassController = TextEditingController();
  var newPassController = TextEditingController();

  changeImage(context) async {
    try{
      final img = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70);
      if(img != null){
        profileImgPath.value = img.path;
      }else{
        return;
      }
    } on PlatformException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  uploadProfileImage() async{
    var filename = basename(profileImgPath.value);
    var destination = 'images/${auth.currentUser!.uid}/$filename';
    Reference ref = FirebaseStorage.instance.refFromURL('gs://emart-53097.appspot.com').child(destination);

    await ref.putFile(File(profileImgPath.value));
    profileImageLink = await ref.getDownloadURL();
    print(profileImageLink);
    return profileImageLink;

  }


  updateProfile({name,password,imgUrl}) async{
    var store = firestore.collection(usersCollection).doc(currentUser!.uid);
    await store.set({
      'name': name,
      'password': password,
      'imgUrl': imgUrl,
    }, SetOptions(merge: true));
    isloading(false);
  }

  changeAuthPassword({context,email, password, newpassword}) async {
    final cred = EmailAuthProvider.credential(email: email, password: password);

    await currentUser!.reauthenticateWithCredential(cred).then((value){
      currentUser!.updatePassword(newpassword);
    }).catchError((error){
      VxToast.show(context, msg: error.toString());
    });
  }

}