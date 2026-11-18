import 'package:flutter_test/flutter_test.dart';
import 'package:skills_lint/skills_lint.dart';

void main() {
  test('skills/ contains only valid skills', () async {
    final config = await ConfigParser.loadConfig();
    expect(config.parsingErrors, isEmpty);

    final valid = await validateSkills(
      skillDirPaths: const ['skills'],
      config: config,
      quiet: true,
    );
    expect(valid, isTrue,
        reason: 'A skill under skills/ failed skills_lint validation. '
            'Run: dart run skills_lint --skills-directory skills/ '
            '--published-skill-name --check-relative-paths');
  });
}
