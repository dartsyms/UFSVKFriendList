//
//  VKFriend.h
//  UFSVKFriendList
//
//  Created by sanchez on 02.06.16.
//  Copyright © 2016 KOT LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VKFriend : NSObject
//NS_ASSUME_NONNULL_BEGIN

@property (strong, nonatomic) NSString *firstname;
@property (strong, nonatomic) NSString *surname;
@property (strong, nonatomic) NSURL *imgUrl;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *university;

- (id)initWithData:(NSDictionary*)dict;

//NS_ASSUME_NONNULL_END
@end
