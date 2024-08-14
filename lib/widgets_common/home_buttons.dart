import 'package:e_mart/consts/consts.dart';

Widget homeButtons(width, height, icon,String? title, onPress){
  return Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(icon, width: 26,),
            10.heightBox,
            title!.text.fontFamily(semibold).size(15.0).color(darkFontGrey).align(TextAlign.center).make(),
          ],
        ).box.rounded.white.size(width, height).shadowSm.make();
}