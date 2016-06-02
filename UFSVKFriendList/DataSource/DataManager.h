//
//  DataManager.h
//  UFSVKFriendList
//
//  Created by noname on 02.06.16.
//  Copyright © 2016 KOT LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

+ (DataManager *)sharedInstance;

- (void)getFriendsForId:(long)userID offset:(NSInteger)offset count:(NSInteger)count
               success:(void(^)(NSArray *friends))success
               failure:(void(^)(NSError *error, NSInteger statusCode)) failure;

@end
