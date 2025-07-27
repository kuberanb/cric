
import '../../domain/entities/extracted_text.dart';

class ExtractedTextModel extends ExtractedText {
  ExtractedTextModel({required super.text});

  factory ExtractedTextModel.fromRaw(String rawText) {
    return ExtractedTextModel(text: rawText);
  }
}
