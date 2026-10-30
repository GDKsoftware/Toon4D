{*******************************************************}
{                                                       }
{         Toon4D Library - LLM Data Optimization        }
{                                                       }
{                 DUnitX Test Suite                     }
{          Primitive Values Encoding Tests              }
{                                                       }
{*******************************************************}
unit Toon4D.Tests.Primitives;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils,
  System.JSON;

type
  [TestFixture]
  TPrimitivesTests = class
  public
    [Test]
    procedure NumberZero_ShouldEncodeAsZero;

    [Test]
    procedure NumberPositiveInteger_ShouldEncodeWithoutDecimals;

    [Test]
    procedure NumberNegativeInteger_ShouldEncodeWithoutDecimals;

    [Test]
    procedure NumberPositiveDecimal_ShouldEncodeCanonicalForm;

    [Test]
    procedure NumberNegativeDecimal_ShouldEncodeCanonicalForm;

    [Test]
    procedure NumberZeroPointZero_ShouldEncodeAsZero;

    [Test]
    procedure NumberNegativeZero_ShouldNormalizeToZero;

    [Test]
    procedure NumberWithTrailingZeros_ShouldRemoveTrailingZeros;

    [Test]
    procedure NumberWithLeadingZeros_ShouldRemoveLeadingZeros;

    [Test]
    procedure NumberScientificNotation_ShouldExpandToDecimal;

    [Test]
    procedure NumberVeryLarge_ShouldEncodeInDecimalForm;

    [Test]
    procedure NumberVerySmall_ShouldEncodeInDecimalForm;

    [Test]
    procedure StringEmpty_ShouldBeQuoted;

    [Test]
    procedure StringSimple_ShouldBeUnquoted;

    [Test]
    procedure StringWithSpaces_ShouldBeUnquoted;

    [Test]
    procedure StringLeadingWhitespace_ShouldBeQuoted;

    [Test]
    procedure StringTrailingWhitespace_ShouldBeQuoted;

    [Test]
    procedure StringLooksLikeTrue_ShouldBeQuoted;

    [Test]
    procedure StringLooksLikeFalse_ShouldBeQuoted;

    [Test]
    procedure StringLooksLikeNull_ShouldBeQuoted;

    [Test]
    procedure StringLooksLikeNumber_ShouldBeQuoted;

    [Test]
    procedure StringWithColon_ShouldBeQuoted;

    [Test]
    procedure StringWithQuote_ShouldBeQuotedAndEscaped;

    [Test]
    procedure StringWithBackslash_ShouldBeQuotedAndEscaped;

    [Test]
    procedure StringWithNewline_ShouldBeQuotedAndEscaped;

    [Test]
    procedure StringWithCarriageReturn_ShouldBeQuotedAndEscaped;

    [Test]
    procedure StringWithTab_ShouldBeQuotedAndEscaped;

    [Test]
    procedure StringWithAllEscapes_ShouldEscapeAll;

    [Test]
    procedure StringWithBrackets_ShouldBeQuoted;

    [Test]
    procedure StringWithBraces_ShouldBeQuoted;

    [Test]
    procedure StringWithLeadingHyphen_ShouldBeQuoted;

    [Test]
    procedure StringUnicode_ShouldPreserveUnicode;

    [Test]
    procedure StringEmoji_ShouldPreserveEmoji;

    [Test]
    procedure BooleanTrue_ShouldEncodeLowercase;

    [Test]
    procedure BooleanFalse_ShouldEncodeLowercase;

    [Test]
    procedure Null_ShouldEncodeLowercase;

    [Test]
    procedure ObjectWithPrimitives_ShouldEncodeKeyValuePairs;

    [Test]
    procedure ObjectWithStringKey_ShouldEncodeUnquotedKey;

    [Test]
    procedure ObjectWithKeyNeedingQuotes_ShouldQuoteKey;

    [Test]
    procedure ObjectWithDottedKey_ShouldNotQuoteKey;

    [Test]
    procedure ObjectWithUnderscoreKey_ShouldNotQuoteKey;

    [Test]
    procedure ObjectWithNumberStartKey_ShouldQuoteKey;

    [Test]
    procedure ObjectEmpty_ShouldProduceEmptyOutput;

    [Test]
    procedure ObjectSinglePrimitive_ShouldEncodeSingleLine;

    [Test]
    procedure ObjectMultiplePrimitives_ShouldEncodeMultipleLines;

    [Test]
    procedure ObjectKeyOrder_ShouldPreserveOrder;

    [Test]
    procedure StringOnlySpaces_ShouldQuote;

    [Test]
    procedure StringResemblingArrayHeader_ShouldQuote;

    [Test]
    procedure StringWithEmbeddedNewline_ShouldQuoteAndEscape;

    [Test]
    procedure StringWithEmbeddedQuote_ShouldEscape;
  end;

