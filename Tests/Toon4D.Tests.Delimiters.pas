{*******************************************************}
{                                                       }
{         Toon4D Library - LLM Data Optimization        }
{                                                       }
{                 DUnitX Test Suite                     }
{           Delimiter Options Tests                     }
{                                                       }
{*******************************************************}
unit Toon4D.Tests.Delimiters;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils,
  System.JSON;

type
  [TestFixture]
  TDelimiterTests = class
  public
    [Test]
    procedure Comma_InlineArray_ShouldUseComma;

    [Test]
    procedure Tab_InlineArray_ShouldUseTab;

    [Test]
    procedure Pipe_InlineArray_ShouldUsePipe;

    [Test]
    procedure Comma_TabularArray_ShouldUseComma;

    [Test]
    procedure Tab_TabularArray_ShouldUseTabInHeader;

    [Test]
    procedure Pipe_TabularArray_ShouldUsePipeInHeader;

    [Test]
    procedure Tab_TabularRows_ShouldSeparateWithTab;

    [Test]
    procedure Pipe_TabularRows_ShouldSeparateWithPipe;

    [Test]
    procedure Comma_StringWithComma_ShouldQuote;

    [Test]
    procedure Tab_StringWithTab_ShouldQuote;

    [Test]
    procedure Pipe_StringWithPipe_ShouldQuote;

    [Test]
    procedure Comma_Default_ShouldNotShowInHeader;

    [Test]
    procedure Tab_ShouldShowInHeader;

    [Test]
    procedure Pipe_ShouldShowInHeader;

    [Test]
    procedure NestedArrays_CanHaveDifferentDelimiters;

    [Test]
    procedure CommaNotQuotedWhenTabDelimiter;

    [Test]
    procedure CommaNotQuotedWhenPipeDelimiter;

    [Test]
    procedure TabOnlyQuotedWhenTabDelimiter;

    [Test]
    procedure PipeOnlyQuotedWhenPipeDelimiter;

    [Test]
    procedure TabularValueWithDelimiter_ShouldQuote;
  end;

implementation

uses
  Toon4D,
  Toon4D.Types,
  Toon4D.Tests.Helpers;

procedure TDelimiterTests.Comma_InlineArray_ShouldUseComma;
var
  JsonObject: TJSONObject;
  JsonArray: TJSONArray;
  Options: TToonOptions;
  ToonOutput: string;
  Expected: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonArray := TJSONArray.Create;
    JsonArray.Add('a');
    JsonArray.Add('b');
    JsonArray.Add('c');
    JsonObject.AddPair('items', JsonArray);

    Options := TToonOptions.Default;
    ToonOutput := TToon.JsonToToon(JsonObject, Options);

    Expected := 'items[3]: a,b,c';
    Assert.AreEqual(Expected, ToonOutput);
  finally
    JsonObject.Free;
  end;
end;

procedure TDelimiterTests.Tab_InlineArray_ShouldUseTab;
var
  JsonObject: TJSONObject;
  JsonArray: TJSONArray;
  Options: TToonOptions;
  ToonOutput: string;
  Expected: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonArray := TJSONArray.Create;
    JsonArray.Add('a');
    JsonArray.Add('b');
    JsonArray.Add('c');
    JsonObject.AddPair('items', JsonArray);

    Options := TToonTestHelpers.Delimited(TToonDelimiter.Tab);
    ToonOutput := TToon.JsonToToon(JsonObject, Options);

    Expected := 'items[3' + #9 + ']: a' + #9 + 'b' + #9 + 'c';
    Assert.AreEqual(Expected, ToonOutput);
  finally
    JsonObject.Free;
  end;
end;

procedure TDelimiterTests.Pipe_InlineArray_ShouldUsePipe;
var
  JsonObject: TJSONObject;
  JsonArray: TJSONArray;
  Options: TToonOptions;
  ToonOutput: string;
  Expected: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonArray := TJSONArray.Create;
    JsonArray.Add('a');
    JsonArray.Add('b');
    JsonArray.Add('c');
    JsonObject.AddPair('items', JsonArray);

    Options := TToonTestHelpers.Delimited(TToonDelimiter.Pipe);
    ToonOutput := TToon.JsonToToon(JsonObject, Options);

    Expected := 'items[3|]: a|b|c';
    Assert.AreEqual(Expected, ToonOutput);
  finally
    JsonObject.Free;
  end;
end;

