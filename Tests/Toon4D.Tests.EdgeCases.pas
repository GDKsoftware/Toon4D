{*******************************************************}
{                                                       }
{         Toon4D Library - LLM Data Optimization        }
{                                                       }
{                 DUnitX Test Suite                     }
{        Edge Cases & Error Handling Tests              }
{                                                       }
{*******************************************************}
unit Toon4D.Tests.EdgeCases;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils,
  System.JSON;

type
  [TestFixture]
  TEdgeCasesTests = class
  public
    [Test]
    procedure NilJsonValue_ShouldRaiseException;

    [Test]
    procedure EmptyJsonString_ShouldReturnEmpty;

    [Test]
    procedure RootPrimitive_ShouldEncodePrimitive;

    [Test]
    procedure RootArray_ShouldEncodeWithoutKey;

    [Test]
    procedure RootObject_ShouldEncodeNormally;

    [Test]
    procedure VeryLargeNumber_ShouldUseExponentNotation;

    [Test]
    procedure VerySmallNumber_ShouldUseExponentNotation;

    [Test]
    procedure NumberMaxFloat_ShouldEncode;

    [Test]
    procedure NumberMinFloat_ShouldEncode;

    [Test]
    procedure StringVeryLong_ShouldPreserve;

    [Test]
    procedure StringAllWhitespace_ShouldQuote;

    [Test]
    procedure StringOnlyNewlines_ShouldQuoteAndEscape;

    [Test]
    procedure ArrayVeryLarge_ShouldEncodeAll;

    [Test]
    procedure ObjectVeryManyKeys_ShouldEncodeAll;

    [Test]
    procedure DeeplyNestedStructure_ShouldHandleDepth;

    [Test]
    procedure CircularReference_ShouldHandleGracefully;

    [Test]
    procedure MalformedJsonString_ShouldRaiseException;

    [Test]
    procedure UnicodeEdgeCases_ShouldPreserve;

    [Test]
    procedure EmojiInKeys_ShouldQuoteKey;

    [Test]
    procedure EmptyArrayInArray_ShouldEncode;

    [Test]
    procedure EmptyObjectInArray_ShouldEncode;

    [Test]
    procedure NullInObjectKey_ShouldEncode;

    [Test]
    procedure BooleanInKey_ShouldStayUnquoted;

    [Test]
    procedure NumberInKey_ShouldConvertToString;

    [Test]
    procedure KeyOrderWithManyKeys_ShouldPreserve;

    [Test]
    procedure TabularWithEmptyFields_ShouldQuote;

    [Test]
    procedure TabularWithNullFields_ShouldEncodeNull;

    [Test]
    procedure ListArrayWithOnlyNulls_ShouldEncodeNulls;

    [Test]
    procedure StringWithAllEscapeCharacters_ShouldEscapeAll;

    [Test]
    procedure StringWithControlCharacters_ShouldQuoteAndEscape;

    [Test]
    procedure ZeroLengthArrayMultiple_ShouldEncodeAll;
  end;

implementation

uses
  Toon4D,
  Toon4D.Consts,
  Toon4D.Types;

procedure TEdgeCasesTests.NilJsonValue_ShouldRaiseException;
var
  JsonValue: TJSONValue;
begin
  JsonValue := nil;
  Assert.WillRaise(
    procedure
    begin
      TToon.JsonToToon(JsonValue);
    end,
    EToonInvalidJsonException
  );
end;

procedure TEdgeCasesTests.EmptyJsonString_ShouldReturnEmpty;
var
  ToonOutput: string;
begin
  ToonOutput := TToon.JsonToToon('{}');
  Assert.AreEqual('', ToonOutput);
end;

procedure TEdgeCasesTests.RootPrimitive_ShouldEncodePrimitive;
var
  ToonOutput: string;
  Expected: string;
begin
  Expected := '42';
  ToonOutput := TToon.JsonToToon('42');
  Assert.AreEqual(Expected, ToonOutput);
end;

procedure TEdgeCasesTests.RootArray_ShouldEncodeWithoutKey;
var
  JsonArray: TJSONArray;
  ToonOutput: string;
  Expected: string;
begin
  JsonArray := TJSONArray.Create;
  try
    JsonArray.Add('a');
    JsonArray.Add('b');
    Expected := '[2]: a,b';
    ToonOutput := TToon.JsonToToon(JsonArray);
    Assert.AreEqual(Expected, ToonOutput);
  finally
    JsonArray.Free;
  end;
end;

procedure TEdgeCasesTests.RootObject_ShouldEncodeNormally;
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

procedure TEdgeCasesTests.VeryLargeNumber_ShouldUseExponentNotation;
var
  JsonValue: TJSONValue;
  ToonOutput: string;
