//
//  DataManager.m
//  UFSVKFriendList
//
//  Created by noname on 02.06.16.
//  Copyright © 2016 KOT LLC. All rights reserved.
//

#import "DataManager.h"
#import "AFNetworking.h"
#import "Constants.h"
#import "VKFriend.h"

@interface DataManager ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;

@end


@implementation DataManager

+ (DataManager *)sharedInstance {
    static DataManager *dataManager = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{ dataManager = [[DataManager alloc] init]; });
    return dataManager;
}

- (id)init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
    }
    return self;
}

- (void)getFriendsForId:(long)userID offset:(NSInteger)offset count:(NSInteger)count
                success:(void (^)(NSArray *))success
                failure:(void (^)(NSError *, NSInteger))failure {
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @(userID),    @"user_id",
                            @"name",      @"order",
                            @(count),     @"count",
                            @(offset),    @"offset",
                            @"photo_50",  @"fields",
                            @"name_case", @"nom",
                            nil];
    
    NSString *urlString = [UFSVK_METHOD_URL stringByAppendingString:FRIENDS_GET_KEY];
    
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:urlString parameters:params error:nil];
    NSURLSessionDataTask *downloadTask = [self.sessionManager dataTaskWithRequest:request
        completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"Reply JSON: %@", responseObject);
                if ([responseObject isKindOfClass:[NSArray class]]) {
                    NSArray *dictArr = [responseObject objectForKey:@"response"];
                    NSMutableArray *dataArr = [NSMutableArray array];
                    for (NSDictionary *dict in dictArr) {
                        VKFriend *friend = [[VKFriend alloc] initWithData:dict];
                        [dataArr addObject:friend];
                    }
                    success(dataArr);
                }
            } else {
                NSLog(@"Error: %@, %@, %@", error, response, responseObject);
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                failure(error, httpResponse.statusCode);
            }
        }];
    [downloadTask resume];
    
}

@end
