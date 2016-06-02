//
//  VKGroup.m
//  UFSVKFriendList
//
//  Created by sanchez on 02.06.16.
//  Copyright © 2016 KOT LLC. All rights reserved.
//

#import "VKGroup.h"

@implementation VKGroup

- (id)initWithData:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.grtitle = [dict objectForKey:@"name"];
        self.grdesc = [dict objectForKey:@"description"];
        NSString *urlString = [dict objectForKey:@"group_photo"]; // placeholder, TODO: choose real key
        if (urlString) {
            self.grImgUrl = [NSURL URLWithString:urlString];
        }
    }
    return self;
}

@end
