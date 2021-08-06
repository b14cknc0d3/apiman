import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xff33691e),
        child: Center(
          // child: Icon(
          //   Icons.apartment_outlined,
          //   size: MediaQuery.of(context).size.width * 0.785,
          // ),
          child: Text(
            "ApiMan",
            style: TextStyle(
                color: Colors.white,
                fontFamily: "Righteous",
                fontWeight: FontWeight.bold,
                fontSize: 40),
            //   style: GoogleFonts.righteous(
            //       color: Colors.white, fontWeight: FontWeight.bold, fontSize: 40),
          ),
        ),
      ),
    );
  }
}