implementation

uses
  Toon4D,
  Toon4D.Consts,
  Toon4D.Tests.Helpers;

procedure TPrimitivesTests.NumberZero_ShouldEncodeAsZero;
var
  JsonValue: TJSONValue;
  ToonOutput: string;
  Expected: string;
begin
  JsonValue := TJSONNumber.Create(0);
  try
    Expected := '0';
    ToonOutput := TToon.JsonToToon(JsonValue);
    Assert.AreEqual(Expected, ToonOutput);
  finally
    JsonValue.Free;
  end;
end;

procedure TPrimitivesTests.NumberPositiveInteger_ShouldEncodeWithoutDecimals;
var
  JsonValue: TJSONValue;
  ToonOutput: string;
  Expected: string;
begin
  JsonValue := TJSONNumber.Create(42);
  try
    Expected := '42';
    ToonOutput := TToon.JsonToToon(JsonValue);
    Assert.AreEqual(Expected, ToonOutput);
  finally
    JsonValue.Free;
  end;
end;

procedure TPrimitivesTests.NumberNegativeInteger_ShouldEncodeWithoutDecimals;
var
  JsonValue: TJSONValue;
  ToonOutput: string;
  Expected: string;
begin
  JsonValue := TJSONNumber.Create(-42);
  try
    Expected := '-42';
    ToonOutput := TToon.JsonToToon(JsonValue);
    Assert.AreEqual(Expected, ToonOutput);
  finally
    JsonValue.Free;
  end;
end;

procedure TPrimitivesTests.NumberPositiveDecimal_ShouldEncodeCanonicalForm;
var
  JsonValue: TJSONValue;
  ToonOutput: string;
  Expected: string;
begin
  JsonValue := TJSONNumber.Create(3.14159);
  try
    Expected := '3.14159';
    ToonOutput := TToon.JsonToToon(JsonValue);
    Assert.AreEqual(Expected, ToonOutput);
  finally
    JsonValue.Free;
  end;
end;

procedure TPrimitivesTests.NumberNegativeDecimal_ShouldEncodeCanonicalForm;
var
  JsonValue: TJSONValue;
  ToonOutput: string;
  Expected: string;
begin
  JsonValue := TJSONNumber.Create(-2.71828);
  try
    Expected := '-2.71828';
    ToonOutput := TToon.JsonToToon(JsonValue);
    Assert.AreEqual(Expected, ToonOutput);
  finally
    JsonValue.Free;
  end;
end;

procedure TPrimitivesTests.NumberZeroPointZero_ShouldEncodeAsZero;
var
  JsonString: string;
  ToonOutput: string;
  Expected: string;
begin
  JsonString := '0.0';
  Expected := '0';
  ToonOutput := TToon.JsonToToon(JsonString);
  Assert.AreEqual(Expected, ToonOutput);
end;

procedure TPrimitivesTests.NumberNegativeZero_ShouldNormalizeToZero;
var
  JsonValue: TJSONValue;
  ToonOutput: string;
  Expected: string;
begin
  JsonValue := TJSONNumber.Create(-0.0);
  try
    Expected := '0';
    ToonOutput := TToon.JsonToToon(JsonValue);
    Assert.AreEqual(Expected, ToonOutput);
  finally
    JsonValue.Free;
  end;
