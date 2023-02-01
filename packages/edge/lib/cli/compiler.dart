import 'dart:io';

import 'package:cli_util/cli_logging.dart';
import 'package:path/path.dart' as p;

enum CompilerLevel {
  O1,
  O2,
  O3,
  O4,
}

class Compiler {
  final Logger logger;

  // The entry point of the application.
  final String entryPoint;

  // The output directory path.
  final String outputDirectory;

  final CompilerLevel level;

  // The output file name. Defaults to `main.dart.js`.
  final String outputFileName;

  Compiler({
    required this.logger,
    required this.entryPoint,
    required this.outputDirectory,
    required this.level,
    this.outputFileName = 'main.dart.js',
  });

  Future<String> compile() async {
    final entry = File(entryPoint);

    if (!await entry.exists()) {
      logger.write('No entry file found at "${entry.path}", aborting.');
      exit(1);
    }

    // final compiling = logger.progress('Compiling Dart entry point');

    final outputPath = p.join(outputDirectory, outputFileName);

    final process = await Process.run('dart', [
      'compile',
      'js',
      '-O1',
      '--no-frequency-based-minification',
      '--server-mode',
      '-o',
      outputPath,
      entry.path,
    ]);

    // compiling.finish(showTiming: true);
    if (process.exitCode != 0) {
      logger.write('Failed to compile dart file.');
      logger.write(process.stderr);
      exit(1);
    }

    logger.trace(process.stdout);

    // TODO: cleanup .deps, .map files?

    return outputPath;
  }
}