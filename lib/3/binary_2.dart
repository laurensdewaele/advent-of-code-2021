import 'dart:convert';
import 'dart:io';

const String inputPath = '/Users/laurens/Projects/advent-of-code/lib/3/input';

void main(List<String> args) async {
  final Stream<List<int>> bitStream = File(inputPath)
      .openRead()
      .transform(utf8.decoder)
      .transform(LineSplitter())
      .map((String line) => line.split('').map((s) => int.parse(s)).toList());

  List<List<int>> columns = [];

  await for (final bitLine in bitStream) {
    if (columns.isEmpty) {
      columns = generateColumns(bitLine.length);
    }

    for (var col = 0; col < bitLine.length; col++) {
      columns[col].add(bitLine[col]);
    }
  }

  // TODO: WTFFFFFFFFFF I CAN'T COPY THIS ARRAY IN DART???
  // IT KEEPS ON MODYFING THE ORIGINAL??

  // final oxygen = await calcOx(columns);
  final CO2 = await calcCO2(columns);
  // print(oxygen);
  print(CO2);
}

Future<int> calcCO2(List<List<int>> columns) async {
  final List<int> CO2ScrubberRatingList =
      filter(columns, common: 'least', equalKeepBit: 0, filterCol: 0);

  final int CO2ScrubberRating =
      int.parse(CO2ScrubberRatingList.join('').toString(), radix: 2);

  return CO2ScrubberRating;
}

Future<int> calcOx(List<List<int>> columns) async {
  final List<int> oxygenGeneratorRatingList =
      filter(columns, common: 'most', equalKeepBit: 1, filterCol: 0);

  final int oxygenGeneratorRating =
      int.parse(oxygenGeneratorRatingList.join('').toString(), radix: 2);

  return oxygenGeneratorRating;
}

List<int> filter(List<List<int>> columns,
    {required String common,
    required int equalKeepBit,
    required int filterCol}) {
  if (columns[0].length == 1) {
    return columns.expand((i) => i).toList();
  }

  // Check common bit in first column
  final commonBit = findCommonBit(columns[filterCol], common: common);
  // Filter list
  final List<int> indexesToDelete = [];
  for (var i = 0; i < columns[filterCol].length; i++) {
    if (columns[filterCol][i] != commonBit) {
      indexesToDelete.add(i);
    }
  }
  for (var col = 0; col < columns.length; col++) {
    for (var index in indexesToDelete) {
      columns[col][index] = 2;
    }
  }

  final List<List<int>> newColumns = columns.map((col) {
    final newCol = col.map((col) => col).toList();
    newCol.removeWhere((el) => el == 2);
    return newCol;
  }).toList();

  return filter(newColumns,
      common: common, equalKeepBit: equalKeepBit, filterCol: ++filterCol);
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
  final totalNoOfZeros = list.length - totalNoOfOnes;

  if (common == 'most') {
    if (totalNoOfOnes > totalNoOfZeros) {
      return 1;
    } else if (totalNoOfOnes == totalNoOfZeros) {
      return 1;
    } else {
      return 0;
    }
  } else {
    if (totalNoOfOnes > totalNoOfZeros) {
      return 0;
    } else if (totalNoOfOnes == totalNoOfZeros) {
      return 0;
    } else {
      return 1;
    }
  }
}

List<int> flipBits(List<int> list) {
  return list.map((bit) => bit == 1 ? 0 : 1).toList();
}