end;

procedure TPrimitivesTests.NumberWithTrailingZeros_ShouldRemoveTrailingZeros;
var
  JsonString: string;
  ToonOutput: string;
  Expected: string;
begin
  JsonString := '5.00000';
  Expected := '5';
  ToonOutput := TToon.JsonToToon(JsonString);
  Assert.AreEqual(Expected, ToonOutput);
end;

procedure TPrimitivesTests.NumberWithLeadingZeros_ShouldRemoveLeadingZeros;
var
  JsonString: string;
  ToonOutput: string;
  Expected: string;
begin
  JsonString := '{"value":"007"}';
  Expected := 'value: "007"';
  ToonOutput := TToon.JsonToToon(JsonString);
  Assert.AreEqual(Expected, ToonOutput);
end;

procedure TPrimitivesTests.NumberScientificNotation_ShouldExpandToDecimal;
var
  JsonString: string;
  ToonOutput: string;
  Expected: string;
begin
  JsonString := '1e6';
  Expected := '1000000';
  ToonOutput := TToon.JsonToToon(JsonString);
  Assert.AreEqual(Expected, ToonOutput);
end;

procedure TPrimitivesTests.NumberVeryLarge_ShouldEncodeInDecimalForm;
var
  JsonString: string;
  ToonOutput: string;
  Expected: string;
begin
  JsonString := '1.23e10';
  Expected := '12300000000';
  ToonOutput := TToon.JsonToToon(JsonString);
  Assert.AreEqual(Expected, ToonOutput);
end;

procedure TPrimitivesTests.NumberVerySmall_ShouldEncodeInDecimalForm;
var
  JsonString: string;
  ToonOutput: string;
  Expected: string;
begin
  JsonString := '1.5e-3';
  Expected := '0.0015';
  ToonOutput := TToon.JsonToToon(JsonString);
  Assert.AreEqual(Expected, ToonOutput);
end;

procedure TPrimitivesTests.StringEmpty_ShouldBeQuoted;
var
  JsonValue: TJSONValue;
  ToonOutput: string;
  Expected: string;
begin
  JsonValue := TJSONString.Create('');
  try
    Expected := '""';
    ToonOutput := TToon.JsonToToon(JsonValue);
    Assert.AreEqual(Expected, ToonOutput);
  finally
    JsonValue.Free;
  end;
end;

procedure TPrimitivesTests.StringSimple_ShouldBeUnquoted;
var
  JsonValue: TJSONValue;
  ToonOutput: string;
  Expected: string;
begin
  JsonValue := TJSONString.Create('hello');
  try
    Expected := 'hello';
    ToonOutput := TToon.JsonToToon(JsonValue);
    Assert.AreEqual(Expected, ToonOutput);
  finally
    JsonValue.Free;
  end;
end;

procedure TPrimitivesTests.StringWithSpaces_ShouldBeUnquoted;
var
  JsonValue: TJSONValue;
  ToonOutput: string;
  Expected: string;
begin
  JsonValue := TJSONString.Create('hello world');
  try
    Expected := 'hello world';
    ToonOutput := TToon.JsonToToon(JsonValue);
    Assert.AreEqual(Expected, ToonOutput);
  finally
    JsonValue.Free;
  end;
end;

procedure TPrimitivesTests.StringLeadingWhitespace_ShouldBeQuoted;
var
  JsonValue: TJSONValue;
  ToonOutput: string;
  Expected: string;
begin
  JsonValue := TJSONString.Create(' leading');
  try
    Expected := '" leading"';
    ToonOutput := TToon.JsonToToon(JsonValue);
    Assert.AreEqual(Expected, ToonOutput);
  finally
    JsonValue.Free;
  end;
end;

procedure TPrimitivesTests.StringTrailingWhitespace_ShouldBeQuoted;
var
  JsonValue: TJSONValue;
  ToonOutput: string;
  Expected: string;
