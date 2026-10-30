{*******************************************************}
{                                                       }
{         Toon4D Library - LLM Data Optimization        }
{                                                       }
{     Copyright(c) 2025 [Organization/Author Name]      }
{              All rights reserved                      }
{                                                       }
{              Licensed under MIT License               }
{                                                       }
{*******************************************************}
unit Toon4D.Tests.ArrayEdgeCases;

/// <summary>
/// Tests for array edge cases from official TOON spec
/// Based on: arrays-tabular.json, arrays-objects.json
/// </summary>

interface

uses
  DUnitX.TestFramework,
  System.JSON,
  Toon4D,
  Toon4D.Types;

type
  [TestFixture]
  TArrayEdgeCasesTests = class
  public
    [Test]
    procedure TabularWithNull_ShouldEncodeNull;
    [Test]
    procedure TabularDelimiterEscaping_ShouldQuote;
    [Test]
    procedure TabularAmbiguousString_ShouldQuote;
    [Test]
    procedure TabularKeyNameQuoting_InHeader;
    [Test]
    procedure ArrayOfArraysDifferentLengths_ShouldUseList;
    [Test]
    procedure ArrayObjectsFieldOrderPreservation;
    [Test]
    procedure ArrayEmptyArraysInObjects_ShouldEncode;
    [Test]
    procedure InlineArrayWithEmptyString_ShouldQuote;
    [Test]
    procedure InlineArrayWithWhitespace_ShouldQuote;
    [Test]
    procedure InlineArrayWithBooleanLike_ShouldQuote;
    [Test]
    procedure InlineArrayWithStructuralChars_ShouldQuote;
  end;

implementation

uses
  System.SysUtils;

{ TArrayEdgeCasesTests }

procedure TArrayEdgeCasesTests.TabularWithNull_ShouldEncodeNull;
var
  JsonObject: TJSONObject;
  JsonArray: TJSONArray;
  Item1: TJSONObject;
  Item2: TJSONObject;
  Result: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonArray := TJSONArray.Create;

    Item1 := TJSONObject.Create;
    Item1.AddPair('id', TJSONNumber.Create(1));
    Item1.AddPair('name', 'Alice');
    JsonArray.Add(Item1);

    Item2 := TJSONObject.Create;
    Item2.AddPair('id', TJSONNumber.Create(2));
    Item2.AddPair('name', TJSONNull.Create);
    JsonArray.Add(Item2);

    JsonObject.AddPair('users', JsonArray);
    Result := TToon.JsonToToon(JsonObject);

    Assert.Contains(Result, 'Alice');
    Assert.Contains(Result, '2,null', 'Null value should be encoded in tabular format');
  finally
    JsonObject.Free;
  end;
end;

procedure TArrayEdgeCasesTests.TabularDelimiterEscaping_ShouldQuote;
var
  JsonObject: TJSONObject;
  JsonArray: TJSONArray;
  Item: TJSONObject;
  Options: TToonOptions;
  Result: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonArray := TJSONArray.Create;

    Item := TJSONObject.Create;
    Item.AddPair('id', TJSONNumber.Create(1));
    Item.AddPair('name', 'Smith,Jr');
    JsonArray.Add(Item);

    JsonObject.AddPair('users', JsonArray);

    Options := TToonOptions.Default;
    Result := TToon.JsonToToon(JsonObject, Options);

    Assert.Contains(Result, '"Smith,Jr"', 'Value with delimiter must be quoted in tabular array');
  finally
    JsonObject.Free;
  end;
end;

procedure TArrayEdgeCasesTests.TabularAmbiguousString_ShouldQuote;
var
  JsonObject: TJSONObject;
  JsonArray: TJSONArray;
  Item: TJSONObject;
  Result: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonArray := TJSONArray.Create;

    Item := TJSONObject.Create;
    Item.AddPair('id', '123');
    Item.AddPair('flag', 'true');
    JsonArray.Add(Item);

    JsonObject.AddPair('data', JsonArray);
    Result := TToon.JsonToToon(JsonObject);

    Assert.Contains(Result, '"123"', 'Numeric string must be quoted');
    Assert.Contains(Result, '"true"', 'Boolean-like string must be quoted');
  finally
    JsonObject.Free;
  end;
end;

procedure TArrayEdgeCasesTests.TabularKeyNameQuoting_InHeader;
var
  JsonObject: TJSONObject;
  JsonArray: TJSONArray;
  Item: TJSONObject;
  Result: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonArray := TJSONArray.Create;

    Item := TJSONObject.Create;
    Item.AddPair('user-id', TJSONNumber.Create(1));
    Item.AddPair('user name', 'Alice');
    JsonArray.Add(Item);

    JsonObject.AddPair('data', JsonArray);
    Result := TToon.JsonToToon(JsonObject);

    Assert.Contains(Result, '"user-id"', 'Key with hyphen must be quoted in header');
    Assert.Contains(Result, '"user name"', 'Key with space must be quoted in header');
  finally
    JsonObject.Free;
  end;
end;

