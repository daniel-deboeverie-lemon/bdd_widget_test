import 'package:bdd_widget_test/src/feature_file.dart';
import 'package:bdd_widget_test/src/generator_options.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('testMethodName test ', () {
    const featureFile = '''
Feature: Counter
    Background:
        Given the app is running
    After:
        And I do not see {'42'} text
    Scenario: Initial counter value is 0
        Given the app is running
        Then I see {'0'} text
''';

    const expectedFeatureDart = '''
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_import, directives_ordering

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import './step/the_app_is_running.dart';

void main() {
  group('Testing feature', () {
    customTestWidgets('Testing scenario', (tester) async {
      await theAppIsRunning(tester);
    });
  });
}
''';

    final feature = FeatureFile(
      featureDir: 'test.feature',
      package: 'test',
      input: featureFile,
      generatorOptions: const GeneratorOptions(
          testMethodName: 'customTestWidgets',
          externalSteps: [
            'package:bdd_sample/i_see_text.dart',
            'package:bdd_sample/i_see_some_text.dart',
            'package:bdd_sample/i_see_some_other_text.dart',
          ]),
    );
    expect(feature.dartContent, expectedFeatureDart);
  });
}