begin
  JsonValue := TJSONString.Create('trailing ');
  try
    Expected := '"trailing "';
    ToonOutput := TToon.JsonToToon(JsonValue);
    Assert.AreEqual(Expected, ToonOutput);
  finally
    JsonValue.Free;
  end;
end;

procedure TPrimitivesTests.StringLooksLikeTrue_ShouldBeQuoted;
var
  JsonValue: TJSONValue;
  ToonOutput: string;
  Expected: string;
begin
  JsonValue := TJSONString.Create('true');
  try
    Expected := '"true"';
    ToonOutput := TToon.JsonToToon(JsonValue);
    Assert.AreEqual(Expected, ToonOutput);
  finally
    JsonValue.Free;
  end;
end;

procedure TPrimitivesTests.StringLooksLikeFalse_ShouldBeQuoted;
var
  JsonValue: TJSONValue;
  ToonOutput: string;
  Expected: string;
begin
  JsonValue := TJSONString.Create('false');
  try
    Expected := '"false"';
    ToonOutput := TToon.JsonToToon(JsonValue);
    Assert.AreEqual(Expected, ToonOutput);
  finally
    JsonValue.Free;
  end;
end;

procedure TPrimitivesTests.StringLooksLikeNull_ShouldBeQuoted;
var
  JsonValue: TJSONValue;
  ToonOutput: string;
  Expected: string;
begin
  JsonValue := TJSONString.Create('null');
  try
    Expected := '"null"';
    ToonOutput := TToon.JsonToToon(JsonValue);
    Assert.AreEqual(Expected, ToonOutput);
  finally
    JsonValue.Free;
  end;
end;

procedure TPrimitivesTests.StringLooksLikeNumber_ShouldBeQuoted;
var
  JsonValue: TJSONValue;
  ToonOutput: string;
  Expected: string;
begin
  JsonValue := TJSONString.Create('42');
  try
    Expected := '"42"';
    ToonOutput := TToon.JsonToToon(JsonValue);
    Assert.AreEqual(Expected, ToonOutput);
  finally
    JsonValue.Free;
  end;
end;

procedure TPrimitivesTests.StringWithColon_ShouldBeQuoted;
var
  JsonValue: TJSONValue;
  ToonOutput: string;
  Expected: string;
begin
  JsonValue := TJSONString.Create('key:value');
  try
    Expected := '"key:value"';
    ToonOutput := TToon.JsonToToon(JsonValue);
    Assert.AreEqual(Expected, ToonOutput);
  finally
    JsonValue.Free;
  end;
end;

procedure TPrimitivesTests.StringWithQuote_ShouldBeQuotedAndEscaped;
var
  JsonValue: TJSONValue;
  ToonOutput: string;
  Expected: string;
begin
  JsonValue := TJSONString.Create('say "hello"');
  try
    Expected := '"say \"hello\""';
    ToonOutput := TToon.JsonToToon(JsonValue);
    Assert.AreEqual(Expected, ToonOutput);
  finally
    JsonValue.Free;
  end;
end;

procedure TPrimitivesTests.StringWithBackslash_ShouldBeQuotedAndEscaped;
var
  JsonValue: TJSONValue;
  ToonOutput: string;
  Expected: string;
begin
  JsonValue := TJSONString.Create('path\to\file');
  try
    Expected := '"path\\to\\file"';
    ToonOutput := TToon.JsonToToon(JsonValue);
    Assert.AreEqual(Expected, ToonOutput);
  finally
    JsonValue.Free;
  end;
end;

procedure TPrimitivesTests.StringWithNewline_ShouldBeQuotedAndEscaped;
var
  JsonValue: TJSONValue;
  ToonOutput: string;
  Expected: string;
