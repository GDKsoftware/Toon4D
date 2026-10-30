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
unit Toon4D.Text;

interface

type
  TToonText = class sealed
  private
    const ByteOrderMark = #$FEFF;

    class function NeedsQuoting(const Value: string; const Delimiter: Char; const IsRoot: Boolean): Boolean; static;
    class function HasSurroundingWhitespace(const Value: string): Boolean; static;
    class function IsLiteral(const Value: string): Boolean; static;
    class function HasStructuralCharacter(const Value: string; const Delimiter: Char): Boolean; static;
    class function HasStructuralStart(const Value: string; const IsRoot: Boolean): Boolean; static;
    class function IsUnquotedKey(const Key: string): Boolean; static;
    class function IsKeyStart(const Character: Char): Boolean; static;
    class function IsKeyCharacter(const Character: Char): Boolean; static;
    class function Quote(const Value: string): string; static;
    class function Escape(const Value: string): string; static;
    class function UnicodeEscape(const Character: Char): string; static;
    class procedure GuardWellFormed(const Value: string); static;

  public
    class function EncodeValue(const Value: string; const Delimiter: Char; const IsRoot: Boolean): string; static;
    class function EncodeKey(const Key: string): string; static;
  end;

implementation

uses
  System.SysUtils,
  System.Character,
  Toon4D.Types,
  Toon4D.Consts,
  Toon4D.Numbers;

class function TToonText.EncodeValue(const Value: string; const Delimiter: Char; const IsRoot: Boolean): string;
begin
  GuardWellFormed(Value);

  if NeedsQuoting(Value, Delimiter, IsRoot) then
    Exit(Quote(Value));

  Result := Value;
end;

class function TToonText.EncodeKey(const Key: string): string;
begin
  GuardWellFormed(Key);

  if IsUnquotedKey(Key) then
    Exit(Key);

  Result := Quote(Key);
end;

class function TToonText.Quote(const Value: string): string;
begin
  const Escaped = Escape(Value);
  Result := Format('"%s"', [Escaped]);
end;

class function TToonText.NeedsQuoting(const Value: string; const Delimiter: Char; const IsRoot: Boolean): Boolean;
begin
  Result := Value.IsEmpty or
            HasSurroundingWhitespace(Value) or
            IsLiteral(Value) or
            TToonNumber.IsNumericLike(Value) or
            HasStructuralCharacter(Value, Delimiter) or
            HasStructuralStart(Value, IsRoot);
end;

class function TToonText.HasSurroundingWhitespace(const Value: string): Boolean;
begin
  const First = Value[Low(Value)];
  const Last = Value[High(Value)];
  Result := CharInSet(First, [' ', #9]) or CharInSet(Last, [' ', #9]);
end;

class function TToonText.IsLiteral(const Value: string): Boolean;
begin
  Result := (Value = 'true') or (Value = 'false') or (Value = 'null');
end;

class function TToonText.HasStructuralCharacter(const Value: string; const Delimiter: Char): Boolean;
begin
  for var Character in Value do
  begin
    const IsStructural = CharInSet(Character, [':', '"', '\', '[', ']', '{', '}']);
    const IsControl = (Character < ' ');
    const IsDelimiter = (Character = Delimiter);
    if IsStructural or IsControl or IsDelimiter then
      Exit(True);
  end;

  Result := False;
end;

class function TToonText.HasStructuralStart(const Value: string; const IsRoot: Boolean): Boolean;
begin
  const First = Value[Low(Value)];
  const StartsLikeListItemOrComment = CharInSet(First, ['-', '#']);
  const StartsWithByteOrderMark = (IsRoot and (First = ByteOrderMark));
  Result := (StartsLikeListItemOrComment or StartsWithByteOrderMark);
end;

class function TToonText.IsUnquotedKey(const Key: string): Boolean;
begin
  if Key.IsEmpty or not IsKeyStart(Key[Low(Key)]) then
    Exit(False);

  for var Character in Key do
  begin
    if not IsKeyCharacter(Character) then
      Exit(False);
  end;

  Result := True;
end;

class function TToonText.IsKeyStart(const Character: Char): Boolean;
begin
  Result := CharInSet(Character, ['A'..'Z', 'a'..'z', '_']);
end;

class function TToonText.IsKeyCharacter(const Character: Char): Boolean;
begin
  Result := CharInSet(Character, ['A'..'Z', 'a'..'z', '0'..'9', '_', '.']);
end;

class function TToonText.Escape(const Value: string): string;
begin
  var Builder := TStringBuilder.Create(Value.Length + 2);
  try
    for var Character in Value do
    begin
      case Character of
        '\' : Builder.Append('\\');
        '"' : Builder.Append('\"');
        #10 : Builder.Append('\n');
        #13 : Builder.Append('\r');
        #9  : Builder.Append('\t');
        #0..#8, #11, #12, #14..#31 :
          Builder.Append(UnicodeEscape(Character));
      else
        Builder.Append(Character);
      end;
    end;

    Result := Builder.ToString;
  finally
    Builder.Free;
  end;
end;

class function TToonText.UnicodeEscape(const Character: Char): string;
begin
  const Hex = IntToHex(Ord(Character), 4);
  const LowerHex = LowerCase(Hex);
  Result := Format('\u%s', [LowerHex]);
end;

class procedure TToonText.GuardWellFormed(const Value: string);
begin
  var IsAfterHighSurrogate := False;
  for var Index := Low(Value) to High(Value) do
  begin
    const Character = Value[Index];
    if IsAfterHighSurrogate then
    begin
      if not Character.IsLowSurrogate then
        raise EToonEncodingException.CreateFmt(ErrorUnpairedSurrogate, [Index - 1]);
      IsAfterHighSurrogate := False;
      Continue;
    end;

    if Character.IsLowSurrogate then
      raise EToonEncodingException.CreateFmt(ErrorUnpairedSurrogate, [Index]);
    IsAfterHighSurrogate := Character.IsHighSurrogate;
  end;

  if IsAfterHighSurrogate then
    raise EToonEncodingException.CreateFmt(ErrorUnpairedSurrogate, [High(Value)]);
end;

end.
