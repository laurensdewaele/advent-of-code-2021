import 'dart:convert';
import 'dart:io';

const String inputPath = './input';

void main(List<String> args) async {
  final Stream<List<int>> bitStream = File(inputPath)
      .openRead()
      .transform(utf8.decoder)
      .transform(LineSplitter())
      .map((String line) => line.split('').map((s) => int.parse(s)).toList());

  final lifeSupportRating = await calc(bitStream);
  print(lifeSupportRating);
}

Future<int> calc(Stream<List<int>> bitLines) async {
  List<List<int>> columns = [];

  await for (final bitLine in bitLines) {
    if (columns.isEmpty) {
      columns = generateColumns(bitLine.length);
    }

    for (var col = 0; col < bitLine.length; col++) {
      columns[col].add(bitLine[col]);
    }
  }

  final List<int> oxygenGeneratorRating =
      filter(columns, common: 'most', equalKeepBit: 1, col: 0);
  final List<int> CO2ScrubberRating =
      filter(columns, common: 'least', equalKeepBit: 0, col: 0);
}

List<int> filter(List<List<int>> columns,
    {required String common, required int equalKeepBit, required int col}) {
  if (columns[col].length == 1) {
    return columns.expand((i) => i).toList();
  }

  final commonBit = findCommonBit(columns[col], common: common);
  final newColumns = columns[col].where(())
  // Check common bit in first column
  // Filter list
  // Check common bit in second column
  // Filter list
  // Stop if list length = 1;
}

List<List<int>> generateColumns(int no) {
  final List<List<int>> columns = [];
  for (var i = 0; i < no; i++) {
    columns.add([]);
  }
  return columns;
}

int findCommonBit(List<int> list, {required String common}) {
  final totalNoOfOnes = list.reduce((a, b) => a + b);
  if (totalNoOfOnes > list.length / 2) {
    return common == 'most' ? 1 : 0;
  } else {
    return common == 'most' ? 0 : 1;
  }
}

List<int> flipBits(List<int> list) {
  return list.map((bit) => bit == 1 ? 0 : 1).toList();
}
