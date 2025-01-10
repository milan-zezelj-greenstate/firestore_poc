import 'dart:convert';
import 'dart:io';

import 'package:file_selector/file_selector.dart';

final jsonExample = {
  "name": "growborg",
  "templateLanguage": "en",
  "translations": [
    {
      "language": "en",
      "values": [
        {
          "key": "helloMessageNoDescription",
          "value": "Welcome to the GrowBorg app"
        },
        {
          "key": "helloMessage",
          "value": "Welcome to the GrowBorg app",
          "description": "The conventional newborn programmer greeting"
        },
        {
          "key": "helloWorld",
          "value": "Hello! '{Isn''t}' this a wonderful day?",
          "description": "Message with escaping charaters"
        },
        {
          "key": "hello",
          "value": "Hello {userName}",
          "description": "A message with a single parameter",
          "placeholders": {
            "userName": {
              "mode": "placeholder",
              "type": "String",
              "example": "Bob"
            }
          }
        },
        {
          "key": "numberOfDevices",
          "value":
              "You have {numberOfDevices} {device} on connected with your account",
          "description": "The conventional newborn programmer greeting",
          "placeholders": {
            "numberOfDevices": {"mode": "placeholder", "type": "int"},
            "device": {
              "mode": "plural",
              "type": "int",
              "values": {"1": "device", "other": "devices"}
            }
          }
        },
        {
          "key": "descriptionCheckEmailScreen",
          "value":
              "We have sent an email to {email}. Please check your email for the verification link.",
          "placeholders": {
            "email": {"mode": "placeholder", "type": "String"}
          }
        },
        {
          "key": "pronoun",
          "value": "{gender}",
          "description": "A gendered message",
          "placeholders": {
            "gender": {
              "mode": "select",
              "type": "String",
              "values": {"male": "he", "female": "she", "other": "they"}
            }
          }
        },
        {
          "key": "numberOfDataPoints",
          "value": "Number of data points: {value}",
          "description": "A message with a formatted int parameter",
          "placeholders": {
            "value": {
              "mode": "placeholder",
              "type": "int",
              "format": "compactCurrency",
              "optionalParameters": {"decimalDigits": 2}
            }
          }
        },
        {
          "key": "helloWorldOn",
          "value": "Hello World on {date}",
          "description": "A message with a date parameter",
          "placeholders": {
            "date": {"type": "DateTime", "format": "yMd"}
          }
        }
      ]
    },
    {
      "language": "de",
      "values": [
        {
          "key": "helloMessage",
          "value": "Willkommen bei der GrowBorg-App",
          "description": "The conventional newborn programmer greeting"
        },
        {
          "key": "helloWorld",
          "value": "Hallo! Ist das nicht ein wunderbarer Tag?",
          "description": "Message with escaping charaters"
        },
        {
          "key": "hello",
          "value": "Hallo {userName}",
          "description": "A message with a single parameter",
          "placeholders": {
            "userName": {
              "mode": "placeholder",
              "type": "String",
              "example": "Bob"
            }
          }
        },
        {
          "key": "numberOfDevices",
          "value":
              "Du hast {numberOfDevices} {device} mit Ihrem Profil verknüpft",
          "description": "The conventional newborn programmer greeting",
          "placeholders": {
            "numberOfDevices": {"mode": "placeholder", "type": "int"},
            "device": {
              "mode": "plural",
              "type": "int",
              "values": {"1": "device", "other": "devices"}
            }
          }
        },
        {
          "key": "pronoun",
          "value": "{gender}",
          "description": "A gendered message",
          "placeholders": {
            "gender": {
              "mode": "select",
              "type": "String",
              "values": {"male": "he", "female": "she", "other": "they"}
            }
          }
        },
        {
          "key": "numberOfDataPoints",
          "value": "Anzahl der Datenpunkte: {value}",
          "description": "A message with a formatted int parameter",
          "placeholders": {
            "value": {
              "mode": "placeholder",
              "type": "int",
              "format": "compactCurrency",
              "optionalParameters": {"decimalDigits": 2}
            }
          }
        },
        {
          "key": "helloWorldOn",
          "value": "Hallo Welt zum Date: {date}",
          "description": "A message with a date parameter",
          "placeholders": {
            "date": {"type": "DateTime", "format": "yMd"}
          }
        }
      ]
    },
    {
      "language": "sr",
      "values": [
        {
          "key": "helloMessage",
          "value": "Dobrodosli u GrowBorg aplikaciju",
          "description": "The conventional newborn programmer greeting"
        },
        {
          "key": "helloWorld",
          "value": "Dobar dan! Nije l'' danas lep dan?",
          "description": "Message with escaping charaters"
        },
        {
          "key": "hello",
          "value": "Pozdrav {userName}",
          "description": "A message with a single parameter",
          "placeholders": {
            "userName": {
              "mode": "placeholder",
              "type": "String",
              "example": "Bob"
            }
          }
        },
        {
          "key": "numberOfDevices",
          "value": "Imate {numberOfDevices} {device} povezanih na vas profil",
          "description": "The conventional newborn programmer greeting",
          "placeholders": {
            "numberOfDevices": {"mode": "placeholder", "type": "int"},
            "device": {
              "mode": "plural",
              "type": "int",
              "values": {"1": "device", "other": "devices"}
            }
          }
        },
        {
          "key": "pronoun",
          "value": "{gender}",
          "description": "A gendered message",
          "placeholders": {
            "gender": {
              "mode": "select",
              "type": "String",
              "values": {"male": "he", "female": "she", "other": "they"}
            }
          }
        },
        {
          "key": "numberOfDataPoints",
          "value": "Broj data poena: {value}",
          "description": "A message with a formatted int parameter",
          "placeholders": {
            "value": {
              "mode": "placeholder",
              "type": "int",
              "format": "compactCurrency",
              "optionalParameters": {"decimalDigits": 2}
            }
          }
        },
        {
          "key": "helloWorldOn",
          "value": "Dobar dan svete datum: {date}",
          "description": "A message with a date parameter",
          "placeholders": {
            "date": {"type": "DateTime", "format": "yMd"}
          }
        }
      ]
    }
  ]
};

