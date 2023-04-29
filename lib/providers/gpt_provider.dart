import 'package:flutter/cupertino.dart';

import '../services/api_service.dart';

class GptProvider with ChangeNotifier {
  String response = '';
  String get getResponse {
    return response;
  }

  String images = '';
  String get getImages {
    return images;
  }

  Future<void> gptResponse(
      {required String msg, required String chosenModelId}) async {
    response = await ApiService.sendMessage(
      message: msg,
      modelId: chosenModelId,
    );
    notifyListeners();
  }

  Future gptImagesResponse({required String prompt}) async {
    images = await ApiService.imageGenerate(
      prompt: prompt,
    );
    notifyListeners();
  }
}
