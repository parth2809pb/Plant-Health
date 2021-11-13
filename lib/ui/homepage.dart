import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plant_health/modelHelper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[800]
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Text("Plant",
                  style: GoogleFonts.spartan(color: Colors.white,fontSize: 45,fontWeight: FontWeight.bold,letterSpacing: 1)
                ),
                Row(
                  children: [
                    Text("Health",
                        style: GoogleFonts.spartan(color: Colors.white,fontSize: 45,fontWeight: FontWeight.bold,letterSpacing: 1)
                    ),
                    Text(".",
                        style: GoogleFonts.spartan(color: Colors.lightGreenAccent,fontSize: 45,fontWeight: FontWeight.bold,letterSpacing: 1)
                    ),
                  ],
                ),
                SizedBox(height: 200,),
                GestureDetector(
                  onDoubleTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>MyApp()));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Text("Swipe left \nto continue",style: GoogleFonts.spartan(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold,letterSpacing: 1)),
                        SizedBox(width: 10,),
                        FaIcon(FontAwesomeIcons.arrowRight, color: Colors.lightGreenAccent,)
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