begin
  JsonValue := TJSONString.Create('line1' + #10 + 'line2');
  try
    Expected := '"line1\nline2"';
    ToonOutput := TToon.JsonToToon(JsonValue);
    Assert.AreEqual(Expected, ToonOutput);
  finally
    JsonValue.Free;
  end;
end;

procedure TPrimitivesTests.StringWithCarriageReturn_ShouldBeQuotedAndEscaped;
var
  JsonValue: TJSONValue;
  ToonOutput: string;
  Expected: string;
begin
  JsonValue := TJSONString.Create('line1' + #13 + 'line2');
  try
    Expected := '"line1\rline2"';
    ToonOutput := TToon.JsonToToon(JsonValue);
    Assert.AreEqual(Expected, ToonOutput);
  finally
    JsonValue.Free;
  end;
end;

procedure TPrimitivesTests.StringWithTab_ShouldBeQuotedAndEscaped;
var
  JsonValue: TJSONValue;
  ToonOutput: string;
  Expected: string;
begin
  JsonValue := TJSONString.Create('col1' + #9 + 'col2');
  try
    Expected := '"col1\tcol2"';
    ToonOutput := TToon.JsonToToon(JsonValue);
    Assert.AreEqual(Expected, ToonOutput);
  finally
    JsonValue.Free;
  end;
end;

procedure TPrimitivesTests.StringWithAllEscapes_ShouldEscapeAll;
var
  JsonValue: TJSONValue;
  ToonOutput: string;
  Expected: string;
begin
  JsonValue := TJSONString.Create('\' + #9 + '"' + #10 + #13);
  try
    Expected := '"\\\t\"\n\r"';
    ToonOutput := TToon.JsonToToon(JsonValue);
    Assert.AreEqual(Expected, ToonOutput);
  finally
    JsonValue.Free;
  end;
end;

procedure TPrimitivesTests.StringWithBrackets_ShouldBeQuoted;
var
  JsonValue: TJSONValue;
  ToonOutput: string;
  Expected: string;
begin
  JsonValue := TJSONString.Create('[value]');
  try
    Expected := '"[value]"';
    ToonOutput := TToon.JsonToToon(JsonValue);
    Assert.AreEqual(Expected, ToonOutput);
  finally
    JsonValue.Free;
  end;
end;

procedure TPrimitivesTests.StringWithBraces_ShouldBeQuoted;
var
  JsonValue: TJSONValue;
  ToonOutput: string;
  Expected: string;
begin
  JsonValue := TJSONString.Create('{value}');
  try
    Expected := '"{value}"';
    ToonOutput := TToon.JsonToToon(JsonValue);
    Assert.AreEqual(Expected, ToonOutput);
  finally
    JsonValue.Free;
  end;
end;

procedure TPrimitivesTests.StringWithLeadingHyphen_ShouldBeQuoted;
var
  JsonValue: TJSONValue;
  ToonOutput: string;
  Expected: string;
begin
  JsonValue := TJSONString.Create('- item');
  try
    Expected := '"- item"';
    ToonOutput := TToon.JsonToToon(JsonValue);
    Assert.AreEqual(Expected, ToonOutput);
  finally
    JsonValue.Free;
  end;
end;

procedure TPrimitivesTests.StringUnicode_ShouldPreserveUnicode;
var
  JsonValue: TJSONValue;
  ToonOutput: string;
  Expected: string;
begin
  JsonValue := TJSONString.Create('Hello 世界');
  try
    Expected := 'Hello 世界';
    ToonOutput := TToon.JsonToToon(JsonValue);
    Assert.AreEqual(Expected, ToonOutput);
  finally
    JsonValue.Free;
  end;
end;

procedure TPrimitivesTests.StringEmoji_ShouldPreserveEmoji;
var
  JsonValue: TJSONValue;
  ToonOutput: string;
  Expected: string;
begin
  JsonValue := TJSONString.Create('Hello 👋 World 🌍');
  try
    Expected := 'Hello 👋 World 🌍';
    ToonOutput := TToon.JsonToToon(JsonValue);
    Assert.AreEqual(Expected, ToonOutput);
  finally
    JsonValue.Free;
  end;
end;

procedure TPrimitivesTests.BooleanTrue_ShouldEncodeLowercase;
var
  JsonValue: TJSONValue;
  ToonOutput: string;
  Expected: string;
begin
  JsonValue := TJSONTrue.Create;
  try
    Expected := 'true';
    ToonOutput := TToon.JsonToToon(JsonValue);
    Assert.AreEqual(Expected, ToonOutput);
  finally
    JsonValue.Free;
  end;
end;

procedure TPrimitivesTests.BooleanFalse_ShouldEncodeLowercase;
var
  JsonValue: TJSONValue;
  ToonOutput: string;
  Expected: string;
begin
  JsonValue := TJSONFalse.Create;
  try
    Expected := 'false';
    ToonOutput := TToon.JsonToToon(JsonValue);
    Assert.AreEqual(Expected, ToonOutput);
  finally
    JsonValue.Free;
  end;
end;

procedure TPrimitivesTests.Null_ShouldEncodeLowercase;
var
  JsonValue: TJSONValue;
  ToonOutput: string;
  Expected: string;
begin
  JsonValue := TJSONNull.Create;
  try
    Expected := 'null';
    ToonOutput := TToon.JsonToToon(JsonValue);
    Assert.AreEqual(Expected, ToonOutput);
  finally
    JsonValue.Free;
  end;
end;

procedure TPrimitivesTests.ObjectWithPrimitives_ShouldEncodeKeyValuePairs;
var
  JsonObject: TJSONObject;
  ToonOutput: string;
  Expected: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonObject.AddPair('name', 'Alice');
    JsonObject.AddPair('age', TJSONNumber.Create(30));
    JsonObject.AddPair('active', TJSONTrue.Create);

    Expected := '''
name: Alice
age: 30
active: true
'''.Trim;

    ToonOutput := TToon.JsonToToon(JsonObject);
    Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), ToonOutput);
  finally
    JsonObject.Free;
  end;
end;

procedure TPrimitivesTests.ObjectWithStringKey_ShouldEncodeUnquotedKey;
var
  JsonObject: TJSONObject;
  ToonOutput: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonObject.AddPair('validKey', 'value');
    ToonOutput := TToon.JsonToToon(JsonObject);
    Assert.Contains(ToonOutput, 'validKey:');
    Assert.IsFalse(ToonOutput.Contains('"validKey"'));
  finally
    JsonObject.Free;
  end;
end;

procedure TPrimitivesTests.ObjectWithKeyNeedingQuotes_ShouldQuoteKey;
var
  JsonObject: TJSONObject;
  ToonOutput: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonObject.AddPair('key with spaces', 'value');
    ToonOutput := TToon.JsonToToon(JsonObject);
    Assert.Contains(ToonOutput, '"key with spaces":');
  finally
    JsonObject.Free;
  end;
end;

procedure TPrimitivesTests.ObjectWithDottedKey_ShouldNotQuoteKey;
var
  JsonObject: TJSONObject;
  ToonOutput: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonObject.AddPair('user.name', 'Alice');
    ToonOutput := TToon.JsonToToon(JsonObject);
    Assert.Contains(ToonOutput, 'user.name:');
    Assert.IsFalse(ToonOutput.Contains('"user.name"'));
  finally
    JsonObject.Free;
  end;
end;

procedure TPrimitivesTests.ObjectWithUnderscoreKey_ShouldNotQuoteKey;
var
  JsonObject: TJSONObject;
  ToonOutput: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonObject.AddPair('user_name', 'Alice');
    ToonOutput := TToon.JsonToToon(JsonObject);
    Assert.Contains(ToonOutput, 'user_name:');
    Assert.IsFalse(ToonOutput.Contains('"user_name"'));
  finally
    JsonObject.Free;
  end;
end;

procedure TPrimitivesTests.ObjectWithNumberStartKey_ShouldQuoteKey;
var
  JsonObject: TJSONObject;
  ToonOutput: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonObject.AddPair('123key', 'value');
    ToonOutput := TToon.JsonToToon(JsonObject);
    Assert.Contains(ToonOutput, '"123key":');
  finally
    JsonObject.Free;
  end;
end;

procedure TPrimitivesTests.ObjectEmpty_ShouldProduceEmptyOutput;
var
  JsonObject: TJSONObject;
  ToonOutput: string;
  Expected: string;
begin
  JsonObject := TJSONObject.Create;
  try
    Expected := '';
    ToonOutput := TToon.JsonToToon(JsonObject);
    Assert.AreEqual(Expected, ToonOutput);
  finally
    JsonObject.Free;
  end;
end;

procedure TPrimitivesTests.ObjectSinglePrimitive_ShouldEncodeSingleLine;
var
  JsonObject: TJSONObject;
  ToonOutput: string;
  Expected: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonObject.AddPair('key', 'value');
    Expected := 'key: value';
    ToonOutput := TToon.JsonToToon(JsonObject);
    Assert.AreEqual(Expected, ToonOutput);
  finally
    JsonObject.Free;
  end;
end;

procedure TPrimitivesTests.ObjectMultiplePrimitives_ShouldEncodeMultipleLines;
var
  JsonObject: TJSONObject;
  ToonOutput: string;
  Lines: TArray<string>;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonObject.AddPair('first', 'value1');
    JsonObject.AddPair('second', 'value2');
    JsonObject.AddPair('third', 'value3');

    ToonOutput := TToon.JsonToToon(JsonObject);
    Lines := ToonOutput.Split([ToonLineBreak]);

    Assert.AreEqual<NativeInt>(3, Length(Lines));
    Assert.AreEqual('first: value1', Lines[0]);
    Assert.AreEqual('second: value2', Lines[1]);
    Assert.AreEqual('third: value3', Lines[2]);
  finally
    JsonObject.Free;
  end;
end;

procedure TPrimitivesTests.ObjectKeyOrder_ShouldPreserveOrder;
var
  JsonObject: TJSONObject;
  ToonOutput: string;
  Lines: TArray<string>;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonObject.AddPair('zebra', '1');
    JsonObject.AddPair('alpha', '2');
    JsonObject.AddPair('beta', '3');

    ToonOutput := TToon.JsonToToon(JsonObject);
    Lines := ToonOutput.Split([ToonLineBreak]);

    Assert.AreEqual<NativeInt>(3, Length(Lines));
    Assert.IsTrue(Lines[0].StartsWith('zebra:'));
    Assert.IsTrue(Lines[1].StartsWith('alpha:'));
    Assert.IsTrue(Lines[2].StartsWith('beta:'));
  finally
    JsonObject.Free;
  end;
end;

procedure TPrimitivesTests.StringOnlySpaces_ShouldQuote;
var
  JsonObject: TJSONObject;
  Result: string;
  Expected: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonObject.AddPair('key', '   ');

    Result := TToon.JsonToToon(JsonObject);

    Expected := 'key: "   "';
    Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), Result, 'String with only spaces must be quoted');
  finally
    JsonObject.Free;
  end;
