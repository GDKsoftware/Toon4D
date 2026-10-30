program Toon4D.Tests;

{$IFNDEF TESTINSIGHT}
{$APPTYPE CONSOLE}
{$ENDIF}
{$STRONGLINKTYPES ON}

uses
  System.SysUtils,
  {$IFDEF TESTINSIGHT}
  TestInsight.DUnitX,
  {$ELSE}
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  {$ENDIF }
  DUnitX.TestFramework,
  Toon4D.Tests.Primitives in 'Toon4D.Tests.Primitives.pas',
  Toon4D.Tests.Arrays in 'Toon4D.Tests.Arrays.pas',
  Toon4D.Tests.Nesting in 'Toon4D.Tests.Nesting.pas',
  Toon4D.Tests.Delimiters in 'Toon4D.Tests.Delimiters.pas',
  Toon4D.Tests.EdgeCases in 'Toon4D.Tests.EdgeCases.pas',
  Toon4D.Tests.Integration in 'Toon4D.Tests.Integration.pas',
  Toon4D.Tests.Conformance in 'Toon4D.Tests.Conformance.pas',
  Toon4D.Tests.KeyEdgeCases in 'Toon4D.Tests.KeyEdgeCases.pas',
  Toon4D.Tests.RootArrays in 'Toon4D.Tests.RootArrays.pas',
  Toon4D.Tests.Whitespace in 'Toon4D.Tests.Whitespace.pas',
  Toon4D.Tests.ObjectEdgeCases in 'Toon4D.Tests.ObjectEdgeCases.pas',
  Toon4D.Tests.ArrayEdgeCases in 'Toon4D.Tests.ArrayEdgeCases.pas',
  Toon4D.Tests.OfficialFixtures in 'Toon4D.Tests.OfficialFixtures.pas',
  Toon4D.Tests.Encoder in 'Toon4D.Tests.Encoder.pas';

{$IFNDEF TESTINSIGHT}
var
  Runner: ITestRunner;
  Results: IRunResults;
  Logger: ITestLogger;
  NUnitLogger: ITestLogger;
{$ENDIF}

begin
{$IFDEF TESTINSIGHT}
  TestInsight.DUnitX.RunRegisteredTests;
{$ELSE}
  try
    TDUnitX.CheckCommandLine;
    Runner := TDUnitX.CreateRunner;
    Runner.UseRTTI := True;

    Logger := TDUnitXConsoleLogger.Create(True);
    Runner.AddLogger(Logger);

    NUnitLogger := TDUnitXXMLNUnitFileLogger.Create(TDUnitX.Options.XMLOutputFile);
    Runner.AddLogger(NUnitLogger);

    Results := Runner.Execute;
    if not Results.AllPassed then
      System.ExitCode := EXIT_ERRORS;

    {$IFNDEF CI}
    // Always pause when running from Delphi IDE
    System.Write('Done.. press <Enter> key to quit.');
    System.Readln;
    {$ENDIF}
  except
    on Exception do
      System.ExitCode := EXIT_ERRORS;
  end;
{$ENDIF}
end.
