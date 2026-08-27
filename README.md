# Toon4D Library - LLM Data Optimization

**Token-Oriented Object Notation (TOON) Encoder for Delphi**

## Overview

Toon4D is a Delphi library that encodes JSON data to TOON format - a compact, human-readable serialization format designed specifically for Large Language Model (LLM) applications. TOON achieves **30-60% token reduction** compared to standard JSON while maintaining or improving LLM comprehension.

## Key Features

- **Full TOON 2.0 Specification Compliance** - Complete implementation of all required features
- **Token Efficiency** - 30-60% token reduction on typical LLM payloads
- **Zero Dependencies** - Uses only Delphi RTL (System.JSON)
- **Cross-Platform** - Windows, macOS, Linux, iOS, Android
- **Comprehensive Test Suite** - 300+ unit tests covering all edge cases
- **Clean API** - Embarcadero-style static class methods

## TOON Format Benefits

TOON is specifically designed for LLM prompts and provides:

1. **Tabular Arrays**: Objects with uniform structure encoded as CSV-style rows
   ```toon
   users[3]{id,name,role}:
     1,Alice,admin
     2,Bob,user
     3,Charlie,viewer
   ```

2. **Minimal Syntax**: Removes redundant punctuation (braces, brackets, quotes)
3. **Explicit Structure**: Array lengths and field names declared upfront for validation
4. **Indentation-Based**: YAML-like nesting for readability

## Quick Start

### Installation

```pascal
// Add to your uses clause
uses
  Toon4D,
  Toon4D.Types;
```

### Basic Usage

```pascal
var
  JsonString := '{"name":"Alice","age":30,"active":true}';
  ToonOutput := TToon.JsonToToon(JsonString);

// Result:
// name: Alice
// age: 30
// active: true
```

### Tabular Arrays

```pascal
var
  JsonString := '''
  {
    "employees": [
      {"id": 1, "name": "Alice Johnson", "role": "admin"},
      {"id": 2, "name": "Bob Smith", "role": "user"},
      {"id": 3, "name": "Charlie Brown", "role": "user"}
    ]
  }
  ''';

  ToonOutput := TToon.JsonToToon(JsonString);

// Result:
// employees[3]{id,name,role}:
//   1,Alice Johnson,admin
//   2,Bob Smith,user
//   3,Charlie Brown,user
```

### Configuration Options

```pascal
var
  Options: TToonOptions := [
    TToonOption.Indent4Spaces,      // Use 4 spaces instead of 2
    TToonOption.DelimiterPipe,      // Use pipe delimiter instead of comma
    TToonOption.KeyFoldingAggressive, // Aggressive key folding
    TToonOption.PreferTabular       // Prefer tabular format for arrays
  ];

  ToonOutput := TToon.JsonToToon(JsonString, Options);
```

## Project Structure

```
Toon4D/
├── Source/
│   ├── Toon4D.pas              // Main API (TToon static class)
│   ├── Toon4D.Types.pas        // Types, enums, options, exceptions
│   ├── Toon4D.Consts.pas       // Constants and resourcestrings
│   └── Toon4D.Utils.pas        // Utility functions
├── Tests/
│   ├── Toon4D.Tests.dpr        // Test project
│   ├── Toon4D.Tests.Primitives.pas
│   ├── Toon4D.Tests.Arrays.pas
│   ├── Toon4D.Tests.ArrayEdgeCases.pas
│   ├── Toon4D.Tests.RootArrays.pas
│   ├── Toon4D.Tests.Nesting.pas
│   ├── Toon4D.Tests.KeyFolding.pas
│   ├── Toon4D.Tests.KeyEdgeCases.pas
│   ├── Toon4D.Tests.Delimiters.pas
│   ├── Toon4D.Tests.EdgeCases.pas
│   ├── Toon4D.Tests.ObjectEdgeCases.pas
│   ├── Toon4D.Tests.Whitespace.pas
│   ├── Toon4D.Tests.Integration.pas
│   ├── Toon4D.Tests.Conformance.pas
│   ├── Toon4D.Tests.OfficialFixtures.pas
│   └── Toon4D.Tests.Helpers.pas
├── SPEC.md                     // Detailed technical specification
└── README.md                   // This file
```

