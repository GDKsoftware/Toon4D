{*******************************************************}
{                                                       }
{         Toon4D Library - LLM Data Optimization        }
{                                                       }
{                 DUnitX Test Suite                     }
{              Integration & Real-World Tests           }
{                                                       }
{*******************************************************}
unit Toon4D.Tests.Integration;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils,
  System.JSON;

type
  [TestFixture]
  TIntegrationTests = class
  public
    [Test]
    procedure RestApiUserList_ShouldEncodeAsTabular;

    [Test]
    procedure RestApiNestedResponse_ShouldEncodeCorrectly;

    [Test]
    procedure NestedSingleKeyPath_ShouldStayNested;

    [Test]
    procedure EcommerceOrderList_ShouldEncodeTabularWithMixedTypes;

    [Test]
    procedure DatabaseQueryResult_ShouldEncodeAsTabular;

    [Test]
    procedure ConfigurationFile_ShouldEncodeNestedObjects;

    [Test]
    procedure LargeDataset100Rows_ShouldHandlePerformance;

    [Test]
    procedure LargeDataset1000Rows_ShouldHandlePerformance;

    [Test]
    procedure DeeplyNested20Levels_ShouldHandleDepth;

    [Test]
    procedure MixedDelimitersInData_ShouldChooseCorrectDelimiter;

    [Test]
    procedure UnicodeMultilingual_ShouldPreserveAllCharacters;

    [Test]
    procedure EmojiInKeysAndValues_ShouldHandleCorrectly;

    [Test]
    procedure TimeSeriesData_ShouldEncodeAsTabular;

    [Test]
    procedure GitHubRepositoryList_ShouldEncodeAsTabular;

    [Test]
    procedure ProductCatalog_ShouldEncodeWithNesting;

    [Test]
    procedure AnalyticsReport_ShouldEncodeComplexStructure;

    [Test]
    procedure EmptyArraysInComplexStructure_ShouldHandleGracefully;

    [Test]
    procedure NullValuesInTabular_ShouldEncodeNull;

    [Test]
    procedure MixedPrimitiveAndObjectArrays_ShouldDetectFormats;

    [Test]
    procedure LongStringsInTabular_ShouldQuoteWhenNeeded;

    [Test]
    procedure NumericStringsInData_ShouldQuoteCorrectly;

    [Test]
    procedure BooleanStringsInData_ShouldQuoteCorrectly;

    [Test]
    procedure ReservedWordsInData_ShouldQuoteCorrectly;

    [Test]
    procedure SpecialCharactersInKeys_ShouldQuoteKeys;

    [Test]
    procedure TokenCountComparison_JsonVsToon_ShouldReduceTokens;

    [Test]
    procedure RealWorldLlmPrompt_UserDataAnalysis;

    [Test]
    procedure RealWorldLlmPrompt_ProductRecommendation;

    [Test]
    procedure RealWorldLlmPrompt_DataValidation;

    [Test]
    procedure AllDelimiterTypes_ShouldWorkCorrectly;

    [Test]
    procedure AllIndentSizes_ShouldFormatCorrectly;

    [Test]
    procedure GracefulDegradation_InvalidNumbers_ShouldConvertToNull;
  end;

implementation

uses
  Toon4D,
  Toon4D.Types,
  Toon4D.Tests.Helpers;

procedure TIntegrationTests.RestApiUserList_ShouldEncodeAsTabular;
var
  JsonString: string;
  ToonOutput: string;
begin
  JsonString := '''
  {
    "users": [
      {"id": 1, "name": "Alice Johnson", "role": "admin", "active": true},
      {"id": 2, "name": "Bob Smith", "role": "user", "active": true},
      {"id": 3, "name": "Charlie Brown", "role": "user", "active": false}
    ]
  }
  ''';

  ToonOutput := TToon.JsonToToon(JsonString);

  Assert.Contains(ToonOutput, 'users[3]{id,name,role,active}:');
  Assert.Contains(ToonOutput, '1,Alice Johnson,admin,true');
  Assert.Contains(ToonOutput, '2,Bob Smith,user,true');
  Assert.Contains(ToonOutput, '3,Charlie Brown,user,false');
