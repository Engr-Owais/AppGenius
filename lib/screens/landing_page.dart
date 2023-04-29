import 'dart:math';

import 'package:chatgpt_course/screens/gptScreen.dart';
import 'package:chatgpt_course/screens/paywall_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyScreen extends StatelessWidget {
  final List<String> headings = [
    'Creative Writing',
    'Social',
    'Formal Writing',
    'Generate Images'
  ];

  final List<List<String>> elements = [
    ['Poem Writing', 'Paragraph Writing', 'Blog Writing', 'Youtube Script'],
    ['Twitter Caption', 'Instagram Caption', 'Facebook Caption'],
    ['Email Writing', 'Letter Writing', 'Application Writing'],
    ['Art Creation']
  ];

  final Random random = Random();

  Color _getRandomColor() {
    return Color.fromARGB(random.nextInt(256), random.nextInt(256),
            random.nextInt(256), random.nextInt(256))
        .withOpacity(0.01);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "APP GENIUS",
            style: GoogleFonts.comfortaa(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            SizedBox(
              height: 35,
            ),
            Expanded(
              flex: 8,
              child: ListView.builder(
                itemCount: headings.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: 0.0, bottom: 20.0, left: 20.0, right: 20.0),
                        child: Text(
                          headings[index],
                          style: GoogleFonts.comfortaa(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFB6EADA),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 100.0,
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: elements[index].length,
                            itemBuilder: (BuildContext context, int gridIndex) {
                              return InkWell(
                                splashColor: Colors.white,
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) {
                                    return GptScreen(
                                        images: elements[index][gridIndex]
                                                .contains("Art Creation")
                                            ? true
                                            : false,
                                        queryTopic: elements[index][gridIndex]);
                                  }));
                                },
                                child: Container(
                                  width: 150,
                                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          _getRandomColor().withOpacity(0.8),
                                          _getRandomColor().withOpacity(0.6),
                                          _getRandomColor().withOpacity(0.8),
                                        ]),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: Text(
                                        elements[index][gridIndex],
                                        style: GoogleFonts.montserrat(
                                          color: Color(0xFFB6EADA),
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
