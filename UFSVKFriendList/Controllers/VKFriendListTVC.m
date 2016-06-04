//
//  VKFriendListTVC.m
//  UFSVKFriendList
//
//  Created by noname on 02.06.16.
//  Copyright © 2016 KOT LLC. All rights reserved.
//

#import "VKFriendListTVC.h"
#import "DataManager.h"
#import "VKFriendTableViewCell.h"
#import "VKFriendDTVC.h"
#import "VKSdk.h"
#import "UIImageView+AFNetworking.h"

@interface VKFriendListTVC () <UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UISearchBarDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomConstraint;

@property (nonatomic) BOOL shouldCollapseDetailViewController;

@end

@implementation VKFriendListTVC {
    UIRefreshControl *refresh;
    NSMutableArray *friendsArray;
    NSMutableArray *searchResults;
}

@dynamic tableView;

static NSInteger friendsPerRequest = 30;
NSString* UFSVK_SHOW_DETAILS_SEGUE_ID = @"showDetails";
NSString* FRIEND_CELL_ID = @"friendItem";
BOOL isFiltered = NO;


#pragma mark - Lifecycle and UI Helper Functions
- (void)viewDidLoad {
    [super viewDidLoad];
    self->friendsArray = [NSMutableArray array];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    self.searchBar.delegate = (id)self;
    
    searchResults = [NSMutableArray arrayWithCapacity:[friendsArray count]];
    self.shouldCollapseDetailViewController = true;
    self.splitViewController.delegate = self;
    [self setupUI];
    [self.tableView reloadData];
}

- (void)setupUI {
    refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(pullTo:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refresh];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
          // insert rows at the top one by one
          for (int i = 0; i < [friends count]; i++) {
              [self.tableView beginUpdates];
              NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
              NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
              [self->friendsArray insertObjects:[NSArray arrayWithObjects:friends[i], nil] atIndexes:indexSet];
               [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
              [self.tableView endUpdates];
          }
          
      }
      failure:^(NSError *error, NSInteger statusCode) {
          NSLog(@"error = %@, code = %ld", [error localizedDescription], (long)statusCode);
      }];
}

- (void)pullTo:(UIRefreshControl *)_refreshControl {
    self.searchBar.text = @"";
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
    if (self.tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
    } else {
        return friendsArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VKFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FRIEND_CELL_ID];
    if (!cell) {
        cell = [[VKFriendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FRIEND_CELL_ID];
    }
    if (self.tableView == self.searchDisplayController.searchResultsTableView) {
        [cell configureCellFor:searchResults[indexPath.row]];
    } else {
        [cell configureCellFor:friendsArray[indexPath.row]];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:UFSVK_SHOW_DETAILS_SEGUE_ID sender:self];
}

#pragma mark - SearchDisplayDelegate methods
-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text {
    if(text.length == 0) {
        isFiltered = NO;
    } else {
        isFiltered = true;
        searchResults = [[NSMutableArray alloc] init];
        for (UFSVKFriend* friend in friendsArray) {
            NSString *universitiesString = @"";
            NSRange universityNameRange = [friend.universities rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange firstNameRange = [friend.surname rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange lastNameRange = [friend.firstname rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange cityNameRange = [friend.city rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(firstNameRange.location != NSNotFound||lastNameRange.location != NSNotFound||cityNameRange.location != NSNotFound||universityNameRange.location != NSNotFound) {
                [searchResults addObject:friend];
            }
        }
    }
    
    [self.tableView reloadData];
}

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope {
    [searchResults removeAllObjects];
    if (!searchText) {
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchText];
        searchResults = [NSMutableArray arrayWithArray:[friendsArray filteredArrayUsingPredicate:resultPredicate]];
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(nullable NSString *)searchString {
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                                         objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

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
        NSIndexPath *indexPath = nil;
        VKFriendDTVC *dtvc;
        if ([[segue destinationViewController] isKindOfClass:[UINavigationController class]]) {
            // ios 7
            dtvc = (VKFriendDTVC *) [[segue destinationViewController] topViewController];
        } else {
            // ios 8
            dtvc = (VKFriendDTVC *) [segue destinationViewController];
        }
        
        if ([self.searchDisplayController isActive]) {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            dtvc.friend = [searchResults objectAtIndex:indexPath.row];
        } else {
            indexPath = [self.tableView indexPathForSelectedRow];
            dtvc.friend = [friendsArray objectAtIndex:indexPath.row];
        }
        
    }
}

#pragma mark - UIScrollViewControllerDelegate methods
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
}


@end