## Configuration Options

### TToonOption Enumeration

```pascal
type
  TToonOption = (
    // Indentation (mutually exclusive)
    Indent2Spaces,              // Default: 2 spaces per level
    Indent4Spaces,              // 4 spaces per level
    IndentCustom,               // Use CustomIndentSize

    // Delimiter selection (mutually exclusive)
    DelimiterComma,             // Default: comma separator
    DelimiterTab,               // Tab separator
    DelimiterPipe,              // Pipe separator

    // Key folding strategy (mutually exclusive)
    KeyFoldingNone,             // No key folding
    KeyFoldingSafe,             // Default: fold safe identifier chains
    KeyFoldingAggressive,       // Aggressive folding

    // Array format preferences
    PreferTabular,              // Default: prefer tabular for uniform arrays
    PreferList,                 // Prefer list format
    ForceInlineForPrimitives,   // Force inline for primitive arrays

    // Validation strictness
    StrictValidation,           // Strict TOON validation
    LenientValidation,          // Lenient validation

    // Quote minimization
    MinimalQuoting,             // Default: minimal quotes
    AlwaysQuoteStrings,         // Always quote string values

    // Number formatting
    NormalizeNumbers,           // Default: canonical form
    PreserveNumberFormat,       // Preserve JSON number format

    // Whitespace handling
    NoTrailingWhitespace,       // Remove trailing whitespace
    CompactOutput,              // Minimize whitespace

    // Error handling
    GracefulDegradation,        // Default: convert invalid to valid
    StrictConformance           // Raise exceptions on errors
  );

  TToonOptions = set of TToonOption;
```

## API Reference

### TToon Class

#### JsonToToon (TJSONValue overload)

```pascal
class function JsonToToon(
  JsonValue: TJSONValue;
  Options: TToonOptions = []
): string;
```

Encodes a TJSONValue to TOON format.

**Parameters:**
- `JsonValue`: The JSON value to encode (must not be nil)
- `Options`: Encoding options (defaults to safe defaults)

**Returns:** TOON formatted string

**Raises:**
- `EToonInvalidJsonException` - When JsonValue is nil or invalid
- `EToonEncodingException` - When encoding fails in strict mode

#### JsonToToon (String overload)

```pascal
class function JsonToToon(
  const JsonString: string;
  Options: TToonOptions = []
): string;
```

Encodes a JSON string to TOON format.

**Parameters:**
- `JsonString`: Valid JSON string
- `Options`: Encoding options

**Returns:** TOON formatted string

**Raises:**
- `EToonInvalidJsonException` - When JSON string is malformed
- `EToonEncodingException` - When encoding fails in strict mode

#### Validate

```pascal
class function Validate(
  const ToonString: string;
  out ErrorMessage: string
): Boolean;
```

Validates a TOON string against the specification.

**Parameters:**
- `ToonString`: TOON formatted string to validate
- `ErrorMessage`: Output parameter with error details

**Returns:** True if valid, False otherwise

#### GetLibraryVersion

```pascal
class function GetLibraryVersion: string;
```

Returns the library version string (e.g., "1.0.0").

## References

### Official TOON Resources

1. **TOON Specification v2.0**
   https://github.com/toon-format/spec

2. **TOON Format Repository**
   https://github.com/toon-format/toon

3. **Official Test Fixtures** (340+ tests)
   https://github.com/toon-format/spec/tree/main/tests/fixtures

### Delphi Resources

4. **System.JSON Documentation**
   https://docwiki.embarcadero.com/Libraries/en/System.JSON

5. **DUnitX Testing Framework**
   https://github.com/VSoftTechnologies/DUnitX

## License

MIT License - See LICENSE file for details

## Contributing

Contributions welcome! Please open an issue or pull request on GitHub.

## Commercial Support

This library is MIT licensed and free to use. For companies that depend on it commercially we offer support and maintenance agreements with guaranteed response times, and sponsored development of features you need. Contact us at [gdksoftware.com/contact-us](https://gdksoftware.com/contact-us) or open an issue to get in touch.
