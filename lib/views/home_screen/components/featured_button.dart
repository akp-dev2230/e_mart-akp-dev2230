import 'package:e_mart/consts/consts.dart';
import 'package:e_mart/views/category_screen/category_details.dart';

Widget featuredButton({String? title, icon}) {
  return Row(
    children: [
      Image.asset(icon, width: 60, fit: BoxFit.fill,),
      title!.text.fontFamily(semibold).size(15.0).color(darkFontGrey).make(),
    ],
  ).box.white.width(200.0).margin(const EdgeInsets.symmetric(horizontal: 4.0))
      .padding(const EdgeInsets.all(4.0)).roundedSM.outerShadowSm.make()
      .onTap(()=> CategoryDetails(title: title));
}