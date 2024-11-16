// data.dart

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'alabanza_femenil.dart';

Future<List<Femenil>> fetchAlabanzasFemeniles() async {
  String jsonString = await rootBundle.loadString('assets/femenil.json');
  List<dynamic> jsonList = json.decode(jsonString);

  List<Femenil> alabanzas =
      jsonList.map((json) => Femenil.fromJson(json)).toList();

  return alabanzas;
}
