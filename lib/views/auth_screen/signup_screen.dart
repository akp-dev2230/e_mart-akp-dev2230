import 'package:e_mart/consts/consts.dart';
import 'package:e_mart/controllers/auth_controller.dart';
import 'package:e_mart/views/auth_screen/login_screen.dart';
import 'package:e_mart/widgets_common/custom_textfield.dart';
import 'package:e_mart/widgets_common/applogo_widget.dart';
import 'package:e_mart/widgets_common/bg_widget.dart';
import 'package:e_mart/widgets_common/our_button.dart';
import 'package:get/get.dart';



class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  bool? isCheck = false;
  var controller = Get.put(AuthController());

  //text controllers
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordRetypeController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return bgWidget(child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            (context.screenHeight * 0.1).heightBox,
            applogoWidget(),
            10.heightBox,
            "Join the $appName".text.fontFamily(bold).white.size(22.0).make(),
            15.heightBox,
            Obx(()=>Column(
                children: [
                  customTextField(title: name, hint:nameHint, controller: nameController, isPass: false),
                  customTextField(title: email, hint:emailHint, controller: emailController, isPass: false),
                  customTextField(title: password, hint:passwordHint, controller: passwordController, isPass: true),
                  customTextField(title: reTypePass, hint:passwordHint, controller: passwordRetypeController, isPass: true),
                  Align(
                      alignment: Alignment.topRight,
                      child: TextButton(onPressed: (){}, child: forgetPass.text.make())),
                  5.heightBox,
                  Row(
                    children: [
                      Checkbox(
                        activeColor: redColor,
                        checkColor: whiteColor,
                        value: isCheck,
                        onChanged: (newValue) {
                        setState(() {
                          isCheck = newValue;
                        });
                        },
                      ),
                      10.widthBox,
                      Expanded(
                        child: RichText(text: const TextSpan(
                          children: [
                            TextSpan(text:"I agree to the ",style: TextStyle(
                            fontFamily: regular,
                            color: fontGrey,
                            )),
                            TextSpan(text:termsAndCond,style: TextStyle(
                              fontFamily: regular,
                              color: redColor,
                            )),
                            TextSpan(text:" & ",style: TextStyle(
                              fontFamily: regular,
                              color: fontGrey,
                            )),
                            TextSpan(text:privacyPolicy,style: TextStyle(
                              fontFamily: regular,
                              color: redColor,
                            ))
                          ]
                        )),
                      )
              
                    ],
                  ),
                  controller.isloading.value 
                      ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(redColor),)
                      : ourButton(
                      color: isCheck == true?redColor:lightGrey,
                      title:signup,
                      textColor: whiteColor,
                      onPress: () async {
                        if(isCheck != false){
                          controller.isloading(true);
                          try {
                            await controller.signupMethod(
                                name: nameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                                context: context
                            ).then((value){
                              VxToast.show(context, msg: loggedin);
                              Get.offAll(() => const LoginScreen());
                            });
                          } catch (e) {
                            controller.signoutMethod(context: context);
                            VxToast.show(context, msg: e.toString());
                            controller.isloading(false);
                          }
                        }
                      },
                  ).box.width(context.screenWidth-50).make(),
                  10.heightBox,
                  // wrapping into gesture detector of velocity X
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      alreadyHaveAccount.text.color(fontGrey).make(),
                      login.text.color(redColor).make().onTap((){
                        Get.back();
                      }),
                    ],
                  )
              
                ],
              ).box.white.rounded.padding(const EdgeInsets.all(16.0)).width(context.screenWidth-70.0).shadowSm.make(),
            ),

          ],
        ),
      ),
    ));
  }
}
