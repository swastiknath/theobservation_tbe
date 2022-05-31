import 'dart:convert';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obs_mtc_tbe3/notifiers.dart';
import 'package:screenshot/screenshot.dart';
import 'package:unicons/unicons.dart';

//changing from Canvaskit to HTML
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
      home: ProviderScope(child: MyHomePage()),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);
  ScreenshotController screenshotController = ScreenshotController();
  double devicePixelRatio = 1.0;

  void takeAndDownloadScreenShot() async {
    await screenshotController
        .capture(
      pixelRatio: devicePixelRatio,
      delay: const Duration(
        milliseconds: 100,
      ),
    )
        .then((pngBytes) {
      final base64 = base64Encode(pngBytes!);
      final anchor = html.AnchorElement(
          href: 'data:application/octet-stream;base64,$base64')
        ..download = "obs_mtc_dice_position.png"
        ..target = 'blank';

      html.document.body!.append(anchor);
      anchor.click();
      anchor.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    const kMaxWidth = 450.0;
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    return Scaffold(
      body: Consumer(builder: (context, ref, _) {
        List<DicePositions> currentStates = ref.watch(diceProvider);

        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
               SizedBox(
                height: 15,
                child: Center(child: Text("The Observation ❤️ Serverless Architecture",  style: GoogleFonts.jura(fontSize: 9, letterSpacing: 1.5), ),),
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
                  'For instructions please refer to the Official \nNotification published within the Working Group.',
                  style: GoogleFonts.jura(
                    fontSize: 10,
                  ),
                ),
              ),
              Screenshot(
                controller: screenshotController,
                child: Column(
                  children: [
                    Center(
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
                                    currentStates[0] == DicePositions.initial
                                        ? "Tap on the Shuffle Icon to Roll the Die."
                                        : "Your Die Positions Are: ",
                                    style: GoogleFonts.jura(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        currentStates[0].diceIconData,
                                        size: 100,
                                      ),
                                      Icon(
                                        currentStates[1].diceIconData,
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
                    const SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: Container(
                        width: 350,
                        decoration: BoxDecoration(
                          color: const Color(0xff211A19),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (currentStates[0] != DicePositions.initial)
                              QuestionDisplay(
                                state: currentStates[0],
                              ),
                            const SizedBox(
                              height: 10,
                            ),
                            if (currentStates[1] != DicePositions.initial)
                              QuestionDisplay(
                                state: currentStates[1],
                              ),
                            if (currentStates[0] == DicePositions.initial)
                              Center(
                                child: Text(
                                  "Roll Your Die to Get Your Questions",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.jura(
                                    fontSize: 20,
                                    color: Colors.red[200],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 5,),
                  ],
                ),
              ),

            ],
          ),
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Consumer(builder: (context, ref, child) {
        List<DicePositions> crStates = ref.watch(diceProvider);

        return FloatingActionButton(
          onPressed: crStates.contains(DicePositions.initial)
              ? () => ref.read(diceProvider.notifier).reshuffle()
              : takeAndDownloadScreenShot,
          tooltip: crStates.contains(DicePositions.initial)
              ? 'Reshuffle'
              : 'Download Dice Image',
          child: crStates.contains(DicePositions.initial)
              ? const Icon(UniconsLine.play)
              : const Icon(UniconsLine.image_download),
        );
      }),
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
          Text(
            "Question #${state.diceFaceValue.toString()}:",
            style: GoogleFonts.cagliostro(fontSize: 18, color: Colors.red[200]),
            textAlign: TextAlign.left,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            state.questionsData,
            maxLines: 10,
            style: GoogleFonts.jura(fontSize: 14),
          ),
        ],
      ),
    ));
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
