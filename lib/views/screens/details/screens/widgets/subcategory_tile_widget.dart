// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubcategoryTileWidget extends StatelessWidget {
  final String image;
  final String title;
  const SubcategoryTileWidget({
    super.key,
    required this.image,
    required this.title,
  }) ;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.grey,
            // border: Border.all(color: Colors.black, width: 1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.network(
              image,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 8,),
        SizedBox(
          width: 110,
          child: Text(
            title,             
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.roboto(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

      ],
    );
  }
}
