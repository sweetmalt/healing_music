class Audios {
  const Audios();
  static const Map<String, String> _hem = {
    "90s 963HZ": "全息963HZ",
    "90s 852HZ": "睡眠852HZ",
    "90s 714HZ": "代谢714HZ",
    "90s 639HZ": "免疫639HZ",
    "90s 528HZ": "消化528HZ",
    "90s 417HZ": "幸福417HZ",
    "90s 396HZ": "动力396HZ" 
  };
  get hem => _hem;

  static const Map<String, String> _bgm = {
    "BGM Hang": "手碟",
    "BGM Piano": "钢琴",
    "BGM Guitar": "吉他",
    "BGM Flute": "长笛",
    "BGM Violin": "小提琴",
    "BGM Cello": "大提琴",
    "BGM Guzheng": "古筝"
  };
  get bgm => _bgm;

  static const Map<String, String> _env = {
    "40s Birds Songs": "鸟鸣",
    "40s Fire": "篝火",
    "40s Night": "虫鸣",
    "40s Rain Drop Lotus": "细雨",
    "40s Rivulet": "小溪流",
    "40s Singing Bowl": "颂钵",
    "40s Water Drops": "水滴"
  };
  get env => _env;

  static const Map<String, String> _bbm = {
    "60s 1HZ": "德尔塔波1HZ助眠",
    "60s 10HZ": "阿尔法波10HZ放松",
    "60s 40HZ": "伽马波40HZ专注"
  };
  get bbm => _bbm;
}
