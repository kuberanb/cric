import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart'; // ✅ CORRECT

import '../../domain/entities/extracted_text.dart';
import '../../domain/repositories/text_extraction_repository.dart';
import '../models/extracted_text_model.dart';

class TextExtractionRepositoryImpl implements TextExtractionRepository {
  @override
  Future<ExtractedText> extractTextFromImage(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText = await textRecognizer.processImage(
      inputImage,
    );
    await textRecognizer.close();

    return ExtractedTextModel.fromRaw(recognizedText.text);
  }
}