begin
  JsonValue := TJSONNumber.Create(1.23e100);
  try
    ToonOutput := TToon.JsonToToon(JsonValue);
    Assert.AreEqual('1.23e+100', ToonOutput);
  finally
    JsonValue.Free;
  end;
end;

procedure TEdgeCasesTests.VerySmallNumber_ShouldUseExponentNotation;
var
  JsonValue: TJSONValue;
  ToonOutput: string;
begin
  JsonValue := TJSONNumber.Create(1.23e-100);
  try
    ToonOutput := TToon.JsonToToon(JsonValue);
    Assert.AreEqual('1.23e-100', ToonOutput);
  finally
    JsonValue.Free;
  end;
end;

procedure TEdgeCasesTests.NumberMaxFloat_ShouldEncode;
var
  JsonValue: TJSONValue;
  ToonOutput: string;
begin
  JsonValue := TJSONNumber.Create(1.7E+308);
  try
    ToonOutput := TToon.JsonToToon(JsonValue);
    Assert.IsNotEmpty(ToonOutput);
  finally
    JsonValue.Free;
  end;
end;

procedure TEdgeCasesTests.NumberMinFloat_ShouldEncode;
var
  JsonValue: TJSONValue;
  ToonOutput: string;
begin
  JsonValue := TJSONNumber.Create(-1.7E+308);
  try
    ToonOutput := TToon.JsonToToon(JsonValue);
    Assert.IsNotEmpty(ToonOutput);
  finally
    JsonValue.Free;
  end;
end;

procedure TEdgeCasesTests.StringVeryLong_ShouldPreserve;
var
  JsonValue: TJSONValue;
  LongString: string;
  ToonOutput: string;
  Index: Integer;
begin
  LongString := '';
  for Index := 1 to 10000 do
  begin
    LongString := LongString + 'a';
  end;

  JsonValue := TJSONString.Create(LongString);
  try
    ToonOutput := TToon.JsonToToon(JsonValue);
    Assert.AreEqual(10000, ToonOutput.Length);
  finally
    JsonValue.Free;
  end;
end;

procedure TEdgeCasesTests.StringAllWhitespace_ShouldQuote;
var
  JsonValue: TJSONValue;
  ToonOutput: string;
  Expected: string;
begin
  JsonValue := TJSONString.Create('   ');
  try
    Expected := '"   "';
    ToonOutput := TToon.JsonToToon(JsonValue);
    Assert.AreEqual(Expected, ToonOutput);
  finally
    JsonValue.Free;
  end;
end;

procedure TEdgeCasesTests.StringOnlyNewlines_ShouldQuoteAndEscape;
var
  JsonValue: TJSONValue;
  ToonOutput: string;
  Expected: string;
