//
//  VKFriendDTVC.m
//  UFSVKFriendList
//
//  Created by noname on 02.06.16.
//  Copyright © 2016 KOT LLC. All rights reserved.
//

#import "VKFriendDTVC.h"
#import "Constants.h"
#import "DataManager.h"
#import "VKFriendDetailTableViewCell.h"
#import "VKFriendDTVC.h"
#import "VKSdk.h"
#import "UIImageView+AFNetworking.h"

@interface VKFriendDTVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation VKFriendDTVC {
    UIRefreshControl *refresh;
    NSMutableArray *groupsArray;
}

@dynamic tableView;

static NSInteger groupsPerRequest = 10;

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self->groupsArray = [NSMutableArray array];
    [self setupUI];
}

- (void)setupUI {
    refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(pullTo:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refresh];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [refresh beginRefreshing];
    [self pullTo:refresh];
}

#pragma mark - Data Load
- (void)loadDataFromServer {
    [[DataManager sharedInstance] getGroupsForUserId:[[[VKSdk accessToken] userId] integerValue]
                                               offset:self->groupsArray.count
                                                count:groupsPerRequest
                                              success:^(NSArray *groups) {
                                                  [self->groupsArray addObjectsFromArray:groups];
                                                  NSMutableArray *nextPart = [NSMutableArray array];
                                                  for (int i = (int)[self->groupsArray count] - (int)[groups count]; i < [self->groupsArray count]; i++) {
                                                      [nextPart addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                                                  }
                                                  [self.tableView beginUpdates];
                                                  [self.tableView insertRowsAtIndexPaths:nextPart withRowAnimation:UITableViewRowAnimationTop];
                                                  [self.tableView endUpdates];
                                              }
                                              failure:^(NSError *error, NSInteger statusCode) {
                                                  NSLog(@"error = %@, code = %ld", [error localizedDescription], (long)statusCode);
                                              }];
}

- (void)pullTo:(UIRefreshControl *)_refreshControl {
    [self loadDataFromServer];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return groupsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VKFriendDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DETAILS_CELL_ID forIndexPath:indexPath];
    if (!cell) {
        cell = [[VKFriendDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DETAILS_CELL_ID];
    }
    [cell configureCellFor:groupsArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


@end
