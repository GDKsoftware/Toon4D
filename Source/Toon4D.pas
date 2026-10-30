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
unit Toon4D;

interface

uses
  System.SysUtils,
  System.JSON,
  Toon4D.Types;

type
  TToon = class sealed
  public
    class function JsonToToon(const JsonValue: TJSONValue): string; overload; static;
    class function JsonToToon(const JsonValue: TJSONValue; const Options: TToonOptions): string; overload; static;
    class function JsonToToon(const JsonString: string): string; overload; static;
    class function JsonToToon(const JsonString: string; const Options: TToonOptions): string; overload; static;
    class function GetLibraryVersion: string; static;
  end;

implementation

uses
  Toon4D.Consts,
  Toon4D.Encoder;

class function TToon.JsonToToon(const JsonValue: TJSONValue): string;
begin
  const Options = TToonOptions.Default;
  Result := JsonToToon(JsonValue, Options);
end;

class function TToon.JsonToToon(const JsonValue: TJSONValue; const Options: TToonOptions): string;
begin
  if not Assigned(JsonValue) then
    raise EToonInvalidJsonException.Create(ErrorNilJsonValue);

  var Encoder := TToonEncoder.Create(Options);
  try
    Result := Encoder.Encode(JsonValue);
  finally
    Encoder.Free;
  end;
end;

class function TToon.JsonToToon(const JsonString: string): string;
begin
  const Options = TToonOptions.Default;
  Result := JsonToToon(JsonString, Options);
end;

class function TToon.JsonToToon(const JsonString: string; const Options: TToonOptions): string;
begin
  const JsonValue = TJSONObject.ParseJSONValue(JsonString);
  if not Assigned(JsonValue) then
    raise EToonInvalidJsonException.CreateFmt(ErrorInvalidJson, [JsonString]);

  try
    Result := JsonToToon(JsonValue, Options);
  finally
    JsonValue.Free;
  end;
end;

class function TToon.GetLibraryVersion: string;
begin
  Result := '2.0.0';
end;

end.
