import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_mart/consts/lists.dart';
import 'package:e_mart/controllers/home_controller.dart';
import 'package:e_mart/services/firestore_services.dart';
import 'package:e_mart/views/category_screen/item_details.dart';
import 'package:e_mart/views/home_screen/components/featured_button.dart';
import 'package:e_mart/views/home_screen/search_screen.dart';
import 'package:e_mart/widgets_common/home_buttons.dart';
import 'package:e_mart/consts/consts.dart';
import 'package:e_mart/widgets_common/loading_indicator.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    var controller = Get.find<HomeController>();

    return Scaffold(
      body: Container(
        padding:const EdgeInsets.all(12.0),
        color: lightGrey,
        width: context.screenWidth,
        height: context.screenHeight,
        child: SafeArea(child: Column(
          children: [
            //search bar
            Container(
              alignment: Alignment.center,
              height: 60,
              color: lightGrey,
              child: TextFormField(
                controller: controller.searchController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: const Icon(Icons.search).onTap((){
                    if(controller.searchController.text.isNotEmptyAndNotNull){
                      Get.to(()=> SearchScreen(title: controller.searchController.text,));
                    }
                  }),
                  filled: true,
                  fillColor: whiteColor,
                  hintText: searchAnything,
                  hintStyle: const TextStyle(color: textFieldGrey),
                ),
              ).box.outerShadowSm.make(),
            ),
            10.heightBox,

            Expanded(
              child: SingleChildScrollView(
                physics:const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    //swiper brands (banner)
                    VxSwiper.builder(
                        aspectRatio: 16/9,
                        autoPlay: true,
                        height: 140,
                        enlargeCenterPage: true,
                        itemCount: sliderList.length,
                        itemBuilder: (context, index){
                          return Image.asset(
                            sliderList[index],
                            fit: BoxFit.fill,
                          ).box.rounded.clip(Clip.antiAlias).margin(const EdgeInsets.symmetric(horizontal: 5)).make();
                        }),
                    10.heightBox,

                    //deal Buttons
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children:List.generate(2, (index)=>homeButtons(
                            context.screenWidth/2.5,
                            context.screenHeight*0.15,
                            index == 0 ? icTodaysDeal : icFlashDeal,
                            index == 0 ? todayDeal : flashSale,
                                (){})
                        )
                    ),

                    //2nd swiper banner
                    10.heightBox,
                    VxSwiper.builder(
                        aspectRatio: 16/9,
                        autoPlay: true,
                        height: 140,
                        enlargeCenterPage: true,
                        itemCount: secondSliderList.length,
                        itemBuilder: (context, index){
                          return Image.asset(
                            secondSliderList[index],
                            fit: BoxFit.fill,
                          ).box.rounded.clip(Clip.antiAlias).margin(const EdgeInsets.symmetric(horizontal: 5)).make();
                        }),

                    //category buttons
                    10.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(3, (index)=>homeButtons(
                          context.screenWidth/3.35,
                          context.screenHeight*0.13,
                          index == 0 ? icTopCategories : index == 1 ? icBrands : icTopSeller,
                          index == 0 ? topCategories : index == 1 ? brand : topSellers,
                              (){})),
                    ),

                    //featured categories
                    20.heightBox,
                    Align(
                        alignment: Alignment.centerLeft,
                        child: featuredCategories.text.color(darkFontGrey).size(18.0).fontFamily(semibold).make()
                    ),
                    20.heightBox,
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(3, (index)=>Column(
                          children: [
                            featuredButton(title: featuredTitles1[index],icon:featuredList1[index]),
                            10.heightBox,
                            featuredButton(title:featuredTitles2[index],icon:featuredList2[index]),
                          ],
                        )),
                      ),
                    ),

                    //featured product
                    20.heightBox,
                    Container(
                      padding:const EdgeInsets.all(12.0),
                      width: double.infinity,
                      decoration: const BoxDecoration(color: redColor),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          featuredProduct.text.white.fontFamily(bold).size(18.0).make(),
                          10.heightBox,
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: FutureBuilder(
                              future: FirestoreServices.getFeaturedProducts(),
                              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                if(!snapshot.hasData){
                                  return Center(child: loadingIndicator(),);
                                }else if(snapshot.data!.docs.isEmpty){
                                  return "No featured products".text.white.makeCentered();
                                }else{
                                  var featuredData = snapshot.data!.docs;
                                  return Row(
                                    children: List.generate(featuredData.length, (index)=>Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Image.network(featuredData[index]['p_imgs'][0],width: 140,height: 140,fit: BoxFit.cover,),
                                        10.heightBox,
                                        "${featuredData[index]['p_name']}".text.fontFamily(semibold).size(16.0).color(darkFontGrey).make(),
                                        10.heightBox,
                                        "${featuredData[index]['p_price']}".numCurrency.text.color(redColor).fontFamily(bold).size(16.0).make(),
                                        10.heightBox,
                                      ],
                                    ).box.white.margin(const EdgeInsets.symmetric(horizontal: 4.0))
                                        .roundedSM.padding(const EdgeInsets.all(8.0)).make().onTap((){
                                          Get.to(()=>ItemDetails(
                                            title: "${featuredData[index]['p_name']}",
                                            data: featuredData[index],
                                          ));
                                    }),
                                    ),
                                  );
                                }
                              }
                            ),
                          ),
                        ],
                      ),
                    ),

                    //3rd swiper banner
                    20.heightBox,
                    VxSwiper.builder(
                        aspectRatio: 16/9,
                        autoPlay: true,
                        height: 140,
                        enlargeCenterPage: true,
                        itemCount: secondSliderList.length,
                        itemBuilder: (context, index){
                          return Image.asset(
                            secondSliderList[index],
                            fit: BoxFit.fill,
                          ).box.rounded.clip(Clip.antiAlias).margin(const EdgeInsets.symmetric(horizontal: 5)).make();
                        }),

                    //all product section
                    20.heightBox,
                    StreamBuilder(
                        stream: FirestoreServices.allProducts(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                          if(!snapshot.hasData){
                            return Center(child: loadingIndicator(),);
                          }else{
                            var allproductsdata = snapshot.data!.docs;
                            return GridView.builder(
                              physics:const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: allproductsdata.length,
                              gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,mainAxisSpacing: 8,crossAxisSpacing: 8,mainAxisExtent: 300,
                              ),
                              itemBuilder: (context,index){
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.network(allproductsdata[index]['p_imgs'][0],width: 200,height: 200,fit: BoxFit.cover,),
                                    const Spacer(),
                                    "${allproductsdata[index]['p_name']}".text.fontFamily(semibold)
                                        .size(15.0).color(darkFontGrey).make(),
                                    10.heightBox,
                                    "${allproductsdata[index]['p_price']}".numCurrency.text.color(redColor)
                                        .fontFamily(bold).size(15.0).make(),
                                    10.heightBox,
                                  ],
                                ).box.white.roundedSM.margin(const EdgeInsets.symmetric(horizontal: 4.0))
                                    .padding(const EdgeInsets.all(8.0)).make().onTap((){
                                      Get.to(()=> ItemDetails(
                                        title: "${allproductsdata[index]['p_name']}",
                                        data: allproductsdata[index],
                                      ));
                                });
                              },
                            );
                          }
                        }
                    ),

                  ],
                ),
              ),
            ),


          ],
        )),
      ),
    );
  }
}
