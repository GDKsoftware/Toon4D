{*******************************************************}
{                                                       }
{         Toon4D Library - LLM Data Optimization        }
{                                                       }
{                 DUnitX Test Suite                     }
{          Nested Objects & Indentation Tests           }
{                                                       }
{*******************************************************}
unit Toon4D.Tests.Nesting;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils,
  System.JSON;

type
  [TestFixture]
  TNestingTests = class
  public
    [Test]
    procedure NestedObjectSingleLevel_ShouldIndentTwoSpaces;

    [Test]
    procedure NestedObjectTwoLevels_ShouldIndentFourSpaces;

    [Test]
    procedure NestedObjectThreeLevels_ShouldIndentSixSpaces;

    [Test]
    procedure NestedObjectWithPrimitives_ShouldIndentAll;

    [Test]
    procedure NestedArrayInObject_ShouldIndentArray;

    [Test]
    procedure NestedObjectInArray_ShouldUseNestedFieldGroup;

    [Test]
    procedure DeepNesting_ShouldMaintainConsistentIndent;

    [Test]
    procedure IndentSize2Spaces_ShouldUseDefault;

    [Test]
    procedure IndentSize4Spaces_ShouldUseWhenConfigured;

    [Test]
    procedure MixedNestingObjectsArrays_ShouldIndentCorrectly;

    [Test]
    procedure EmptyNestedObject_ShouldProduceKeyOnly;

    [Test]
    procedure NestedObjectWithMultipleKeys_ShouldIndentEach;

    [Test]
    procedure ArrayWithUniformNestedObjects_ShouldUseNestedFieldGroup;

    [Test]
    procedure EmptyInnerArrays_ShouldEncode;

    [Test]
    procedure MixedLengthInnerArrays_ShouldEncode;

    [Test]
    procedure StringsWithDelimitersInNested_ShouldQuote;
  end;

implementation

uses
  Toon4D,
  Toon4D.Consts,
  Toon4D.Types,
  Toon4D.Tests.Helpers;

procedure TNestingTests.NestedObjectSingleLevel_ShouldIndentTwoSpaces;
var
  JsonObject: TJSONObject;
  NestedObject: TJSONObject;
  ToonOutput: string;
  Expected: string;
begin
  JsonObject := TJSONObject.Create;
  try
    NestedObject := TJSONObject.Create;
    NestedObject.AddPair('city', 'NYC');
    JsonObject.AddPair('address', NestedObject);

    Expected := '''
address:
  city: NYC
'''.Trim;

    ToonOutput := TToon.JsonToToon(JsonObject);
    Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), ToonOutput);
  finally
    JsonObject.Free;
  end;
end;

procedure TNestingTests.NestedObjectTwoLevels_ShouldIndentFourSpaces;
var
  JsonObject: TJSONObject;
  Level1: TJSONObject;
  Level2: TJSONObject;
  ToonOutput: string;
  Expected: string;
begin
  JsonObject := TJSONObject.Create;
  try
    Level1 := TJSONObject.Create;
    Level2 := TJSONObject.Create;
    Level2.AddPair('value', TJSONNumber.Create(42));
    Level1.AddPair('nested', Level2);
    JsonObject.AddPair('data', Level1);

    Expected := '''
data:
  nested:
    value: 42
'''.Trim;

    ToonOutput := TToon.JsonToToon(JsonObject);
    Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), ToonOutput);
  finally
    JsonObject.Free;
  end;
end;

procedure TNestingTests.NestedObjectThreeLevels_ShouldIndentSixSpaces;
var
  JsonObject: TJSONObject;
  Level1: TJSONObject;
  Level2: TJSONObject;
  Level3: TJSONObject;
  ToonOutput: string;
  Lines: TArray<string>;
begin
  JsonObject := TJSONObject.Create;
  try
    Level1 := TJSONObject.Create;
    Level2 := TJSONObject.Create;
    Level3 := TJSONObject.Create;
    Level3.AddPair('value', 'deep');
    Level2.AddPair('level3', Level3);
    Level1.AddPair('level2', Level2);
    JsonObject.AddPair('level1', Level1);

    ToonOutput := TToon.JsonToToon(JsonObject);
    Lines := ToonOutput.Split([ToonLineBreak]);

    Assert.AreEqual('level1:', Lines[0]);
    Assert.AreEqual('  level2:', Lines[1]);
    Assert.AreEqual('    level3:', Lines[2]);
    Assert.AreEqual('      value: deep', Lines[3]);
  finally
    JsonObject.Free;
  end;
