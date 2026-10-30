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
unit Toon4D.Numbers;

interface

uses
  System.SysUtils,
  System.JSON;

type
  TToonNumber = class sealed
  private
    type
      TDecimal = record
        IsNegative: Boolean;
        Digits: string;
        Exponent: Integer;

        procedure Normalize;
      end;

      TNumberText = record
        IsNegative: Boolean;
        IntegerDigits: string;
        FractionDigits: string;
        ExponentText: string;
      end;

      TScanner = record
        Text: string;
        Position: Integer;

        class function Create(const Text: string): TScanner; static;
        function IsAt(const Characters: TSysCharSet): Boolean;
        function IsAtEnd: Boolean;
        function SkipSign(const Signs: TSysCharSet): Boolean;
        function ReadDigits: string;
        function TryReadFraction(out Digits: string): Boolean;
        function TryReadExponent(out ExponentText: string): Boolean;
        function TryReadNumber(const Signs: TSysCharSet; out Number: TNumberText): Boolean;
      end;

    const SmallestPlainPointPosition = -5;
    const LargestPlainPointPosition = 21;

    class function EncodeDouble(const Value: Double): string; static;
    class function TryParse(const Text: string; out Decimal: TDecimal): Boolean; static;
    class function Render(const Decimal: TDecimal): string; static;
    class function RenderPlain(const Digits: string; const Exponent: Integer): string; static;
    class function RenderScientific(const Digits: string; const Exponent: Integer): string; static;

  public
    class function Encode(const Number: TJSONNumber): string; static;
    class function IsNumericLike(const Text: string): Boolean; static;
  end;

implementation

uses
  System.Math;

procedure TToonNumber.TDecimal.Normalize;
begin
  Digits := Digits.TrimLeft(['0']);

  while Digits.EndsWith('0') do
  begin
    Digits := Digits.Remove(Digits.Length - 1);
    Inc(Exponent);
  end;
end;

class function TToonNumber.TScanner.Create(const Text: string): TScanner;
begin
  Result.Text     := Text;
  Result.Position := Low(Text);
end;

function TToonNumber.TScanner.IsAt(const Characters: TSysCharSet): Boolean;
begin
  Result := (not IsAtEnd) and CharInSet(Text[Position], Characters);
end;

function TToonNumber.TScanner.IsAtEnd: Boolean;
begin
  Result := (Position > High(Text));
end;

function TToonNumber.TScanner.SkipSign(const Signs: TSysCharSet): Boolean;
begin
  Result := IsAt(['-']);
  if IsAt(Signs) then
    Inc(Position);
end;

function TToonNumber.TScanner.ReadDigits: string;
begin
  const Start = Position;
  while IsAt(['0'..'9']) do
    Inc(Position);

  Result := Copy(Text, Start, Position - Start);
end;

function TToonNumber.TScanner.TryReadFraction(out Digits: string): Boolean;
begin
  Digits := '';
  if not IsAt(['.']) then
    Exit(True);

  Inc(Position);
  Digits := ReadDigits;
  Result := not Digits.IsEmpty;
end;

function TToonNumber.TScanner.TryReadExponent(out ExponentText: string): Boolean;
begin
  ExponentText := '';
  if not IsAt(['e', 'E']) then
    Exit(True);

  Inc(Position);
  const IsNegative = SkipSign(['+', '-']);
  const Digits = ReadDigits;
  if Digits.IsEmpty then
    Exit(False);

  ExponentText := Digits;
  if IsNegative then
    ExponentText := Format('-%s', [Digits]);
  Result := True;
end;

function TToonNumber.TScanner.TryReadNumber(const Signs: TSysCharSet; out Number: TNumberText): Boolean;
begin
  Number := Default(TNumberText);
  Number.IsNegative    := SkipSign(Signs);
  Number.IntegerDigits := ReadDigits;

  Result := ((not Number.IntegerDigits.IsEmpty) and
             TryReadFraction(Number.FractionDigits) and
             TryReadExponent(Number.ExponentText) and
             IsAtEnd);
