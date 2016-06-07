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

@interface VKFriendDTVC () <UITableViewDelegate, UITableViewDataSource, UISplitViewControllerDelegate>

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
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self setupUI];
    self.splitViewController.delegate = self;
    if ([self.splitViewController respondsToSelector:@selector(displayModeButtonItem)]) {
        self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        self.navigationItem.leftItemsSupplementBackButton = YES;
    } else {
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self action:nil];
        self.navigationItem.leftBarButtonItem = barButtonItem;
        self.navigationItem.leftItemsSupplementBackButton = YES;
    }
    [self.tableView reloadData];
}

- (void)setupUI {
    refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(pullTo:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refresh];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 140;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    if (friend.firstname != nil) {
        self.navigationItem.title = [NSString stringWithFormat:@"%@ %@", friend.firstname, friend.surname];
    } else {
        self.navigationItem.title = @"Current User";
    }
    [self pullTo:refresh];
}

#pragma mark - Data Load
- (void)loadDataFromServer {
    [[DataManager sharedInstance] getGroupsForUserId:[[friend userID] integerValue]
                                              offset:self->groupsArray.count
                                               count:groupsPerRequest
     success:^(NSArray *groups) {
         for (int i = 0; i < [groups count]; i++) {
             [self.tableView beginUpdates];
             NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
             NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
             [self->groupsArray insertObjects:[NSArray arrayWithObjects:groups[i], nil] atIndexes:indexSet];
             [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
             [self.tableView endUpdates];
         }
     }
     failure:^(NSError *error, NSInteger statusCode) {
         NSLog(@"error = %@, code = %ld", [error localizedDescription], (long)statusCode);
     }];
}

- (void)pullTo:(UIRefreshControl *)_refreshControl {
    [refresh beginRefreshing];
    [self loadDataFromServer];
    [self.tableView reloadData];
    [refresh endRefreshing];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static VKFriendDetailTableViewCell *cell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [self.tableView dequeueReusableCellWithIdentifier:DETAILS_CELL_ID];
    });
    
    [cell configureCellFor:groupsArray[indexPath.row]];
    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(cell.bounds));
    return [self calculateHeightForConfiguredSizingCell:cell];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    CGFloat height = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    height += 1.0f;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}


#pragma mark - UISplitViewControllerDelegate methods

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
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
#pragma clang diagnostic pop

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
