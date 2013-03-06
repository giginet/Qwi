//
//  QWUserManager.m
//  Qwi
//
//  Created by giginet on 3/5/13.
//  Copyright (c) 2013 giginet. All rights reserved.
//

#import "QWUserManager.h"
#import "CJSONDeserializer.h"
#import <Twitter/Twitter.h>
#import <Social/Social.h>

@implementation QWUserManager

const NSString* kUserShowAPI = @"http://api.twitter.com/1.1/users/show.json";
const NSString* kUserFriendsAPI = @"https://api.twitter.com/1.1/friends/ids.json";

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
  [self createUserWithParameters:@{@"screen_name" : screenName}
                             via:account
                         succeed:onSucceed];
}

- (void)createUserWithID:(NSString*)userID via:(ACAccount *)account succeed:(void (^)(QWUser *, NSHTTPURLResponse *, NSError *))onSucceed {
  [self createUserWithParameters:@{@"user_id" : userID}
                             via:account
                         succeed:onSucceed];
  
}

- (void)createUserWithParameters:(NSDictionary *)parameters via:(ACAccount *)account succeed:(void (^)(QWUser *, NSHTTPURLResponse *, NSError *))onSucceed {
  /*
   iOS6ではTWRequestではなく、SLRequestを利用するのが良いらしい
   5は切り捨てる方針で
   // http://stackoverflow.com/questions/13330596/twrequest-is-deprecated-in-ios-6-0-what-can-i-use-instead
   */
  SLRequest* showRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                              requestMethod:SLRequestMethodGET
                                                        URL:[NSURL URLWithString:(NSString*)kUserShowAPI]
                                                 parameters:parameters];
  showRequest.account = account;
  [showRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
    NSString* jsonString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    QWUser* user = [[QWUser alloc] initWithJSON:jsonString];
    [_users setObject:user forKey:user.screenName];
    if (onSucceed) {
      onSucceed(user, urlResponse, error);
    }
  }];
}

- (QWUser*)userWithScreenName:(NSString *)screenName {
  return [_users objectForKey:screenName];
}

- (void)createFriendsOfUser:(QWUser *)user
                        via:(ACAccount *)account
                    succeed:(void (^)(NSArray *, NSHTTPURLResponse *, NSError *))onSucceed {
  int cursor = -1;
  SLRequest* request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                          requestMethod:SLRequestMethodGET
                                                    URL:[NSURL URLWithString:(NSString*)kUserFriendsAPI]
                                             parameters:@{@"cursor" : [NSString stringWithFormat:@"%d", cursor], @"screen_name" : user.screenName, @"count" : @"10"}];
  request.account = account;
  [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
    NSDictionary* response = [[CJSONDeserializer deserializer] deserialize:responseData
                                                                     error:nil];
    NSMutableArray* friends = [NSMutableArray array];
    NSArray* ids = response[@"ids"];
    for (NSNumber* userID in ids) {
      if (userID) {
        NSString* str = [NSString stringWithFormat:@"%ld", [userID longValue]];
        
        [self createUserWithID:str
                           via:account
                       succeed:^(QWUser *user, NSHTTPURLResponse *urlResponse, NSError *error) {
                         [friends addObject:user];
                         NSLog(@"%@", user.name);
                       }];
      }
    }
  }];
  
}


@end
