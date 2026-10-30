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
unit Toon4D.Types;

interface

uses
  System.SysUtils;

type
  {$SCOPEDENUMS ON}
  TToonDelimiter = (Comma, Tab, Pipe);
  {$SCOPEDENUMS OFF}

  TToonDelimiterHelper = record helper for TToonDelimiter
    function Character: Char;
    function HeaderSymbol: string;
  end;

  TToonOptions = record
    IndentSize: Integer;
    Delimiter: TToonDelimiter;

    class function Default: TToonOptions; static;
  end;

  EToonException = class(Exception);
  EToonInvalidJsonException = class(EToonException);
  EToonInvalidOptionsException = class(EToonException);
  EToonEncodingException = class(EToonException);

implementation

function TToonDelimiterHelper.Character: Char;
begin
  case Self of
    TToonDelimiter.Comma : Result := ',';
    TToonDelimiter.Tab   : Result := #9;
    TToonDelimiter.Pipe  : Result := '|';
  else
    raise ENotSupportedException.CreateFmt('Unsupported delimiter: %d', [Ord(Self)]);
  end;
end;

function TToonDelimiterHelper.HeaderSymbol: string;
begin
  const IsDefaultDelimiter = (Self = TToonDelimiter.Comma);
  if IsDefaultDelimiter then
    Exit('');

  Result := Character;
end;

class function TToonOptions.Default: TToonOptions;
begin
  Result.IndentSize := 2;
  Result.Delimiter  := TToonDelimiter.Comma;
end;

end.
