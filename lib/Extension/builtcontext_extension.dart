import 'package:flutter/material.dart';

extension ContextExtentions on BuildContext {
  Color kPrimaryColor() => const  Color(0xffFF9200); 
  Color kOrangeColor() => const  Color(0xffFF9200); 

  LinearGradient kCardLinearGradient() => const LinearGradient(
        begin: Alignment(-1.9, 1.3557),
        end: Alignment(1.5467, 1.5467),
        colors: [
          Color(0xFFA300BE),
          Color(0xFFFFCC00),
        ],
      );
}
