{*******************************************************}
{                                                       }
{         Toon4D Library - LLM Data Optimization        }
{                                                       }
{                 DUnitX Test Suite                     }
{         Official TOON Spec Conformance Tests          }
{                                                       }
{*******************************************************}
unit Toon4D.Tests.Conformance;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils,
  System.JSON;

type
  [TestFixture]
  TConformanceTests = class
  public
    [Test]
    procedure PrimitiveString_ShouldMatchExpected;

    [Test]
    procedure PrimitiveNumber_ShouldMatchExpected;

    [Test]
    procedure PrimitiveBoolean_ShouldMatchExpected;

    [Test]
    procedure PrimitiveNull_ShouldMatchExpected;

    [Test]
    procedure SimpleObject_ShouldMatchExpected;

    [Test]
    procedure NestedObject_ShouldMatchExpected;

    [Test]
    procedure ArrayPrimitive_ShouldMatchExpected;

    [Test]
    procedure ArrayTabular_ShouldMatchExpected;

    [Test]
    procedure ArrayList_ShouldMatchExpected;

    [Test]
    procedure ArrayEmpty_ShouldMatchExpected;

    [Test]
    procedure ArrayMixedPrimitives_ShouldMatchExpected;

    [Test]
    procedure ArrayNested_ShouldMatchExpected;

    [Test]
    procedure DelimiterComma_ShouldMatchExpected;

    [Test]
    procedure DelimiterTab_ShouldMatchExpected;

    [Test]
    procedure DelimiterPipe_ShouldMatchExpected;

    [Test]
    procedure QuotingEmpty_ShouldMatchExpected;

    [Test]
    procedure QuotingWhitespace_ShouldMatchExpected;

    [Test]
    procedure QuotingReserved_ShouldMatchExpected;

    [Test]
    procedure QuotingNumeric_ShouldMatchExpected;

    [Test]
    procedure QuotingSpecialChars_ShouldMatchExpected;

    [Test]
    procedure EscapeSequences_ShouldMatchExpected;

    [Test]
    procedure NumberNormalization_ShouldMatchExpected;

    [Test]
    procedure NumberNegativeZero_ShouldMatchExpected;

    [Test]
    procedure NumberTrailingZeros_ShouldMatchExpected;

    [Test]
    procedure NumberScientificNotation_ShouldMatchExpected;

    [Test]
    procedure IndentationTwoSpaces_ShouldMatchExpected;

    [Test]
    procedure IndentationFourSpaces_ShouldMatchExpected;

    [Test]
    procedure WhitespaceNoTrailing_ShouldMatchExpected;

    [Test]
    procedure KeyEncodingUnquoted_ShouldMatchExpected;

    [Test]
    procedure KeyEncodingQuoted_ShouldMatchExpected;

    [Test]
    procedure KeyEncodingDotted_ShouldMatchExpected;

    [Test]
    procedure KeyEncodingUnderscore_ShouldMatchExpected;

    [Test]
    procedure TabularUniformObjects_ShouldMatchExpected;

    [Test]
    procedure TabularFieldOrder_ShouldMatchExpected;

    [Test]
    procedure TabularWithNull_ShouldMatchExpected;

    [Test]
    procedure TabularWithBooleans_ShouldMatchExpected;

    [Test]
    procedure TabularWithNumbers_ShouldMatchExpected;

    [Test]
    procedure ListMixedTypes_ShouldMatchExpected;

    [Test]
    procedure ListNestedObjects_ShouldMatchExpected;

    [Test]
    procedure ListNestedArrays_ShouldMatchExpected;

    [Test]
    procedure RootPrimitive_ShouldMatchExpected;

    [Test]
    procedure RootArray_ShouldMatchExpected;

    [Test]
    procedure RootObject_ShouldMatchExpected;

    [Test]
    procedure ComplexNested_ShouldMatchExpected;

    [Test]
    procedure UnicodeCharacters_ShouldMatchExpected;

    [Test]
    procedure EmptyStringValue_ShouldMatchExpected;

    [Test]
    procedure EmptyObject_ShouldMatchExpected;

    [Test]
    procedure SingleKeyObject_ShouldMatchExpected;
  end;

implementation

uses
  Toon4D,
  Toon4D.Types,
  Toon4D.Tests.Helpers;

procedure TConformanceTests.PrimitiveString_ShouldMatchExpected;
var
  JsonInput: string;
  Expected: string;
  Actual: string;
begin
  JsonInput := '"hello"';
  Expected := 'hello';
  Actual := TToon.JsonToToon(JsonInput);
  Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), Actual);
end;

