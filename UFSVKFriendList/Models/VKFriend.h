//
//  VKFriend.h
//  UFSVKFriendList
//
//  Created by noname on 02.06.16.
//  Copyright © 2016 KOT LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VKFriend : NSObject

@property (strong, nonatomic) NSString *firstname;
@property (strong, nonatomic) NSString *surname;
@property (strong, nonatomic) NSURL *imgUrl;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSMutableArray *universities;
@property (strong, nonatomic) NSNumber *userId;

- (id)initWithData:(NSDictionary*)dict;

@end
