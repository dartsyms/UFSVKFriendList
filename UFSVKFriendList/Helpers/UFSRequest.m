//
//  UFSRequest.m
//  UFSVKFriendList
//
//  Created by noname on 03.06.16.
//  Copyright © 2016 KOT LLC. All rights reserved.
//

#import "UFSRequest.h"

@implementation UFSRequest

- (void)initRequestDataWith:(NSDictionary *)dict {
    self.requestParams = [dict objectForKey:@"params"];
    self.requestMethod = [dict objectForKey:@"method"];
    self.requestBaseUrl = [dict objectForKey:@"base_url"];
    self.requestKey = [dict objectForKey:@"key"];
}

- (NSDictionary *)dataForRequest {
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          self.requestParams,   @"params",
                          self.requestMethod,   @"method",
                          self.requestKey,      @"key",
                          self.requestBaseUrl,  @"base_url", nil];
    return dict;
}

@end
