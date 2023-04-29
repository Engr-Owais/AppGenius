import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatgpt_course/providers/gpt_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/models_provider.dart';
import '../widgets/text_widget.dart';

class GptScreen extends StatefulWidget {
  final String queryTopic;
  final bool images;
  const GptScreen({Key? key, required this.queryTopic, required this.images})
      : super(key: key);

  @override
  _GptScreenState createState() => _GptScreenState();
}

class _GptScreenState extends State<GptScreen> {
  bool _isTyping = false;
  late TextEditingController _queryController;
  late TextEditingController _imageController;
  String queryResponse = '';
  bool _isDownloading = false;
  double opacity = 1.0;
  @override
  void initState() {
    _queryController = TextEditingController();

    _imageController = TextEditingController();
    changeOpacity();
    super.initState();
  }

  @override
  void dispose() {
    _queryController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  changeOpacity() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        opacity = opacity == 0.0 ? 1.0 : 0.0;
        changeOpacity();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final gptProvider = Provider.of<GptProvider>(context);
    final modelsProvider = Provider.of<ModelsProvider>(context);
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: widget.images
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: gptProvider.getImages.isEmpty
                  ? InkWell(
                      onTap: () async {
                        await sendPrompt(gptProvider: gptProvider);
                      },
                      splashColor: Colors.grey[300],
                      child: _isTyping
                          ? Center(child: CircularProgressIndicator())
                          : Container(
                              height: 60,
                              width: size.width / 2,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: LinearGradient(colors: [
                                    Color(0xFF301E67),
                                    Color(0xFF5B8FB9),
                                  ])),
                              child: Center(
                                child: Text(
                                  "Generate Image",
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                    )
                  : Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            gptProvider.images = '';
                            _imageController.clear();
                          },
                          splashColor: Colors.grey[300],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 60,
                              width: size.width / 5,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: LinearGradient(colors: [
                                    Color(0xFF301E67),
                                    Color(0xFF5B8FB9),
                                  ])),
                              child: Center(
                                  child: Icon(
                                Icons.delete,
                                color: Colors.red,
                              )),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              download(gptProvider.getImages);
                            },
                            splashColor: Colors.grey[300],
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 60,
                                width: size.width / 2,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: LinearGradient(colors: [
                                      Color(0xFF301E67),
                                      Color(0xFF5B8FB9),
                                    ])),
                                child: Center(
                                  child: _isDownloading
                                      ? Text(
                                          "Downloading...",
                                          style: GoogleFonts.montserrat(
                                            color: Colors.white,
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      : Text(
                                          "Download Image",
                                          style: GoogleFonts.montserrat(
                                            color: Colors.white,
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ))
          : SizedBox(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.0,
        title: Text(
          "${widget.queryTopic}",
          style: GoogleFonts.comfortaa(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFFB6EADA),
          ),
        ),
      ),
      body: widget.images
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: _imageController,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    decoration: InputDecoration(
                      hintText: "Write What Image You Want?",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1),
                      ),
                    ),
                  ),
                  Expanded(
                    child: gptProvider.getImages.isEmpty
                        ? Image.asset(
                            'assets/images/noImage.png',
                            height: 150,
                            width: 250,
                          )
                        : CachedNetworkImage(
                            imageUrl: gptProvider.getImages,
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                  )
                ],
              ),
            )
          : SingleChildScrollView(
              child: Container(
                height: size.height,
                width: size.width,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 150,
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 5.0),
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.white, width: 1.5)),
                        child: TextField(
                          controller: _queryController,
                          style: TextStyle(color: Colors.white, fontSize: 18),
                          decoration: InputDecoration(
                            isDense: true,
                            prefixIcon: Text(
                              "Write a ${widget.queryTopic} on ",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            prefixIconConstraints:
                                BoxConstraints(minWidth: 0, minHeight: 0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 250,
                        width: size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white)),
                        child: gptProvider.getResponse.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Your response will be here",
                                  style: GoogleFonts.montserrat(
                                    color: Color(0xFFB6EADA),
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListView(
                                  children: [
                                    DefaultTextStyle(
                                      style: GoogleFonts.montserrat(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16),
                                      child:
                                          Text(gptProvider.getResponse.trim()),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    _isTyping
                        ? CircularProgressIndicator()
                        : InkWell(
                            onTap: () async {
                              await sendMessageFCT(
                                  modelsProvider: modelsProvider,
                                  gptProvider: gptProvider);
                            },
                            splashColor: Colors.grey[300],
                            child: Container(
                              height: 60,
                              width: size.width / 2,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: LinearGradient(colors: [
                                    Color(0xFF301E67),
                                    Color(0xFF5B8FB9),
                                  ])),
                              child: Center(
                                child: Text(
                                  "Generate",
                                  style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 18.0,
                    ),
                    gptProvider.getResponse.isEmpty
                        ? SizedBox()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () async {
                                  Clipboard.setData(ClipboardData(
                                          text: gptProvider.getResponse))
                                      .then((value) =>
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              duration:
                                                  Duration(milliseconds: 400),
                                              content: TextWidget(
                                                label: "Copied To ClipBoard",
                                              ),
                                              backgroundColor: Colors.green,
                                            ),
                                          ));
                                },
                                splashColor: Colors.grey[300],
                                child: Container(
                                  height: 60,
                                  width: size.width / 3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.green,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Copy",
                                      style: GoogleFonts.montserrat(
                                        color: Colors.black,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 18.0,
                              ),
                              InkWell(
                                onTap: () async {
                                  setState(() {
                                    gptProvider.response = '';
                                    _queryController.clear();
                                  });
                                },
                                splashColor: Colors.grey[300],
                                child: Container(
                                  height: 60,
                                  width: size.width / 3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.red,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "CLEAR",
                                      style: GoogleFonts.montserrat(
                                        color: Colors.black,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                  ],
                ),
              ),
            ),
    ));
  }

  Future<void> sendMessageFCT({
    required GptProvider gptProvider,
    required ModelsProvider modelsProvider,
  }) async {
    if (_isTyping) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: TextWidget(
            label: "You cant send multiple messages at a time",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_queryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "Please type a message",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      String msg = "Write a ${widget.queryTopic} on " + _queryController.text;
      print(msg);
      setState(() {
        _isTyping = true;
      });
      await gptProvider.gptResponse(
          msg: msg, chosenModelId: modelsProvider.getCurrentModel);

      setState(() {});
    } catch (error) {
      log("error $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: TextWidget(
          label: error.toString(),
        ),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        _isTyping = false;
      });
    }
  }

  Future sendPrompt({
    required GptProvider gptProvider,
  }) async {
    if (_imageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "Please type a prompt",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      setState(() {
        _isTyping = true;
      });
      await gptProvider.gptImagesResponse(
        prompt: _imageController.text,
      );

      setState(() {});
    } catch (error) {
      log("error sssssssss $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: TextWidget(
          label: error.toString(),
        ),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        _isTyping = false;
      });
    }
  }

  Future<void> download(url) async {
    setState(() {
      _isDownloading = true;
    });

    GallerySaver.saveImage(url).then((value) => {
          setState(() {
            _isDownloading = false;
          }),
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: TextWidget(
              label: "Image Downloaded",
            ),
            backgroundColor: Colors.green,
          ))
        });
  }
}
