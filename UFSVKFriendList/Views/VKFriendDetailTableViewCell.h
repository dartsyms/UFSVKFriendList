//
//  VKFriendDetailTableViewCell.h
//  UFSVKFriendList
//
//  Created by noname on 02.06.16.
//  Copyright © 2016 KOT LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UFSVKGroup.h"

@interface VKFriendDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UIImageView *groupPhoto;

@property NSURLRequest *request;

- (void)configureCellFor:(UFSVKGroup *)group;

@end
