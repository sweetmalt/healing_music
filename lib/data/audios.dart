class Audios {
  const Audios();
  static const Map<String, String> _hem = {
    "90s 396HZ": "海底轮",
    "90s 417HZ": "脐轮",
    "90s 528HZ": "太阳轮",
    "90s 639HZ": "心轮",
    "90s 714HZ": "喉轮",
    "90s 852HZ": "眉心轮",
    "90s 963HZ": "顶轮"
  };
  get hem => _hem;

  static const Map<String, String> _bgm = {
    "BGM Space": "空灵",
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
    "60s 1HZ": "1HZ德尔塔波",
    "60s 10HZ": "10HZ阿尔法波",
    "60s 40HZ": "40HZ伽马波"
  };
  get bbm => _bbm;
}
