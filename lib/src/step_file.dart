import 'package:bdd_widget_test/src/bdd_line.dart';
import 'package:bdd_widget_test/src/generator_options.dart';
import 'package:bdd_widget_test/src/step_generator.dart';
import 'package:bdd_widget_test/src/util/constants.dart';
import 'package:path/path.dart' as p;

abstract class StepFile {
  const StepFile._(this.import);

  final String import;

  static StepFile create(
    String featureDir,
    String package,
    BddLine bddLine,
    Map<String, String> existingSteps,
    GeneratorOptions generatorOptions,
    String testerTypeTagValue,
    String testerNameTagValue,
  ) {
    final file = '${getStepFilename(bddLine.value)}.dart';

    if (existingSteps.containsKey(file)) {
      final import =
          p.join('.', existingSteps[file], file).replaceAll(r'\', '/');
      return ExistingStepFile._(import);
    }

    final externalStep = generatorOptions.externalSteps
        .firstWhere((l) => l.contains(file), orElse: () => '');
    if (externalStep.isNotEmpty) {
      return ExternalStepFile._(externalStep);
    }

    if (generatorOptions.stepFolder.startsWith('./') ||
        generatorOptions.stepFolder.startsWith('../')) {
      final import =
          p.join(generatorOptions.stepFolder, file).replaceAll(r'\', '/');
      final filename = p.join(featureDir, generatorOptions.stepFolder, file);
      return NewStepFile._(
        import,
        filename,
        package,
        bddLine.value,
        testerTypeTagValue,
        testerNameTagValue,
        bddLine.type == LineType.dataTableStep,
        generatorOptions.addWorld,
      );
    }

    final pathToTestFolder = p.relative(testFolderName, from: featureDir);
    final import = p
        .join(pathToTestFolder, generatorOptions.stepFolder, file)
        .replaceAll(r'\', '/');
    final filename = p.join(testFolderName, generatorOptions.stepFolder, file);
    return NewStepFile._(
      import,
      filename,
      package,
      bddLine.value,
      testerTypeTagValue,
      testerNameTagValue,
      bddLine.type == LineType.dataTableStep,
      generatorOptions.addWorld,
    );
  }
}

class NewStepFile extends StepFile {
  const NewStepFile._(
    super.import,
    this.filename,
    this.package,
    this.line,
    this.testerType,
    this.testerName,
    this.hasDataTable,
    this.addWorld,
  ) : super._();

  final String package;
  final String line;
  final String filename;
  final String testerType;
  final String testerName;
  final bool hasDataTable;
  final bool addWorld;

  String get dartContent => generateStepDart(
        package,
        line,
        testerType,
        testerName,
        hasDataTable,
        addWorld,
      );
}

class ExistingStepFile extends StepFile {
  const ExistingStepFile._(super.import) : super._();
}

class ExternalStepFile extends StepFile {
  const ExternalStepFile._(super.import) : super._();
}