procedure TDelimiterTests.Comma_TabularArray_ShouldUseComma;
var
  JsonObject: TJSONObject;
  JsonArray: TJSONArray;
  Item: TJSONObject;
  Options: TToonOptions;
  ToonOutput: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonArray := TJSONArray.Create;

    Item := TJSONObject.Create;
    Item.AddPair('id', TJSONNumber.Create(1));
    Item.AddPair('name', 'Alice');
    JsonArray.Add(Item);

    JsonObject.AddPair('users', JsonArray);

    Options := TToonOptions.Default;
    ToonOutput := TToon.JsonToToon(JsonObject, Options);

    Assert.Contains(ToonOutput, 'users[1]{id,name}:');
    Assert.Contains(ToonOutput, '1,Alice');
  finally
    JsonObject.Free;
  end;
end;

procedure TDelimiterTests.Tab_TabularArray_ShouldUseTabInHeader;
var
  JsonObject: TJSONObject;
  JsonArray: TJSONArray;
  Item: TJSONObject;
  Options: TToonOptions;
  ToonOutput: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonArray := TJSONArray.Create;

    Item := TJSONObject.Create;
    Item.AddPair('id', TJSONNumber.Create(1));
    Item.AddPair('name', 'Alice');
    JsonArray.Add(Item);

    JsonObject.AddPair('users', JsonArray);

    Options := TToonTestHelpers.Delimited(TToonDelimiter.Tab);
    ToonOutput := TToon.JsonToToon(JsonObject, Options);

    Assert.Contains(ToonOutput, 'users[1' + #9 + ']{id' + #9 + 'name}:');
  finally
    JsonObject.Free;
  end;
end;

procedure TDelimiterTests.Pipe_TabularArray_ShouldUsePipeInHeader;
var
  JsonObject: TJSONObject;
  JsonArray: TJSONArray;
  Item: TJSONObject;
  Options: TToonOptions;
  ToonOutput: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonArray := TJSONArray.Create;

    Item := TJSONObject.Create;
    Item.AddPair('id', TJSONNumber.Create(1));
    Item.AddPair('name', 'Alice');
    JsonArray.Add(Item);

    JsonObject.AddPair('users', JsonArray);

    Options := TToonTestHelpers.Delimited(TToonDelimiter.Pipe);
    ToonOutput := TToon.JsonToToon(JsonObject, Options);

    Assert.Contains(ToonOutput, 'users[1|]{id|name}:');
  finally
    JsonObject.Free;
  end;
end;

procedure TDelimiterTests.Tab_TabularRows_ShouldSeparateWithTab;
var
  JsonObject: TJSONObject;
  JsonArray: TJSONArray;
  Item: TJSONObject;
  Options: TToonOptions;
  ToonOutput: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonArray := TJSONArray.Create;

    Item := TJSONObject.Create;
    Item.AddPair('id', TJSONNumber.Create(1));
    Item.AddPair('name', 'Alice');
    JsonArray.Add(Item);

    JsonObject.AddPair('users', JsonArray);

    Options := TToonTestHelpers.Delimited(TToonDelimiter.Tab);
    ToonOutput := TToon.JsonToToon(JsonObject, Options);

    Assert.Contains(ToonOutput, '1' + #9 + 'Alice');
  finally
    JsonObject.Free;
  end;
end;

procedure TDelimiterTests.Pipe_TabularRows_ShouldSeparateWithPipe;
var
  JsonObject: TJSONObject;
  JsonArray: TJSONArray;
  Item: TJSONObject;
  Options: TToonOptions;
  ToonOutput: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonArray := TJSONArray.Create;

    Item := TJSONObject.Create;
    Item.AddPair('id', TJSONNumber.Create(1));
    Item.AddPair('name', 'Alice');
    JsonArray.Add(Item);

    JsonObject.AddPair('users', JsonArray);

    Options := TToonTestHelpers.Delimited(TToonDelimiter.Pipe);
    ToonOutput := TToon.JsonToToon(JsonObject, Options);

    Assert.Contains(ToonOutput, '1|Alice');
  finally
    JsonObject.Free;
  end;
end;

procedure TDelimiterTests.Comma_StringWithComma_ShouldQuote;
var
  JsonObject: TJSONObject;
  JsonArray: TJSONArray;
  Options: TToonOptions;
  ToonOutput: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonArray := TJSONArray.Create;
    JsonArray.Add('a,b');
    JsonArray.Add('c');
    JsonObject.AddPair('items', JsonArray);

    Options := TToonOptions.Default;
    ToonOutput := TToon.JsonToToon(JsonObject, Options);

    Assert.Contains(ToonOutput, '"a,b"');
  finally
    JsonObject.Free;
  end;
end;

procedure TDelimiterTests.Tab_StringWithTab_ShouldQuote;
var
  JsonObject: TJSONObject;
  JsonArray: TJSONArray;
  Options: TToonOptions;
  ToonOutput: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonArray := TJSONArray.Create;
    JsonArray.Add('a' + #9 + 'b');
    JsonArray.Add('c');
    JsonObject.AddPair('items', JsonArray);

    Options := TToonTestHelpers.Delimited(TToonDelimiter.Tab);
    ToonOutput := TToon.JsonToToon(JsonObject, Options);

    Assert.Contains(ToonOutput, '"a\tb"');
  finally
    JsonObject.Free;
  end;
end;

procedure TDelimiterTests.Pipe_StringWithPipe_ShouldQuote;
var
  JsonObject: TJSONObject;
  JsonArray: TJSONArray;
  Options: TToonOptions;
  ToonOutput: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonArray := TJSONArray.Create;
    JsonArray.Add('a|b');
    JsonArray.Add('c');
    JsonObject.AddPair('items', JsonArray);

    Options := TToonTestHelpers.Delimited(TToonDelimiter.Pipe);
    ToonOutput := TToon.JsonToToon(JsonObject, Options);

    Assert.Contains(ToonOutput, '"a|b"');
  finally
    JsonObject.Free;
  end;
end;

procedure TDelimiterTests.Comma_Default_ShouldNotShowInHeader;
var
  JsonObject: TJSONObject;
  JsonArray: TJSONArray;
  Item: TJSONObject;
  Options: TToonOptions;
  ToonOutput: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonArray := TJSONArray.Create;

    Item := TJSONObject.Create;
    Item.AddPair('id', TJSONNumber.Create(1));
    JsonArray.Add(Item);

    JsonObject.AddPair('items', JsonArray);

    Options := TToonOptions.Default;
    ToonOutput := TToon.JsonToToon(JsonObject, Options);

    Assert.Contains(ToonOutput, 'items[1]{id}:');
    Assert.IsFalse(ToonOutput.Contains('[1,]'));
  finally
    JsonObject.Free;
  end;
end;

procedure TDelimiterTests.Tab_ShouldShowInHeader;
var
  JsonObject: TJSONObject;
  JsonArray: TJSONArray;
  Options: TToonOptions;
  ToonOutput: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonArray := TJSONArray.Create;
    JsonArray.Add('a');
    JsonObject.AddPair('items', JsonArray);

    Options := TToonTestHelpers.Delimited(TToonDelimiter.Tab);
    ToonOutput := TToon.JsonToToon(JsonObject, Options);

    Assert.Contains(ToonOutput, '[1' + #9 + ']:');
  finally
    JsonObject.Free;
  end;
end;

procedure TDelimiterTests.Pipe_ShouldShowInHeader;
var
  JsonObject: TJSONObject;
  JsonArray: TJSONArray;
  Options: TToonOptions;
  ToonOutput: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonArray := TJSONArray.Create;
    JsonArray.Add('a');
    JsonObject.AddPair('items', JsonArray);

    Options := TToonTestHelpers.Delimited(TToonDelimiter.Pipe);
    ToonOutput := TToon.JsonToToon(JsonObject, Options);

    Assert.Contains(ToonOutput, '[1|]:');
  finally
    JsonObject.Free;
  end;
end;

procedure TDelimiterTests.NestedArrays_CanHaveDifferentDelimiters;
var
  JsonObject: TJSONObject;
  OuterArray: TJSONArray;
  InnerArray: TJSONArray;
  Options: TToonOptions;
  ToonOutput: string;
begin
  JsonObject := TJSONObject.Create;
  try
    OuterArray := TJSONArray.Create;
    InnerArray := TJSONArray.Create;
    InnerArray.Add('a');
    InnerArray.Add('b');
    OuterArray.Add(InnerArray);
    JsonObject.AddPair('items', OuterArray);

    Options := TToonOptions.Default;
    ToonOutput := TToon.JsonToToon(JsonObject, Options);

    Assert.Contains(ToonOutput, 'items[1]:');
    Assert.Contains(ToonOutput, '- [2]: a,b');
  finally
    JsonObject.Free;
  end;
end;

procedure TDelimiterTests.CommaNotQuotedWhenTabDelimiter;
var
  JsonObject: TJSONObject;
  JsonArray: TJSONArray;
  Options: TToonOptions;
  ToonOutput: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonArray := TJSONArray.Create;
    JsonArray.Add('a,b');  // Contains comma
    JsonArray.Add('c');
    JsonObject.AddPair('items', JsonArray);

    Options := TToonTestHelpers.Delimited(TToonDelimiter.Tab);
    ToonOutput := TToon.JsonToToon(JsonObject, Options);

    Assert.Contains(ToonOutput, 'a,b');
    Assert.IsFalse(ToonOutput.Contains('"a,b"'), 'Comma should not be quoted when tab is delimiter');
  finally
    JsonObject.Free;
  end;
end;

procedure TDelimiterTests.CommaNotQuotedWhenPipeDelimiter;
var
  JsonObject: TJSONObject;
  JsonArray: TJSONArray;
  Options: TToonOptions;
  ToonOutput: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonArray := TJSONArray.Create;
    JsonArray.Add('a,b');  // Contains comma
    JsonArray.Add('c');
    JsonObject.AddPair('items', JsonArray);

    Options := TToonTestHelpers.Delimited(TToonDelimiter.Pipe);
    ToonOutput := TToon.JsonToToon(JsonObject, Options);

    Assert.Contains(ToonOutput, 'a,b');
    Assert.IsFalse(ToonOutput.Contains('"a,b"'), 'Comma should not be quoted when pipe is delimiter');
  finally
    JsonObject.Free;
  end;
end;

procedure TDelimiterTests.TabOnlyQuotedWhenTabDelimiter;
var
  JsonObject: TJSONObject;
  JsonArray: TJSONArray;
  Options: TToonOptions;
  ToonOutput: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonArray := TJSONArray.Create;
    JsonArray.Add('a' + #9 + 'b');
    JsonObject.AddPair('items', JsonArray);

    Options := TToonOptions.Default;
    ToonOutput := TToon.JsonToToon(JsonObject, Options);

    Assert.Contains(ToonOutput, '\t', 'Tab should be escaped');

    JsonObject.Free;
    JsonObject := TJSONObject.Create;

    JsonArray := TJSONArray.Create;
    JsonArray.Add('a' + #9 + 'b');
    JsonArray.Add('c');
    JsonObject.AddPair('items', JsonArray);

    Options := TToonTestHelpers.Delimited(TToonDelimiter.Tab);
    ToonOutput := TToon.JsonToToon(JsonObject, Options);

    Assert.Contains(ToonOutput, '"a\tb"', 'Tab must be quoted when tab is delimiter');
  finally
    JsonObject.Free;
  end;
end;

procedure TDelimiterTests.PipeOnlyQuotedWhenPipeDelimiter;
var
  JsonObject: TJSONObject;
  JsonArray: TJSONArray;
  Options: TToonOptions;
  ToonOutput: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonArray := TJSONArray.Create;
    JsonArray.Add('a|b');
    JsonObject.AddPair('items', JsonArray);

    Options := TToonOptions.Default;
    ToonOutput := TToon.JsonToToon(JsonObject, Options);

    Assert.Contains(ToonOutput, 'a|b');
    Assert.IsFalse(ToonOutput.Contains('"a|b"'), 'Pipe should not be quoted when comma is delimiter');

    JsonObject.Free;
    JsonObject := TJSONObject.Create;

    JsonArray := TJSONArray.Create;
    JsonArray.Add('a|b');
    JsonArray.Add('c');
    JsonObject.AddPair('items', JsonArray);

    Options := TToonTestHelpers.Delimited(TToonDelimiter.Pipe);
    ToonOutput := TToon.JsonToToon(JsonObject, Options);

    Assert.Contains(ToonOutput, '"a|b"', 'Pipe must be quoted when pipe is delimiter');
  finally
    JsonObject.Free;
  end;
end;

procedure TDelimiterTests.TabularValueWithDelimiter_ShouldQuote;
var
  JsonObject: TJSONObject;
  JsonArray: TJSONArray;
  Item: TJSONObject;
  Options: TToonOptions;
  ToonOutput: string;
begin
  JsonObject := TJSONObject.Create;
  try
    JsonArray := TJSONArray.Create;

    Item := TJSONObject.Create;
    Item.AddPair('id', TJSONNumber.Create(1));
    Item.AddPair('name', 'Smith,John');  // Name contains comma
    JsonArray.Add(Item);

    JsonObject.AddPair('users', JsonArray);

    Options := TToonOptions.Default;
    ToonOutput := TToon.JsonToToon(JsonObject, Options);

    Assert.Contains(ToonOutput, '"Smith,John"');
  finally
    JsonObject.Free;
  end;
end;

end.
