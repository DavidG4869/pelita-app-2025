extension DateUtils on DateTime {
  static List<String> _months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Juni', 'Juli', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'];
  DateTime getPrevDate(int days) {
    return this.subtract(Duration(days: days));
  }

  DateTime getNextDate(int days) {
    return this.add(Duration(days: days));
  }

  DateTime getPublishDate() => this.getDate().getPrevDate(1);

  DateTime getDate() => DateTime(this.year, this.month, this.day);

  String formatString({bool withYear = false}) {
    var basic = '${this.day} ${_months[this.month - 1]}';
    return withYear ? '$basic ${this.year}' : basic;
  }
}
