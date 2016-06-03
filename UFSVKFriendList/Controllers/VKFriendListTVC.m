//
//  VKFriendListTVC.m
//  UFSVKFriendList
//
//  Created by noname on 02.06.16.
//  Copyright © 2016 KOT LLC. All rights reserved.
//

#import "VKFriendListTVC.h"
#import "Constants.h"
#import "DataManager.h"
#import "VKFriend.h"
#import "VKFriendTableViewCell.h"
#import "VKFriendDTVC.h"
#import "VKSdk.h"
#import "UIImageView+AFNetworking.h"

@interface VKFriendListTVC () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomConstraint;


@end

@implementation VKFriendListTVC {
    UIRefreshControl *refresh;
    NSMutableArray *friendsArray;
    NSArray *searchResults;
}

@dynamic tableView;

static NSInteger friendsPerRequest = 30;

#pragma mark - Lifecycle and UI Helper Functions
- (void)viewDidLoad {
    [super viewDidLoad];
    self->friendsArray = [NSMutableArray array];
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Data Load
- (void)loadDataFromServer {
    [[DataManager sharedInstance] getFriendsForUserId:[[[VKSdk accessToken] userId] integerValue]
               offset:self->friendsArray.count
                count:friendsPerRequest
                success:^(NSArray *friends) {
                    [self->friendsArray addObjectsFromArray:friends];
                    NSMutableArray *nextPart = [NSMutableArray array];
                    for (int i = (int)[self->friendsArray count] - (int)[friends count]; i < [self->friendsArray count]; i++) {
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
    self.searchBar.text = @"";
    [self loadDataFromServer];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return friendsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VKFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FRIEND_CELL_ID forIndexPath:indexPath];
    if (!cell) {
        cell = [[VKFriendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FRIEND_CELL_ID];
    }
    [cell configureCellFor:friendsArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // not used
}

//TODO: Implement search by name, city, etc

#pragma mark - Keyboard Notification Observers
-(void)keyboardWillShow:(NSNotification *)notification {
    CGSize keyboardSize = [[notification userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.tableViewBottomConstraint.constant = keyboardSize.height;
}

-(void)keyboardWillHide {
    self.tableViewBottomConstraint.constant = 0;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:UFSVK_SHOW_DETAILS_SEGUE_ID]) {
        VKFriendDTVC *dtvc = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        dtvc.friend = [friendsArray objectAtIndex:indexPath.row];
    }
}

@end
