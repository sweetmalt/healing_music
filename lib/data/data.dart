import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class Data extends Object {
  final String jsonFileName;
  Data({
    required this.jsonFileName,
  });
  @override
  String toString() {
    return 'Data(jsonFileName: $jsonFileName)';
  }

  Future<Map<String, dynamic>> read() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$jsonFileName');
      if (!await file.exists()) {
        final jsonString =
            await rootBundle.loadString("assets/json/$jsonFileName");
        await file.writeAsString(jsonString);
        return json.decode(jsonString);
      } else {
        final contents = await file.readAsString();
        return json.decode(contents);
      }
    } catch (e) {
      if (kDebugMode) {
        print('读取JSON文件时出错: $e');
      }
      return {};
    }
  }

  Future<void> write(Map<String, dynamic> data) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$jsonFileName');
      final jsonString = json.encode(data);
      await file.writeAsString(jsonString);
    } catch (e) {
      if (kDebugMode) {
        print('写入JSON文件时出错: $e');
      }
    }
  }
}