begin
  JsonValue := TJSONString.Create(#10 + #10 + #10);
  try
    Expected := '"\n\n\n"';
    ToonOutput := TToon.JsonToToon(JsonValue);
    Assert.AreEqual(Expected, ToonOutput);
  finally
    JsonValue.Free;
  end;
end;

procedure TEdgeCasesTests.ArrayVeryLarge_ShouldEncodeAll;
const
  LargeArraySize = 1000;
var
  JsonObject: TJSONObject;
  JsonArray: TJSONArray;
  ToonOutput: string;
  Index: Integer;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonArray := TJSONArray.Create;
    for Index := 1 to LargeArraySize do
    begin
      JsonArray.AddElement(TJSONNumber.Create(Index));
    end;
    JsonObject.AddPair('numbers', JsonArray);

    ToonOutput := TToon.JsonToToon(JsonObject);
    Assert.Contains(ToonOutput, 'numbers[1000]:');
  finally
    JsonObject.Free;
  end;
end;

procedure TEdgeCasesTests.ObjectVeryManyKeys_ShouldEncodeAll;
var
  JsonObject: TJSONObject;
  ToonOutput: string;
  Lines: TArray<string>;
  Index: Integer;
begin
  JsonObject := TJSONObject.Create;
  try
    for Index := 1 to 100 do
    begin
      JsonObject.AddPair('key' + Index.ToString, TJSONNumber.Create(Index));
    end;

    ToonOutput := TToon.JsonToToon(JsonObject);
    Lines := ToonOutput.Split([ToonLineBreak]);
    Assert.AreEqual<NativeInt>(100, Length(Lines));
  finally
    JsonObject.Free;
  end;
end;

procedure TEdgeCasesTests.DeeplyNestedStructure_ShouldHandleDepth;
var
  JsonObject: TJSONObject;
  CurrentLevel: TJSONObject;
  ToonOutput: string;
  Index: Integer;
begin
  JsonObject := TJSONObject.Create;
  try
    CurrentLevel := JsonObject;
    for Index := 1 to 20 do
    begin
      var NextLevel := TJSONObject.Create;
      CurrentLevel.AddPair('level' + Index.ToString, NextLevel);
      CurrentLevel := NextLevel;
    end;
    CurrentLevel.AddPair('value', 'deep');

    ToonOutput := TToon.JsonToToon(JsonObject);
    Assert.IsNotEmpty(ToonOutput);
  finally
    JsonObject.Free;
  end;
end;

procedure TEdgeCasesTests.CircularReference_ShouldHandleGracefully;
var
  JsonObject: TJSONObject;
  ToonOutput: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonObject.AddPair('key', 'value');
    ToonOutput := TToon.JsonToToon(JsonObject);
    Assert.IsNotEmpty(ToonOutput);
  finally
    JsonObject.Free;
  end;
end;

procedure TEdgeCasesTests.MalformedJsonString_ShouldRaiseException;
var
  RaisedException: Boolean;
begin
  RaisedException := False;
  try
    TToon.JsonToToon('{invalid json}');
  except
    on EToonInvalidJsonException do
      RaisedException := True;
  end;
  Assert.IsTrue(RaisedException);
end;

procedure TEdgeCasesTests.UnicodeEdgeCases_ShouldPreserve;
var
  JsonValue: TJSONValue;
  ToonOutput: string;
  Expected: string;
begin
  JsonValue := TJSONString.Create('Ǽ Ǿ Ȁ Ȃ 𝕳𝖊𝖑𝖑𝖔');
  try
    Expected := 'Ǽ Ǿ Ȁ Ȃ 𝕳𝖊𝖑𝖑𝖔';
    ToonOutput := TToon.JsonToToon(JsonValue);
    Assert.AreEqual(Expected, ToonOutput);
  finally
    JsonValue.Free;
  end;
end;

procedure TEdgeCasesTests.EmojiInKeys_ShouldQuoteKey;
var
  JsonObject: TJSONObject;
  ToonOutput: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonObject.AddPair('key🔑', 'value');
    ToonOutput := TToon.JsonToToon(JsonObject);
    Assert.Contains(ToonOutput, '"key🔑":');
  finally
    JsonObject.Free;
  end;
end;

procedure TEdgeCasesTests.EmptyArrayInArray_ShouldEncode;
var
  JsonObject: TJSONObject;
  OuterArray: TJSONArray;
  InnerArray: TJSONArray;
  ToonOutput: string;
begin
  JsonObject := TJSONObject.Create;
  try
    OuterArray := TJSONArray.Create;
    InnerArray := TJSONArray.Create;
    OuterArray.Add(InnerArray);
    JsonObject.AddPair('items', OuterArray);

    ToonOutput := TToon.JsonToToon(JsonObject);
    Assert.Contains(ToonOutput, 'items[1]:');
    Assert.Contains(ToonOutput, '- [0]:');
  finally
    JsonObject.Free;
  end;
end;

procedure TEdgeCasesTests.EmptyObjectInArray_ShouldEncode;
var
  JsonObject: TJSONObject;
  JsonArray: TJSONArray;
  EmptyObject: TJSONObject;
  ToonOutput: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonArray := TJSONArray.Create;
    EmptyObject := TJSONObject.Create;
    JsonArray.Add(EmptyObject);
    JsonObject.AddPair('items', JsonArray);

    ToonOutput := TToon.JsonToToon(JsonObject);
    Assert.Contains(ToonOutput, 'items[1]:');
    Assert.Contains(ToonOutput, '  -');
  finally
    JsonObject.Free;
  end;
end;

procedure TEdgeCasesTests.NullInObjectKey_ShouldEncode;
var
  JsonObject: TJSONObject;
  ToonOutput: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonObject.AddPair('key', TJSONNull.Create);
    ToonOutput := TToon.JsonToToon(JsonObject);
    Assert.AreEqual('key: null', ToonOutput);
  finally
    JsonObject.Free;
  end;
end;

procedure TEdgeCasesTests.BooleanInKey_ShouldStayUnquoted;
var
  JsonObject: TJSONObject;
  ToonOutput: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonObject.AddPair('true', 'value');
    ToonOutput := TToon.JsonToToon(JsonObject);
    Assert.AreEqual('true: value', ToonOutput);
  finally
    JsonObject.Free;
  end;
end;

procedure TEdgeCasesTests.NumberInKey_ShouldConvertToString;
var
  JsonObject: TJSONObject;
  ToonOutput: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonObject.AddPair('123', 'value');
    ToonOutput := TToon.JsonToToon(JsonObject);
    Assert.Contains(ToonOutput, '"123":');
  finally
    JsonObject.Free;
  end;
end;

procedure TEdgeCasesTests.KeyOrderWithManyKeys_ShouldPreserve;
var
  JsonObject: TJSONObject;
  ToonOutput: string;
  Lines: TArray<string>;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonObject.AddPair('zebra', '1');
    JsonObject.AddPair('yankee', '2');
    JsonObject.AddPair('xray', '3');
    JsonObject.AddPair('alpha', '4');
    JsonObject.AddPair('bravo', '5');

    ToonOutput := TToon.JsonToToon(JsonObject);
    Lines := ToonOutput.Split([ToonLineBreak]);

    Assert.IsTrue(Lines[0].StartsWith('zebra:'));
    Assert.IsTrue(Lines[1].StartsWith('yankee:'));
    Assert.IsTrue(Lines[2].StartsWith('xray:'));
    Assert.IsTrue(Lines[3].StartsWith('alpha:'));
    Assert.IsTrue(Lines[4].StartsWith('bravo:'));
  finally
    JsonObject.Free;
  end;
end;

procedure TEdgeCasesTests.TabularWithEmptyFields_ShouldQuote;
var
  JsonObject: TJSONObject;
  JsonArray: TJSONArray;
  Item: TJSONObject;
  ToonOutput: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonArray := TJSONArray.Create;

    Item := TJSONObject.Create;
    Item.AddPair('name', 'Alice');
    Item.AddPair('middle', '');
    JsonArray.Add(Item);

    JsonObject.AddPair('users', JsonArray);
    ToonOutput := TToon.JsonToToon(JsonObject);

    Assert.Contains(ToonOutput, 'Alice,""');
  finally
    JsonObject.Free;
  end;
end;

procedure TEdgeCasesTests.TabularWithNullFields_ShouldEncodeNull;
var
  JsonObject: TJSONObject;
  JsonArray: TJSONArray;
  Item: TJSONObject;
  ToonOutput: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonArray := TJSONArray.Create;

    Item := TJSONObject.Create;
    Item.AddPair('name', 'Alice');
    Item.AddPair('age', TJSONNull.Create);
    JsonArray.Add(Item);

    JsonObject.AddPair('users', JsonArray);
    ToonOutput := TToon.JsonToToon(JsonObject);

    Assert.Contains(ToonOutput, 'Alice,null');
  finally
    JsonObject.Free;
  end;
end;

procedure TEdgeCasesTests.ListArrayWithOnlyNulls_ShouldEncodeNulls;
var
  JsonObject: TJSONObject;
  JsonArray: TJSONArray;
  ToonOutput: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonArray := TJSONArray.Create;
    JsonArray.AddElement(TJSONNull.Create);
    JsonArray.AddElement(TJSONNull.Create);
    JsonArray.AddElement(TJSONNull.Create);
    JsonObject.AddPair('items', JsonArray);

    ToonOutput := TToon.JsonToToon(JsonObject);
    Assert.Contains(ToonOutput, 'items[3]: null,null,null');
  finally
    JsonObject.Free;
  end;
end;

procedure TEdgeCasesTests.StringWithAllEscapeCharacters_ShouldEscapeAll;
var
  JsonValue: TJSONValue;
  ToonOutput: string;
  Expected: string;
begin
  JsonValue := TJSONString.Create('\' + '"' + #10 + #13 + #9);
  try
    Expected := '"\\\"\n\r\t"';
    ToonOutput := TToon.JsonToToon(JsonValue);
    Assert.AreEqual(Expected, ToonOutput);
  finally
    JsonValue.Free;
  end;
end;

procedure TEdgeCasesTests.StringWithControlCharacters_ShouldQuoteAndEscape;
var
  JsonValue: TJSONValue;
  ToonOutput: string;
begin
  JsonValue := TJSONString.Create('text' + #0 + 'more');
  try
    ToonOutput := TToon.JsonToToon(JsonValue);
    Assert.IsTrue(ToonOutput.StartsWith('"'));
    Assert.IsTrue(ToonOutput.EndsWith('"'));
  finally
    JsonValue.Free;
  end;
end;

procedure TEdgeCasesTests.ZeroLengthArrayMultiple_ShouldEncodeAll;
var
  JsonObject: TJSONObject;
  ToonOutput: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonObject.AddPair('empty1', TJSONArray.Create);
    JsonObject.AddPair('empty2', TJSONArray.Create);
    JsonObject.AddPair('empty3', TJSONArray.Create);

    ToonOutput := TToon.JsonToToon(JsonObject);
    Assert.AreEqual('empty1: []'#10'empty2: []'#10'empty3: []', ToonOutput);
  finally
    JsonObject.Free;
  end;
end;

end.
