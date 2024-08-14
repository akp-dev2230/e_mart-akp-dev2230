import 'package:e_mart/consts/consts.dart';

Widget customTextField({String? hint,String? title, isPass, controller}){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      title!.text.color(redColor).fontFamily(semibold).size(16.0).make(),
      5.heightBox,
      TextFormField(
          controller: controller,
          obscureText: isPass,
          decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontFamily: semibold,color: textFieldGrey),
          isDense: true,
          fillColor: lightGrey,
          filled: true,
          border: InputBorder.none,
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: redColor)),
        ),
      ),
      5.heightBox,
    ],
  );
}