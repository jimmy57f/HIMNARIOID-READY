// data.dart

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'alabanza.dart';

Future<List<Alabanza>> fetchAlabanzas() async {
  String jsonString = await rootBundle.loadString('assets/alabanzas.json');
  List<dynamic> jsonList = json.decode(jsonString);

  List<Alabanza> alabanzas =
      jsonList.map((json) => Alabanza.fromJson(json)).toList();

  return alabanzas;
}