end;

class function TToonNumber.Encode(const Number: TJSONNumber): string;
begin
  var Decimal: TDecimal;
  if TryParse(Number.Value, Decimal) then
    Exit(Render(Decimal));

  Result := EncodeDouble(Number.AsDouble);
end;

class function TToonNumber.IsNumericLike(const Text: string): Boolean;
begin
  var Scanner := TScanner.Create(Text);
  var Number: TNumberText;
  Result := Scanner.TryReadNumber(['+', '-'], Number);
end;

class function TToonNumber.EncodeDouble(const Value: Double): string;
begin
  const IsFinite = not (IsNan(Value) or IsInfinite(Value));
  if not IsFinite then
    Exit('null');

  const Text = FloatToStr(Value, TFormatSettings.Invariant);
  var Decimal: TDecimal;
  if not TryParse(Text, Decimal) then
    Exit('null');

  Result := Render(Decimal);
end;

class function TToonNumber.TryParse(const Text: string; out Decimal: TDecimal): Boolean;
begin
  Decimal := Default(TDecimal);

  var Scanner := TScanner.Create(Text);
  var Number: TNumberText;
  if not Scanner.TryReadNumber(['-'], Number) then
    Exit(False);

  var Exponent := 0;
  const HasExponent = not Number.ExponentText.IsEmpty;
  if HasExponent and not TryStrToInt(Number.ExponentText, Exponent) then
    Exit(False);

  Decimal.IsNegative := Number.IsNegative;
  Decimal.Digits     := Format('%s%s', [Number.IntegerDigits, Number.FractionDigits]);
  Decimal.Exponent   := Exponent - Number.FractionDigits.Length;
  Decimal.Normalize;
  Result := True;
end;

class function TToonNumber.Render(const Decimal: TDecimal): string;
begin
  if Decimal.Digits.IsEmpty then
    Exit('0');

  const PointPosition = Decimal.Digits.Length + Decimal.Exponent;
  const IsPlainRange = InRange(PointPosition, SmallestPlainPointPosition, LargestPlainPointPosition);

  var Magnitude: string;
  if IsPlainRange then
    Magnitude := RenderPlain(Decimal.Digits, Decimal.Exponent)
  else
    Magnitude := RenderScientific(Decimal.Digits, Decimal.Exponent);

  if Decimal.IsNegative then
    Exit(Format('-%s', [Magnitude]));

  Result := Magnitude;
end;

class function TToonNumber.RenderPlain(const Digits: string; const Exponent: Integer): string;
begin
  const IsWholeNumber = (Exponent >= 0);
  if IsWholeNumber then
  begin
    const TrailingZeros = StringOfChar('0', Exponent);
    Exit(Format('%s%s', [Digits, TrailingZeros]));
  end;

  const PointPosition = Digits.Length + Exponent;
  const HasIntegerPart = (PointPosition > 0);
  if HasIntegerPart then
  begin
    const IntegerPart = Digits.Substring(0, PointPosition);
    const FractionPart = Digits.Substring(PointPosition);
    Exit(Format('%s.%s', [IntegerPart, FractionPart]));
  end;

  const LeadingZeros = StringOfChar('0', -PointPosition);
  Result := Format('0.%s%s', [LeadingZeros, Digits]);
end;

class function TToonNumber.RenderScientific(const Digits: string; const Exponent: Integer): string;
begin
  var Mantissa := Digits.Substring(0, 1);
  const HasFraction = (Digits.Length > 1);
  if HasFraction then
  begin
    const FractionPart = Digits.Substring(1);
    Mantissa := Format('%s.%s', [Mantissa, FractionPart]);
  end;

  const ScientificExponent = Digits.Length + Exponent - 1;
  var Sign := '+';
  const IsNegativeExponent = (ScientificExponent < 0);
  if IsNegativeExponent then
    Sign := '-';

  Result := Format('%se%s%d', [Mantissa, Sign, Abs(ScientificExponent)]);
end;

end.
