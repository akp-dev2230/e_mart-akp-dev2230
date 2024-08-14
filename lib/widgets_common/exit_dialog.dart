import 'package:e_mart/consts/consts.dart';


Future<bool?> exitDialog({context, title}) {
  return showDialog<bool>(context: context, builder: (context) {
    return AlertDialog(
      title: "Confirm".text.make(),
      content: "Are you sure want to $title?".text.make(),
      actions: [
        TextButton(
          onPressed:(){
            Navigator.pop(context, true);
          },
          child: "Yes".text.make(),
        ),
        TextButton(
          onPressed:(){
            Navigator.pop(context, false);
          },
          child: "No".text.make(),
        )
      ],
    );
  });
}