//
//  VKFriendTableViewCell.m
//  UFSVKFriendList
//
//  Created by noname on 02.06.16.
//  Copyright © 2016 KOT LLC. All rights reserved.
//

#import "VKFriendTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "VKSdk.h"

@implementation VKFriendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.userPhoto.layer.cornerRadius = (CGFloat) self.userPhoto.frame.size.width /2;
    self.userPhoto.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)configureCellFor:(UFSVKFriend *)friend {
    self.friendName.text = [NSString stringWithFormat:@"%@ %@", friend.firstname, friend.surname];
    self.cityFrom.text = friend.city;
    self.universityIn.text = friend.universities;
    
    self.request = [NSURLRequest requestWithURL:friend.imgUrl];
    __weak VKFriendTableViewCell *weakSelf = self;
    self.imageView.image = nil;
    [self.imageView setImageWithURLRequest:self.request placeholderImage:nil
        success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            weakSelf.userPhoto.image = image;
            [weakSelf layoutSubviews];
        }
        failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            //
        }];
}


@end
