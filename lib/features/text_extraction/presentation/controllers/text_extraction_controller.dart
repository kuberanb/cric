import 'dart:io';
import 'package:get/get.dart';
import '../../data/repositories/text_extraction_repository_impl.dart';
import '../../domain/entities/extracted_text.dart';

class TextExtractionController extends GetxController {
  final repository = TextExtractionRepositoryImpl();
  var extractedText = ''.obs;
  var isLoading = false.obs;

  Future<void> extractText(File imageFile) async {
    isLoading.value = true;
    try {
      ExtractedText result = await repository.extractTextFromImage(imageFile);
      extractedText.value = result.text;
    } catch (e) {
      extractedText.value = 'Error: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }
}
