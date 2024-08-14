import 'package:e_mart/consts/consts.dart';
import 'package:e_mart/consts/lists.dart';
import 'package:e_mart/controllers/product_controller.dart';
import 'package:e_mart/views/chat_screen/chat_screen.dart';
import 'package:e_mart/widgets_common/our_button.dart';
import 'package:get/get.dart';


class ItemDetails extends StatelessWidget {
  final String? title;
  final dynamic data;
  const ItemDetails({super.key, required this.title, this.data});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductController());
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop){
        if(didPop){
          return;
        }
        controller.resetValues();
      },
      child: Scaffold(
        backgroundColor: lightGrey,
        appBar: AppBar(
          leading: IconButton(
              onPressed: (){
                controller.resetValues();
                Get.back();
              },
              icon: const Icon(Icons.arrow_back),
          ),
          title: title!.text.color(darkFontGrey).fontFamily(bold).make(),
          actions: [
            IconButton(onPressed: (){}, icon: const Icon(Icons.share),),
            Obx(
                ()=> IconButton(
                  onPressed: (){
                    if(controller.isFav.value){
                      controller.removeFromWishlist(data.id,context);
                    }else{
                      controller.addToWishlist(data.id,context);
                    }
                  },
                  icon: Icon(
                    Icons.favorite_outlined,
                    color: controller.isFav.value ? redColor : darkFontGrey,
                  )
                ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //swiper (all images of product)
                          VxSwiper.builder(
                              autoPlay: true,
                              height: 350,
                              aspectRatio: 16/9,
                              viewportFraction: 1.0,
                              itemCount: data['p_imgs'].length,
                              itemBuilder: (context,index){
                                return Image.network(data['p_imgs'][index],width: double.infinity,fit: BoxFit.cover,);
                              }
                          ),
      
                          10.heightBox,
                          //title and details section
                          title!.text.size(16).color(darkFontGrey).fontFamily(semibold).make(),
                          10.heightBox,
      
                          //rating
                          VxRating(
                            isSelectable: false,
                            value: double.parse(data['p_rating']),
                            onRatingUpdate: (value){},
                            normalColor: textFieldGrey,
                            selectionColor: golden,
                            count: 5,
                            maxRating: 5,
                            size: 25,
                          ),
      
                          //price
                          10.heightBox,
                          "${data['p_price']}".text.color(redColor).size(18.0).fontFamily(bold).make(),
      
                          Row(
                            children: [
                              Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      "Seller".text.white.fontFamily(semibold).make(),
                                      5.heightBox,
                                      "${data['p_seller']}".text.fontFamily(semibold).color(darkFontGrey).make(),
                                    ],
                                  )
                              ),
                              const CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(Icons.message_rounded, color: darkFontGrey,),
                              ).onTap((){
                                Get.to(() => const ChatScreen(),
                                  arguments: [data['p_seller'], data['vendor_id']],
                                );
                              }),
                            ],
                          ).box.height(60.0).padding(const EdgeInsets.symmetric(horizontal: 16.0)).color(textFieldGrey).make(),
      
                          //color section
                          20.heightBox,
                          Obx(
                            () => Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      child: "Color: ".text.color(textFieldGrey).make(),
                                    ),
                                    Row(
                                      children: List.generate(
                                          data['p_colors'].length, (index) => Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              VxBox().size(40.0, 40.0)
                                              .roundedFull
                                              .color(Color(data['p_colors'][index]).withOpacity(1.0))
                                              .margin(const EdgeInsets.symmetric(horizontal: 4.0)).make().onTap((){
                                                controller.changeColorIndex(index);
                                              }),
      
                                              Visibility(
                                                  visible: index == controller.colorIndex.value,
                                                  child: const Icon(Icons.done,color: Colors.white),
                                              ),
                                            ],
                                          )),
                                    )
                                  ],
                                ).box.padding(const EdgeInsets.all(8.0)).make(),
      
                                //quantity row
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      child: "Quantity: ".text.color(textFieldGrey).make(),
                                    ),
                                    Obx(
                                        () => Row(
                                        children: [
                                          IconButton(onPressed: (){
                                            controller.decreaseQuantity();
                                            controller.calculateTotalPrice(int.parse(data['p_price']));
                                          }, icon: const Icon(Icons.remove)),
                                          controller.quantity.value.text.size(16.0).color(darkFontGrey).fontFamily(bold).make(),
                                          IconButton(onPressed: (){
                                            controller.increaseQuantity(int.parse(data['p_quantity']));
                                            controller.calculateTotalPrice(int.parse(data['p_price']));
                                          }, icon: const Icon(Icons.add)),
                                          "(${data['p_quantity']} available)".text.color(textFieldGrey).make(),
                                        ],
                                      ),
                                    ),
                                 ],
                               ).box.padding(const EdgeInsets.all(8.0)).make(),
      
                                //item total(price)
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      child: "Total: ".text.color(textFieldGrey).make(),
                                    ),
                                    "${controller.totalPrice.value}".text.color(redColor).size(16.0).fontFamily(bold).make(),
                                  ],
                                ).box.padding(const EdgeInsets.all(8.0)).make(),
      
                              ],
                            ).box.white.shadowSm.make(),
                          ),
      
                          //description section
                          10.heightBox,
                          "Description".text.color(darkFontGrey).fontFamily(semibold).make(),
                          10.heightBox,
                          "${data['p_desc']}".text.color(darkFontGrey).make(),
      
                          //button section
                          10.heightBox,
                          ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context,index){
                                  return ListTile(
                                    title: itemDetailButtonsList[index].text.fontFamily(semibold).color(darkFontGrey).make(),
                                    trailing: const Icon(Icons.arrow_forward),
                                  );
                                },
                                separatorBuilder: (context,index){
                                  return const Divider(height: 5, thickness: 2,);
                                },
                                itemCount: itemDetailButtonsList.length
                          ).box.white.shadowSm.make(),
      
                          //products you may like
                          20.heightBox,
                          productsYouMayLike.text.size(16).fontFamily(bold).color(darkFontGrey).make(),
                          10.heightBox,
                          //copied this widget from home_screen featured product
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(6, (index)=>Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(imgP1,width: 150,fit: BoxFit.cover,),
                                  10.heightBox,
                                  "Laptop 4GB/64GB".text.fontFamily(semibold).color(darkFontGrey).make(),
                                  10.heightBox,
                                  "\$600".text.color(redColor).fontFamily(bold).size(16.0).make(),
                                  10.heightBox,
                                ],
                              ).box.white.margin(const EdgeInsets.symmetric(horizontal: 4.0))
                                  .roundedSM.padding(const EdgeInsets.all(8.0)).make(),
                              ),
                            ),
                          ),
      
                        ],
                      ),
                  )
                ),
            ),
            SizedBox(
              width: context.screenWidth*0.9,
              height: 60,
              child: ourButton(
                  color: redColor,
                  textColor: whiteColor,
                  title: addToCart,
                  onPress: (){
                    if(controller.quantity.value > 0){
                      controller.addToCart(
                        color: data['p_colors'][controller.colorIndex.value],
                        context: context,
                        // vendorID: data['vendor_id'],
                        img: data['p_imgs'][0],
                        qty: controller.quantity.value,
                        sellername: data['p_seller'],
                        title: data['p_name'],
                        tprice: controller.totalPrice.value,
                      );
                      VxToast.show(context, msg: "Added to cart");
                    }else{
                      VxToast.show(context, msg: "Quantity can't be 0");
                    }
                  },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
