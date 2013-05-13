//
//  QWUserManager.m
//  Qwi
//
//  Created by giginet on 3/5/13.
//  Copyright (c) 2013 giginet. All rights reserved.
//

#import "QWUserManager.h"
#import <Twitter/Twitter.h>
#import <Social/Social.h>

#import "QWAccount.h"

@implementation QWUserManager

const NSString *kUserShowAPI = @"http://api.twitter.com/1.1/users/show.json";

+ (id)sharedManager {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        _users = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)createUserWithScreenName:(NSString *)screenName
                             via:(ACAccount *)account
                         succeed:(void (^)(QWUser *, NSHTTPURLResponse *, NSError *))onSucceed {
    /*
     iOS6ではTWRequestではなく、SLRequestを利用するのが良いらしい
     5は切り捨てる方針で
     // http://stackoverflow.com/questions/13330596/twrequest-is-deprecated-in-ios-6-0-what-can-i-use-instead
     */
    SLRequest *showRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                requestMethod:SLRequestMethodGET
                                                          URL:[NSURL URLWithString:(NSString *) kUserShowAPI]
                                                   parameters:@{@"screen_name" : screenName}];
    showRequest.account = account;
    [showRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        NSString *jsonString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        if ([account.username isEqual:screenName]) {
            QWAccount *user = [[QWAccount alloc] initWithJSON:jsonString];
            [_users setObject:user forKey:screenName];
            if (onSucceed) {
                onSucceed(user, urlResponse, error);
            }
        } else {
            QWUser *user = [[QWUser alloc] initWithJSON:jsonString];
            [_users setObject:user forKey:screenName];
            if (onSucceed) {
                onSucceed(user, urlResponse, error);
            }
        }
    }];
}

- (QWUser *)userWithScreenName:(NSString *)screenName {
    return [_users objectForKey:screenName];
}

@end
