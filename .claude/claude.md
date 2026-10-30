# Toon4D Development Context

Toon4D is a Delphi encoder from JSON to TOON. It targets version 4.4 of the TOON specification: https://github.com/toon-format/spec/blob/main/SPEC.md. The specification is the authority; when it changes, update the encoder and the fixtures together.

## Source

- `Toon4D.pas`: `TToon`, the public entry point (`JsonToToon`, `GetLibraryVersion`).
- `Toon4D.Types.pas`: `TToonOptions` (`IndentSize`, `Delimiter`), `TToonDelimiter` and the exceptions.
- `Toon4D.Encoder.pas`: `TToonEncoder`, which chooses the form of every value and writes the lines.
- `Toon4D.Fields.pas`: the field list of a tabular or keyed header, including nested field groups.
- `Toon4D.Text.pas`: quoting and escaping of string values and keys.
- `Toon4D.Numbers.pas`: canonical number form, from the decimal text of a `TJSONNumber`.
- `Toon4D.Consts.pas`: line break and messages.

The library uses only the RTL, so it uses `System.Generics.Collections` rather than Spring4D.

## Tests

`build.bat` builds `Tests/Toon4D.Tests.dproj` for Win32 and Win64 and runs the suite on both. Builds must have no hints or warnings.

`Tests/fixtures` is a copy of `tests/fixtures/encode` from the specification repository. `Toon4D.Tests.OfficialFixtures` runs every fixture in those files; when the specification moves to a new version, copy the new files over these and add a `TestCase` for any new file.
