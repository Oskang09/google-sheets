import 'package:gstool/util.dart';

import 'main.dart';

class ExampleIndexMode {
  @Column(index: 0, parser: int.parse)
  int one;

  @Column(index: 1, parser: int.parse)
  int two;

  @Column(index: 2, parser: int.parse)
  int three;

  ExampleIndexMode();
}

class ExampleHeaderMode {
  @Column(name: "one", parser: int.parse)
  int one;

  @Column(name: "two", parser: int.parse)
  int two;

  @Column(name: "three", parser: int.parse)
  int three;

  ExampleHeaderMode();
}

void main() async {
  GoogleSheets<ExampleHeaderMode> sheets = GoogleSheets(
      "https://docs.google.com/spreadsheets/d/1uV032Lgm-HfQ-mAgcb7PPHdLcOATNYA1NYDI557xZWk",
      headerMode: true);
  await sheets.update(null);
  print(sheets.data.first.one);
  print(sheets.data.first.two);
  print(sheets.data.first.three);

  GoogleSheets<ExampleIndexMode> sheetsTwo = GoogleSheets(
      "https://docs.google.com/spreadsheets/d/1uV032Lgm-HfQ-mAgcb7PPHdLcOATNYA1NYDI557xZWk",
      headerMode: true);
  await sheetsTwo.update(null);
  print(sheetsTwo.data.first.one);
  print(sheetsTwo.data.first.two);
  print(sheetsTwo.data.first.three);
}