end;

procedure TNestingTests.NestedObjectWithPrimitives_ShouldIndentAll;
var
  JsonObject: TJSONObject;
  NestedObject: TJSONObject;
  ToonOutput: string;
  Expected: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonObject.AddPair('id', TJSONNumber.Create(1));

    NestedObject := TJSONObject.Create;
    NestedObject.AddPair('street', '123 Main St');
    NestedObject.AddPair('city', 'NYC');
    JsonObject.AddPair('address', NestedObject);

    JsonObject.AddPair('active', TJSONTrue.Create);

    Expected := '''
id: 1
address:
  street: 123 Main St
  city: NYC
active: true
'''.Trim;

    ToonOutput := TToon.JsonToToon(JsonObject);
    Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), ToonOutput);
  finally
    JsonObject.Free;
  end;
end;

procedure TNestingTests.NestedArrayInObject_ShouldIndentArray;
var
  JsonObject: TJSONObject;
  NestedObject: TJSONObject;
  JsonArray: TJSONArray;
  ToonOutput: string;
  Expected: string;
begin
  JsonObject := TJSONObject.Create;
  try
    NestedObject := TJSONObject.Create;
    JsonArray := TJSONArray.Create;
    JsonArray.Add('admin');
    JsonArray.Add('user');
    NestedObject.AddPair('roles', JsonArray);
    JsonObject.AddPair('permissions', NestedObject);

    Expected := '''
permissions:
  roles[2]: admin,user
'''.Trim;

    ToonOutput := TToon.JsonToToon(JsonObject);
    Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), ToonOutput);
  finally
    JsonObject.Free;
  end;
end;

