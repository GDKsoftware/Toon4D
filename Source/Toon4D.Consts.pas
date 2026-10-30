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
unit Toon4D.Consts;

interface

const
  ToonLineBreak = #10;

resourcestring
  ErrorInvalidJson = 'Invalid JSON input: %s';
  ErrorNilJsonValue = 'JSON value cannot be nil';
  ErrorInvalidIndentSize = 'Invalid indent size: %d (must be at least 1)';
  ErrorUnpairedSurrogate = 'String contains an unpaired surrogate at position %d';
  ErrorUnsupportedJsonValue = 'Unsupported JSON value: %s';

implementation

end.
