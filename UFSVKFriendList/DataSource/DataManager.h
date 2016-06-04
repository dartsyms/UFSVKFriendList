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

- (void)getFriendsForUserId:(NSInteger)userID offset:(NSInteger)offset count:(NSInteger)count
                    success:(void(^)(NSArray *friends))success
                    failure:(void(^)(NSError *error, NSInteger statusCode)) failure;

- (void)getGroupsForUserId:(NSInteger)userID offset:(NSInteger)offset count:(NSInteger)count
                   success:(void(^)(NSArray *groups))success
                   failure:(void(^)(NSError *error, NSInteger statusCode)) failure;

- (void)getFriendsForUserId:(NSInteger)userID offset:(NSInteger)offset count:(NSInteger)count searchQuery:(NSString *)searchString
                    success:(void(^)(NSArray *friends))success
                    failure:(void(^)(NSError *error, NSInteger statusCode)) failure;
- (void)getCityById:(NSString *)cityID
            success:(void(^)(NSString *city))success
            failure:(void(^)(NSError *error, NSInteger statusCode)) failure;

@end
