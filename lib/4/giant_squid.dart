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

  // Go through 5 draws and iterate
  // find if full column or full row
  // Add another draw
  // find if full column or full row

  // Board no. winners
  final List<int> winners = [];
  var takeCount = 5;
  var currentDraw = draws.take(takeCount).toList();

  while (winners.isEmpty) {
    for (var i = 0; i < boards.length; i++) {
      final boardNo = i + 1;
      final bool validColumns = checkColumns(currentDraw, boards[i]);
      final bool validRows = checkRows(currentDraw, boards[i]);
      if (validRows || validColumns) {
        winners.add(boardNo);
      }
    }
    takeCount++;
    currentDraw = draws.take(takeCount).toList();
  }
}

bool checkColumns(List<int> draw, List<List<int>> board) {
  final List<List<int>> inverted = [[], [], [], [], []];
  for (var row = 0; row < 5; row++) {
    for (var col = 0; col < 5; col++) {
      inverted[col].add(board[row][col]);
    }
  }

  return checkRows(draw, inverted);
}

bool checkRows(List<int> draw, List<List<int>> board) {
  return false;
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
