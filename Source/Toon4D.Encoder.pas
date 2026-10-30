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
unit Toon4D.Encoder;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  System.JSON,
  Toon4D.Types,
  Toon4D.Fields;

type
  TToonEncoder = class
  private
    const ListItemMarker = '- ';
    const EmptyListItemMarker = '-';
    const EmptyArray = '[]';

    var
      FIndentSize: Integer;
      FDelimiter: TToonDelimiter;
      FOutput: TStringBuilder;

    procedure EncodeRoot(const Value: TJSONValue);
    procedure EncodeRootObject(const JsonObject: TJSONObject);
    procedure EncodeFields(const JsonObject: TJSONObject; const Depth: Integer);
    procedure EncodeField(const Key: string; const Value: TJSONValue; const LineDepth: Integer;
                          const Marker: string; const ContentDepth: Integer);
    procedure EncodeObjectField(const KeyText: string; const JsonObject: TJSONObject; const LineDepth: Integer;
                                const Marker: string; const ContentDepth: Integer);
    procedure EncodeArrayField(const KeyText: string; const JsonArray: TJSONArray; const LineDepth: Integer;
                               const Marker: string; const ContentDepth: Integer);
    procedure EncodeArray(const KeyText: string; const JsonArray: TJSONArray; const LineDepth: Integer;
                          const Marker: string; const ContentDepth: Integer; const AllowsTabular: Boolean);
    procedure EncodeTable(const HeaderStart: string; const JsonArray: TJSONArray; const Fields: TToonFieldList;
                          const LineDepth, ContentDepth: Integer);
    procedure EncodeList(const HeaderStart: string; const JsonArray: TJSONArray; const LineDepth, ContentDepth: Integer);
    procedure EncodeListItem(const Item: TJSONValue; const Depth: Integer);
    procedure EncodeObjectListItem(const JsonObject: TJSONObject; const Depth: Integer);
    procedure EncodeKeyedTable(const KeyText: string; const JsonObject: TJSONObject; const Fields: TToonFieldList;
                               const LineDepth: Integer; const Marker: string; const ContentDepth: Integer);
    procedure AppendLine(const Depth: Integer; const Text: string);

    function TryKeyedFields(const JsonObject: TJSONObject; out Fields: TToonFieldList): Boolean;
    function TryTabularFields(const JsonArray: TJSONArray; out Fields: TToonFieldList): Boolean;
    function IsPrimitiveArray(const JsonArray: TJSONArray): Boolean;
    function ArrayHeaderStart(const Marker, KeyText: string; const Count: Integer): string;
    function InlineValues(const JsonArray: TJSONArray): string;
    function FieldListText(const Fields: TToonFieldList): string;
    function RowText(const JsonObject: TJSONObject; const Fields: TToonFieldList): string;
    procedure CollectCells(const JsonObject: TJSONObject; const Fields: TToonFieldList; const Cells: TStringBuilder);
    function PrimitiveText(const Value: TJSONValue; const IsRoot: Boolean = False): string;

  public
    constructor Create(const Options: TToonOptions);
    destructor Destroy; override;

    function Encode(const Value: TJSONValue): string;
  end;

implementation

uses
  Toon4D.Consts,
  Toon4D.Text,
  Toon4D.Numbers;

constructor TToonEncoder.Create(const Options: TToonOptions);
begin
  inherited Create;

  const IsValidIndentSize = (Options.IndentSize >= 1);
  if not IsValidIndentSize then
    raise EToonInvalidOptionsException.CreateFmt(ErrorInvalidIndentSize, [Options.IndentSize]);

  FIndentSize := Options.IndentSize;
  FDelimiter  := Options.Delimiter;
  FOutput     := TStringBuilder.Create;
end;

destructor TToonEncoder.Destroy;
begin
  FOutput.Free;
  inherited;
end;

function TToonEncoder.Encode(const Value: TJSONValue): string;
begin
  FOutput.Clear;
  EncodeRoot(Value);
  Result := FOutput.ToString;
end;

