import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_mart/consts/consts.dart';
import 'package:e_mart/controllers/product_controller.dart';
import 'package:e_mart/services/firestore_services.dart';
import 'package:e_mart/views/category_screen/item_details.dart';
import 'package:e_mart/widgets_common/bg_widget.dart';
import 'package:e_mart/widgets_common/loading_indicator.dart';
import 'package:get/get.dart';

class CategoryDetails extends StatelessWidget {
  final String? title;
  const CategoryDetails({super.key, required this.title});

  @override
  Widget build(BuildContext context) {

    var controller = Get.find<ProductController>();

    return bgWidget(
      child: Scaffold(
        appBar: AppBar(
          title: title!.text.fontFamily(bold).white.make(),
        ),
        body: StreamBuilder(
            stream: FirestoreServices.getProducts(title),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              if(!snapshot.hasData){
                return Center(
                  child: loadingIndicator(),
                );
              }else if(snapshot.data!.docs.isEmpty){
                return Center(
                  child: "No products found".text.color(darkFontGrey).make(),
                );
              }else{
                var data = snapshot.data!.docs;

                return Container(
                  padding:const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        physics:const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(controller.subcat.length, (index) =>
                              "${controller.subcat[index]}".text.fontFamily(semibold).size(12.0).color(darkFontGrey).makeCentered()
                                  .box.white.rounded.size(120.0, 60.0).margin(const EdgeInsets.symmetric(horizontal: 4.0)).make()
                          ),
                        ),
                      ),

                      20.heightBox,

                      //items container
                      Expanded(
                          child: GridView.builder(
                              physics:const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: data.length,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,mainAxisExtent: 250,mainAxisSpacing: 8,crossAxisSpacing: 8),
                              itemBuilder: (context,index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.network(data[index]['p_imgs'][0],width: 200,height: 150,fit: BoxFit.cover,),
                                    "${data[index]['p_name']}".text.fontFamily(semibold).color(darkFontGrey).make(),
                                    10.heightBox,
                                    "${data[index]['p_price']}".numCurrency.text.color(redColor).fontFamily(bold).size(16.0).make(),
                                    10.heightBox,
                                  ],
                                ).box.white.roundedSM.outerShadowSm
                                    .margin(const EdgeInsets.symmetric(horizontal: 4.0))
                                    .padding(const EdgeInsets.all(8.0))
                                    .make().onTap((){
                                      controller.checkIfFav(data[index]);
                                      Get.to(() => ItemDetails(title: "${data[index]['p_name']}", data: data[index],));
                                    });
                              },
                          )
                      ),

                    ],
                  ),
                );
              }
            },
        ),
      )
    );
  }
}
