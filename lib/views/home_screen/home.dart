import 'package:e_mart/consts/consts.dart';
import 'package:e_mart/controllers/home_controller.dart';
import 'package:e_mart/views/cart_screen/cart_screen.dart';
import 'package:e_mart/views/category_screen/category_screen.dart';
import 'package:e_mart/views/home_screen/home_screen.dart';
import 'package:e_mart/views/profile_screen/profile_screen.dart';
import 'package:e_mart/widgets_common/exit_dialog.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {

    //init home controller
    var controller = Get.put(HomeController());

    var navBarItem = [
      BottomNavigationBarItem(icon: Image.asset(icHome,width: 26,),label: home),
      BottomNavigationBarItem(icon: Image.asset(icCategories,width: 26,),label: categories),
      BottomNavigationBarItem(icon: Image.asset(icCart,width: 26,),label: cart),
      BottomNavigationBarItem(icon: Image.asset(icProfile,width: 26,),label: account),
    ];

    var navBody = [const HomeScreen(),const CategoryScreen(),const CartScreen(),const ProfileScreen()];

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async{
        if(didPop){
          return;
        }
        final bool shouldPop = await exitDialog(context: context, title: exit) ?? false;

        if(context.mounted && shouldPop){
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Obx(()=> Expanded(child: navBody.elementAt(controller.currentNavIndex.value))),
          ],
        ),
        bottomNavigationBar: Obx(()=>
           BottomNavigationBar(
             currentIndex: controller.currentNavIndex.value,
             selectedItemColor: redColor,
             selectedLabelStyle: const TextStyle(fontFamily: semibold),
             type: BottomNavigationBarType.fixed,
             backgroundColor: whiteColor,
             items: navBarItem,
             onTap: (value){
               controller.currentNavIndex.value = value;
             },
          ),
        ),
      ),
    );
  }
}
