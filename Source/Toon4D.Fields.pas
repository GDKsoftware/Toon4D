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
unit Toon4D.Fields;

interface

uses
  System.JSON,
  System.Generics.Collections;

type
  TToonFieldList = class;

  TToonField = class
  private
    FName: string;
    FSubfields: TToonFieldList;

  public
    constructor Create(const Name: string; const Subfields: TToonFieldList = nil);
    destructor Destroy; override;

    function IsLeaf: Boolean;

    property Name: string read FName;
    property Subfields: TToonFieldList read FSubfields;
  end;

  TToonFieldList = class(TObjectList<TToonField>)
  private
    class function HaveSameKeys(const First, Other: TJSONObject): Boolean; static;
    class function ColumnOf(const Objects: TArray<TJSONObject>; const Name: string): TArray<TJSONValue>; static;
    class function IsPrimitiveColumn(const Column: TArray<TJSONValue>): Boolean; static;
    class function TryAsObjects(const Values: TArray<TJSONValue>; out Objects: TArray<TJSONObject>): Boolean; static;
    class function TryCreateField(const Objects: TArray<TJSONObject>; const Name: string; out Field: TToonField): Boolean; static;

  public
    class function TryBuild(const Objects: TArray<TJSONObject>; out Fields: TToonFieldList): Boolean; static;
    class function TryBuildFromValues(const Values: TArray<TJSONValue>; out Fields: TToonFieldList): Boolean; static;
    class function IsPrimitive(const Value: TJSONValue): Boolean; static;
  end;

implementation

constructor TToonField.Create(const Name: string; const Subfields: TToonFieldList);
begin
  inherited Create;
  FName      := Name;
  FSubfields := Subfields;
end;

destructor TToonField.Destroy;
begin
  FSubfields.Free;
  inherited;
end;

function TToonField.IsLeaf: Boolean;
begin
  Result := (FSubfields = nil);
end;

class function TToonFieldList.TryBuild(const Objects: TArray<TJSONObject>; out Fields: TToonFieldList): Boolean;
begin
  Fields := nil;
  const HasObjects = (Length(Objects) > 0);
  if not HasObjects then
    Exit(False);

  const First = Objects[0];
  const HasKeys = (First.Count > 0);
  if not HasKeys then
    Exit(False);

  for var Other in Objects do
  begin
    if not HaveSameKeys(First, Other) then
      Exit(False);
  end;

  var Candidate := TToonFieldList.Create;
  try
    for var Pair in First do
    begin
      var Field: TToonField;
      if not TryCreateField(Objects, Pair.JsonString.Value, Field) then
        Exit(False);
      Candidate.Add(Field);
    end;

    Fields    := Candidate;
    Candidate := nil;
    Result    := True;
  finally
    Candidate.Free;
  end;
end;

class function TToonFieldList.TryBuildFromValues(const Values: TArray<TJSONValue>; out Fields: TToonFieldList): Boolean;
begin
  Fields := nil;

  var Objects: TArray<TJSONObject>;
  if not TryAsObjects(Values, Objects) then
    Exit(False);

  Result := TryBuild(Objects, Fields);
end;

class function TToonFieldList.IsPrimitive(const Value: TJSONValue): Boolean;
begin
  Result := not ((Value is TJSONObject) or (Value is TJSONArray));
end;

class function TToonFieldList.HaveSameKeys(const First, Other: TJSONObject): Boolean;
begin
  const HasSameCount = (Other.Count = First.Count);
  if not HasSameCount then
    Exit(False);

  for var Pair in First do
  begin
    const Name = Pair.JsonString.Value;
    const HasKey = Assigned(Other.GetValue(Name));
    if not HasKey then
      Exit(False);
  end;

  Result := True;
end;

class function TToonFieldList.TryCreateField(const Objects: TArray<TJSONObject>; const Name: string; out Field: TToonField): Boolean;
begin
  Field := nil;

  const Column = ColumnOf(Objects, Name);
  if IsPrimitiveColumn(Column) then
  begin
    Field := TToonField.Create(Name);
    Exit(True);
  end;

  var Subfields: TToonFieldList;
  if not TryBuildFromValues(Column, Subfields) then
    Exit(False);

  Field  := TToonField.Create(Name, Subfields);
  Result := True;
end;

class function TToonFieldList.ColumnOf(const Objects: TArray<TJSONObject>; const Name: string): TArray<TJSONValue>;
begin
  SetLength(Result, Length(Objects));
  for var Index := 0 to High(Objects) do
  begin
    Result[Index] := Objects[Index].GetValue(Name);
  end;
end;

class function TToonFieldList.IsPrimitiveColumn(const Column: TArray<TJSONValue>): Boolean;
begin
  for var Value in Column do
  begin
    if not IsPrimitive(Value) then
      Exit(False);
  end;

  Result := True;
end;

class function TToonFieldList.TryAsObjects(const Values: TArray<TJSONValue>; out Objects: TArray<TJSONObject>): Boolean;
begin
  SetLength(Objects, Length(Values));
  for var Index := 0 to High(Values) do
  begin
    if not (Values[Index] is TJSONObject) then
      Exit(False);
    Objects[Index] := TJSONObject(Values[Index]);
  end;

  Result := True;
end;

end.
