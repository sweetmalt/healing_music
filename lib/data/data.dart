import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scidart/numdart.dart';
import 'package:scidart/scidart.dart';

class Data extends Object {
  Data();
  @override
  String toString() {
    return 'Data';
  }

  static Future<String> path(String fileName) async {
    if (fileName.isEmpty) {
      return "";
    }
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$fileName';
  }

  static Future<bool> exists(String fileName) async {
    if (fileName.isEmpty) {
      return false;
    }
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    return await file.exists();
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
      // 按文件的最后修改时间倒排
      files.sort((a, b) {
        final aStat = a.statSync();
        final bStat = b.statSync();
        return bStat.modified.compareTo(aStat.modified);
      });
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

  static Map<String, Map<String, String>> dataDoc = {
    'energyPsy': {"title": '心理能量 EPS', "short": "心理能量 EPS", "long": "心理能量 EPS"},
    'energyPhy': {"title": '生理能量 EPH', "short": "生理能量 EPH", "long": "生理能量 EPH"},
    'curRelax': {
      "title": '松弛感 RELAX',
      "short": "松弛感，是一场灵魂的深海潜游",
      "long":
          "“松弛感”是指个体在特定情境下感受到的放松和自在的程度。它反映了大脑处于一种低压力、低焦虑、高舒适度的状态。在日常生活中，当我们感到轻松、无忧无虑时，就代表处于一种“松弛感”较强的状态。"
    },
    'curSharp': {
      "title": '敏锐度 SHARP',
      "short": "唤醒清醒力，掌控动态平衡",
      "long":
          "当感官褪去麻木，当直觉穿透表象，真正的敏锐力便成为连接世界的天线——它不意味着焦虑，而是让阳光下的尘埃与暗夜里的萤火都清晰可辨。在动态呼吸冥想中，您将训练大脑捕捉细微的情绪波动；通过环境音波解析课程，唤醒听觉对频率的精准解码；触觉感知矩阵则让指尖读懂温度变化的密语。这些并非超能力，而是人类与生俱来的觉察本能。"
    },
    'curFlow': {
      "title": '心流指数 FLOW',
      "short": "沉浸心流之境，唤醒内在能量",
      "long":
          "“心流”是指一种完全沉浸在当前活动中的状态，伴随着高度的专注、控制感和愉悦感。在这种状态下，人们会忘记时间的流逝，感到自己的能力与挑战完美匹配。这种状态由心理学家米哈里·契克森米哈赖 (Mihaly Csikszentmihalyi) 首次提出。"
    },
    'bciAtt': {
      "title": '专注度 ATT',
      "short": "注意力越集中，精神内耗越低，越能把更多能量用于身心修复。",
      "long":
          "“专注度”是指个体在特定任务或情境下，将注意力集中于特定信息或目标的能力。它反映了大脑处理信息的效率和对干扰的抑制能力。高专注度状态下，人们能够更高效地学习、工作和解决问题。"
    },
    'bciMed': {
      "title": '安全感 MED',
      "short": "安全感越高，人越松弛，副交感神经承受的压力越低，越能把更多能量用于身心疗愈。",
      "long":
          "“安全感”是指个体在面对环境或情境时，感受到的平静、放松和可控的程度。它反映了大脑对周围环境的评估和应对压力的能力。高安全感状态下，人们感到舒适、安心，更容易放松身心，进行休息和恢复。"
    },
    'bciAp': {
      "title": '愉悦度 AP',
      "short": "越愉悦，越接纳，这是吸纳外部能量的关键时刻。",
      "state": "平常,舒心,畅快,欢喜,极乐",
      "long":
          "“愉悦度”指标能够帮助人们实时了解自己的情绪状态。在日常生活中，情绪波动是常态，但过度的负面情绪可能会对身心健康造成不利影响。通过AI脑机检测脑电波并计算“愉悦度”，个体可以及时发现自己情绪的变化，从而采取相应的措施进行调节，如放松训练、调整生活方式等，以维持良好的心理状态。"
    },
    'bciDelta': {
      "title": 'δ波 Delta',
      "short": "德尔塔波是一种睡眠状态时占主导的神经活动。",
      "long":
          "德尔塔波是一类极为特殊的神经活动。当我们陷入睡眠状态，大脑不再被清醒时的繁杂思绪充斥，德尔塔波便逐渐占据主导地位。它的频率极为缓慢，却蕴含着巨大的能量。这种波的产生，意味着身体已进入深度的休息阶段。在德尔塔波的作用下，心跳趋于平缓，呼吸变得深沉且均匀，肌肉也彻底放松下来。身体仿佛开启了自我修复的 “夜间工厂”，细胞加速新陈代谢，疲惫的器官得到滋养，免疫系统全力运作。德尔塔波主导的睡眠状态，是身心恢复活力、为新一天积蓄能量的关键时期 。"
    },
    'bciTheta': {
      "title": 'θ波 Theta',
      "short": "θ波是一种趋近睡眠状态时占主导的神经活动。",
      "long":
          "θ 波在趋近睡眠状态时发挥着主导作用。当夜幕降临，白日的喧嚣渐渐远去，我们的意识开始变得模糊，身体也愈发放松，此时 θ 波便悄然登场。它的频率介于 4 至 8 赫兹之间，相比清醒时的高频脑波，θ 波显得缓慢而沉稳。伴随着 θ 波的产生，我们仿佛进入了一个半梦半醒的奇妙地带。在这个状态下，身体各部分机能逐渐放缓节奏，肌肉松弛，呼吸也趋于平稳。大脑不再进行高强度的思考运算，转而开始为即将到来的深度睡眠做准备，让身心在 θ 波的轻抚下，慢慢沉浸到舒缓宁静的氛围之中，为睡眠修复之旅拉开序幕。"
    },
    'bciLowAlpha': {
      "title": '低α波 LowAlpha',
      "short": "低α波是一种处在松弛状态时占主导的神经活动。",
      "long":
          "低 α 波的频率通常在 8 至 10 赫兹之间，节奏舒缓而平稳。它的出现，如同给身心注入了一股宁静的力量。随着低 α 波的活跃，紧绷的肌肉渐渐放松，焦虑与压力悄然消散。我们的思维不再急切地追逐目标，而是变得悠然、闲适。在低 α 波主导下，身心如同进入了一片宁静港湾，享受着惬意与自在，为后续的精力恢复奠定良好基础 。"
    },
    'bciHighAlpha': {
      "title": '高α波 HighAlpha',
      "short": "高α波是一种趋近松弛状态时占主导的神经活动。",
      "long":
          "高 α 波频率大约处于 10 至 12 赫兹之间，其节奏轻快而富有韵律。此时，身体尚未完全松弛下来，但已开始感知到放松的信号。就像在繁忙工作间隙，暂时放下手头事务，靠在椅背上，轻轻闭上双眼的那一刻，高 α 波活跃起来。它促使紧绷的神经纤维逐步舒展，心跳也随之稍缓，呼吸渐趋平和。思维不再被繁杂琐事紧紧束缚，开始拥有一丝自由的灵动，为即将到来的全身心松弛状态铺就道路，引领我们走向宁静舒缓之境 。"
    },
    'bciLowBeta': {
      "title": '低β波 LowBeta',
      "short": "低β波是一种处在思虑状态时占主导的神经活动。",
      "long":
          "低 β 波是思虑状态下的显著标识。当我们陷入对问题的思索、规划未来事务，或是回忆过往经历时，低 β 波便开始在神经元之间踊跃传递。它的频率范围通常在 12 至 15 赫兹，不算太快，但充满活力。此时，大脑的不同区域协同运作，前额叶负责逻辑分析，海马体助力记忆调取。随着低 β 波的主导，我们全身心投入思考，注意力高度聚焦。身体虽保持相对静止，可大脑内部如同忙碌的蜂巢。血液加速流向大脑，为神经细胞输送充足养分，助力思维不断深入拓展，让我们在思虑的海洋中持续探索，直至梳理清思绪，找到问题的解决方向 。"
    },
    'bciHighBeta': {
      "title": '高β波 HighBeta',
      "short": "高β波是一种趋近思虑状态时占主导的神经活动。",
      "long":
          "它的频率范围大致在 15 至 30 赫兹，节奏急促且充满力量。随着高 β 波占据主导，大脑各区域迅速进入 “备战” 状态。前额叶皮质飞速运转，进行逻辑推理与决策判断；颞叶积极参与，唤起相关知识与经验。身体也会不自觉地紧绷，心跳加快，为大脑高强度的工作提供充足能量。在高 β 波的驱动下，我们的思维愈发敏捷，不断在脑海中碰撞出灵感火花，朝着解决问题、达成目标的方向全速迈进 。"
    },
    'bciLowGamma': {
      "title": '低γ波 LowGamma',
      "short": "低γ波是一种处在一般专注状态时占主导的神经活动。",
      "long":
          "低 γ 波在一般专注状态下发挥着关键的主导作用。当我们沉浸于日常事务，像阅读一本引人入胜的书籍、专注地操作电脑处理文档，又或是精心烹制一顿美食时，低 γ 波便悄然 “上岗”。它的频率通常处于 30 至 50 赫兹之间，有着平稳且有序的节奏。一旦低 γ 波占据主导，大脑便开启高效工作模式。神经元之间默契协作，信息传递迅速而精准。我们的注意力高度集中，周围的干扰被自动屏蔽，全身心投入手头之事。此时，身体维持着稳定的状态，呼吸均匀，肌肉保持适度张力，为大脑专注运行提供坚实支撑，助力我们在一般专注状态下，高效完成各项任务，达成预期目标 。"
    },
    'bciMiddleGamma': {
      "title": '中γ波 MiddleGamma',
      "short": "中γ波是一种达到高度专注状态时占主导的神经活动。",
      "long":
          "当中 γ 波在高度专注状态下闪亮登场，整个 “会场” 便会被彻底点燃。在攻克一道棘手的数学难题、精心雕琢一幅艺术画作，或者进行一场紧张激烈的竞技比赛时，中 γ 波开始发挥它的魔力。其频率范围大致在 50 至 80 赫兹，节奏紧凑且充满爆发力。中 γ 波一旦占据主导，大脑的各个区域仿佛训练有素的精锐部队，迅速进入特级战备状态。前额叶皮质全力施展逻辑分析与深度思考的能力，视觉、听觉等感官区域将信息高效传递整合。身体也进入高度协调状态，呼吸不自觉放缓，心跳却沉稳有力，源源不断地为大脑输送能量。在中 γ 波的强力驱动下，我们与专注之事融为一体，外界的一切都被隔绝，全身心沉浸在高度专注的巅峰体验中，不断突破自我，向着目标全力冲刺 。"
    },
    'bciTemperature': {
      "title": '额温 Temperature',
      "short": "反应当前体温，一般比标准体温低1~2度。",
      "long":
          "人体体温是反映健康状况的重要指标，而额温作为常用的体温测量方式之一，有着独特的特性。额头部位暴露在外，其温度受外界环境影响较大。额温所反应的当前体温，一般情况下会比标准体温低 1 至 2 度。这是因为额头皮肤直接与空气接触，热量容易散失。比如在正常的室内环境下，使用额温枪测量，得出的数值通常会低于口腔或腋下测量的标准体温。不过，这一差值并非固定不变，在寒冷的室外，差值可能更大；而在闷热的环境里，差值或许会有所缩小。但总体而言，了解额温与标准体温的这一关系，能帮助我们更准确地解读体温数据，及时察觉身体的异常状况 。"
    },
    'bciHeartRate': {
      "title": '心率 HeartRate',
      "short": "心跳是驱动生命活力的核心机制，55~75bpm的平稳静息心率是释放生命能量的最佳状态。",
      "long":
          "心跳，宛如生命乐章中那激昂而又稳健的鼓点，是驱动生命活力的核心机制。从生命最初的萌芽开始，心脏便不知疲倦地跳动，它如同一位忠诚的卫士，为全身各个器官与组织源源不断地输送着饱含氧气与营养的血液。在众多心率数值中，55 至 75bpm 的平稳静息心率堪称释放生命能量的最佳状态。当心率处于这一区间，心脏无需过度操劳，却能高效地完成血液循环任务。身体的新陈代谢有条不紊地进行，各个细胞如同被精准调校的机器部件，活力满满地运转。在这样的心率下，我们会感到精力充沛，思维清晰，无论是应对日常工作，还是投入休闲活动，都能轻松胜任，尽情释放生命蕴含的无限能量，享受健康活力的生活。"
    },
    'bciHrv': {
      "title": '心率变异性 HRV',
      "short": "HRV（心率变异性）：副交感神经活性指标。",
      "long":
          "NN50是HRV分析中的一个指标，表示相邻两次正常心动周期（NN间期）之间的差值大于50毫秒的次数。NN50是反映心率变异性中高频成分的一个指标，主要与副交感神经活动相关。NN50常用于评估副交感神经的功能状态，特别是在短时HRV分析中。\nLF/HF是HRV频域分析中的一个指标，表示低频功率（LF, 0.04-0.15 Hz）与高频功率（HF, 0.15-0.4 Hz）的比值。LF/HF比值的变化可以反映交感神经和副交感神经的平衡状态，特别是在应激反应、情绪调节和心血管健康研究中有明确意义。"
    },
    'bciGrind': {"title": '咬牙', "short": "可用于控制音乐。", "long": "可用于控制音乐。"},
  };

  static Future<String> generateAiText(String prompt) async {
    if (prompt == "") {
      return "";
    }
    final response = await http.post(
      Uri.parse('https://api.deepseek.com/chat/completions'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer sk-a7170a19070b426683827950e06a0dfa',
      },
      body: jsonEncode({
        'model': 'deepseek-chat',
        'messages': [
          {
            'role': 'system',
            'content': '''
                你是一位专业的心理和情绪分析疗愈师，我现在给你几项用户数据，需要你以这些数据为基础，发挥你心理分析和疗愈上的专业优势，为客户在1.心理层面2.因心理问题可引发的对生理的影响，这两个维度上输出个性化分析和日常建议的报告。
                我给你的用户数据是经由脑机接口设备采集并计算得到的数据，包含安全感、专注度、心流指数、松弛感、愉悦感、心率变异性NN50和LF/HF（其中LF/HF值越低越好，其他数值都是越高越好）。这些数据均以百分比表示。
                该分析和建议报告分为四段，第一段为情绪和心理解读，第二段为因心理问题可引发的生理问题的分析，第三段为日常调节心理和生理的建议，包含情绪训练、生理锻炼、饮食调节、生活方式调节等，最后第四段以通用的内容结尾：“另外，也建议您与专业咨询/疗愈师沟通，以获得针对您的个性化解决方案。祝您健康幸福！”
                整体文字数量控制在不超过800字，文字的风格要阳光积极正面，体现对用户的关怀，传递温度，具有亲和力和感染力，段落标题里禁止出现#号*号等各种markdown格式原有的标识符号。
                '''
          },
          {'role': 'user', 'content': prompt},
        ],
        'stream': false,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      String res = data['choices'][0]['message']['content'];
      res = res.replaceAll('**', '');
      return res;
    } else {
      throw Exception('Failed to generate AI text');
    }
  }

  static Future<String> generateAiText2(String prompt) async {
    if (prompt == "") {
      return "";
    }
    final client = http.Client();
    try {
      final request =
          http.Request('POST', Uri.parse('https://api.coze.cn/v3/chat?'));
      request.headers.addAll({
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer pat_PoodcJJ0NxjV2LmfuQ6LCBk48hFQUDAvdxfZPGTgyvlf6ei22rjPkIyyoz13a3mP',
      });
      request.body = jsonEncode({
        "bot_id": "7434848152596774939",
        "user_id": "1234567890",
        "stream": true,
        "additional_messages": [
          {
            "role": "user",
            "content": prompt,
            "content_type": "text",
            "type": "question"
          }
        ]
      });

      final response = await client.send(request);
      await for (var chunk in response.stream.transform(utf8.decoder)) {
        List<String> lines = chunk.split('\n');
        for (var line in lines) {
          if (line.startsWith('data:')) {
            String jsonData = line.substring(5);
            Map<String, dynamic> data = jsonDecode(jsonData);
            if (data['type'] != null &&
                data['type'] == 'answer' &&
                data['content'] != null &&
                data['content'].length > 100) {
              String aiText = data['content'];
              aiText = aiText.replaceAll('#', '');
              return aiText;
            }
          }
        }
      }
      return "";
    } finally {
      client.close();
    }
  }

  static Future<String> generateAiImage(String prompt) async {
    if (prompt == "") {
      return "";
    }
    final client = http.Client();
    try {
      final request =
          http.Request('POST', Uri.parse('https://api.coze.cn/v3/chat?'));
      request.headers.addAll({
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer pat_PoodcJJ0NxjV2LmfuQ6LCBk48hFQUDAvdxfZPGTgyvlf6ei22rjPkIyyoz13a3mP',
      });
      request.body = jsonEncode({
        "bot_id": "7496709743646720035",
        "user_id": "1234567890",
        "stream": true,
        "additional_messages": [
          {
            "role": "user",
            "content": prompt,
            "content_type": "text",
            "type": "question"
          }
        ]
      });

      final response = await client.send(request);
      await for (var chunk in response.stream.transform(utf8.decoder)) {
        List<String> lines = chunk.split('\n');
        for (var line in lines) {
          if (line.startsWith('data:')) {
            String jsonData = line.substring(5);
            Map<String, dynamic> data = jsonDecode(jsonData);
            if (data['type'] != null &&
                data['type'] == 'answer' &&
                data['content'] != null) {
              String imgUrl = data['content'];
              return imgUrl;
            }
          }
        }
      }
      return "";
    } finally {
      client.close();
    }
  }

  static Future<void> downloadAndSaveImage(
      String imageUrl, String savePath) async {
    if (imageUrl.isEmpty || savePath.isEmpty) {
      return;
    }
    try {
      // 发送HTTP GET请求获取图片数据
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        // 将图片数据写入文件
        final file = File(savePath);
        await file.writeAsBytes(response.bodyBytes);
        if (kDebugMode) {
          print('图片保存成功: $savePath');
        }
      } else {
        if (kDebugMode) {
          print('图片下载失败，状态码: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('图片下载或保存过程中发生错误: $e');
      }
    }
  }

  static Future<void> saveImageToGallery(String imagePath) async {
    try {
      final result = await ImageGallerySaverPlus.saveFile(imagePath);
      if (result['isSuccess']) {
        Get.snackbar(
          "成功",
          "图片保存成功",
          backgroundColor: ThemeData().colorScheme.primary,
          colorText: ThemeData().colorScheme.primaryContainer,
        );
      } else {
        Get.snackbar(
          "失败",
          "图片保存失败",
          backgroundColor: ThemeData().colorScheme.primary,
          colorText: ThemeData().colorScheme.primaryContainer,
        );
      }
    } catch (e) {
      Get.snackbar(
        "错误",
        "保存图片时发生错误",
        backgroundColor: ThemeData().colorScheme.primary,
        colorText: ThemeData().colorScheme.primaryContainer,
      );
    }
  }
}
