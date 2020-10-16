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