procedure TArrayEdgeCasesTests.ArrayOfArraysDifferentLengths_ShouldUseList;
var
  JsonObject: TJSONObject;
  OuterArray: TJSONArray;
  Array1: TJSONArray;
  Array2: TJSONArray;
  Result: string;
begin
  JsonObject := TJSONObject.Create;
  try
    OuterArray := TJSONArray.Create;

    Array1 := TJSONArray.Create;
    Array1.Add('a');
    Array1.Add('b');
    OuterArray.AddElement(Array1);

    Array2 := TJSONArray.Create;
    Array2.Add('c');
    OuterArray.AddElement(Array2);

    JsonObject.AddPair('data', OuterArray);
    Result := TToon.JsonToToon(JsonObject);

    Assert.Contains(Result, '- [2]: a,b');
    Assert.Contains(Result, '- [1]: c');
  finally
    JsonObject.Free;
  end;
end;

procedure TArrayEdgeCasesTests.ArrayObjectsFieldOrderPreservation;
var
  JsonObject: TJSONObject;
  JsonArray: TJSONArray;
  Item1: TJSONObject;
  Item2: TJSONObject;
  Result: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonArray := TJSONArray.Create;

    Item1 := TJSONObject.Create;
    Item1.AddPair('zebra', 'z1');
    Item1.AddPair('alpha', 'a1');
    JsonArray.Add(Item1);

    Item2 := TJSONObject.Create;
    Item2.AddPair('zebra', 'z2');
    Item2.AddPair('alpha', 'a2');
    JsonArray.Add(Item2);

    JsonObject.AddPair('items', JsonArray);
    Result := TToon.JsonToToon(JsonObject);

    Assert.Contains(Result, '{zebra,alpha}', 'Field order should match first object order');
  finally
    JsonObject.Free;
  end;
end;

procedure TArrayEdgeCasesTests.ArrayEmptyArraysInObjects_ShouldEncode;
var
  JsonObject: TJSONObject;
  JsonArray: TJSONArray;
  Item: TJSONObject;
  EmptyArray: TJSONArray;
  Result: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonArray := TJSONArray.Create;

    Item := TJSONObject.Create;
    Item.AddPair('id', TJSONNumber.Create(1));
    EmptyArray := TJSONArray.Create;
    Item.AddPair('tags', EmptyArray);
    JsonArray.Add(Item);

    JsonObject.AddPair('items', JsonArray);
    Result := TToon.JsonToToon(JsonObject);

    Assert.Contains(Result, 'tags: []');
  finally
    JsonObject.Free;
  end;
end;

procedure TArrayEdgeCasesTests.InlineArrayWithEmptyString_ShouldQuote;
var
  JsonObject: TJSONObject;
  JsonArray: TJSONArray;
  Result: string;
  Expected: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonArray := TJSONArray.Create;
    JsonArray.Add('a');
    JsonArray.Add('');
    JsonArray.Add('c');

    JsonObject.AddPair('items', JsonArray);
    Result := TToon.JsonToToon(JsonObject);

    Expected := 'items[3]: a,"",c';
    Assert.AreEqual(Expected, Result, 'Empty string in inline array must be quoted');
  finally
    JsonObject.Free;
  end;
end;

procedure TArrayEdgeCasesTests.InlineArrayWithWhitespace_ShouldQuote;
var
  JsonObject: TJSONObject;
  JsonArray: TJSONArray;
  Result: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonArray := TJSONArray.Create;
    JsonArray.Add('a');
    JsonArray.Add(' b ');
    JsonArray.Add('c');

    JsonObject.AddPair('items', JsonArray);
    Result := TToon.JsonToToon(JsonObject);

    Assert.Contains(Result, '" b "', 'String with leading/trailing whitespace must be quoted');
  finally
    JsonObject.Free;
  end;
end;

procedure TArrayEdgeCasesTests.InlineArrayWithBooleanLike_ShouldQuote;
var
  JsonObject: TJSONObject;
  JsonArray: TJSONArray;
  Result: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonArray := TJSONArray.Create;
    JsonArray.Add('true');
    JsonArray.Add('false');
    JsonArray.Add('null');

    JsonObject.AddPair('items', JsonArray);
    Result := TToon.JsonToToon(JsonObject);

    Assert.Contains(Result, '"true"');
    Assert.Contains(Result, '"false"');
    Assert.Contains(Result, '"null"');
  finally
    JsonObject.Free;
  end;
end;

procedure TArrayEdgeCasesTests.InlineArrayWithStructuralChars_ShouldQuote;
var
  JsonObject: TJSONObject;
  JsonArray: TJSONArray;
  Result: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonArray := TJSONArray.Create;
    JsonArray.Add('[');
    JsonArray.Add(']');
    JsonArray.Add('{');
    JsonArray.Add('}');

    JsonObject.AddPair('items', JsonArray);
    Result := TToon.JsonToToon(JsonObject);

    Assert.Contains(Result, '"["');
    Assert.Contains(Result, '"]"');
    Assert.Contains(Result, '"{"');
    Assert.Contains(Result, '"}"');
  finally
    JsonObject.Free;
  end;
end;

end.