end;

procedure TIntegrationTests.RestApiNestedResponse_ShouldEncodeCorrectly;
var
  JsonString: string;
  ToonOutput: string;
begin
  JsonString := '''
  {
    "data": {
      "metadata": {
        "version": "1.0",
        "timestamp": "2025-01-15T10:30:00Z"
      }
    }
  }
  ''';

  ToonOutput := TToon.JsonToToon(JsonString);

  Assert.Contains(ToonOutput, 'data:');
  Assert.Contains(ToonOutput, 'metadata:');
  Assert.Contains(ToonOutput, 'version: "1.0"');
  Assert.Contains(ToonOutput, 'timestamp:');
end;

procedure TIntegrationTests.NestedSingleKeyPath_ShouldStayNested;
var
  JsonString: string;
  ToonOutput: string;
begin
  JsonString := '{"data":{"metadata":{"version":1}}}';

  ToonOutput := TToon.JsonToToon(JsonString);

  Assert.AreEqual('data:'#10'  metadata:'#10'    version: 1', ToonOutput);
end;

procedure TIntegrationTests.EcommerceOrderList_ShouldEncodeTabularWithMixedTypes;
var
  JsonString: string;
  ToonOutput: string;
begin
  JsonString := '''
  {
    "orders": [
      {"orderId": "ORD-001", "customer": "Alice", "amount": 99.99, "shipped": true},
      {"orderId": "ORD-002", "customer": "Bob", "amount": 149.5, "shipped": false},
      {"orderId": "ORD-003", "customer": "Charlie", "amount": 75, "shipped": true}
    ]
  }
  ''';

  ToonOutput := TToon.JsonToToon(JsonString);

  Assert.Contains(ToonOutput, 'orders[3]{orderId,customer,amount,shipped}:');
  Assert.Contains(ToonOutput, 'ORD-001,Alice,99.99,true');
  Assert.Contains(ToonOutput, 'ORD-002,Bob,149.5,false');
  Assert.Contains(ToonOutput, 'ORD-003,Charlie,75,true');
end;

procedure TIntegrationTests.DatabaseQueryResult_ShouldEncodeAsTabular;
var
  JsonString: string;
  ToonOutput: string;
begin
  JsonString := '''
  {
    "results": [
      {"id": 1, "firstName": "John", "lastName": "Doe", "age": 30, "city": "New York"},
      {"id": 2, "firstName": "Jane", "lastName": "Smith", "age": 25, "city": "Los Angeles"},
      {"id": 3, "firstName": "Mike", "lastName": "Johnson", "age": 35, "city": "Chicago"}
    ]
  }
  ''';

  ToonOutput := TToon.JsonToToon(JsonString);

  Assert.Contains(ToonOutput, 'results[3]{id,firstName,lastName,age,city}:');
  Assert.Contains(ToonOutput, '1,John,Doe,30,New York');
  Assert.Contains(ToonOutput, '2,Jane,Smith,25,Los Angeles');
  Assert.Contains(ToonOutput, '3,Mike,Johnson,35,Chicago');
end;

procedure TIntegrationTests.ConfigurationFile_ShouldEncodeNestedObjects;
var
  JsonString: string;
  ToonOutput: string;
begin
  JsonString := '''
  {
    "database": {
      "host": "localhost",
      "port": 5432,
      "name": "mydb"
    },
    "cache": {
      "enabled": true,
      "ttl": 3600
    }
  }
  ''';

  ToonOutput := TToon.JsonToToon(JsonString);

  Assert.Contains(ToonOutput, 'database:');
  Assert.Contains(ToonOutput, 'host: localhost');
  Assert.Contains(ToonOutput, 'port: 5432');
  Assert.Contains(ToonOutput, 'cache:');
  Assert.Contains(ToonOutput, 'enabled: true');
  Assert.Contains(ToonOutput, 'ttl: 3600');
end;

procedure TIntegrationTests.LargeDataset100Rows_ShouldHandlePerformance;
var
  JsonBuilder: TStringBuilder;
  Index: Integer;
  JsonString: string;
  ToonOutput: string;
begin
  JsonBuilder := TStringBuilder.Create;
  try
    JsonBuilder.Append('{"items":[');
    for Index := 1 to 100 do
    begin
      if Index > 1 then
        JsonBuilder.Append(',');
      JsonBuilder.AppendFormat('{"id":%d,"name":"Item%d","value":%d}', [Index, Index, Index * 10]);
    end;
    JsonBuilder.Append(']}');
    JsonString := JsonBuilder.ToString;
  finally
    JsonBuilder.Free;
  end;

  ToonOutput := TToon.JsonToToon(JsonString);

  Assert.Contains(ToonOutput, 'items[100]{id,name,value}:');
  Assert.Contains(ToonOutput, '1,Item1,10');
  Assert.Contains(ToonOutput, '100,Item100,1000');
end;

procedure TIntegrationTests.LargeDataset1000Rows_ShouldHandlePerformance;
var
  JsonBuilder: TStringBuilder;
  Index: Integer;
  JsonString: string;
  ToonOutput: string;
begin
  JsonBuilder := TStringBuilder.Create;
  try
    JsonBuilder.Append('{"records":[');
    for Index := 1 to 1000 do
    begin
      if Index > 1 then
        JsonBuilder.Append(',');
      JsonBuilder.AppendFormat('{"id":%d,"status":"active"}', [Index]);
    end;
    JsonBuilder.Append(']}');
    JsonString := JsonBuilder.ToString;
  finally
    JsonBuilder.Free;
  end;

  ToonOutput := TToon.JsonToToon(JsonString);

  Assert.Contains(ToonOutput, 'records[1000]{id,status}:');
  Assert.IsTrue(Length(ToonOutput) > 0, 'Output should not be empty');
end;

procedure TIntegrationTests.DeeplyNested20Levels_ShouldHandleDepth;
var
  JsonBuilder: TStringBuilder;
  Index: Integer;
  JsonString: string;
  ToonOutput: string;
begin
  JsonBuilder := TStringBuilder.Create;
  try
    for Index := 1 to 20 do
      JsonBuilder.AppendFormat('{"level%d":', [Index]);

    JsonBuilder.Append('"value"');

    for Index := 1 to 20 do
      JsonBuilder.Append('}');

    JsonString := JsonBuilder.ToString;
  finally
    JsonBuilder.Free;
  end;

  ToonOutput := TToon.JsonToToon(JsonString);

  Assert.Contains(ToonOutput, 'level1:');
  Assert.Contains(ToonOutput, 'level20:');
  Assert.Contains(ToonOutput, 'value');
end;

procedure TIntegrationTests.MixedDelimitersInData_ShouldChooseCorrectDelimiter;
var
  JsonString: string;
  ToonOutput: string;
  Options: TToonOptions;
begin
  JsonString := '''
  {
    "items": ["value,with,commas", "value-with-dashes", "normal"]
  }
  ''';

  Options := TToonTestHelpers.Delimited(TToonDelimiter.Pipe);
  ToonOutput := TToon.JsonToToon(JsonString, Options);

  Assert.Contains(ToonOutput, 'items[3|]:');
  Assert.Contains(ToonOutput, 'value,with,commas|value-with-dashes|normal');
end;

procedure TIntegrationTests.UnicodeMultilingual_ShouldPreserveAllCharacters;
var
  JsonString: string;
  ToonOutput: string;
begin
  JsonString := '''
  {
    "greeting": {
      "english": "Hello",
      "chinese": "你好",
      "arabic": "مرحبا",
      "hebrew": "שלום",
      "japanese": "こんにちは"
    }
  }
  ''';

  ToonOutput := TToon.JsonToToon(JsonString);

  Assert.Contains(ToonOutput, 'Hello');
  Assert.Contains(ToonOutput, '你好');
  Assert.Contains(ToonOutput, 'مرحبا');
  Assert.Contains(ToonOutput, 'שלום');
  Assert.Contains(ToonOutput, 'こんにちは');
end;

procedure TIntegrationTests.EmojiInKeysAndValues_ShouldHandleCorrectly;
var
  JsonString: string;
  ToonOutput: string;
begin
  JsonString := '''
  {
    "reactions": [
      {"emoji": "👍", "count": 5},
      {"emoji": "❤️", "count": 3},
      {"emoji": "🎉", "count": 2}
    ]
  }
  ''';

  ToonOutput := TToon.JsonToToon(JsonString);

  Assert.Contains(ToonOutput, 'reactions[3]{emoji,count}:');
  Assert.Contains(ToonOutput, '👍');
  Assert.Contains(ToonOutput, '❤️');
  Assert.Contains(ToonOutput, '🎉');
end;

procedure TIntegrationTests.TimeSeriesData_ShouldEncodeAsTabular;
var
  JsonString: string;
  ToonOutput: string;
begin
  JsonString := '''
  {
    "metrics": [
      {"timestamp": "2025-01-01T00:00:00Z", "cpu": 45.2, "memory": 62.1},
      {"timestamp": "2025-01-01T01:00:00Z", "cpu": 52.8, "memory": 58.3},
      {"timestamp": "2025-01-01T02:00:00Z", "cpu": 38.5, "memory": 64.7}
    ]
  }
  ''';

  ToonOutput := TToon.JsonToToon(JsonString);

  Assert.Contains(ToonOutput, 'metrics[3]{timestamp,cpu,memory}:');
  Assert.Contains(ToonOutput, '"2025-01-01T00:00:00Z",45.2,62.1');
end;

procedure TIntegrationTests.GitHubRepositoryList_ShouldEncodeAsTabular;
var
  JsonString: string;
  ToonOutput: string;
begin
  JsonString := '''
  {
    "repositories": [
      {"name": "awesome-project", "stars": 1250, "language": "Pascal", "active": true},
      {"name": "cool-library", "stars": 850, "language": "Delphi", "active": true},
      {"name": "old-tool", "stars": 120, "language": "Pascal", "active": false}
    ]
  }
  ''';

  ToonOutput := TToon.JsonToToon(JsonString);

  Assert.Contains(ToonOutput, 'repositories[3]{name,stars,language,active}:');
  Assert.Contains(ToonOutput, 'awesome-project,1250,Pascal,true');
end;

procedure TIntegrationTests.ProductCatalog_ShouldEncodeWithNesting;
var
  JsonString: string;
  ToonOutput: string;
begin
  JsonString := '''
  {
    "category": "Electronics",
    "products": [
      {"id": "P001", "name": "Laptop", "price": 999.99},
      {"id": "P002", "name": "Mouse", "price": 29.99},
      {"id": "P003", "name": "Keyboard", "price": 79.99}
    ]
  }
  ''';

  ToonOutput := TToon.JsonToToon(JsonString);

  Assert.Contains(ToonOutput, 'category: Electronics');
  Assert.Contains(ToonOutput, 'products[3]{id,name,price}:');
  Assert.Contains(ToonOutput, 'P001,Laptop,999.99');
end;

procedure TIntegrationTests.AnalyticsReport_ShouldEncodeComplexStructure;
var
  JsonString: string;
  ToonOutput: string;
begin
  JsonString := '''
  {
    "report": {
      "period": "2025-Q1",
      "summary": {
        "totalUsers": 1500,
        "activeUsers": 1200,
        "revenue": 45000.50
      },
      "topCountries": [
        {"country": "USA", "users": 500},
        {"country": "UK", "users": 300},
        {"country": "Germany", "users": 200}
      ]
    }
  }
  ''';

  ToonOutput := TToon.JsonToToon(JsonString);

  Assert.Contains(ToonOutput, 'report:');
  Assert.Contains(ToonOutput, 'period: 2025-Q1');
  Assert.Contains(ToonOutput, 'summary:');
  Assert.Contains(ToonOutput, 'totalUsers: 1500');
  Assert.Contains(ToonOutput, 'topCountries[3]{country,users}:');
  Assert.Contains(ToonOutput, 'USA,500');
end;

procedure TIntegrationTests.EmptyArraysInComplexStructure_ShouldHandleGracefully;
var
  JsonString: string;
  ToonOutput: string;
begin
  JsonString := '''
  {
    "data": {
      "items": [],
      "count": 0
    }
  }
  ''';

  ToonOutput := TToon.JsonToToon(JsonString);

  Assert.Contains(ToonOutput, 'items: []');
  Assert.Contains(ToonOutput, 'count: 0');
end;

procedure TIntegrationTests.NullValuesInTabular_ShouldEncodeNull;
var
  JsonString: string;
  ToonOutput: string;
begin
  JsonString := '''
  {
    "users": [
      {"id": 1, "name": "Alice", "email": "alice@example.com"},
      {"id": 2, "name": "Bob", "email": null},
      {"id": 3, "name": "Charlie", "email": "charlie@example.com"}
    ]
  }
  ''';

  ToonOutput := TToon.JsonToToon(JsonString);

  Assert.Contains(ToonOutput, 'users[3]{id,name,email}:');
  Assert.Contains(ToonOutput, '2,Bob,null');
end;

procedure TIntegrationTests.MixedPrimitiveAndObjectArrays_ShouldDetectFormats;
var
  JsonString: string;
  ToonOutput: string;
begin
  JsonString := '''
  {
    "tags": ["tag1", "tag2", "tag3"],
    "users": [
      {"name": "Alice", "role": "admin"},
      {"name": "Bob", "role": "user"}
    ]
  }
  ''';

  ToonOutput := TToon.JsonToToon(JsonString);

  Assert.Contains(ToonOutput, 'tags[3]: tag1,tag2,tag3');
  Assert.Contains(ToonOutput, 'users[2]{name,role}:');
  Assert.Contains(ToonOutput, 'Alice,admin');
end;

procedure TIntegrationTests.LongStringsInTabular_ShouldQuoteWhenNeeded;
var
  JsonString: string;
  ToonOutput: string;
begin
  JsonString := '''
  {
    "messages": [
      {"id": 1, "text": "Short message"},
      {"id": 2, "text": "Message with: colon"},
      {"id": 3, "text": "Normal text here"}
    ]
  }
  ''';

  ToonOutput := TToon.JsonToToon(JsonString);

  Assert.Contains(ToonOutput, 'messages[3]{id,text}:');
  Assert.Contains(ToonOutput, '1,Short message');
  Assert.Contains(ToonOutput, '"Message with: colon"');
end;

procedure TIntegrationTests.NumericStringsInData_ShouldQuoteCorrectly;
var
  JsonString: string;
  ToonOutput: string;
begin
  JsonString := '''
  {
    "codes": [
      {"id": 1, "code": "123"},
      {"id": 2, "code": "ABC"},
      {"id": 3, "code": "456"}
    ]
  }
  ''';

  ToonOutput := TToon.JsonToToon(JsonString);

  Assert.Contains(ToonOutput, 'codes[3]{id,code}:');
  Assert.Contains(ToonOutput, '"123"');
  Assert.Contains(ToonOutput, 'ABC');
  Assert.Contains(ToonOutput, '"456"');
end;

procedure TIntegrationTests.BooleanStringsInData_ShouldQuoteCorrectly;
var
  JsonString: string;
  ToonOutput: string;
begin
  JsonString := '''
  {
    "items": [
      {"id": 1, "value": "true"},
      {"id": 2, "value": "normal"},
      {"id": 3, "value": "false"}
    ]
  }
  ''';

  ToonOutput := TToon.JsonToToon(JsonString);

  Assert.Contains(ToonOutput, 'items[3]{id,value}:');
  Assert.Contains(ToonOutput, '"true"');
  Assert.Contains(ToonOutput, 'normal');
  Assert.Contains(ToonOutput, '"false"');
end;

procedure TIntegrationTests.ReservedWordsInData_ShouldQuoteCorrectly;
var
  JsonString: string;
  ToonOutput: string;
begin
  JsonString := '''
  {
    "entries": [
      {"name": "null"},
      {"name": "true"},
      {"name": "false"},
      {"name": "normal"}
    ]
  }
  ''';

  ToonOutput := TToon.JsonToToon(JsonString);

  Assert.Contains(ToonOutput, 'entries[4]{name}:');
  Assert.Contains(ToonOutput, '"null"');
  Assert.Contains(ToonOutput, '"true"');
  Assert.Contains(ToonOutput, '"false"');
  Assert.Contains(ToonOutput, 'normal');
end;

procedure TIntegrationTests.SpecialCharactersInKeys_ShouldQuoteKeys;
var
  JsonString: string;
  ToonOutput: string;
begin
  JsonString := '''
  {
    "user-name": "Alice",
    "first name": "Bob",
    "email@address": "test@example.com"
  }
  ''';

  ToonOutput := TToon.JsonToToon(JsonString);

  Assert.Contains(ToonOutput, '"user-name": Alice');
  Assert.Contains(ToonOutput, '"first name": Bob');
  Assert.Contains(ToonOutput, '"email@address": test@example.com');
end;

procedure TIntegrationTests.TokenCountComparison_JsonVsToon_ShouldReduceTokens;
var
  JsonString: string;
  ToonOutput: string;
  JsonLength: Integer;
  ToonLength: Integer;
  ReductionPercent: Double;
begin
  JsonString := '''
  {
    "users": [
      {"id": 1, "name": "Alice", "role": "admin", "active": true},
      {"id": 2, "name": "Bob", "role": "user", "active": true},
      {"id": 3, "name": "Charlie", "role": "user", "active": false},
      {"id": 4, "name": "Diana", "role": "admin", "active": true},
      {"id": 5, "name": "Eve", "role": "user", "active": true}
    ]
  }
  ''';

  ToonOutput := TToon.JsonToToon(JsonString);

  JsonLength := Length(JsonString);
  ToonLength := Length(ToonOutput);
  ReductionPercent := ((JsonLength - ToonLength) / JsonLength) * 100;

  Assert.IsTrue(ToonLength < JsonLength, 'TOON output should be shorter than JSON');
  Assert.IsTrue(ReductionPercent >= 20, 'Should achieve at least 20% reduction for tabular data');
end;

procedure TIntegrationTests.RealWorldLlmPrompt_UserDataAnalysis;
var
  JsonString: string;
  ToonOutput: string;
begin
  JsonString := '''
  {
    "task": "Analyze user activity patterns",
    "users": [
      {"userId": "U001", "lastLogin": "2025-01-15", "activityScore": 85, "premium": true},
      {"userId": "U002", "lastLogin": "2025-01-14", "activityScore": 62, "premium": false},
      {"userId": "U003", "lastLogin": "2025-01-15", "activityScore": 91, "premium": true},
      {"userId": "U004", "lastLogin": "2025-01-13", "activityScore": 45, "premium": false}
    ],
    "instructions": "Identify users who need engagement campaigns"
  }
  ''';

  ToonOutput := TToon.JsonToToon(JsonString);

  Assert.Contains(ToonOutput, 'task: Analyze user activity patterns');
  Assert.Contains(ToonOutput, 'users[4]{userId,lastLogin,activityScore,premium}:');
  Assert.Contains(ToonOutput, 'U001,2025-01-15,85,true');
  Assert.Contains(ToonOutput, 'instructions:');
end;

procedure TIntegrationTests.RealWorldLlmPrompt_ProductRecommendation;
var
  JsonString: string;
  ToonOutput: string;
begin
  JsonString := '''
  {
    "context": "E-commerce product recommendations",
    "userProfile": {
      "interests": ["electronics", "gaming"],
      "budget": 500
    },
    "products": [
      {"productId": "P100", "name": "Gaming Mouse", "price": 79.99, "category": "electronics"},
      {"productId": "P101", "name": "Mechanical Keyboard", "price": 149.99, "category": "electronics"},
      {"productId": "P102", "name": "Gaming Headset", "price": 89.99, "category": "electronics"}
    ],
    "question": "Which products best match the user profile?"
  }
  ''';

  ToonOutput := TToon.JsonToToon(JsonString);

  Assert.Contains(ToonOutput, 'context: E-commerce product recommendations');
  Assert.Contains(ToonOutput, 'userProfile:');
  Assert.Contains(ToonOutput, 'products[3]{productId,name,price,category}:');
  Assert.Contains(ToonOutput, 'P100,Gaming Mouse,79.99,electronics');
  Assert.Contains(ToonOutput, 'question:');
end;

procedure TIntegrationTests.RealWorldLlmPrompt_DataValidation;
var
  JsonString: string;
  ToonOutput: string;
begin
  JsonString := '''
  {
    "task": "Validate data quality",
    "records": [
      {"id": 1, "email": "valid@example.com", "age": 25, "status": "active"},
      {"id": 2, "email": "invalid-email", "age": -5, "status": "unknown"},
      {"id": 3, "email": "another@example.com", "age": 30, "status": "active"}
    ],
    "rules": {
      "email": "must be valid format",
      "age": "must be positive",
      "status": "must be active or inactive"
    },
    "output": "List invalid records with reasons"
  }
  ''';

  ToonOutput := TToon.JsonToToon(JsonString);

  Assert.Contains(ToonOutput, 'task: Validate data quality');
  Assert.Contains(ToonOutput, 'records[3]{id,email,age,status}:');
  Assert.Contains(ToonOutput, '2,invalid-email,-5,unknown');
  Assert.Contains(ToonOutput, 'rules:');
  Assert.Contains(ToonOutput, 'output:');
end;

procedure TIntegrationTests.AllDelimiterTypes_ShouldWorkCorrectly;
var
  JsonString: string;
  ToonComma: string;
  ToonTab: string;
  ToonPipe: string;
begin
  JsonString := '{"items":["a","b","c"]}';

  ToonComma := TToon.JsonToToon(JsonString, TToonOptions.Default);
  Assert.Contains(ToonComma, 'items[3]: a,b,c');

  ToonTab := TToon.JsonToToon(JsonString, TToonTestHelpers.Delimited(TToonDelimiter.Tab));
  Assert.Contains(ToonTab, 'items[3' + #9 + ']:');

  ToonPipe := TToon.JsonToToon(JsonString, TToonTestHelpers.Delimited(TToonDelimiter.Pipe));
  Assert.Contains(ToonPipe, 'items[3|]: a|b|c');
end;

procedure TIntegrationTests.AllIndentSizes_ShouldFormatCorrectly;
var
  JsonString: string;
  Toon2Spaces: string;
  Toon4Spaces: string;
begin
  JsonString := '{"outer":{"inner":"value"}}';

  Toon2Spaces := TToon.JsonToToon(JsonString, TToonTestHelpers.Indented(2));
  Assert.IsTrue(Toon2Spaces.Contains('  '), 'Should contain 2-space indentation');

  Toon4Spaces := TToon.JsonToToon(JsonString, TToonTestHelpers.Indented(4));
  Assert.IsTrue(Toon4Spaces.Contains('    '), 'Should contain 4-space indentation');
end;

procedure TIntegrationTests.GracefulDegradation_InvalidNumbers_ShouldConvertToNull;
var
  JsonValue: TJSONObject;
  ToonOutput: string;
begin
  JsonValue := TJSONObject.Create;
  try
    JsonValue.AddPair('validNumber', TJSONNumber.Create(42));
    JsonValue.AddPair('infinity', TJSONNumber.Create(1.0 / 0.0));
    JsonValue.AddPair('negativeInfinity', TJSONNumber.Create(-1.0 / 0.0));
    JsonValue.AddPair('notANumber', TJSONNumber.Create(0.0 / 0.0));

    ToonOutput := TToon.JsonToToon(JsonValue);

    Assert.Contains(ToonOutput, 'validNumber: 42');
    Assert.Contains(ToonOutput, 'infinity: null');
    Assert.Contains(ToonOutput, 'negativeInfinity: null');
    Assert.Contains(ToonOutput, 'notANumber: null');
  finally
    JsonValue.Free;
  end;
end;

end.
