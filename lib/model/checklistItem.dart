class ChecklistItem {
  ChecklistItem({
    required this.des,
    required this.pass,
    this.service,
    this.half,
    this.year,
    this.belt,
    this.value,
    this.major,
  });

  String des;
  bool pass;
  List<String?>? value;
  bool? service;
  bool? major;
  bool? half;
  bool? belt;
  bool? year;

  static List<String>? _toString(list) {
    if (list == null) return null;
    List<String> group = [];
    for (String? t in list) {
      group.add(t!);
    }
    return group;
  }

  static ChecklistItem fromMap(Map<String, dynamic> data) {
    final String des = data['des'];
    final bool pass = data['pass'];
    final List<String?>? value = _toString(data['value']);
    final bool? service = data['service'];
    final bool? major = data['major'];
    final bool? half = data['half'];
    final bool? belt = data['belt'];
    final bool? year = data['year'];

    return ChecklistItem(
      des: des,
      pass: pass,
      value: value,
      service: service,
      major: major,
      half: half,
      belt: belt,
      year: year,
    );
  }

  copy() => ChecklistItem(
        des: des,
        pass: pass,
        value: value,
        service: service,
        major: major,
        half: half,
        belt: belt,
        year: year,
      );
      
  static List fromChecklistItem(List<ChecklistItem> list) {
    List cli = [];
    for (ChecklistItem t in list) {
      Map<String, dynamic> pel = t.toMap();
      cli.add(pel);
    }
    return cli;
  }

  Map<String, dynamic> toMap() {
    return {
      'des': des,
      'pass': pass,
      'value': value,
      'service': service,
      'major': major,
      'half': half,
      'belt': belt,
      'year': year,
    };
  }
}
