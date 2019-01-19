//
//  FCViewController.m
//  FC-SQL
//
//  Created by fangqk1991 on 01/18/2019.
//  Copyright (c) 2019 fangqk1991. All rights reserved.
//

#import "FCViewController.h"
#import "UIColor+Extensions.h"
#import "FCToast.h"
#import "FCDB.h"
#import "FCActionView.h"

@interface FCViewController ()

@property (nonatomic, strong) FCDatabase *database;
@property (nonatomic, strong) NSArray *records;

@property (nonatomic, strong) NSString *sortKey;
@property (nonatomic, strong) NSString *sortDirection;

@end

@implementation FCViewController

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
    
    _records = @[];
    _sortKey = @"uid";
    _sortDirection = @"ASC";
    
    {
        self.navigationItem.leftBarButtonItem = self.editButtonItem;
        
        UIBarButtonItem *playButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onPlay:)];
        self.navigationItem.rightBarButtonItem = playButton;
    }
    
    _database = [[FCDatabase alloc] initWithDBFile:[self dbFile]];
    
    {
        NSString *filepath = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"sql"];
        [_database importSQLFile:filepath];
    }
    
    [self reloadRecords];
}

- (void)onPlay:(id)sender {
    
    FCActionView *dialog = [FCActionView dialogWithTitle:@"Choose"];
    [dialog addAction:@"Insert" handler:^(UIAlertAction *action) {
        FCDBAdder *adder = [_database fc_adder];
        [adder setTable:@"random_record"];
        [adder insertKey:@"name" value:[NSString stringWithFormat:@"V - %05d", rand() % 10000]];
        [adder execute];
        [self reloadRecords];
    }];
    [dialog addAction:@"Remove uid > 5" handler:^(UIAlertAction *action) {
        FCDBRemover *remover = [_database fc_remover];
        [remover setTable:@"random_record"];
        [remover addSpecialCondition:@"uid > ?", @(5)];
        [remover execute];
        [self reloadRecords];
    }];
    [dialog addAction:@"ORDER BY uid ASC" handler:^(UIAlertAction *action) {
        _sortKey = @"uid";
        _sortDirection = @"ASC";
        [self reloadRecords];
    }];
    [dialog addAction:@"ORDER BY name DESC" handler:^(UIAlertAction *action) {
        _sortKey = @"name";
        _sortDirection = @"DESC";
        [self reloadRecords];
    }];
    [dialog showInVC:self];
}

- (void)reloadRecords
{
    FCDBSearcher *searcher = [_database fc_searcher];
    [searcher setTable:@"random_record"];
    [searcher setColumns:@[@"uid", @"name"]];
    [searcher addOrderRule:_sortKey direction:_sortDirection];
    _records = [searcher queryList];
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
        
        FCDBRemover *remover = [_database fc_remover];
        [remover setTable:@"random_record"];
        [remover addConditionKey:@"uid" value:object[@"uid"]];
        [remover execute];
        
        [FCToast toastInVC:self message:[NSString stringWithFormat:@"Record removed. [%@: %@]", object[@"uid"], object[@"name"]]];
        [self reloadRecords];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *object = _records[indexPath.row];
    
    FCDBModifier *modifier = [_database fc_modifier];
    [modifier setTable:@"random_record"];
    [modifier updateKey:@"name" value:[NSString stringWithFormat:@"C - %04d", rand() % 10000]];
    [modifier addConditionKey:@"uid" value:object[@"uid"]];
    [modifier execute];
    
    [FCToast toastInVC:self message:[NSString stringWithFormat:@"Value changed. [%@: %@]", object[@"uid"], object[@"name"]]];
    [self reloadRecords];
}

@end
