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
unit Toon4D.Tests.OfficialFixtures;

interface

uses
  DUnitX.TestFramework,
  System.JSON,
  Toon4D.Types;

type
  [TestFixture]
  TOfficialFixturesTests = class
  private
    class function FixturesDirectory: string; static;
    class function OptionsOf(const Fixture: TJSONObject): TToonOptions; static;
    class function DelimiterOf(const Symbol: string): TToonDelimiter; static;
    class function MismatchOf(const Fixture: TJSONObject): string; static;

  public
    [Test]
    [TestCase('Primitives', 'primitives.json')]
    [TestCase('Objects', 'objects.json')]
    [TestCase('ObjectsKeyed', 'objects-keyed.json')]
    [TestCase('ArraysPrimitive', 'arrays-primitive.json')]
    [TestCase('ArraysTabular', 'arrays-tabular.json')]
    [TestCase('ArraysObjects', 'arrays-objects.json')]
    [TestCase('ArraysNested', 'arrays-nested.json')]
    [TestCase('Delimiters', 'delimiters.json')]
    [TestCase('Whitespace', 'whitespace.json')]
    procedure Encode_MatchesOfficialFixtures(const FileName: string);
  end;

implementation

uses
  System.SysUtils,
  System.Classes,
  System.IOUtils,
  Toon4D;

procedure TOfficialFixturesTests.Encode_MatchesOfficialFixtures(const FileName: string);
begin
  const FilePath = TPath.Combine(FixturesDirectory, FileName);
  const Content = TFile.ReadAllText(FilePath, TEncoding.UTF8);
  const Root = TJSONObject.ParseJSONValue(Content) as TJSONObject;
  const Mismatches = TStringList.Create;
  try
    const Fixtures = Root.GetValue<TJSONArray>('tests');
    for var Fixture in Fixtures do
    begin
      const Mismatch = MismatchOf(Fixture as TJSONObject);
      if not Mismatch.IsEmpty then
        Mismatches.Add(Mismatch);
    end;

    const Summary = Format('%d of %d fixtures in %s fail:%s%s', [Mismatches.Count, Fixtures.Count, FileName, sLineBreak, Mismatches.Text]);
    Assert.AreEqual(0, Mismatches.Count, Summary);
  finally
    Mismatches.Free;
    Root.Free;
  end;
end;

class function TOfficialFixturesTests.FixturesDirectory: string;
begin
  const ExecutableDirectory = TPath.GetDirectoryName(ParamStr(0));
  const PlatformDirectory = TPath.GetDirectoryName(ExecutableDirectory);
  const TestsDirectory = TPath.GetDirectoryName(PlatformDirectory);
  Result := TPath.Combine(TestsDirectory, 'fixtures');
end;

class function TOfficialFixturesTests.MismatchOf(const Fixture: TJSONObject): string;
begin
  const Name = Fixture.GetValue<string>('name');
  const Input = Fixture.GetValue('input');
  const Expected = Fixture.GetValue<string>('expected');
  const Actual = TToon.JsonToToon(Input, OptionsOf(Fixture));

  const IsMatch = (Actual = Expected);
  if IsMatch then
    Exit('');

  Result := Format('%s%sexpected:%s%s%sactual:%s%s', [Name, sLineBreak, sLineBreak, Expected, sLineBreak, sLineBreak, Actual]);
end;

class function TOfficialFixturesTests.OptionsOf(const Fixture: TJSONObject): TToonOptions;
begin
  Result := TToonOptions.Default;

  var Options: TJSONObject;
  if not Fixture.TryGetValue<TJSONObject>('options', Options) then
    Exit;

  var Delimiter: string;
  if Options.TryGetValue<string>('delimiter', Delimiter) then
    Result.Delimiter := DelimiterOf(Delimiter);

  var IndentSize: Integer;
  if Options.TryGetValue<Integer>('indentSize', IndentSize) then
    Result.IndentSize := IndentSize;
end;

class function TOfficialFixturesTests.DelimiterOf(const Symbol: string): TToonDelimiter;
begin
  const IsTab = (Symbol = #9);
  if IsTab then
    Exit(TToonDelimiter.Tab);

  const IsPipe = (Symbol = '|');
  if IsPipe then
    Exit(TToonDelimiter.Pipe);

  Result := TToonDelimiter.Comma;
end;

end.
