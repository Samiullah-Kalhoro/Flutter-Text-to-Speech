import 'package:flutter/material.dart';
import 'package:text_to_speech/text_to_speech.dart';

class ReadOrator extends StatefulWidget {
  const ReadOrator({super.key});

  @override
  State<ReadOrator> createState() => _ReadOratorState();
}

class _ReadOratorState extends State<ReadOrator> {
  final String defaultLanguage = 'en-US';
  String? language;
  String? languageCode;
  List<String> languageCodes = <String>[];
  List<String> languages = <String>[];

  String text = '';
  TextEditingController textEditingController = TextEditingController();
  TextToSpeech tts = TextToSpeech();
  String? voice;
  double volume = 1; // Range: 0-1

  @override
  void initState() {
    textEditingController.text = text;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initLanguages();
    });
    super.initState();
  }

  Future<void> initLanguages() async {
    languageCodes = await tts.getLanguages();

    final List<String>? displayLanguages = await tts.getDisplayLanguages();
    if (displayLanguages == null) {
      return;
    }

    languages.clear();
    for (final dynamic lang in displayLanguages) {
      languages.add(lang as String);
    }

    final String? defaultLangCode = await tts.getDefaultLanguage();
    if (defaultLangCode != null && languageCodes.contains(defaultLangCode)) {
      languageCode = defaultLangCode;
    } else {
      languageCode = defaultLanguage;
    }
    language = await tts.getDisplayLanguageByCode(languageCode!);

    voice = await getVoiceByLang(languageCode!);

    if (mounted) {
      setState(() {});
    }
  }

  Future<String?> getVoiceByLang(String lang) async {
    final List<String>? voices = await tts.getVoiceByLang(languageCode!);
    if (voices != null && voices.isNotEmpty) {
      return voices.first;
    }
    return null;
  }

  void speak() {
    tts.setVolume(volume);

    if (languageCode != null) {
      tts.setLanguage(languageCode!);
    }

    tts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              Image.asset(
                "assets/images/tts.png",
                fit: BoxFit.contain,
                width: 200,
                height: 150,
              ),
              const SizedBox(
                height: 10,
              ),
              Card(
                elevation: .5,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: textEditingController,
                    maxLength: 500,
                    maxLines: 10,
                    minLines: 5,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Enter text here...',
                      counterText: '${text.length}/500',
                    ),
                    onChanged: (String newText) {
                      setState(() {
                        text = newText;
                      });
                    },
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Language'),
                  const SizedBox(
                    width: 20,
                  ),
                  DropdownButton<String>(
                    value: language,
                    icon: const Icon(Icons.arrow_drop_down_sharp),
                    iconSize: 24,
                    elevation: 16,
                    underline: Container(
                      height: 2,
                    ),
                    onChanged: (String? newLang) async {
                      languageCode = await tts.getLanguageCodeByName(newLang!);
                      voice = await getVoiceByLang(languageCode!);
                      setState(() {
                        language = newLang;
                      });
                    },
                    items:
                        languages.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      label: const Text('Speak'),
                      icon: const Icon(Icons.volume_up_outlined),
                      onPressed: () {
                        speak();
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(right: 10),
                      child: ElevatedButton.icon(
                        label: const Text('Stop'),
                        icon: const Icon(Icons.stop),
                        onPressed: () {
                          tts.stop();
                        },
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
