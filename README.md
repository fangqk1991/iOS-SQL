# 简介
这是一个对 SQLite 进行简单增删改查的调用框架

<!--
[![CI Status](https://img.shields.io/travis/fangqk1991/FC-SQL.svg?style=flat)](https://travis-ci.org/fangqk1991/FC-SQL)
[![Version](https://img.shields.io/cocoapods/v/FC-SQL.svg?style=flat)](https://cocoapods.org/pods/FC-SQL)
[![License](https://img.shields.io/cocoapods/l/FC-SQL.svg?style=flat)](https://cocoapods.org/pods/FC-SQL)
[![Platform](https://img.shields.io/cocoapods/p/FC-SQL.svg?style=flat)](https://cocoapods.org/pods/FC-SQL)
-->

## 依赖
* iOS 8+
* [FMDB 2.7](https://github.com/ccgus/fmdb)

## 安装
FC-SQL 使用 [CocoaPods](https://cocoapods.org) 进行安装.

编辑 `podfile`

```ruby
target 'MyApp' do
	...
    pod 'FC-SQL', :git => 'https://github.com/fangqk1991/iOS-SQL.git', :tag => '0.1.0'
end
```

运行

```
pod install
```

## 使用
```
#import "FCDB.h"
```

### FCDatabase
```
// 初始化方法
- (instancetype)initWithDBFile:(NSString *)dbFile;

// 导入数据库文件
- (void)importSQLFile:(NSString *)sqlFile;

// 直接查询
- (NSArray *)executeQuery:(NSString *)query values:(NSArray *)params;
- (BOOL)executeUpdate:(NSString *)query values:(NSArray *)params;
```

### BuilderBase (Adder/Modifier/Remover/Searcher 的基类)
```
// 初始化方法
- (instancetype)initWithDatabase:(FCDatabase *)database;

// 添加执行条件（简单匹配）
- (void)addConditionKey:(NSString *)key value:(id)value;


// 添加执行条件（自定义）
- (void)addSpecialCondition:(NSString *)condition, ...;

...
```

### FCDBAdder
```
- (void)insertKey:(NSString *)key value:(NSString *)value;
- (void)execute;
```

### FCDBModifier
```
- (void)updateKey:(NSString *)key value:(NSString *)value;
- (void)execute;
```

### FCDBRemover
```
- (void)execute;
```

### FCDBSearcher
```
// 采用 DISTINCT
- (void)markDistinct;

// 设置列
- (void)setColumns:(NSArray *)columns;

// 添加列
- (void)addColumn:(NSString *)column;

// 添加排序规则
- (void)addOrderRule:(NSString *)sortKey direction:(NSString *)direction;

// 设置页码信息
- (void)setPageInfo:(int)page feedsPerPage:(int)feedsPerPage;

// 设置附加语句
- (void)setOptionStr:(NSString *)optionStr;

// 查询
- (NSArray *)queryList;
- (int)queryCount;
```

### 示例
请到 `Example` 工程目录下，执行 `pod install` 后运行工程

```
// Adder
FCDBAdder *adder = [_database fc_adder];
[adder setTable:@"SOME_TABLE"];
[adder insertKey:@"COLUMN_1" value:@"SOME NAME"];
[adder insertKey:@"COLUMN_2" value:@"SOME NAME"];
[adder execute];

// Modifier
FCDBModifier *modifier = [_database fc_modifier];
[modifier setTable:@"SOME_TABLE"];
[modifier updateKey:@"COLUMN 1" value:@"NEW NAME"];
[modifier addConditionKey:@"uid" value:@"SOME VALUE"];
[modifier execute];

// Remover
FCDBRemover *remover = [_database fc_remover];
[remover setTable:@"SOME_TABLE"];
[remover addSpecialCondition:@"uid > ?", @(5)];
[remover execute];
[self reloadRecords];

// Searcher
FCDBSearcher *searcher = [_database fc_searcher];
[searcher setTable:@"SOME_TABLE"];
[searcher setColumns:@[@"uid", @"name"]];
[searcher addOrderRule:_sortKey direction:_sortDirection];
_records = [searcher queryList];
```

## Author

fangqk1991, me@fangqk.com

## License

FC-SQL is available under the MIT license. See the LICENSE file for more info.
