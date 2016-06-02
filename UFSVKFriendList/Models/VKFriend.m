//
//  VKFriend.m
//  UFSVKFriendList
//
//  Created by sanchez on 02.06.16.
//  Copyright © 2016 KOT LLC. All rights reserved.
//

#import "VKFriend.h"

@implementation VKFriend

- (id)initWithData:(NSDictionary *)dict {
    
    self = [super init];
    if (self) {
        self.firstname = [dict objectForKey:@"first_name"];
        self.surname = [dict objectForKey:@"last_name"];
        NSString *urlString = [dict objectForKey:@"photo"]; // placeholder, TODO: choose real key
        if (urlString) {
            self.imgUrl = [NSURL URLWithString:urlString];
        }
        self.city = [dict objectForKey:@"city"];
        self.university = [dict objectForKey:@"university"];
    }
    return self;
}

@end
