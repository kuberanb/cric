

import '../entities/extracted_text.dart';
import 'dart:io';

abstract class TextExtractionRepository {
  Future<ExtractedText> extractTextFromImage(File imageFile);
}
