//
//  VKFriendDetailTableViewCell.m
//  UFSVKFriendList
//
//  Created by noname on 02.06.16.
//  Copyright © 2016 KOT LLC. All rights reserved.
//

#import "VKFriendDetailTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation VKFriendDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.groupPhoto.layer.cornerRadius = (CGFloat) self.groupPhoto.frame.size.width /2;
    self.groupPhoto.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configureCellFor:(UFSVKGroup *)group {
    NSLog(@"Group name: %@, description: %@, imageUrl: %@", group.grtitle, group.grdesc, group.grImgUrl);
    self.title.text = group.grtitle;
    self.desc.text = group.grdesc;
    
    self.request = [NSURLRequest requestWithURL:group.grImgUrl];
    __weak VKFriendDetailTableViewCell *weakSelf = self;
    self.imageView.image = nil;
    [self.imageView setImageWithURLRequest:self.request placeholderImage:nil
                                   success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                       weakSelf.groupPhoto.image = image;
                                       [weakSelf layoutSubviews];
                                   }
                                   failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                       //
                                   }];
}

@end