procedure TConformanceTests.PrimitiveNumber_ShouldMatchExpected;
var
  JsonInput: string;
  Expected: string;
  Actual: string;
begin
  JsonInput := '42';
  Expected := '42';
  Actual := TToon.JsonToToon(JsonInput);
  Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), Actual);
end;

procedure TConformanceTests.PrimitiveBoolean_ShouldMatchExpected;
var
  JsonInput: string;
  Expected: string;
  Actual: string;
begin
  JsonInput := 'true';
  Expected := 'true';
  Actual := TToon.JsonToToon(JsonInput);
  Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), Actual);
end;

procedure TConformanceTests.PrimitiveNull_ShouldMatchExpected;
var
  JsonInput: string;
  Expected: string;
  Actual: string;
begin
  JsonInput := 'null';
  Expected := 'null';
  Actual := TToon.JsonToToon(JsonInput);
  Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), Actual);
end;

procedure TConformanceTests.SimpleObject_ShouldMatchExpected;
var
  JsonInput: string;
  Expected: string;
  Actual: string;
begin
  JsonInput := '{"name":"Alice","age":30}';
  Expected := '''
name: Alice
age: 30
'''.Trim;
  Actual := TToon.JsonToToon(JsonInput);
  Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), Actual);
end;

procedure TConformanceTests.NestedObject_ShouldMatchExpected;
var
  JsonInput: string;
  Expected: string;
  Actual: string;
begin
  JsonInput := '{"user":{"name":"Alice","age":30}}';
  Expected := '''
user:
  name: Alice
  age: 30
'''.Trim;
  Actual := TToon.JsonToToon(JsonInput);
  Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), Actual);
end;

procedure TConformanceTests.ArrayPrimitive_ShouldMatchExpected;
var
  JsonInput: string;
  Expected: string;
  Actual: string;
begin
  JsonInput := '{"tags":["admin","ops","dev"]}';
  Expected := 'tags[3]: admin,ops,dev';
  Actual := TToon.JsonToToon(JsonInput);
  Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), Actual);
end;

procedure TConformanceTests.ArrayTabular_ShouldMatchExpected;
var
  JsonInput: string;
  Expected: string;
  Actual: string;
begin
  JsonInput := '{"users":[{"id":1,"name":"Alice"},{"id":2,"name":"Bob"}]}';
  Expected := '''
users[2]{id,name}:
  1,Alice
  2,Bob
'''.Trim;
  Actual := TToon.JsonToToon(JsonInput);
  Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), Actual);
end;

procedure TConformanceTests.ArrayList_ShouldMatchExpected;
var
  JsonInput: string;
  Expected: string;
  Actual: string;
begin
  JsonInput := '{"items":[1,{"key":"value"},"text"]}';
  Expected := '''
items[3]:
  - 1
  - key: value
  - text
'''.Trim;
  Actual := TToon.JsonToToon(JsonInput);
  Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), Actual);
end;

procedure TConformanceTests.ArrayEmpty_ShouldMatchExpected;
var
  JsonInput: string;
  Expected: string;
  Actual: string;
begin
  JsonInput := '{"items":[]}';
  Expected := 'items: []';
  Actual := TToon.JsonToToon(JsonInput);
  Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), Actual);
end;

procedure TConformanceTests.ArrayMixedPrimitives_ShouldMatchExpected;
var
  JsonInput: string;
  Expected: string;
  Actual: string;
begin
  JsonInput := '{"items":[1,"text",true,null]}';
  Expected := 'items[4]: 1,text,true,null';
  Actual := TToon.JsonToToon(JsonInput);
  Assert.AreEqual(Expected, Actual);
end;

procedure TConformanceTests.ArrayNested_ShouldMatchExpected;
var
  JsonInput: string;
  Expected: string;
  Actual: string;
begin
  JsonInput := '{"matrix":[[1,2],[3,4]]}';
  Expected := '''
matrix[2]:
  - [2]: 1,2
  - [2]: 3,4
'''.Trim;
  Actual := TToon.JsonToToon(JsonInput);
  Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), Actual);
end;

procedure TConformanceTests.DelimiterComma_ShouldMatchExpected;
var
  JsonInput: string;
  Expected: string;
  Actual: string;
  Options: TToonOptions;
begin
  JsonInput := '{"items":["a","b","c"]}';
  Expected := 'items[3]: a,b,c';
  Options := TToonOptions.Default;
  Actual := TToon.JsonToToon(JsonInput, Options);
  Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), Actual);
end;

procedure TConformanceTests.DelimiterTab_ShouldMatchExpected;
var
  JsonInput: string;
  Actual: string;
  Options: TToonOptions;
