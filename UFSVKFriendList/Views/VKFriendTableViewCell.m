//
//  VKFriendTableViewCell.m
//  UFSVKFriendList
//
//  Created by noname on 02.06.16.
//  Copyright © 2016 KOT LLC. All rights reserved.
//

#import "VKFriendTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation VKFriendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


-(void)configureCellFor:(UFSVKFriend *)friend {
    self.friendName.text = [NSString stringWithFormat:@"%@ %@", friend.firstname, friend.surname];
    self.cityFrom.text = friend.city;
    
    if (friend.universities.count > 0) {
        self.universityIn.text = [friend.universities componentsJoinedByString:@", "];
    } else {
        self.universityIn.text = @" ";
    }
    
    self.request = [NSURLRequest requestWithURL:friend.imgUrl];
    __weak VKFriendTableViewCell *weakSelf = self;
    self.imageView.image = nil;
    [self.imageView setImageWithURLRequest:self.request placeholderImage:nil
        success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            weakSelf.imageView.image = image;
            [weakSelf layoutSubviews];
        }
        failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            //
        }];
}


@end
