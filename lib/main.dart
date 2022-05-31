import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screenshot/screenshot.dart';
import 'package:unicons/unicons.dart';

import 'mappings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Observation MediaTech Chapter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: const Color(0xffe42a2a),
      ),
      home: MyHomePage(title: 'The Observation MTC'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScreenshotController screenshotController = ScreenshotController();
  double devicePixelRatio = 1.0;
  List<DicePositions> states = DicePositions.values.toList();

  DicePositions state1 = DicePositions.one;
  DicePositions state2 = DicePositions.three;

  void takeAndDownloadScreenShot() async {
    await screenshotController.capture(
      pixelRatio: devicePixelRatio,
      delay: const Duration(
        milliseconds: 100,
      ),
    ).then((pngBytes) {

      final base64 = base64Encode(pngBytes!);
      final anchor =
      html.AnchorElement(href: 'data:application/octet-stream;base64,$base64')
        ..download = "obs_mtc_dice_position.png"
        ..target = 'blank';

      html.document.body!.append(anchor);
      anchor.click();
      anchor.remove();


    });
  }

  void reshuffle() async {
    Future.delayed(const Duration(seconds: 4), () {});
  }

  @override
  Widget build(BuildContext context) {
    const kMaxWidth = 450.0;
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: deviceHeight * 0.1,
            ),
            const HeadLine(),
            const SizedBox(
              height: 10,
            ),
            Center(
                child: Text(
              'Team Building Exercise #3 - The DiceBreaker',
              style: GoogleFonts.cagliostro(
                fontSize: 15,
              ),
            )),
            Center(
                child: Text(
                  'For instructions please refer to the Official \nNotification published with the Working Group.',
                  style: GoogleFonts.jura(
                    fontSize: 10,
                  ),
                )),
            Screenshot(
              controller: screenshotController,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: deviceWidth > kMaxWidth ? 350 : kMaxWidth,
                    child: Card(
                      elevation: 10,
                      borderOnForeground: false,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Roll the Dice",
                              style: GoogleFonts.jura(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  state1.diceIconData,
                                  size: 100,
                                ),
                                Icon(
                                  state2.diceIconData,
                                  size: 100,
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            QuestionDisplay(state: state1,),
            const SizedBox(height: 10,),
            QuestionDisplay(state: state2,),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: takeAndDownloadScreenShot,
        tooltip: 'Save the Dice State',
        child: const Icon(UniconsLine.image_download),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class QuestionDisplay extends StatelessWidget {
  const QuestionDisplay({
    Key? key,
    required this.state,

  }) : super(key: key);

  final DicePositions state;


  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 350,

        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Question #${state.diceFaceValue.toString()}:", style: GoogleFonts.cagliostro(fontSize: 18, color: Colors.red[200]), textAlign: TextAlign.left,),
            const SizedBox(height: 5,),
            Text(state.questionsData, maxLines: 3, style: GoogleFonts.jura(fontSize: 14),),
          ],
        ),

      )
    );
  }
}

class HeadLine extends StatelessWidget {
  const HeadLine({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.network(
          "https://ik.imagekit.io/fwwm2nv0b6z/"
          "tr:n-media_library_thumbnail/OBS_LANDING_ASSET_WHITE_6KTPM0zq1."
          "png?media_library_thumbnail",
          fit: BoxFit.cover,
        ),
        const SizedBox(
          width: 10,
        ),
        Image.network("https://ik.imagekit.io/fwwm2nv0b6z/"
            "tr:n-media_library_thumbnail/c_level_WlmPs9c9c.png?"
            "ik-sdk-version=javascript-1.4.3&updatedAt=1653948296952")
      ],
    );
  }
}