procedure TToonEncoder.EncodeRoot(const Value: TJSONValue);
begin
  if Value is TJSONObject then
  begin
    EncodeRootObject(TJSONObject(Value));
    Exit;
  end;

  if Value is TJSONArray then
  begin
    const JsonArray = TJSONArray(Value);
    const IsEmpty = (JsonArray.Count = 0);
    if IsEmpty then
      AppendLine(0, EmptyArray)
    else
      EncodeArray('', JsonArray, 0, '', 1, True);
    Exit;
  end;

  const EncodedValue = PrimitiveText(Value, True);
  AppendLine(0, EncodedValue);
end;

procedure TToonEncoder.EncodeRootObject(const JsonObject: TJSONObject);
begin
  var Fields: TToonFieldList;
  if not TryKeyedFields(JsonObject, Fields) then
  begin
    EncodeFields(JsonObject, 0);
    Exit;
  end;

  try
    EncodeKeyedTable('', JsonObject, Fields, 0, '', 1);
  finally
    Fields.Free;
  end;
end;

procedure TToonEncoder.EncodeFields(const JsonObject: TJSONObject; const Depth: Integer);
begin
  for var Pair in JsonObject do
  begin
    EncodeField(Pair.JsonString.Value, Pair.JsonValue, Depth, '', Depth + 1);
  end;
end;

procedure TToonEncoder.EncodeField(const Key: string; const Value: TJSONValue; const LineDepth: Integer;
                                   const Marker: string; const ContentDepth: Integer);
begin
  const EncodedKey = TToonText.EncodeKey(Key);

  if Value is TJSONObject then
  begin
    EncodeObjectField(EncodedKey, TJSONObject(Value), LineDepth, Marker, ContentDepth);
    Exit;
  end;

  if Value is TJSONArray then
  begin
    EncodeArrayField(EncodedKey, TJSONArray(Value), LineDepth, Marker, ContentDepth);
    Exit;
  end;

  const EncodedValue = PrimitiveText(Value);
  AppendLine(LineDepth, Format('%s%s: %s', [Marker, EncodedKey, EncodedValue]));
end;

procedure TToonEncoder.EncodeObjectField(const KeyText: string; const JsonObject: TJSONObject; const LineDepth: Integer;
                                         const Marker: string; const ContentDepth: Integer);
begin
  var Fields: TToonFieldList;
  if not TryKeyedFields(JsonObject, Fields) then
  begin
    AppendLine(LineDepth, Format('%s%s:', [Marker, KeyText]));
    EncodeFields(JsonObject, ContentDepth);
    Exit;
  end;

  try
    EncodeKeyedTable(KeyText, JsonObject, Fields, LineDepth, Marker, ContentDepth);
  finally
    Fields.Free;
  end;
end;

procedure TToonEncoder.EncodeArrayField(const KeyText: string; const JsonArray: TJSONArray; const LineDepth: Integer;
                                        const Marker: string; const ContentDepth: Integer);
begin
  const IsEmpty = (JsonArray.Count = 0);
  if IsEmpty then
  begin
    AppendLine(LineDepth, Format('%s%s: %s', [Marker, KeyText, EmptyArray]));
    Exit;
  end;

  EncodeArray(KeyText, JsonArray, LineDepth, Marker, ContentDepth, True);
end;

procedure TToonEncoder.EncodeArray(const KeyText: string; const JsonArray: TJSONArray; const LineDepth: Integer;
                                   const Marker: string; const ContentDepth: Integer; const AllowsTabular: Boolean);
begin
  const HeaderStart = ArrayHeaderStart(Marker, KeyText, JsonArray.Count);

  if IsPrimitiveArray(JsonArray) then
  begin
    const Values = InlineValues(JsonArray);
    if Values.IsEmpty then
      AppendLine(LineDepth, Format('%s:', [HeaderStart]))
    else
      AppendLine(LineDepth, Format('%s: %s', [HeaderStart, Values]));
    Exit;
  end;

  var Fields: TToonFieldList := nil;
  const IsTable = (AllowsTabular and TryTabularFields(JsonArray, Fields));
  if not IsTable then
  begin
    EncodeList(HeaderStart, JsonArray, LineDepth, ContentDepth);
    Exit;
  end;

  try
    EncodeTable(HeaderStart, JsonArray, Fields, LineDepth, ContentDepth);
  finally
    Fields.Free;
  end;
