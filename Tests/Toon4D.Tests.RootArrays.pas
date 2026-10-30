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
unit Toon4D.Tests.RootArrays;

/// <summary>
/// Tests for root-level array encoding with different delimiters
/// Based on official TOON spec fixtures: arrays-primitive.json, delimiters.json
/// </summary>

interface

uses
  DUnitX.TestFramework,
  System.JSON,
  Toon4D,
  Toon4D.Types;

type
  [TestFixture]
  TRootArraysTests = class
  public
    [Test]
    procedure RootArrayTabDelimiter_Primitives;
    [Test]
    procedure RootArrayPipeDelimiter_Primitives;
    [Test]
    procedure RootArrayUniformObjects_Tabular;
    [Test]
    procedure RootArrayNonUniformObjects_List;
  end;

implementation

uses
  System.SysUtils,
  Toon4D.Tests.Helpers;

{ TRootArraysTests }

procedure TRootArraysTests.RootArrayTabDelimiter_Primitives;
var
  JsonArray: TJSONArray;
  Options: TToonOptions;
  Result: string;
  Expected: string;
begin
  JsonArray := TJSONArray.Create;
  try
    JsonArray.Add('a');
    JsonArray.Add('b');
    JsonArray.Add('c');

    Options := TToonTestHelpers.Delimited(TToonDelimiter.Tab);
    Result := TToon.JsonToToon(JsonArray, Options);

    Expected := '[3' + #9 + ']: a' + #9 + 'b' + #9 + 'c';
    Assert.AreEqual(Expected, Result, 'Root array with tab delimiter should show tab in header and values');
  finally
    JsonArray.Free;
  end;
end;

procedure TRootArraysTests.RootArrayPipeDelimiter_Primitives;
var
  JsonArray: TJSONArray;
  Options: TToonOptions;
  Result: string;
  Expected: string;
begin
  JsonArray := TJSONArray.Create;
  try
    JsonArray.Add('a');
    JsonArray.Add('b');
    JsonArray.Add('c');

    Options := TToonTestHelpers.Delimited(TToonDelimiter.Pipe);
    Result := TToon.JsonToToon(JsonArray, Options);

    Expected := '[3|]: a|b|c';
    Assert.AreEqual(Expected, Result, 'Root array with pipe delimiter should show pipe in header and values');
  finally
    JsonArray.Free;
  end;
end;

procedure TRootArraysTests.RootArrayUniformObjects_Tabular;
var
  JsonArray: TJSONArray;
  Item1: TJSONObject;
  Item2: TJSONObject;
  Result: string;
  Expected: string;
begin
  JsonArray := TJSONArray.Create;
  try
    Item1 := TJSONObject.Create;
    Item1.AddPair('id', TJSONNumber.Create(1));
    Item1.AddPair('name', 'Alice');
    JsonArray.Add(Item1);

    Item2 := TJSONObject.Create;
    Item2.AddPair('id', TJSONNumber.Create(2));
    Item2.AddPair('name', 'Bob');
    JsonArray.Add(Item2);

    Result := TToon.JsonToToon(JsonArray);

    Expected := '''
[2]{id,name}:
  1,Alice
  2,Bob
'''.Trim;

    Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), Result, 'Root array with uniform objects should use tabular format');
  finally
    JsonArray.Free;
  end;
end;

procedure TRootArraysTests.RootArrayNonUniformObjects_List;
var
  JsonArray: TJSONArray;
  Item1: TJSONObject;
  Item2: TJSONObject;
  Result: string;
  Expected: string;
begin
  JsonArray := TJSONArray.Create;
  try
    Item1 := TJSONObject.Create;
    Item1.AddPair('id', TJSONNumber.Create(1));
    Item1.AddPair('name', 'Alice');
    JsonArray.Add(Item1);

    Item2 := TJSONObject.Create;
    Item2.AddPair('id', TJSONNumber.Create(2));
    Item2.AddPair('role', 'admin');
    JsonArray.Add(Item2);

    Result := TToon.JsonToToon(JsonArray);

    Expected := '''
[2]:
  - id: 1
    name: Alice
  - id: 2
    role: admin
'''.Trim;

    Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), Result, 'Root array with non-uniform objects should use list format');
  finally
    JsonArray.Free;
  end;
end;

end.
