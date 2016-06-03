//
//  UFSVKFriend.m
//  UFSVKFriendList
//
//  Created by noname on 02.06.16.
//  Copyright © 2016 KOT LLC. All rights reserved.
//

#import "UFSVKFriend.h"

@implementation UFSVKFriend

- (id)initWithData:(NSDictionary *)dict {
    
    self = [super init];
    if (self) {
        self.firstname = [dict objectForKey:@"first_name"];
        self.userID = [dict objectForKey:@"user_id"];
        self.surname = [dict objectForKey:@"last_name"];
        NSString *urlString = [dict objectForKey:@"photo_50"];
        if (urlString) {
            self.imgUrl = [NSURL URLWithString:urlString];
        }
        self.city = [[dict objectForKey:@"city"] objectForKey:@"title"];

        NSArray *arr = [dict objectForKey:@"universities"];
        for (NSDictionary *item in arr) {
            [self.universities addObject:[item objectForKey:@"name"]];
        }
    }
    return self;
}

@end
