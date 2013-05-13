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

#include "CJSONDeserializer.h"

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
            QWAccount *user = [NSEntityDescription insertNewObjectForEntityForName:@"QWUser"
                                                         inManagedObjectContext:self.managedObjectContext];
            [self updateFromJSON:jsonString for:user];
            [_users setObject:user forKey:screenName];
            if (onSucceed) {
                onSucceed(user, urlResponse, error);
            }
        } else {
            QWUser *user = [NSEntityDescription insertNewObjectForEntityForName:@"QWUser"
                                                         inManagedObjectContext:self.managedObjectContext];
            [self updateFromJSON:jsonString for:user];
            [_users setObject:user forKey:screenName];
            if (onSucceed) {
                onSucceed(user, urlResponse, error);
            }
        }
    }];
}

- (QWUser *)selectUserByName:(NSString *)name {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([QWUser class])];
    request.predicate = [NSPredicate predicateWithFormat:@"screenName = %@", name];

    NSArray *cache = [self.managedObjectContext executeFetchRequest:request error:nil];
    if ([cache count] > 0) {
        return [cache lastObject];
    }
    return NULL;
}

- (BOOL)isCachedByName:(NSString *)name {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([QWUser class])];
    return [self.managedObjectContext countForFetchRequest:request error:nil] > 0;
}

- (QWUser *)updateFromJSON:(NSString *)jsonString for:(QWUser *)user {
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];

    user.name = dictionary[@"name"];
    user.screenName = dictionary[@"screen_name"];
    user.bio = dictionary[@"description"];
    user.friendsCount = dictionary[@"friends_count"];
    user.favoritesCount = dictionary[@"favorites_count"];
    user.statusesCount = dictionary[@"statuses_count"];
    user.followersCount = dictionary[@"followers_count"];
    user.listedCount = dictionary[@"listed_count"];
    if (dictionary[@"url"]) {
        user.url = dictionary[@"url"];
    }

    user.profileImageURL = dictionary[@"profile_image_url"];
    user.location = dictionary[@"location"];
    NSURL *imageURL = [[NSURL alloc] initWithString:user.profileImageURL];
    user.profileImage = [NSData dataWithContentsOfURL:imageURL];
}

@end
