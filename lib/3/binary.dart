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
  final List<int> col1 = [];
  final List<int> col2 = [];
  final List<int> col3 = [];
  final List<int> col4 = [];
  final List<int> col5 = [];

  await for (final bitLine in bitLines) {
    for (var col = 1; col <= 5; col++) {
      switch (col) {
        case 1:
          col1.add(bitLine[0]);
          break;
        case 2:
          col2.add(bitLine[1]);
          break;
        case 3:
          col3.add(bitLine[2]);
          break;
        case 4:
          col4.add(bitLine[3]);
          break;
        case 5:
          col5.add(bitLine[4]);
          break;
      }
    }
  }

  final gammaBits = [
    mostCommon(col1),
    mostCommon(col2),
    mostCommon(col3),
    mostCommon(col4),
    mostCommon(col5)
  ];

  final epsilonBits = flipBits(gammaBits);

  final gamma = int.parse(gammaBits.join('').toString(), radix: 2);
  final epsilon = int.parse(epsilonBits.join('').toString(), radix: 2);

  return gamma * epsilon;
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
