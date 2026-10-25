"""Create and verify a source-only archive. Python standard library only."""
from pathlib import Path
import zipfile

root = Path(__file__).resolve().parents[1]
# The assignment file name must carry both student IDs.
output = root.parent / '40312440132_22652290356_Campus_Event_Explorer_HW1.zip'
excluded = {'.git', '.idea', '.vscode', '.dart_tool', 'build', '.gradle', 'Pods', '.symlinks', 'ephemeral', '__pycache__'}
local_files = {'local.properties', 'Generated.xcconfig', 'flutter_export_environment.sh', '.flutter-plugins-dependencies', '.flutter-plugins', 'key.properties', '.DS_Store'}
with zipfile.ZipFile(output, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as archive:
    for path in sorted(root.rglob('*')):
        if not path.is_file():
            continue
        relative = path.relative_to(root)
        if excluded.intersection(relative.parts) or path.name in local_files or path.suffix in {'.iml', '.jks'}:
            continue
        archive.write(path, Path('campus_event_explorer') / relative)
with zipfile.ZipFile(output) as archive:
    assert archive.testzip() is None
    names = archive.namelist()
    assert not any('/build/' in name or '/.dart_tool/' in name for name in names)
    for required in ['lib/main.dart', 'pubspec.yaml', 'pubspec.lock', 'README.md', 'android/gradlew', 'android/gradle/wrapper/gradle-wrapper.jar', 'ios/Runner.xcodeproj/project.pbxproj', 'assets/fonts/OFL.txt']:
        assert f'campus_event_explorer/{required}' in names, required
    assert len([name for name in names if '/screenshots/' in name and name.endswith('.png')]) == 8
print(f'Archive: {output}')
print(f'Files: {len(names)}; bytes: {output.stat().st_size}; integrity: OK')
