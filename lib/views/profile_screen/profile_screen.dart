import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_mart/consts/consts.dart';
import 'package:e_mart/consts/firebase_consts.dart';
import 'package:e_mart/consts/lists.dart';
import 'package:e_mart/controllers/auth_controller.dart';
import 'package:e_mart/controllers/profile_controller.dart';
import 'package:e_mart/services/firestore_services.dart';
import 'package:e_mart/views/auth_screen/login_screen.dart';
import 'package:e_mart/views/chat_screen/messaging_screen.dart';
import 'package:e_mart/views/orders_screen/orders_screen.dart';
import 'package:e_mart/views/profile_screen/components/details_card.dart';
import 'package:e_mart/views/profile_screen/edit_profile_screen.dart';
import 'package:e_mart/views/wishlist_screen/wishlist_screen.dart';
import 'package:e_mart/widgets_common/bg_widget.dart';
import 'package:e_mart/widgets_common/exit_dialog.dart';
import 'package:e_mart/widgets_common/loading_indicator.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());

    return bgWidget(
      child: Scaffold(
        body: StreamBuilder(
            stream: FirestoreServices.getUser(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){

              if (!snapshot.hasData){
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(redColor),
                  ),
                );
              }else {

                var data = snapshot.data!.docs[0];

                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        //edit profile section
                        Align(
                          alignment: Alignment.topRight,
                          child:const Icon(Icons.edit,color: whiteColor,).onTap((){
                            controller.nameController.text = data['name'];
                            controller.isloading(false);
                            Get.to(() => EditProfileScreen(data: data));
                          }),
                        ),

                        //user details section
                        Row(
                          children: [
                            data['imgUrl'] == ''
                                ? Image.asset(imgProfile2, width: 100,fit: BoxFit.cover,).box.roundedFull.clip(Clip.antiAlias).make()
                                : Image.network(data['imgUrl'], width: 100, fit: BoxFit.cover,),
                            10.widthBox,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data['name'],style: const TextStyle(fontFamily: semibold,color: whiteColor),),
                                  Text(data['email'],style: const TextStyle(fontFamily: semibold,color: whiteColor),),
                                ],
                              ),
                            ),
                            PopScope(
                              canPop: false,
                              onPopInvoked: (bool didPop) async{
                                if(didPop){
                                  return;
                                }
                                // final bool shouldPop = await exitDialog(context: context, title: logOut) ?? false;
                                // if(context.mounted && shouldPop){
                                //   Get.offAll(() => const LoginScreen());
                                // }
                              },
                              child: OutlinedButton(
                                onPressed: () async{
                                  final bool shouldPop = await exitDialog(context: context, title: logOut) ?? false;
                                  if(context.mounted && shouldPop){
                                    await Get.put(AuthController()).signoutMethod(context: context);
                                    Get.offAll(() => const LoginScreen());
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                  color: Colors.white,
                                  ),
                                ),
                                child: const Text('Log out',style: TextStyle(fontFamily: semibold,color: whiteColor),),
                              ),
                            )
                          ],
                        ),

                        20.heightBox,
                        FutureBuilder(
                            future: FirestoreServices.getCounts(),
                            builder: (BuildContext context, AsyncSnapshot snapshot ){
                              if(!snapshot.hasData){
                                return Center(child: loadingIndicator(),);
                              }else{
                                var countData = snapshot.data;

                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    detailsCard(context.screenWidth/3.3, countData[0].toString(), "in your cart"),
                                    detailsCard(context.screenWidth/3.3, countData[1].toString(), "in your wishlist"),
                                    detailsCard(context.screenWidth/3.3, countData[2].toString(), "your Orders"),
                                  ],
                                );
                              }
                            }
                        ),

                        40.heightBox,

                        ListView.separated(
                            shrinkWrap: true,
                            itemCount: profileButtonsList.length,
                            itemBuilder: (context,index){
                              return ListTile(
                                onTap: (){
                                  switch (index){
                                    case 0:
                                      Get.to(()=>const OrdersScreen());
                                      break;
                                    case 1:
                                      Get.to(()=> const WishlistScreen());
                                      break;
                                    case 2:
                                      Get.to(()=> const MessagingScreen());
                                      break;
                                  }
                                },
                                leading: Image.asset(profileButtonsicon[index],width: 20,),
                                title: profileButtonsList[index].text.fontFamily(semibold).color(darkFontGrey).make(),
                              );
                            },
                            separatorBuilder: (context,index){
                              return const Divider(color: lightGrey ,);
                            },
                        ).box.white.rounded.padding(const EdgeInsets.symmetric(horizontal: 16.0)).shadowSm.make(),

                      ],
                    ),
                  ),
                );
              }

            },
        )
      ),
    );
  }
}
