import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_mart/consts/consts.dart';
import 'package:e_mart/consts/lists.dart';
import 'package:e_mart/controllers/cart_controller.dart';
import 'package:e_mart/views/home_screen/home.dart';
import 'package:e_mart/widgets_common/loading_indicator.dart';
import 'package:e_mart/widgets_common/our_button.dart';
import 'package:get/get.dart';

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({super.key});

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  @override
  Widget build(BuildContext context) {

    var controller = Get.find<CartController>();

    return Obx(
      ()=> Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          title: "Choose Payment Method".text.fontFamily(semibold).color(darkFontGrey).make(),
        ),
        bottomNavigationBar: SizedBox(
          height: 60,
          child: controller.placingOrder.value
              ? Center(child: loadingIndicator(),)
          : ourButton(
              onPress: () async{
                await controller.placeMyOrder(
                    orderPaymentMethod: paymentMethods[controller.paymentIndex.value],
                    totalAmount: controller.totalP.value,
                );
                await controller.clearCart();
                VxToast.show(context, msg: "Order placed successfully");
                Get.offAll(const Home());
              },
              color: redColor,
              textColor: whiteColor,
              title: "Place your order"
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: paymentMethodsImg.length,
                  itemBuilder: (context, index){
                    return GestureDetector(
                      onTap: (){
                        setState(() {
                          controller.changePaymentIndex(index);
                        });
                      },
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            style: BorderStyle.solid,
                            color: controller.paymentIndex.value == index ? redColor : Colors.black,
                            width: 2.0
                          ),
                        ),
                        margin: const EdgeInsets.only(bottom: 8.0),
                        child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Image.asset(
                                paymentMethodsImg[index],
                                width: double.infinity,
                                height: 100,
                                colorBlendMode: controller.paymentIndex.value == index ? BlendMode.darken : BlendMode.color,
                                color: controller.paymentIndex.value == index ? Colors.black.withOpacity(0.2) : Colors.transparent,
                                fit: BoxFit.cover,
                              ),
                              controller.paymentIndex.value == index
                                  ? Transform.scale(
                                       scale: 1.5,
                                       child: Checkbox(
                                          activeColor: Colors.green,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                                          value: true,
                                          onChanged: (value){}
                                       ),
                                  ) : Container(),
                              Positioned(
                                  bottom: 10,
                                  right: 10,
                                  child: paymentMethods[index].text.fontFamily(semibold).size(16.0).make()
                              ),
                            ],
                        ),
                      ),
                    );
                  }
              ),
            ],
          ),
        ),


      ),
    );
  }
}