begin
  JsonInput := '{"items":["a","b","c"]}';
  Options := TToonTestHelpers.Delimited(TToonDelimiter.Tab);
  Actual := TToon.JsonToToon(JsonInput, Options);
  Assert.Contains(Actual, 'items[3' + #9 + ']:');
  Assert.Contains(Actual, 'a' + #9 + 'b' + #9 + 'c');
end;

procedure TConformanceTests.DelimiterPipe_ShouldMatchExpected;
var
  JsonInput: string;
  Expected: string;
  Actual: string;
  Options: TToonOptions;
begin
  JsonInput := '{"items":["a","b","c"]}';
  Expected := 'items[3|]: a|b|c';
  Options := TToonTestHelpers.Delimited(TToonDelimiter.Pipe);
  Actual := TToon.JsonToToon(JsonInput, Options);
  Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), Actual);
end;

procedure TConformanceTests.QuotingEmpty_ShouldMatchExpected;
var
  JsonInput: string;
  Expected: string;
  Actual: string;
begin
  JsonInput := '{"text":""}';
  Expected := 'text: ""';
  Actual := TToon.JsonToToon(JsonInput);
  Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), Actual);
end;

procedure TConformanceTests.QuotingWhitespace_ShouldMatchExpected;
var
  JsonInput: string;
  Expected: string;
  Actual: string;
begin
  JsonInput := '{"text":" hello "}';
  Expected := 'text: " hello "';
  Actual := TToon.JsonToToon(JsonInput);
  Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), Actual);
end;

procedure TConformanceTests.QuotingReserved_ShouldMatchExpected;
var
  JsonInput: string;
  Expected: string;
  Actual: string;
begin
  JsonInput := '{"value":"true"}';
  Expected := 'value: "true"';
  Actual := TToon.JsonToToon(JsonInput);
  Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), Actual);
end;

procedure TConformanceTests.QuotingNumeric_ShouldMatchExpected;
var
  JsonInput: string;
  Expected: string;
  Actual: string;
begin
  JsonInput := '{"code":"123"}';
  Expected := 'code: "123"';
  Actual := TToon.JsonToToon(JsonInput);
  Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), Actual);
end;

procedure TConformanceTests.QuotingSpecialChars_ShouldMatchExpected;
var
  JsonInput: string;
  Expected: string;
  Actual: string;
begin
  JsonInput := '{"url":"http://example.com"}';
  Expected := 'url: "http://example.com"';
  Actual := TToon.JsonToToon(JsonInput);
  Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), Actual);
end;

procedure TConformanceTests.EscapeSequences_ShouldMatchExpected;
var
  JsonObject: TJSONObject;
  Expected: string;
  Actual: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonObject.AddPair('text', 'line1'#10'line2'#9'tab"quote\backslash');
    Expected := 'text: "line1\nline2\ttab\"quote\\backslash"';
    Actual := TToon.JsonToToon(JsonObject);
    Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), Actual);
  finally
    JsonObject.Free;
  end;
end;

procedure TConformanceTests.NumberNormalization_ShouldMatchExpected;
var
  JsonInput: string;
  Expected: string;
  Actual: string;
begin
  JsonInput := '{"value":5.0}';
  Expected := 'value: 5';
  Actual := TToon.JsonToToon(JsonInput);
  Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), Actual);
end;

procedure TConformanceTests.NumberNegativeZero_ShouldMatchExpected;
var
  JsonInput: string;
  Expected: string;
  Actual: string;
begin
  JsonInput := '{"value":-0.0}';
  Expected := 'value: 0';
  Actual := TToon.JsonToToon(JsonInput);
  Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), Actual);
end;

procedure TConformanceTests.NumberTrailingZeros_ShouldMatchExpected;
var
  JsonInput: string;
  Expected: string;
  Actual: string;
begin
  JsonInput := '{"value":3.14000}';
  Expected := 'value: 3.14';
  Actual := TToon.JsonToToon(JsonInput);
  Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), Actual);
end;

procedure TConformanceTests.NumberScientificNotation_ShouldMatchExpected;
var
  JsonInput: string;
  Expected: string;
  Actual: string;
begin
  JsonInput := '{"value":1.5e3}';
  Expected := 'value: 1500';
  Actual := TToon.JsonToToon(JsonInput);
  Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), Actual);
end;

procedure TConformanceTests.IndentationTwoSpaces_ShouldMatchExpected;
var
  JsonInput: string;
  Expected: string;
  Actual: string;
  Options: TToonOptions;
