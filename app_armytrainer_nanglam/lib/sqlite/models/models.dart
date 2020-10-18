class Push {
  int countRecord;
  int countLevel;
  String date;
  Push({this.countRecord, this.countLevel, this.date});
  Map<String, dynamic> toMap() {
    return {
      'countRecord': countRecord,
      'countLevel': countLevel,
      'date': date,
    };
  }
}

class Sit {
  int countRecord;
  int countLevel;
  String date;
  Sit({this.countRecord, this.countLevel, this.date});
  Map<String, dynamic> toMap() {
    return {
      'countRecord': countRecord,
      'countLevel': countLevel,
      'date': date,
    };
  }
}

class PushRoutine {
  int idx;
  String routine;
  int time;
  PushRoutine({this.idx, this.routine, this.time});
  Map<String, dynamic> toMap() {
    return {
      'idx': idx,
      'routine': routine,
      'time': time,
    };
  }
}

class SitRoutine {
  int idx;
  String routine;
  int time;
  SitRoutine({this.idx, this.routine, this.time});
  Map<String, dynamic> toMap() {
    return {
      'idx': idx,
      'routine': routine,
      'time': time,
    };
  }
}
