import 'package:e_mart/consts/consts.dart';

Widget ourButton({onPress,Color? color,Color? textColor,String? title}){
  return ElevatedButton(
    onPressed: onPress,
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(color),
      padding: const WidgetStatePropertyAll(EdgeInsets.all(12.0)),
    ),
    child: title!.text.color(textColor).fontFamily(bold).make(),
  );
}