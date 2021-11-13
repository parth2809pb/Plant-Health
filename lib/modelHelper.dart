import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plant_health/ui/cure.dart';
import 'package:plant_health/ui/homepage.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File _image;
  List _recognitions;
  String dname = "";
  String diseaseName = "";
  String PlantName = "";
  bool _busy = false;

  Future _showDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Select Image from... "),
            content: SingleChildScrollView(
              child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(30)
                        ),
                        child: GestureDetector(
                          child: Text("Gallery ",style: TextStyle(color: Colors.white),),
                          onTap: () {
                            predictImagePickerGallery(context);
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(30)
                        ),
                        child: GestureDetector(
                          child: Text("Camera ",style: TextStyle(color: Colors.white),),
                          onTap: () {
                            predictImagePickerCamera(context);
                          },
                        ),
                      )
                    ],
                  ),



            ),
          );
        });
  }

  Future<void> predictImagePickerGallery(BuildContext context) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() {
      _busy = true;
      _image = image;
    });
    //Navigator.of(context).pop();
    recognizeImage(image);
  }

  Future<void> predictImagePickerCamera(BuildContext context) async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image == null) return;
    setState(() {
      _busy = true;
      _image = image;
    });
    //Navigator.of(context).pop();
    recognizeImage(image);
  }

  @override
  void initState() {
    super.initState();

    _busy = true;

    loadModel().then((val) {
      setState(() {
        _busy = false;
      });
    });
  }

  Future loadModel() async {
    try {
      await Tflite.loadModel(
        model: "assets/Parths_final_plant.tflite",
        labels: "assets/Labels.txt",
      );
    } on PlatformException {
      print('Failed to load model.');
    }
  }

  Future recognizeImage(File image) async {
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _busy = false;
      _recognitions = recognitions;
    });
  }

  handleCure() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Cure(dname),
    ));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Widget> stackChildren = [];



    if (_busy) {
      stackChildren.add(const Opacity(
        child: ModalBarrier(dismissible: false, color: Colors.grey),
        opacity: 0.3,
      ));
      stackChildren.add(const Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Healthify Your Plant'),
      //   backgroundColor: Colors.green,
      // ),
      body: PageView(
        children: [


          Container(
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
                    SizedBox(height: 190,),
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
                    SizedBox(height: 20,),
                    Container(child: Image.asset("images/plant1.png")),

                  ],
                ),
              ),
            ),
          ),




          Container(
            decoration: BoxDecoration(
              color: Colors.grey[900]
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 15),
              child: SafeArea(
                child: Column(

                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _image == null ? Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Please select \na leaf.',
                              style: GoogleFonts.spartan(color: Colors.white,fontSize: 35,fontWeight: FontWeight.bold,letterSpacing: 1)),
                          SizedBox(height: 20,),
                          GestureDetector(
                            onTap: () {
                              predictImagePickerGallery(context);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height/3,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.grey[800],
                                  borderRadius: BorderRadius.circular(30)
                              ),
                              child: Center(child: Text("Gallery ",style: GoogleFonts.spartan(color: Colors.white,fontSize: 35,fontWeight: FontWeight.bold,letterSpacing: 1)),

                              )),
                          ),
                          SizedBox(height: 20,),
                          GestureDetector(
                            onTap: () {
                              predictImagePickerCamera(context);
                            },
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height/3,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.grey[800],
                                    borderRadius: BorderRadius.circular(30)
                                ),
                                child: Center(child: Text("Camera ",style: GoogleFonts.spartan(color: Colors.lightGreenAccent,fontSize: 35,fontWeight: FontWeight.bold,letterSpacing: 1)),

                                )),
                          ),
                        ],
                      ),
                    ) : Column(
                      children: [
                        Container(
                          height: 300,
                          width: MediaQuery.of(context).size.width,
                          //padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(_image),
                              fit: BoxFit.cover,
                            ),
                            border: Border.all(
                              color: Colors.grey[800],
                              width: 8,
                            ),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                offset: const Offset(
                                  5.0,
                                  5.0,
                                ), //Offset
                                blurRadius: 10.0,
                                spreadRadius: 2.0,
                              ), //BoxShadow
                              BoxShadow(
                                color: Colors.white,
                                offset: const Offset(0.0, 0.0),
                                blurRadius: 0.0,
                                spreadRadius: 0.0,
                              ), //BoxShadow
                            ],
                          ),
                        ),
                        SizedBox(height: 50,),
                        Column(
                          children: _recognitions != null
                              ? _recognitions.map((res) {
                            dname = res['label'];
                            String junklessString = dname.replaceAll(new RegExp('[\\W_\/]+'), ' ');
                            List SplittedText = junklessString.split(' ');
                            PlantName = SplittedText[0];
                            diseaseName = SplittedText[SplittedText.length-2]+SplittedText[SplittedText.length-1];
                            print(SplittedText);


                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Leaf belongs to "+PlantName+" plant.",
                                  style: GoogleFonts.spartan(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold,letterSpacing: 1),
                                ),
                                SizedBox(height: 10,),
                                Text(
                                  "Suffering from "+diseaseName+".",
                                  style: GoogleFonts.spartan(color: Colors.lightGreenAccent,fontSize: 25,fontWeight: FontWeight.bold,letterSpacing: 1),
                                ),
                              ],
                            );
                          }).toList()
                              : [],
                        ),
                        SizedBox(height: 50,),
                        _image == null ? Text("") : Row(
                          children: [
                            //SizedBox(width: MediaQuery.of(context).size.width - 265,),
                            GestureDetector(
                              onTap: () {
                                handleCure();
                              },
                              child: Container(
                                  width: MediaQuery.of(context).size.width-30,
                                  height: MediaQuery.of(context).size.height/8,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.grey[800],
                                      borderRadius: BorderRadius.circular(30)
                                  ),
                                  child: Center(child: Text("Cure Me! ",style: GoogleFonts.spartan(color: Colors.lightGreenAccent,fontSize: 35,fontWeight: FontWeight.bold,letterSpacing: 1)),

                                  )),
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _image=null;
                            });
                            setState(() {
                            });
                          },
                          child: Container(
                              width: MediaQuery.of(context).size.width-30,
                              height: MediaQuery.of(context).size.height/8,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.grey[800],
                                  borderRadius: BorderRadius.circular(30)
                              ),
                              child: Center(child: Text("New Leaf.",style: GoogleFonts.spartan(color: Colors.white,fontSize: 35,fontWeight: FontWeight.bold,letterSpacing: 1)),

                              )),
                        ),
                      ],
                    ),


                  ],
                ),
              ),
            ),
          ),






        ],
      ),





      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     _showDialog(context);
      //   },
      //   tooltip: 'Pick Image',
      //   label: const Text('Select A Leaf'),
      //   icon: FaIcon(FontAwesomeIcons.leaf),
      //   backgroundColor: Colors.green,
      // ),
    );
  }
}
