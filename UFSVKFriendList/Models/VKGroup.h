//
//  VKGroup.h
//  UFSVKFriendList
//
//  Created by noname on 02.06.16.
//  Copyright © 2016 KOT LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VKGroup : NSObject

@property (strong, nonatomic) NSString *grtitle;
@property (strong, nonatomic) NSString *grdesc;
@property (strong, nonatomic) NSURL *grImgUrl;

- (id)initWithData:(NSDictionary*)dict;

@end