class RegexMatch {
  int start;
  int end;
  String value;

  @override
  String toString() {
    return value;
  }

  RegexMatch({required this.start, required this.end, required this.value});
}

void main() async {
  localizeFile(jsonFilePath: "assets/example.json");
}

void localizeFile({required String jsonFilePath}) async {
  final jsonFile = await File(jsonFilePath).readAsString();
  final json = jsonDecode(jsonFile);

  final translations = json["translations"];
  final String? directoryPath = await getDirectoryPath();
  if (directoryPath != null) {
    for (final translation in translations) {
      jsonToArb(translation, directoryPath);
    }
  }
}

void localizeJson({required Map<String, dynamic> json}) async {
  final translations = json["translations"];
  final String? directoryPath = await getDirectoryPath();
  if (directoryPath != null) {
    for (final translation in translations) {
      jsonToArb(translation, directoryPath);
    }
  }
}

void jsonToArb(Map<String, dynamic> json, String directory) async {
  final language = json["language"];
  final fileName = "app_$language.arb";

  final file = File.fromUri(Uri(path: "$directory/$fileName"));

  await file.create(recursive: true);

  final translations = json["values"];

  Map<String, dynamic> result = {"@@locale": language};

  for (final translation in translations) {
    result.addAll(convertTranslation(translation));
  }
  final generatedFile = await file.writeAsString(jsonEncode(result));
  print("Generated file: ${generatedFile.absolute.path}");
}

Map<String, dynamic> convertTranslation(Map<String, dynamic> translation) {
  Map<String, dynamic> result = {};
  final placeholderRegExp = RegExp("(?<!'){([^}]*)}");

  final placeholders = placeholderRegExp
      .allMatches(translation["value"])
      .map((e) => RegexMatch(start: e.start, end: e.end, value: e.group(1)!))
      .toList();

  String value = translation["value"];

  if (placeholders.isNotEmpty) {
    for (final placeholder in placeholders) {
      final variable = translation["placeholders"][placeholder.value];

      if (variable["mode"] == "plural") {
        String firstPart = value.substring(0, placeholder.end);
        String secondPart = value.substring(placeholder.end, value.length);
        firstPart += "{${placeholder.value}, plural, ";
        for (final valueKey in variable["values"].keys) {
          String variableValue = variable["values"][valueKey];

          final temp =
              "${valueKey != "other" ? "=" : ""}$valueKey{$variableValue}";

          firstPart += temp;
        }

        value = "$firstPart}$secondPart";
      }

      if (variable["mode"] == "select") {
        String firstPart = value.substring(0, placeholder.start);
        String secondPart = value.substring(placeholder.end, value.length);
        firstPart += "{${placeholder.value}, select, ";
        for (final valueKey in variable["values"].keys) {
          String variableValue = variable["values"][valueKey];

          final temp = "$valueKey{$variableValue}";

          firstPart += temp;
        }

        value = "$firstPart$secondPart}";
      }
    }
  }

  result[translation["key"]] = value;

  if (translation["description"] != null ||
      translation["placeholders"] != null) {
    final variableName = "@${translation["key"]}";
    result[variableName] = {};

    if (translation["description"] != null) {
      result[variableName].addAll({
        "description": translation["description"],
      });
    }
    if (translation["placeholders"] != null) {
      Map<String, dynamic> plc = translation["placeholders"];

      plc.map((key, value) {
        value.remove("mode");
        value.remove("values");
        return MapEntry(key, value);
      });

      result[variableName].addAll({
        "placeholders": plc,
      });
    }
  }

  return result;
}