end;

procedure TToonEncoder.EncodeTable(const HeaderStart: string; const JsonArray: TJSONArray; const Fields: TToonFieldList;
                                   const LineDepth, ContentDepth: Integer);
begin
  const FieldList = FieldListText(Fields);
  AppendLine(LineDepth, Format('%s%s:', [HeaderStart, FieldList]));

  for var Item in JsonArray do
  begin
    const Row = RowText(TJSONObject(Item), Fields);
    AppendLine(ContentDepth, Row);
  end;
end;

procedure TToonEncoder.EncodeList(const HeaderStart: string; const JsonArray: TJSONArray; const LineDepth, ContentDepth: Integer);
begin
  AppendLine(LineDepth, Format('%s:', [HeaderStart]));

  for var Item in JsonArray do
  begin
    EncodeListItem(Item, ContentDepth);
  end;
end;

procedure TToonEncoder.EncodeListItem(const Item: TJSONValue; const Depth: Integer);
begin
  if Item is TJSONObject then
  begin
    EncodeObjectListItem(TJSONObject(Item), Depth);
    Exit;
  end;

  if Item is TJSONArray then
  begin
    EncodeArray('', TJSONArray(Item), Depth, ListItemMarker, Depth + 1, False);
    Exit;
  end;

  const EncodedValue = PrimitiveText(Item);
  AppendLine(Depth, Format('%s%s', [ListItemMarker, EncodedValue]));
end;

procedure TToonEncoder.EncodeObjectListItem(const JsonObject: TJSONObject; const Depth: Integer);
begin
  const IsEmpty = (JsonObject.Count = 0);
  if IsEmpty then
  begin
    AppendLine(Depth, EmptyListItemMarker);
    Exit;
  end;

  const FieldDepth = Depth + 1;
  const ContentDepth = Depth + 2;
  var IsFirst := True;
  for var Pair in JsonObject do
  begin
    if IsFirst then
      EncodeField(Pair.JsonString.Value, Pair.JsonValue, Depth, ListItemMarker, ContentDepth)
    else
      EncodeField(Pair.JsonString.Value, Pair.JsonValue, FieldDepth, '', ContentDepth);
    IsFirst := False;
  end;
end;

procedure TToonEncoder.EncodeKeyedTable(const KeyText: string; const JsonObject: TJSONObject; const Fields: TToonFieldList;
                                        const LineDepth: Integer; const Marker: string; const ContentDepth: Integer);
begin
  const FieldList = FieldListText(Fields);
  const DelimiterSymbol = FDelimiter.HeaderSymbol;
  AppendLine(LineDepth, Format('%s%s[%d:%s]%s:', [Marker, KeyText, JsonObject.Count, DelimiterSymbol, FieldList]));

  for var Pair in JsonObject do
  begin
    const EntryKey = TToonText.EncodeKey(Pair.JsonString.Value);
    const Row = RowText(TJSONObject(Pair.JsonValue), Fields);
    AppendLine(ContentDepth, Format('%s: %s', [EntryKey, Row]));
  end;
end;

procedure TToonEncoder.AppendLine(const Depth: Integer; const Text: string);
begin
  const HasLines = (FOutput.Length > 0);
  if HasLines then
    FOutput.Append(ToonLineBreak);

  FOutput.Append(' ', Depth * FIndentSize);
  FOutput.Append(Text);
end;

function TToonEncoder.TryKeyedFields(const JsonObject: TJSONObject; out Fields: TToonFieldList): Boolean;
begin
  Fields := nil;

  const HasEnoughEntries = (JsonObject.Count >= 2);
  if not HasEnoughEntries then
    Exit(False);

  var Values: TArray<TJSONValue>;
  SetLength(Values, JsonObject.Count);
  for var Index := 0 to JsonObject.Count - 1 do
  begin
    Values[Index] := JsonObject.Pairs[Index].JsonValue;
  end;

  Result := TToonFieldList.TryBuildFromValues(Values, Fields);
