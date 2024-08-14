import 'package:e_mart/consts/consts.dart';
import 'package:e_mart/views/auth_screen/login_screen.dart';
import 'package:e_mart/views/home_screen/home.dart';
import 'package:e_mart/widgets_common/applogo_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  //creating a method to change screen

  changeScreen(){
    Future.delayed(const Duration(seconds: 3), (){
      // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen())); //(sdb akp)
      // Get.to(() => const LoginScreen());
      auth.authStateChanges().listen((User? user){
        if(user == null && mounted){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
        }else{
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home()));
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    changeScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: redColor,
      body: Center(
        child: Column(
          children: [
            Align(alignment: Alignment.topLeft, child: Image.asset(icSplashBg, width: 300,),),
            const SizedBox(height: 20,),
            applogoWidget(),
            const SizedBox(height: 10,),
            appName.text.fontFamily(bold).size(22.0).white.make(),
            5.heightBox,
            appVersion.text.white.make(),
            const Spacer(),
            credits.text.white.fontFamily(semibold).make(),
            30.heightBox,
            //our splash screen UI is completed...

          ],
        ),
      ),
    );
  }
}
