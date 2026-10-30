# Toon4D

Toon4D is a Delphi encoder that turns JSON into TOON (Token-Oriented Object Notation), a compact text format for sending structured data to large language models. It targets version 4.4 of the [TOON specification](https://github.com/toon-format/spec) (`toon-spec: 4.4`) and passes the official encoder fixtures.

Toon4D uses only the Delphi RTL. It encodes; it does not decode TOON.

## Installation

Install the DPM package `GDK.Toon4D`, or add `Source` to your search path. Runtime packages for RAD Studio 10.3 to 13 are in `packages`.

## Usage

Use `Toon4D`, and `Toon4D.Types` for options.

```pascal
uses
  Toon4D,
  Toon4D.Types;

const Toon = TToon.JsonToToon('{"name":"Alice","age":30,"active":true,"tags":["admin","ops"],"notes":[]}');
```

```
name: Alice
age: 30
active: true
tags[2]: admin,ops
notes: []
```

`JsonToToon` takes a JSON string or a `TJSONValue`. The caller keeps ownership of a `TJSONValue`.

### Arrays of objects

An array whose objects share the same keys becomes a table. Columns that hold objects with the same keys become nested field groups.

```
employees[2]{id,name,role}:
  1,Alice Johnson,admin
  2,Bob Smith,user
```

```
orders[2]{id,customer{name,country},total}:
  1,Ada,DK,99.5
  2,Bob,UK,149
```

Arrays that do not fit a table are written as a list:

```
items[2]:
  - id: 1
    tags[2]: x,y
  - id: 2
    note: "#todo"
```

### Objects of objects

An object with two or more entries whose values share the same keys becomes a keyed table:

```
servers[2:]{host,port}:
  alpha: a.example.com,8080
  beta: b.example.com,9090
```

The specification decides which form a value gets. There is no option to prefer one form over another.

## Options

```pascal
var Options := TToonOptions.Default;
Options.IndentSize := 4;
Options.Delimiter := TToonDelimiter.Pipe;

const Toon = TToon.JsonToToon(Json, Options);
```

```
team:
    lead: Ada
    members[2|]{id|name}:
        1|Bob
        2|Cy
```

| Field | Default | Values |
|-------|---------|--------|
| `IndentSize` | 2 | Spaces per level, 1 or more |
| `Delimiter` | `TToonDelimiter.Comma` | `Comma`, `Tab` or `Pipe` |

These are the two encoder options the specification defines.

## Numbers

Numbers are written from the decimal text of the `TJSONNumber`, so a parsed number keeps every digit it had in the JSON: `1.5000` becomes `1.5` and `1e6` becomes `1000000`. Values from 0.000001 up to, but not including, 1e21 are written without an exponent. Smaller and larger values use exponent notation, such as `1e-7` and `1.23e+100`. `NaN` and infinity become `null`.

## Errors

| Exception | Raised when |
|-----------|-------------|
| `EToonInvalidJsonException` | The JSON string does not parse, or the `TJSONValue` is nil |
| `EToonInvalidOptionsException` | `IndentSize` is less than 1 |
| `EToonEncodingException` | A string or key contains an unpaired UTF-16 surrogate |

All three descend from `EToonException`.

## Building and testing

```batch
build.bat
```

This builds the DUnitX suite in `Tests` for Win32 and Win64 and runs it on both. From a RAD Studio command prompt it uses the Delphi of that prompt, otherwise the newest RAD Studio installed. The test suite uses multiline string literals and needs Delphi 12 or later.

`Tests/fixtures` holds the encoder fixtures from the [specification repository](https://github.com/toon-format/spec/tree/main/tests/fixtures/encode). `Toon4D.Tests.OfficialFixtures` runs every fixture in those files and reports each one that fails.

## License

MIT License - See LICENSE file for details

## Contributing

Contributions welcome! Please open an issue or pull request on GitHub.

## Commercial Support

This library is MIT licensed and free to use. For companies that depend on it commercially we offer support and maintenance agreements with guaranteed response times, and sponsored development of features you need. Contact us at [gdksoftware.com/contact-us](https://gdksoftware.com/contact-us) or open an issue to get in touch.
