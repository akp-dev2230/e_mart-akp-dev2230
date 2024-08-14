import 'dart:io';

import 'package:e_mart/consts/consts.dart';
import 'package:e_mart/controllers/profile_controller.dart';
import 'package:e_mart/views/profile_screen/profile_screen.dart';
import 'package:e_mart/widgets_common/bg_widget.dart';
import 'package:e_mart/widgets_common/custom_textfield.dart';
import 'package:e_mart/widgets_common/our_button.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatelessWidget {
  final dynamic data;

  const EditProfileScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProfileController>();


    return bgWidget(
      child: Scaffold(
        appBar: AppBar(
          title: "Profile".text.size(22.0).fontFamily(semibold).color(whiteColor).make(),
        ),
        body: Obx(() =>
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                data['imgUrl'] == '' && controller.profileImgPath.isEmpty
                    ? Image.asset(imgProfile2, width: 100,fit: BoxFit.cover,).box.roundedFull.clip(Clip.antiAlias).make()
                    : data['imgUrl'] != '' && controller.profileImgPath.isEmpty
                        ? Image.network(data['imgUrl'],width: 100,fit: BoxFit.cover,)
                           .box.roundedFull.clip(Clip.antiAlias).make()
                        : Image.file(File(controller.profileImgPath.value),width: 100,fit: BoxFit.cover,)
                           .box.roundedFull.clip(Clip.antiAlias).make(),
                10.heightBox,
                ourButton(color: redColor,textColor: whiteColor,title: "Change",onPress: (){
                  controller.changeImage(context);
                }),
                const Divider(),
                20.heightBox,
                customTextField(controller: controller.nameController,hint: nameHint,title: name,isPass: false),
                10.heightBox,
                customTextField(controller: controller.oldPassController,hint: passwordHint,title: oldpass,isPass: true),
                10.heightBox,
                customTextField(controller: controller.newPassController,hint: passwordHint,title: newpass,isPass: true),
                20.heightBox,

                controller.isloading.value
                    ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(redColor),
                    )
                    : SizedBox(
                          width: context.screenWidth - 60,
                          child: ourButton(color: redColor,textColor: whiteColor,title: "Save",onPress: () async {
                             controller.isloading(true);
                             // String imgUrl = '';

                             //if image is not selected
                             if(controller.profileImgPath.isNotEmpty){
                               await controller.uploadProfileImage();
                             }else{
                               controller.profileImageLink = data['imgUrl'];
                             }

                             //if old password matches databases
                             if(data['password'] == controller.oldPassController.text){
                               await controller.changeAuthPassword(
                                 email: data['email'],
                                 password: controller.oldPassController.text,
                                 newpassword: controller.newPassController.text,
                               );

                               await controller.updateProfile(
                                 imgUrl: controller.profileImageLink,
                                 name: controller.nameController.text,
                                 password: controller.newPassController.text,
                               );

                             }else{
                               VxToast.show(context, msg: "Wrong old password");
                               controller.isloading(false);
                             }

                          }),
                    ),
              ],
                        ).box.white.roundedSM.shadowSm.padding(const EdgeInsets.all(18.0))
                .margin(const EdgeInsets.only(top: 50.0,left: 12.0,right: 12.0)).make(),
            ),
        ),
      ),
    );
  }
}
