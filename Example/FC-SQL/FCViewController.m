//
//  FCViewController.m
//  FC-SQL
//
//  Created by fangqk1991 on 01/18/2019.
//  Copyright (c) 2019 fangqk1991. All rights reserved.
//

#import "FCViewController.h"
#import "FCDatabase.h"
#import "UIColor+Extensions.h"
#import "FCDBSearcher.h"
#import "FCDBAdder.h"
#import "FCDBModifier.h"
#import "FCDBRemover.h"
#import "FCToast.h"

@interface FCViewController ()

@property (nonatomic, strong) FCDatabase *database;
@property (nonatomic, strong) NSArray *records;

@end

@implementation FCViewController

- (instancetype)init
{
    if(self = [super init])
    {
        _records = @[];
    }
    
    return self;
}

- (NSString *)dbFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir = [paths lastObject];
    return [dir stringByAppendingPathComponent:@"db.sqlite"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    {
        self.navigationItem.leftBarButtonItem = self.editButtonItem;
        
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
        self.navigationItem.rightBarButtonItem = addButton;
    }
    
    _database = [[FCDatabase alloc] initWithDBFile:[self dbFile]];
    
    {
        NSString *filepath = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"sql"];
        [_database importSQLFile:filepath];
    }
    
    [self reloadRecords];
}

- (void)insertRecords
{
    FCDBSearcher *builder = [[FCDBSearcher alloc] initWithDatabase:_database];
    [builder setTable:@"random_record"];
    [builder setColumns:@[@"uid", @"name"]];
    NSArray *items = [builder queryList];
    int count = [builder queryCount];
    
    NSLog(@"%@", items);
    NSLog(@"%@ items", @(count));
}

- (void)insertNewObject:(id)sender {
    FCDBAdder *builder = [[FCDBAdder alloc] initWithDatabase:_database];
    [builder setTable:@"random_record"];
    [builder insertKey:@"name" value:[NSString stringWithFormat:@"Value: %05d", rand() % 10000]];
    [builder execute];
    [self reloadRecords];
}

- (void)reloadRecords
{
    FCDBSearcher *builder = [[FCDBSearcher alloc] initWithDatabase:_database];
    [builder setTable:@"random_record"];
    [builder setColumns:@[@"uid", @"name"]];
    _records = [builder queryList];
    [self.tableView reloadData];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _records.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSDictionary *object = self.records[indexPath.row];
    cell.textLabel.text = [object[@"uid"] stringValue];
    cell.detailTextLabel.text = object[@"name"];
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSDictionary *object = _records[indexPath.row];
        
        FCDBRemover *builder = [[FCDBRemover alloc] initWithDatabase:_database];
        [builder setTable:@"random_record"];
        [builder addConditionKey:@"uid" value:object[@"uid"]];
        [builder execute];
        
        [FCToast toastInVC:self message:[NSString stringWithFormat:@"Record removed. [uid: %@]", object[@"uid"]]];
        [self reloadRecords];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *object = _records[indexPath.row];
    
    FCDBModifier *builder = [[FCDBModifier alloc] initWithDatabase:_database];
    [builder setTable:@"random_record"];
    [builder updateKey:@"name" value:[NSString stringWithFormat:@"Value: %05d", rand() % 10000]];
    [builder addConditionKey:@"uid" value:object[@"uid"]];
    [builder execute];
    
    [FCToast toastInVC:self message:[NSString stringWithFormat:@"Value changed. [uid: %@]", object[@"uid"]]];
    [self reloadRecords];
}

@end