procedure TNestingTests.NestedObjectInArray_ShouldUseNestedFieldGroup;
var
  JsonObject: TJSONObject;
  JsonArray: TJSONArray;
  Item: TJSONObject;
  NestedObject: TJSONObject;
  ToonOutput: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonArray := TJSONArray.Create;

    Item := TJSONObject.Create;
    Item.AddPair('id', TJSONNumber.Create(1));

    NestedObject := TJSONObject.Create;
    NestedObject.AddPair('city', 'NYC');
    Item.AddPair('address', NestedObject);

    JsonArray.Add(Item);
    JsonObject.AddPair('users', JsonArray);

    ToonOutput := TToon.JsonToToon(JsonObject);
    Assert.AreEqual('users[1]{id,address{city}}:'#10'  1,NYC', ToonOutput);
  finally
    JsonObject.Free;
  end;
end;

procedure TNestingTests.DeepNesting_ShouldMaintainConsistentIndent;
var
  JsonObject: TJSONObject;
  Level1: TJSONObject;
  Level2: TJSONObject;
  Level3: TJSONObject;
  Level4: TJSONObject;
  ToonOutput: string;
  Lines: TArray<string>;
begin
  JsonObject := TJSONObject.Create;
  try
    Level1 := TJSONObject.Create;
    Level2 := TJSONObject.Create;
    Level3 := TJSONObject.Create;
    Level4 := TJSONObject.Create;

    Level4.AddPair('value', 'bottom');
    Level3.AddPair('d', Level4);
    Level2.AddPair('c', Level3);
    Level1.AddPair('b', Level2);
    JsonObject.AddPair('a', Level1);

    ToonOutput := TToon.JsonToToon(JsonObject);
    Lines := ToonOutput.Split([ToonLineBreak]);

    Assert.AreEqual('a:', Lines[0]);
    Assert.AreEqual('  b:', Lines[1]);
    Assert.AreEqual('    c:', Lines[2]);
    Assert.AreEqual('      d:', Lines[3]);
    Assert.AreEqual('        value: bottom', Lines[4]);
  finally
    JsonObject.Free;
  end;
end;

procedure TNestingTests.IndentSize2Spaces_ShouldUseDefault;
var
  JsonObject: TJSONObject;
  NestedObject: TJSONObject;
  ToonOutput: string;
begin
  JsonObject := TJSONObject.Create;
  try
    NestedObject := TJSONObject.Create;
    NestedObject.AddPair('key', 'value');
    JsonObject.AddPair('nested', NestedObject);

    ToonOutput := TToon.JsonToToon(JsonObject);
    Assert.Contains(ToonOutput, '  key: value');
    Assert.IsFalse(ToonOutput.Contains('    key:'));
  finally
    JsonObject.Free;
  end;
end;

procedure TNestingTests.IndentSize4Spaces_ShouldUseWhenConfigured;
var
  JsonObject: TJSONObject;
  NestedObject: TJSONObject;
  Options: TToonOptions;
  ToonOutput: string;
begin
  JsonObject := TJSONObject.Create;
  try
    NestedObject := TJSONObject.Create;
    NestedObject.AddPair('key', 'value');
    JsonObject.AddPair('nested', NestedObject);

    Options := TToonTestHelpers.Indented(4);
    ToonOutput := TToon.JsonToToon(JsonObject, Options);

    Assert.Contains(ToonOutput, '    key: value');
  finally
    JsonObject.Free;
  end;
end;

procedure TNestingTests.MixedNestingObjectsArrays_ShouldIndentCorrectly;
var
  JsonObject: TJSONObject;
  Level1: TJSONObject;
  JsonArray: TJSONArray;
  ArrayItem: TJSONObject;
  ToonOutput: string;
begin
  JsonObject := TJSONObject.Create;
  try
    Level1 := TJSONObject.Create;
    JsonArray := TJSONArray.Create;

    ArrayItem := TJSONObject.Create;
    ArrayItem.AddPair('id', TJSONNumber.Create(1));
    ArrayItem.AddPair('name', 'Item1');
    JsonArray.Add(ArrayItem);

    Level1.AddPair('items', JsonArray);
    JsonObject.AddPair('data', Level1);

    ToonOutput := TToon.JsonToToon(JsonObject);
    Assert.Contains(ToonOutput, 'data:');
    Assert.Contains(ToonOutput, '  items[1]{id,name}:');
    Assert.Contains(ToonOutput, '    1,Item1');
  finally
    JsonObject.Free;
  end;
end;

procedure TNestingTests.EmptyNestedObject_ShouldProduceKeyOnly;
var
  JsonObject: TJSONObject;
  EmptyObject: TJSONObject;
  ToonOutput: string;
  Expected: string;
begin
  JsonObject := TJSONObject.Create;
  try
    EmptyObject := TJSONObject.Create;
    JsonObject.AddPair('empty', EmptyObject);

    Expected := 'empty:';
    ToonOutput := TToon.JsonToToon(JsonObject);
    Assert.AreEqual(Expected, ToonOutput);
  finally
    JsonObject.Free;
  end;
end;

procedure TNestingTests.NestedObjectWithMultipleKeys_ShouldIndentEach;
var
  JsonObject: TJSONObject;
  NestedObject: TJSONObject;
  ToonOutput: string;
  Expected: string;
begin
  JsonObject := TJSONObject.Create;
  try
    NestedObject := TJSONObject.Create;
    NestedObject.AddPair('first', 'value1');
    NestedObject.AddPair('second', 'value2');
    NestedObject.AddPair('third', 'value3');
    JsonObject.AddPair('nested', NestedObject);

    Expected := '''
nested:
  first: value1
  second: value2
  third: value3
'''.Trim;

    ToonOutput := TToon.JsonToToon(JsonObject);
    Assert.AreEqual(TToonTestHelpers.NormalizeLineEndings(Expected), ToonOutput);
  finally
    JsonObject.Free;
  end;
end;

procedure TNestingTests.ArrayWithUniformNestedObjects_ShouldUseNestedFieldGroup;
var
  JsonObject: TJSONObject;
  JsonArray: TJSONArray;
  Item1: TJSONObject;
  Item2: TJSONObject;
  Nested1: TJSONObject;
  Nested2: TJSONObject;
  ToonOutput: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonArray := TJSONArray.Create;

    Item1 := TJSONObject.Create;
    Item1.AddPair('id', TJSONNumber.Create(1));
    Nested1 := TJSONObject.Create;
    Nested1.AddPair('x', TJSONNumber.Create(10));
    Item1.AddPair('coords', Nested1);
    JsonArray.Add(Item1);

    Item2 := TJSONObject.Create;
    Item2.AddPair('id', TJSONNumber.Create(2));
    Nested2 := TJSONObject.Create;
    Nested2.AddPair('x', TJSONNumber.Create(20));
    Item2.AddPair('coords', Nested2);
    JsonArray.Add(Item2);

    JsonObject.AddPair('items', JsonArray);
    ToonOutput := TToon.JsonToToon(JsonObject);

    Assert.AreEqual('items[2]{id,coords{x}}:'#10'  1,10'#10'  2,20', ToonOutput);
  finally
    JsonObject.Free;
  end;
end;

procedure TNestingTests.EmptyInnerArrays_ShouldEncode;
var
  JsonObject: TJSONObject;
  OuterArray: TJSONArray;
  EmptyArray1: TJSONArray;
  EmptyArray2: TJSONArray;
  EmptyArray3: TJSONArray;
  Result: string;
  Expected: string;
begin
  JsonObject := TJSONObject.Create;
  try
    OuterArray := TJSONArray.Create;

    EmptyArray1 := TJSONArray.Create;
    OuterArray.AddElement(EmptyArray1);

    EmptyArray2 := TJSONArray.Create;
    OuterArray.AddElement(EmptyArray2);

    EmptyArray3 := TJSONArray.Create;
    OuterArray.AddElement(EmptyArray3);

    JsonObject.AddPair('data', OuterArray);
    Result := TToon.JsonToToon(JsonObject);

    Expected := '''
data[3]:
  - [0]:
  - [0]:
  - [0]:
'''.Trim;
    Expected := TToonTestHelpers.NormalizeLineEndings(Expected);

    Assert.AreEqual(Expected, Result, 'Empty inner arrays should be encoded');
  finally
    JsonObject.Free;
  end;
end;

procedure TNestingTests.MixedLengthInnerArrays_ShouldEncode;
var
  JsonObject: TJSONObject;
  OuterArray: TJSONArray;
  Array1: TJSONArray;
  Array2: TJSONArray;
  Array3: TJSONArray;
  Result: string;
  Expected: string;
begin
  JsonObject := TJSONObject.Create;
  try
    OuterArray := TJSONArray.Create;

    Array1 := TJSONArray.Create;
    Array1.AddElement(TJSONNumber.Create(1));
    OuterArray.AddElement(Array1);

    Array2 := TJSONArray.Create;
    Array2.AddElement(TJSONNumber.Create(2));
    Array2.AddElement(TJSONNumber.Create(3));
    OuterArray.AddElement(Array2);

    Array3 := TJSONArray.Create;
    Array3.AddElement(TJSONNumber.Create(4));
    Array3.AddElement(TJSONNumber.Create(5));
    Array3.AddElement(TJSONNumber.Create(6));
    OuterArray.AddElement(Array3);

    JsonObject.AddPair('data', OuterArray);
    Result := TToon.JsonToToon(JsonObject);

    Expected := '''
data[3]:
  - [1]: 1
  - [2]: 2,3
  - [3]: 4,5,6
'''.Trim;
    Expected := TToonTestHelpers.NormalizeLineEndings(Expected);

    Assert.AreEqual(Expected, Result, 'Mixed-length inner arrays should be encoded');
  finally
    JsonObject.Free;
  end;
end;

procedure TNestingTests.StringsWithDelimitersInNested_ShouldQuote;
var
  JsonObject: TJSONObject;
  NestedObject: TJSONObject;
  JsonArray: TJSONArray;
  Options: TToonOptions;
  Result: string;
begin
  JsonObject := TJSONObject.Create;
  try
    NestedObject := TJSONObject.Create;

    JsonArray := TJSONArray.Create;
    JsonArray.Add('a,b');
    JsonArray.Add('c');
    NestedObject.AddPair('items', JsonArray);

    JsonObject.AddPair('data', NestedObject);

    Options := TToonOptions.Default;
    Result := TToon.JsonToToon(JsonObject, Options);

    Assert.Contains(Result, '"a,b"', 'String with delimiter should be quoted in nested context');
  finally
    JsonObject.Free;
  end;
end;

end.
