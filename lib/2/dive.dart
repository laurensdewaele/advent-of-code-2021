import 'dart:convert';
import 'dart:io';
import 'dart:math';

const Map<String, Command> commandMap = {
  'up': Command.up,
  'forward': Command.forward,
  'down': Command.down
};

enum Command { up, forward, down }

class CommandInput {
  final Command command;
  final int value;

  CommandInput(this.command, this.value);
}

const String inputPath = '/Users/laurens/Projects/advent-of-code/lib/2/input';

void main(List<String> args) async {
  final commandStream = File(inputPath)
      .openRead()
      .transform(utf8.decoder)
      .transform(LineSplitter())
      .map((String line) {
    final List<String> split = line.split(' ');
    final Command command = commandMap[split[0]]!;
    final int value = int.parse(split[1]);
    return CommandInput(command, value);
  });

  final Point result = await calculateFinalPosition(commandStream);
  print('result: ${result.x * result.y}');
}

Future<Point<num>> calculateFinalPosition(
    Stream<CommandInput> commandInputs) async {
  int x = 0;
  int y = 0;
  int aim = 0;

  await for (final commandInput in commandInputs) {
    switch (commandInput.command) {
      case Command.down:
        aim += commandInput.value;
        break;
      case Command.up:
        aim -= commandInput.value;
        break;
      case Command.forward:
        x += commandInput.value;
        y += aim * commandInput.value;
        break;
    }
  }

  return Point(x, y);
}
