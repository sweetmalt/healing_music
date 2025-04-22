import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scidart/numdart.dart';
import 'package:scidart/scidart.dart';

class Data extends Object {
  Data();
  @override
  String toString() {
    return 'Data';
  }

  static Future<Map<String, dynamic>> read(String jsonFileName) async {
    _readCloud("");
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$jsonFileName');
      if (!await file.exists()) {
        // 从assets目录读取JSON文件
        final jsonString =
            await rootBundle.loadString('assets/json/$jsonFileName');
        await file.writeAsString(jsonString);
        return json.decode(jsonString);
      } else {
        final contents = await file.readAsString();
        return json.decode(contents);
      }
    } catch (e) {
      return {};
    }
  }

  static Future<Map<String, dynamic>> _readCloud(String jsonFileName) async {
    return {};
  }

  static Future<List<String>> readFileList(String start) async {
    _readFileListCloud(0);
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
      return [];
    }
  }

  static Future<List<String>> _readFileListCloud(int userId) async {
    return [];
  }

  static Future<bool> delete(String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');
      await file.delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> rename(String fileName, String newname) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');
      await file.rename('${directory.path}/$newname');
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> write(
      Map<String, dynamic> data, String jsonFileName) async {
    _writeCloud({}, "");
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$jsonFileName');
      final jsonString = json.encode(data);
      await file.writeAsString(jsonString);

      ///
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> _writeCloud(
      Map<String, dynamic> data, String jsonFileName) async {
    return true;
  }

  /// 基于rr间期值数组的心率变异性hrv数据的频域分析（Frequency-Domain Analysis）
  /// 通过功率谱密度（PSD）计算不同频段的能量分布：
  /// 总功率（TP）
  /// 总频段（通常 ≤0.4 Hz）的功率：
  /// TP = ∫0~0.4 P(f) df
  /// 低频功率（LF, 0.04–0.15 Hz）
  /// LF=∫0.040.15P(f)df
  /// 高频功率（HF, 0.15–0.4 Hz）
  /// HF=∫0.15~0.4P(f)df
  /// LF/HF 比值
  /// 反映交感与副交感神经平衡：
  /// LFHF=LF功率/HF功率
  static List<double> calculateLFHF(List<dynamic> hrvData) {
    // 将HRV数据转换为数组
    ArrayComplex arrayComplex = ArrayComplex.empty();
    for (int i = 0; i < hrvData.length; i++) {
      Complex c = Complex(real: hrvData[i]);
      arrayComplex.add(c);
    }
    // 进行傅里叶变换
    ArrayComplex fftResult = fft(arrayComplex);
    // 计算频率分辨率
    double freqResolution = 1.0 / hrvData.length;
    // 计算总功率（TP）
    double tp = 0.0;
    for (int i = 0; i < fftResult.length; i++) {
      double freq = i * freqResolution;
      if (freq <= 0.4) {
        double abs = fftResult[i].real * fftResult[i].real +
            fftResult[i].imaginary * fftResult[i].imaginary;
        tp += abs;
      }
    }
    //计算低频功率（LF）
    double lf = 0.0;
    for (int i = 0; i < fftResult.length; i++) {
      double freq = i * freqResolution;
      if (freq >= 0.04 && freq <= 0.15) {
        double abs = fftResult[i].real * fftResult[i].real +
            fftResult[i].imaginary * fftResult[i].imaginary;
        lf += abs;
      }
    }
    //计算高频功率（HF）
    double hf = 0.0;
    for (int i = 0; i < fftResult.length; i++) {
      double freq = i * freqResolution;
      if (freq >= 0.15 && freq <= 0.4) {
        double abs = fftResult[i].real * fftResult[i].real +
            fftResult[i].imaginary * fftResult[i].imaginary;
        hf += abs;
      }
    }
    //计算 LF/HF 比值
    double lfhf = 0.0;
    if (hf > 0) {
      lfhf = lf / hf;
    }
    return [tp, lf, hf, (lfhf * 100).toInt() / 100];
  }

  static List<double> calculate(List<dynamic> data) {
    if (data.length > 10) {
      ///计算平均值
      double mv = data.reduce((a, b) => a + b) / data.length;

      ///计算标准差
      double sum = 0.0;
      for (int i = 0; i < data.length; i++) {
        sum += math.pow(data[i] - mv, 2);
      }
      double sdnn = math.sqrt(sum / data.length);

      /// 计算均方根
      sum = 0.0;
      for (int i = 1; i < data.length; i++) {
        sum += math.pow((data[i] - data[i - 1]), 2);
      }
      double rmssd = math.sqrt(sum / (data.length - 1));
      return [
        (mv * 100).toInt() / 100,
        (sdnn * 100).toInt() / 100,
        (rmssd * 100).toInt() / 100
      ];
    }
    return [0.0, 0.0, 0.0];
  }
}
