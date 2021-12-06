import 'dart:convert';
import 'dart:io';

const String inputPath = './input';

void main(List<String> args) async {
  final Stream<List<int>> bitStream = File(inputPath)
      .openRead()
      .transform(utf8.decoder)
      .transform(LineSplitter())
      .map((String line) => line.split('').map((s) => int.parse(s)).toList());

  final powerConsumption = await calc(bitStream);
  print(powerConsumption);
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

  final List<int> gammaBits =
      columns.map((List<int> column) => mostCommon(column)).toList();

  final epsilonBits = flipBits(gammaBits);

  final gamma = int.parse(gammaBits.join('').toString(), radix: 2);
  final epsilon = int.parse(epsilonBits.join('').toString(), radix: 2);

  return gamma * epsilon;
}

List<List<int>> generateColumns(int no) {
  final List<List<int>> columns = [];
  for (var i = 0; i < no; i++) {
    columns.add([]);
  }
  return columns;
}

int mostCommon(List<int> list) {
  final totalNoOfOnes = list.reduce((a, b) => a + b);
  if (totalNoOfOnes > list.length / 2) {
    return 1;
  } else {
    return 0;
  }
}

List<int> flipBits(List<int> list) {
  return list.map((bit) => bit == 1 ? 0 : 1).toList();
}
