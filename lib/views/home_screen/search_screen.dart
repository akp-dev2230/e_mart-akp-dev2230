import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_mart/consts/consts.dart';
import 'package:e_mart/services/firestore_services.dart';
import 'package:e_mart/views/category_screen/item_details.dart';
import 'package:e_mart/widgets_common/loading_indicator.dart';
import 'package:get/get.dart';

class SearchScreen extends StatelessWidget {
  final String? title;
  const SearchScreen({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: title!.text.color(darkFontGrey).make(),
      ),
      body: FutureBuilder(
          future: FirestoreServices.searchProducts(title),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(!snapshot.hasData){
              return Center(child: loadingIndicator(),);
            }else if(snapshot.data!.docs.isEmpty){
              return "No products found".text.black.makeCentered();
            }else{
              var data = snapshot.data!.docs;
              var filtered = data.where(
                      (element)=> element['p_name'].toString().toLowerCase().contains(title!.toLowerCase())
              ).toList();

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, mainAxisSpacing: 8,crossAxisSpacing: 8, mainAxisExtent: 300
                  ),
                  children: filtered.mapIndexed((currentvalue, index)=>Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(filtered[index]['p_imgs'][0],width: 200,height: 200,fit: BoxFit.cover,),
                      const Spacer(),
                      "${filtered[index]['p_name']}".text.fontFamily(semibold)
                          .size(15.0).color(darkFontGrey).make(),
                      10.heightBox,
                      "${filtered[index]['p_price']}".numCurrency.text.color(redColor)
                          .fontFamily(bold).size(15.0).make(),
                      10.heightBox,
                    ],
                  ).box.white.margin(const EdgeInsets.symmetric(horizontal: 4.0)).roundedSM
                      .outerShadowMd.padding(const EdgeInsets.all(8.0)).make().onTap((){
                        Get.to(()=> ItemDetails(
                          title: "${filtered[index]['p_name']}",
                          data: filtered[index],
                        ));
                  })).toList(),

                ),
              );
            }
          }
      ),
    );
  }
}
