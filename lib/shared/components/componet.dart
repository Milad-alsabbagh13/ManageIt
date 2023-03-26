import 'package:flutter/material.dart';
Widget defaultFormField({
  required String label,
  required String error,
  required IconData prefix,
  required TextEditingController controller,
  bool issecure=false,
  TextInputType keyboard=TextInputType.text,
})
{
  return Padding(
    padding: const EdgeInsets.only(bottom: 20.0),
    child: TextFormField(
      keyboardType:keyboard ,
      controller: controller,
      obscureText: issecure,
      validator: (String? value){
        if (value!=null &&value.isEmpty)return error;
        else return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color:Colors.white),

        ),
        label: Text(label,style: TextStyle(color: Colors.white),),
        prefixIcon: Icon(prefix,color: Colors.white,),
      ),
    ),
  );
}














void navigateTo(BuildContext context, Widget screen) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) {
        return screen;
      },
    ),
  );
}
Widget defaultbutton({
  required String text,
  required Function ontap
})
{
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
      width: double.infinity,
      height: 70.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.green[400],
      ),
      child: MaterialButton(onPressed: ontap(),
        child: Text(text),),
    ),);
}
