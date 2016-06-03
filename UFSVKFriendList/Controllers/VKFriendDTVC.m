//
//  VKFriendDTVC.m
//  UFSVKFriendList
//
//  Created by noname on 02.06.16.
//  Copyright © 2016 KOT LLC. All rights reserved.
//

#import "DataManager.h"
#import "VKFriendDetailTableViewCell.h"
#import "VKFriendDTVC.h"
#import "UIImageView+AFNetworking.h"

@interface VKFriendDTVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation VKFriendDTVC {
    UIRefreshControl *refresh;
    NSMutableArray *groupsArray;
}
@synthesize friend;
@dynamic tableView;

static NSInteger groupsPerRequest = 10;
NSString* DETAILS_CELL_ID = @"detailsItem";

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self->groupsArray = [NSMutableArray array];
    [self setupUI];
    self.splitViewController.delegate = self;
//    if ([self.splitViewController respondsToSelector:@selector(displayModeButtonItem)]) {
//        self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
//        self.navigationItem.leftItemsSupplementBackButton = YES;
//    } else {
//        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
//                                                                          style:UIBarButtonItemStylePlain
//                                                                         target:self action:nil];
//        self.navigationItem.leftBarButtonItem = barButtonItem;
//        self.navigationItem.leftItemsSupplementBackButton = YES;
//    }
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
    [[DataManager sharedInstance] getGroupsForUserId:[[friend userID] integerValue]
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

#pragma mark - UISplitViewControllerDelegate methods

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc {
    if (![svc respondsToSelector:@selector(displayModeButtonItem)]) {
        UINavigationController *navController = (UINavigationController *) svc.viewControllers[svc.viewControllers.count - 1];
        VKFriendDTVC *dtvc = (VKFriendDTVC *) navController.topViewController;
        barButtonItem.image = [UIImage imageNamed:@"IC_BackChevron"];
        dtvc.navigationItem.leftBarButtonItem = barButtonItem;
    } else {
        self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        self.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    if (![svc respondsToSelector:@selector(displayModeButtonItem)]) {
        UINavigationController *navController = (UINavigationController *) svc.viewControllers[svc.viewControllers.count - 1];
        VKFriendDTVC *dtvc = (VKFriendDTVC *) navController.topViewController;
        dtvc.navigationItem.leftBarButtonItem = nil;
    } else {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

@end
