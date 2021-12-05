import 'dart:convert';
import 'dart:io';

Future<int> sonarSweep() async {
  late final List<int> depths;
  final lineSplitter = LineSplitter();

  final String input =
      await File('/Users/laurens/Projects/advent-of-code/lib/1/input')
          .readAsString();

  final List<String> lines = lineSplitter.convert(input);
  depths = lines.map((String line) => int.parse(line)).toList();

  int largerThanPrevious = 0;
  List<int> previousWindow = [];
  List<int> window = [];

  for (var depth in depths) {
    if (previousWindow.length != 3 && window.length != 3) {
      previousWindow.add(depth);
      window.add(depth);
    } else {
      window.removeAt(0);
      window.add(depth);

      final sumWindow = sumArray(window);
      final sumPrevious = sumArray(previousWindow);

      if (sumWindow > sumPrevious) {
        largerThanPrevious++;
      }

      previousWindow.removeAt(0);
      previousWindow.add(depth);
    }
  }

  return largerThanPrevious;
}

int sumArray(List<int> arr) {
  return arr.reduce((value, element) => value + element);
}
