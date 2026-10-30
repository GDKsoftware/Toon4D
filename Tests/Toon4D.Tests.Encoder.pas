{*******************************************************}
{                                                       }
{         Toon4D Library - LLM Data Optimization        }
{                                                       }
{     Copyright(c) 2025 Marco Geuze - GDK Software      }
{              All rights reserved                      }
{                                                       }
{              Licensed under MIT License               }
{                                                       }
{*******************************************************}
unit Toon4D.Tests.Encoder;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TEncoderTests = class
  public
    [Test]
    [TestCase('Zero', '0')]
    [TestCase('Negative', '-1')]
    procedure JsonToToon_IndentSizeBelowOne_RaisesInvalidOptions(const IndentSize: Integer);

    [Test]
    procedure JsonToToon_IndentSizeThree_IndentsEveryLevelByThree;

    [Test]
    [TestCase('LoneHighSurrogate', 'D83D')]
    [TestCase('LoneLowSurrogate', 'DC4B')]
    procedure JsonToToon_UnpairedSurrogateInValue_RaisesEncodingError(const Surrogate: string);

    [Test]
    procedure JsonToToon_UnpairedSurrogateInKey_RaisesEncodingError;

    [Test]
    procedure JsonToToon_SurrogatePair_EncodesLiterally;

    [Test]
    procedure JsonToToon_NotANumber_EncodesNull;

    [Test]
    [TestCase('OneTenth', '0.1,0.1')]
    [TestCase('Million', '1000000,1000000')]
    [TestCase('NegativeHalf', '-0.5,-0.5')]
    procedure JsonToToon_NumberFromDouble_EncodesCanonicalDecimal(const ValueText: string; const Expected: string);

    [Test]
    [TestCase('ExponentAtUpperBound', '1e21,1e+21')]
    [TestCase('JustBelowUpperBound', '999999999999999999999,999999999999999999999')]
    [TestCase('ExponentBelowLowerBound', '0.0000001,1e-7')]
    [TestCase('LowerBound', '1E-6,0.000001')]
    [TestCase('TrailingZeros', '1.5000,1.5')]
    [TestCase('NegativeZero', '-0.0,0')]
    procedure JsonToToon_NumberText_EncodesCanonicalForm(const Text: string; const Expected: string);

    [Test]
    procedure GetLibraryVersion_ReturnsTwo;
  end;

implementation

uses
  System.SysUtils,
  System.Math,
  System.JSON,
  Toon4D,
  Toon4D.Types,
  Toon4D.Tests.Helpers;

procedure TEncoderTests.JsonToToon_IndentSizeBelowOne_RaisesInvalidOptions(const IndentSize: Integer);
begin
  const Options = TToonTestHelpers.Indented(IndentSize);

  Assert.WillRaise(
    procedure
    begin
      TToon.JsonToToon('{"a":{"b":1}}', Options);
    end,
    EToonInvalidOptionsException);
end;

procedure TEncoderTests.JsonToToon_IndentSizeThree_IndentsEveryLevelByThree;
begin
  const Options = TToonTestHelpers.Indented(3);

  const Actual = TToon.JsonToToon('{"a":[{"b":1,"c":{"d":2}},5]}', Options);

  Assert.AreEqual('a[2]:'#10'   - b: 1'#10'      c:'#10'         d: 2'#10'   - 5', Actual);
end;

procedure TEncoderTests.JsonToToon_UnpairedSurrogateInValue_RaisesEncodingError(const Surrogate: string);
begin
  const HexText = Format('$%s', [Surrogate]);
  const Character = Char(StrToInt(HexText));
  const Value = TJSONString.Create(Format('a%sb', [Character]));
  try
    Assert.WillRaise(
      procedure
      begin
        TToon.JsonToToon(Value);
      end,
      EToonEncodingException);
  finally
    Value.Free;
  end;
end;

procedure TEncoderTests.JsonToToon_UnpairedSurrogateInKey_RaisesEncodingError;
begin
  const JsonObject = TJSONObject.Create;
  try
    JsonObject.AddPair(Format('k%s', [Char($D83D)]), 'value');

    Assert.WillRaise(
      procedure
      begin
        TToon.JsonToToon(JsonObject);
      end,
      EToonEncodingException);
  finally
    JsonObject.Free;
  end;
end;

procedure TEncoderTests.JsonToToon_SurrogatePair_EncodesLiterally;
begin
  const Emoji = Format('%s%s', [Char($D83D), Char($DC4B)]);
  const Value = TJSONString.Create(Format('hi %s', [Emoji]));
  try
    const Actual = TToon.JsonToToon(Value);

    Assert.AreEqual(Format('hi %s', [Emoji]), Actual);
  finally
    Value.Free;
  end;
end;

procedure TEncoderTests.JsonToToon_NotANumber_EncodesNull;
begin
  const Value = TJSONNumber.Create(NaN);
  try
    const Actual = TToon.JsonToToon(Value);

    Assert.AreEqual('null', Actual);
  finally
    Value.Free;
  end;
end;

procedure TEncoderTests.JsonToToon_NumberFromDouble_EncodesCanonicalDecimal(const ValueText: string; const Expected: string);
begin
  const Value = StrToFloat(ValueText, TFormatSettings.Invariant);
  const Number = TJSONNumber.Create(Value);
  try
    const Actual = TToon.JsonToToon(Number);

    Assert.AreEqual(Expected, Actual);
  finally
    Number.Free;
  end;
end;

procedure TEncoderTests.JsonToToon_NumberText_EncodesCanonicalForm(const Text: string; const Expected: string);
begin
  const Actual = TToon.JsonToToon(Format('{"n":%s}', [Text]));

  Assert.AreEqual(Format('n: %s', [Expected]), Actual);
end;

procedure TEncoderTests.GetLibraryVersion_ReturnsTwo;
begin
  const Actual = TToon.GetLibraryVersion;

  Assert.AreEqual('2.0.0', Actual);
end;

end.
