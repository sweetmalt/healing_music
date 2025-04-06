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
        final tempFile = File("assets/json/$jsonFileName");
        if (await tempFile.exists()) {
          final jsonString =
              await rootBundle.loadString("assets/json/$jsonFileName");
          await file.writeAsString(jsonString);
          return json.decode(jsonString);
        } else {
          return {};
        }
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

  Future<List<String>> readFileList(String start) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      // 获取目录下以start开头的的所有文件
      final files = directory.listSync().where((file) {
        return file is File && file.path.startsWith('${directory.path}/$start');
      }).toList();
      // 将文件列表转换为文件名列表
      if (files.isNotEmpty) {
        final fileNames =
            files.map((file) => file.path.split('/').last).toList();
        return fileNames;
      } else {
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print('读取JSON文件时出错: $e');
      }
    }
    return [];
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
