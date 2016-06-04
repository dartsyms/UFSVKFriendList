//
//  UFSVKGroup.m
//  UFSVKFriendList
//
//  Created by noname on 02.06.16.
//  Copyright © 2016 KOT LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UFSVKGroup.h"

@implementation UFSVKGroup

- (id)initWithData:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.grtitle = [dict objectForKey:@"name"];
        NSString *descHtml = [dict objectForKey:@"description"];
        NSAttributedString *attr = [[NSAttributedString alloc] initWithData:[descHtml dataUsingEncoding:NSUTF8StringEncoding]
                                                                    options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                              NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
        self.grdesc = [attr string];
        NSString *urlString = [dict objectForKey:@"photo"];
        if (urlString) {
            self.grImgUrl = [NSURL URLWithString:urlString];
        }
    }
    return self;
}

@end
