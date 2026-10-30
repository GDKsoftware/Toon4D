{*******************************************************}
{                                                       }
{         Toon4D Library - LLM Data Optimization        }
{                                                       }
{                 DUnitX Test Suite                     }
{                  Test Helper Classes                  }
{                                                       }
{*******************************************************}
unit Toon4D.Tests.Helpers;

interface

uses
  System.SysUtils,
  Toon4D.Types;

type
  TToonTestHelpers = class sealed
  public
    class function NormalizeLineEndings(const S: string): string; static;
    class function Delimited(const Delimiter: TToonDelimiter): TToonOptions; static;
    class function Indented(const IndentSize: Integer): TToonOptions; static;
  end;

implementation

uses
  Toon4D.Consts;

class function TToonTestHelpers.NormalizeLineEndings(const S: string): string;
begin
  Result := StringReplace(S, sLineBreak, ToonLineBreak, [rfReplaceAll]);
end;

class function TToonTestHelpers.Delimited(const Delimiter: TToonDelimiter): TToonOptions;
begin
  Result := TToonOptions.Default;
  Result.Delimiter := Delimiter;
end;

class function TToonTestHelpers.Indented(const IndentSize: Integer): TToonOptions;
begin
  Result := TToonOptions.Default;
  Result.IndentSize := IndentSize;
end;

end.
