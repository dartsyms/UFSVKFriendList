//
//  VKFriendTableViewCell.h
//  UFSVKFriendList
//
//  Created by noname on 02.06.16.
//  Copyright © 2016 KOT LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UFSVKFriend.h"

@interface VKFriendTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *friendName;
@property (weak, nonatomic) IBOutlet UILabel *cityFrom;
@property (weak, nonatomic) IBOutlet UILabel *universityIn;
@property (weak, nonatomic) IBOutlet UIImageView *userPhoto;

@property NSURLRequest *request;

- (void)configureCellFor:(UFSVKFriend *)friend;

@end
