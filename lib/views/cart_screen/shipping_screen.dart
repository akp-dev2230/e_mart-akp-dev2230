import 'package:e_mart/consts/consts.dart';
import 'package:e_mart/controllers/cart_controller.dart';
import 'package:e_mart/views/cart_screen/payment_method.dart';
import 'package:e_mart/widgets_common/custom_textfield.dart';
import 'package:e_mart/widgets_common/our_button.dart';
import 'package:get/get.dart';

class ShippingScreen extends StatelessWidget {
  const ShippingScreen({super.key});

  @override
  Widget build(BuildContext context) {

    var controller = Get.find<CartController>();

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Shippping Info".text.fontFamily(semibold).color(darkFontGrey).make(),
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: ourButton(
          onPress: (){
            if(controller.addressController.text.isNotEmpty && controller.cityController.text.isNotEmpty
                && controller.stateController.text.isNotEmpty && controller.postalCodeController.text.isNotEmpty
                && controller.phoneController.text.isNotEmpty){

              Get.to(() => const PaymentMethod());

            }else{
              VxToast.show(context, msg: "Please fill all fields");
            }
          },
          color: redColor,
          textColor: whiteColor,
          title: "Continue"
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            customTextField(hint: "Address",title: "Address",isPass: false,controller: controller.addressController),
            customTextField(hint: "City",title: "City",isPass: false, controller: controller.cityController),
            customTextField(hint: "State",title: "State",isPass: false, controller: controller.stateController),
            customTextField(hint: "Postal Code",title: "Postal Code",isPass: false, controller: controller.postalCodeController),
            customTextField(hint: "Phone",title: "Phone",isPass: false, controller: controller.phoneController),
          ],
        ),
      ),
    );
  }
}
