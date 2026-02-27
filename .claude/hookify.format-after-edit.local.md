---
name: format-after-edit
enabled: true
event: file
conditions:
  - field: file_path
    operator: regex_match
    pattern: \.dart$
---

**Run `dart format` on the file you just modified.**

After every Edit or Write to a `.dart` file, immediately run:
```
dart format <file_path>
```

This is a project requirement — do not skip formatting.
