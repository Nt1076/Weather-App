import 'package:flutter/material.dart';


class AditionalInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const AditionalInfoItem({
    super.key,required this.icon,required this.label,required this.value
  });

  @override
  Widget build(BuildContext context) {
    return Column(
       children: [
         Icon(icon ,size: 32,),
      const   SizedBox(height: 12,),
         Text(label,
         style:const TextStyle(
           fontSize: 15
         ),),
        const SizedBox(height: 6,),
         Text(value,style:
        const TextStyle(fontWeight: FontWeight.bold,fontSize: 16) ,)
       ],
     );
  }
}

