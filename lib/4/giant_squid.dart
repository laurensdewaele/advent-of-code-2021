import 'dart:convert';
import 'dart:io';

void main(List<String> args) async {
  final Stream<String> lines = File('./input')
      .openRead()
      .transform(utf8.decoder)
      .transform(LineSplitter());

  final input = await mapInput(lines);
  final draws = input.draws;
  final boards = input.boards;
  print(boards);
  print(draws);
}

Future<Input> mapInput(Stream<String> lines) async {
  List<int> draws = [];
  int boardCount = 0;
  final List<List<List<int>>> boards = [];

  await for (final line in lines) {
    if (draws.isEmpty) {
      draws = line.split(',').map((c) => int.parse(c)).toList();
      continue;
    }

    if (line.isEmpty) {
      boardCount++;
      boards.add([]);
      continue;
    }

    final List<String> rowString = line.split(' ');
    rowString.removeWhere((c) => c == ' ' || c == '');
    final List<int> row = rowString.map((c) => int.parse(c)).toList();
    boards[boardCount - 1].add(row);
  }

  return Input(draws: draws, boards: boards);
}

class Input {
  final List<List<List<int>>> boards;
  final List<int> draws;

  Input({required this.boards, required this.draws});
}