begin
  JsonInput := '{"outer":{"inner":"value"}}';
  Expected := '''
outer:
  inner: value
'''.Trim;
  Options := TToonTestHelpers.Indented(2);
  Actual := TToon.JsonToToon(JsonInput, Options);
  Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), Actual);
end;

procedure TConformanceTests.IndentationFourSpaces_ShouldMatchExpected;
var
  JsonInput: string;
  Expected: string;
  Actual: string;
  Options: TToonOptions;
begin
  JsonInput := '{"outer":{"inner":"value"}}';
  Expected := '''
outer:
    inner: value
'''.Trim;
  Options := TToonTestHelpers.Indented(4);
  Actual := TToon.JsonToToon(JsonInput, Options);
  Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), Actual);
end;

procedure TConformanceTests.WhitespaceNoTrailing_ShouldMatchExpected;
var
  JsonInput: string;
  Actual: string;
  Lines: TArray<string>;
  Line: string;
begin
  JsonInput := '{"name":"Alice","age":30}';
  Actual := TToon.JsonToToon(JsonInput);
  Lines := Actual.Split([#13#10, #10]);
  for Line in Lines do
  begin
    Assert.IsFalse(Line.EndsWith(' '), 'Line should not have trailing whitespace: ' + Line);
  end;
end;

procedure TConformanceTests.KeyEncodingUnquoted_ShouldMatchExpected;
var
  JsonInput: string;
  Expected: string;
  Actual: string;
begin
  JsonInput := '{"user_name":"Alice"}';
  Expected := 'user_name: Alice';
  Actual := TToon.JsonToToon(JsonInput);
  Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), Actual);
end;

procedure TConformanceTests.KeyEncodingQuoted_ShouldMatchExpected;
var
  JsonInput: string;
  Expected: string;
  Actual: string;
begin
  JsonInput := '{"user-name":"Alice"}';
  Expected := '"user-name": Alice';
  Actual := TToon.JsonToToon(JsonInput);
  Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), Actual);
end;

procedure TConformanceTests.KeyEncodingDotted_ShouldMatchExpected;
var
  JsonInput: string;
  Expected: string;
  Actual: string;
begin
  JsonInput := '{"user.name":"Alice"}';
  Expected := 'user.name: Alice';
  Actual := TToon.JsonToToon(JsonInput);
  Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), Actual);
end;

procedure TConformanceTests.KeyEncodingUnderscore_ShouldMatchExpected;
var
  JsonInput: string;
  Expected: string;
  Actual: string;
begin
  JsonInput := '{"_private":"value"}';
  Expected := '_private: value';
  Actual := TToon.JsonToToon(JsonInput);
  Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), Actual);
end;

procedure TConformanceTests.TabularUniformObjects_ShouldMatchExpected;
var
  JsonInput: string;
  Expected: string;
  Actual: string;
begin
  JsonInput := '{"data":[{"a":1,"b":2},{"a":3,"b":4}]}';
  Expected := '''
data[2]{a,b}:
  1,2
  3,4
'''.Trim;
  Actual := TToon.JsonToToon(JsonInput);
  Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), Actual);
end;

procedure TConformanceTests.TabularFieldOrder_ShouldMatchExpected;
var
  JsonInput: string;
  Actual: string;
begin
  JsonInput := '{"users":[{"name":"Alice","id":1},{"name":"Bob","id":2}]}';
  Actual := TToon.JsonToToon(JsonInput);
  Assert.Contains(Actual, 'users[2]{name,id}:');
  Assert.Contains(Actual, 'Alice,1');
  Assert.Contains(Actual, 'Bob,2');
end;

procedure TConformanceTests.TabularWithNull_ShouldMatchExpected;
var
  JsonInput: string;
  Expected: string;
  Actual: string;
begin
  JsonInput := '{"data":[{"a":1,"b":null},{"a":2,"b":3}]}';
  Expected := '''
data[2]{a,b}:
  1,null
  2,3
'''.Trim;
  Actual := TToon.JsonToToon(JsonInput);
  Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), Actual);
end;

procedure TConformanceTests.TabularWithBooleans_ShouldMatchExpected;
var
  JsonInput: string;
  Expected: string;
  Actual: string;
begin
  JsonInput := '{"data":[{"active":true,"count":1},{"active":false,"count":2}]}';
  Expected := '''
data[2]{active,count}:
  true,1
  false,2
'''.Trim;
  Actual := TToon.JsonToToon(JsonInput);
  Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), Actual);
end;

procedure TConformanceTests.TabularWithNumbers_ShouldMatchExpected;
var
  JsonInput: string;
  Expected: string;
  Actual: string;
