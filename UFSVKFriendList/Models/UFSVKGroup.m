//
//  UFSVKGroup.m
//  UFSVKFriendList
//
//  Created by noname on 02.06.16.
//  Copyright © 2016 KOT LLC. All rights reserved.
//

#import "UFSVKGroup.h"

@implementation UFSVKGroup

- (id)initWithData:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.grtitle = [dict objectForKey:@"name"];
        self.grdesc = [dict objectForKey:@"description"];
        NSString *urlString = [dict objectForKey:@"photo"];
        if (urlString) {
            self.grImgUrl = [NSURL URLWithString:urlString];
        }
    }
    return self;
}

@end