end;

procedure TPrimitivesTests.StringResemblingArrayHeader_ShouldQuote;
var
  JsonObject: TJSONObject;
  Result: string;
  Expected: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonObject.AddPair('key', '[2]');

    Result := TToon.JsonToToon(JsonObject);

    Expected := 'key: "[2]"';
    Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), Result, 'String resembling array header must be quoted');
  finally
    JsonObject.Free;
  end;
end;

procedure TPrimitivesTests.StringWithEmbeddedNewline_ShouldQuoteAndEscape;
var
  JsonObject: TJSONObject;
  Result: string;
  Expected: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonObject.AddPair('key', 'line1'#10'line2');

    Result := TToon.JsonToToon(JsonObject);

    Expected := 'key: "line1\nline2"';
    Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), Result, 'String with embedded newline must be quoted and escaped');
  finally
    JsonObject.Free;
  end;
end;

procedure TPrimitivesTests.StringWithEmbeddedQuote_ShouldEscape;
var
  JsonObject: TJSONObject;
  Result: string;
  Expected: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonObject.AddPair('key', 'say "hello"');

    Result := TToon.JsonToToon(JsonObject);

    Expected := 'key: "say \"hello\""';
    Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), Result, 'String with embedded quote must be escaped');
  finally
    JsonObject.Free;
  end;
end;

end.
