//
//  UFSRequest.h
//  UFSVKFriendList
//
//  Created by noname on 03.06.16.
//  Copyright © 2016 KOT LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UFSRequest : NSObject

@property NSDictionary *requestParams;
@property NSString *requestMethod;
@property NSString *requestBaseUrl;
@property NSString *requestKey;

- (void)initRequestDataWith:(NSDictionary *)dict;
- (NSDictionary *)dataForRequest;

@end