end;

function TToonEncoder.TryTabularFields(const JsonArray: TJSONArray; out Fields: TToonFieldList): Boolean;
begin
  var Values: TArray<TJSONValue>;
  SetLength(Values, JsonArray.Count);
  for var Index := 0 to JsonArray.Count - 1 do
  begin
    Values[Index] := JsonArray.Items[Index];
  end;

  Result := TToonFieldList.TryBuildFromValues(Values, Fields);
end;

function TToonEncoder.IsPrimitiveArray(const JsonArray: TJSONArray): Boolean;
begin
  for var Item in JsonArray do
  begin
    if not TToonFieldList.IsPrimitive(Item) then
      Exit(False);
  end;

  Result := True;
end;

function TToonEncoder.ArrayHeaderStart(const Marker, KeyText: string; const Count: Integer): string;
begin
  const DelimiterSymbol = FDelimiter.HeaderSymbol;
  Result := Format('%s%s[%d%s]', [Marker, KeyText, Count, DelimiterSymbol]);
end;

function TToonEncoder.InlineValues(const JsonArray: TJSONArray): string;
begin
  var Values: TArray<string>;
  SetLength(Values, JsonArray.Count);
  for var Index := 0 to JsonArray.Count - 1 do
  begin
    const Item = JsonArray.Items[Index];
    Values[Index] := PrimitiveText(Item);
  end;

  Result := string.Join(FDelimiter.Character, Values);
end;

function TToonEncoder.FieldListText(const Fields: TToonFieldList): string;
begin
  var Entries: TArray<string>;
  SetLength(Entries, Fields.Count);
  for var Index := 0 to Fields.Count - 1 do
  begin
    const Field = Fields[Index];
    const Name = TToonText.EncodeKey(Field.Name);
    if Field.IsLeaf then
    begin
      Entries[Index] := Name;
      Continue;
    end;

    const SubfieldList = FieldListText(Field.Subfields);
    Entries[Index] := Format('%s%s', [Name, SubfieldList]);
  end;

  const Joined = string.Join(FDelimiter.Character, Entries);
  Result := Format('{%s}', [Joined]);
end;

function TToonEncoder.RowText(const JsonObject: TJSONObject; const Fields: TToonFieldList): string;
begin
  var Cells := TStringBuilder.Create;
  try
    CollectCells(JsonObject, Fields, Cells);
    Result := Cells.ToString;
  finally
    Cells.Free;
  end;
end;

procedure TToonEncoder.CollectCells(const JsonObject: TJSONObject; const Fields: TToonFieldList; const Cells: TStringBuilder);
begin
  for var Field in Fields do
  begin
    const Value = JsonObject.GetValue(Field.Name);
    if not Field.IsLeaf then
    begin
      CollectCells(TJSONObject(Value), Field.Subfields, Cells);
      Continue;
    end;

    const HasCells = (Cells.Length > 0);
    if HasCells then
      Cells.Append(FDelimiter.Character);

    const Cell = PrimitiveText(Value);
    Cells.Append(Cell);
  end;
end;

function TToonEncoder.PrimitiveText(const Value: TJSONValue; const IsRoot: Boolean): string;
begin
  if Value is TJSONNumber then
    Exit(TToonNumber.Encode(TJSONNumber(Value)));

  if Value is TJSONString then
  begin
    const Text = TJSONString(Value).Value;
    Exit(TToonText.EncodeValue(Text, FDelimiter.Character, IsRoot));
  end;

  if Value is TJSONBool then
  begin
    if TJSONBool(Value).AsBoolean then
      Exit('true');
    Exit('false');
  end;

  if Value is TJSONNull then
    Exit('null');

  raise EToonEncodingException.CreateFmt(ErrorUnsupportedJsonValue, [Value.ClassName]);
end;

end.
