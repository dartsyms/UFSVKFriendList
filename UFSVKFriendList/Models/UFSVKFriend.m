//
//  UFSVKFriend.m
//  UFSVKFriendList
//
//  Created by noname on 02.06.16.
//  Copyright © 2016 KOT LLC. All rights reserved.
//

#import "UFSVKFriend.h"
#import "DataManager.h"

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
        
        NSString *cityID = [dict objectForKey:@"city"];
        [[DataManager sharedInstance] getCityById:cityID success:^(NSString *city) {
            if (city) {
                self.city = city;
            } else {
                self.city = @"Город не указан";
            }
        } failure:^(NSError *error, NSInteger statusCode) {
            //
        }];
        
        // Get university or school if any, otherwise empty.
        NSArray *uniDict = [dict objectForKey:@"universities"];
        NSArray *schDict = [dict objectForKey:@"schools"];
        if ([uniDict count] > 0) {
            NSMutableArray *univers = [@[] mutableCopy];
            for (NSDictionary *item in uniDict) {
                [univers addObject:[item objectForKey:@"name"]];
            }
            self.universities = [univers componentsJoinedByString:@", "];
        } else  if ([schDict count] > 0) {
            NSMutableArray *schools = [@[] mutableCopy];
            for (NSDictionary *item in schDict) {
                [schools addObject:[item objectForKey:@"name"]];
            }
            self.universities = [schools componentsJoinedByString:@", "];
        } else {
            self.universities = @"Образование не указано.";
        }

    }
    return self;
}


@end