begin
  JsonInput := '{"data":[{"x":1.5,"y":2.0},{"x":3.14,"y":4}]}';
  Expected := '''
data[2]{x,y}:
  1.5,2
  3.14,4
'''.Trim;
  Actual := TToon.JsonToToon(JsonInput);
  Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), Actual);
end;

procedure TConformanceTests.ListMixedTypes_ShouldMatchExpected;
var
  JsonInput: string;
  Actual: string;
begin
  JsonInput := '{"items":[1,{"name":"Alice"},true]}';
  Actual := TToon.JsonToToon(JsonInput);
  Assert.Contains(Actual, 'items[3]:');
  Assert.Contains(Actual, '- 1');
  Assert.Contains(Actual, '- name: Alice');
  Assert.Contains(Actual, '- true');
end;

procedure TConformanceTests.ListNestedObjects_ShouldMatchExpected;
var
  JsonInput: string;
  Actual: string;
begin
  JsonInput := '{"items":[{"a":1},{"a":2,"b":3}]}';
  Actual := TToon.JsonToToon(JsonInput);
  Assert.Contains(Actual, 'items[2]:');
  Assert.Contains(Actual, '- a: 1');
  Assert.Contains(Actual, '- a: 2');
  Assert.Contains(Actual, 'b: 3');
end;

procedure TConformanceTests.ListNestedArrays_ShouldMatchExpected;
var
  JsonInput: string;
  Actual: string;
begin
  JsonInput := '{"items":[[1,2],[3,4,5]]}';
  Actual := TToon.JsonToToon(JsonInput);
  Assert.Contains(Actual, 'items[2]:');
  Assert.Contains(Actual, '- [2]: 1,2');
  Assert.Contains(Actual, '- [3]: 3,4,5');
end;

procedure TConformanceTests.RootPrimitive_ShouldMatchExpected;
var
  JsonInput: string;
  Expected: string;
  Actual: string;
begin
  JsonInput := '42';
  Expected := '42';
  Actual := TToon.JsonToToon(JsonInput);
  Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), Actual);
end;

procedure TConformanceTests.RootArray_ShouldMatchExpected;
var
  JsonInput: string;
  Expected: string;
  Actual: string;
begin
  JsonInput := '[1,2,3]';
  Expected := '[3]: 1,2,3';
  Actual := TToon.JsonToToon(JsonInput);
  Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), Actual);
end;

procedure TConformanceTests.RootObject_ShouldMatchExpected;
var
  JsonInput: string;
  Expected: string;
  Actual: string;
begin
  JsonInput := '{"name":"Alice"}';
  Expected := 'name: Alice';
  Actual := TToon.JsonToToon(JsonInput);
  Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), Actual);
end;

procedure TConformanceTests.ComplexNested_ShouldMatchExpected;
var
  JsonInput: string;
  Actual: string;
begin
  JsonInput := '''
  {
    "data": {
      "users": [
        {"id": 1, "name": "Alice"},
        {"id": 2, "name": "Bob"}
      ],
      "metadata": {
        "total": 2
      }
    }
  }
  ''';
  Actual := TToon.JsonToToon(JsonInput);
  Assert.Contains(Actual, 'data:');
  Assert.Contains(Actual, 'users[2]{id,name}:');
  Assert.Contains(Actual, '1,Alice');
  Assert.Contains(Actual, 'metadata:');
  Assert.Contains(Actual, 'total: 2');
end;

procedure TConformanceTests.UnicodeCharacters_ShouldMatchExpected;
var
  JsonInput: string;
  Expected: string;
  Actual: string;
begin
  JsonInput := '{"text":"Hello 世界 🌍"}';
  Expected := 'text: Hello 世界 🌍';
  Actual := TToon.JsonToToon(JsonInput);
  Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), Actual);
end;

procedure TConformanceTests.EmptyStringValue_ShouldMatchExpected;
var
  JsonInput: string;
  Expected: string;
  Actual: string;
begin
  JsonInput := '{"value":""}';
  Expected := 'value: ""';
  Actual := TToon.JsonToToon(JsonInput);
  Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), Actual);
end;

procedure TConformanceTests.EmptyObject_ShouldMatchExpected;
var
  JsonInput: string;
  Expected: string;
  Actual: string;
begin
  JsonInput := '{}';
  Expected := '';
  Actual := TToon.JsonToToon(JsonInput);
  Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), Actual);
end;

procedure TConformanceTests.SingleKeyObject_ShouldMatchExpected;
var
  JsonInput: string;
  Expected: string;
  Actual: string;
begin
  JsonInput := '{"name":"Alice"}';
  Expected := 'name: Alice';
  Actual := TToon.JsonToToon(JsonInput);
  Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), Actual);
end;

end.
