//
//  QWUser.m
//  Qwi
//
//  Created by giginet on 3/5/13.
//  Copyright (c) 2013 giginet. All rights reserved.
//
#include "CJSONDeserializer.h"

#import "QWUser.h"

@interface QWUser(Private)
- (void)parseWithJSON:(NSString*)jsonString;
@end

@implementation QWUser

- (id)initWithJSON:(NSString *)jsonString {
  self = [super init];
  if (self) {
    [self parseWithJSON:jsonString];
  }
  return self;
}

- (void)parseWithJSON:(NSString *)jsonString {
  NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
  NSError *error = nil;
  NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
  self.name = [[dictionary objectForKey:@"name"] stringValue];
  self.screenName = [[dictionary objectForKey:@"screen_name"] stringValue];
  self.description = [[dictionary objectForKey:@"description"] stringValue];
  self.friendsCount = [[dictionary objectForKey:@"friend_count"] integerValue];
  self.favoritesCount = [[dictionary objectForKey:@"favorites_count"] integerValue];
  self.statusesCount = [[dictionary objectForKey:@"statuses_count"] integerValue];
  self.followersCount = [[dictionary objectForKey:@"followers_count"] integerValue];
  self.listedCount = [[dictionary objectForKey:@"listed_count"] integerValue];
  if ([dictionary objectForKey:@"url"]) {
    NSString* urlString = [[dictionary objectForKey:@"url"] stringValue];
    self.URL = [NSURL URLWithString:urlString];
  }
  
  self.profileImageURL = [NSURL URLWithString:[[dictionary objectForKey:@"profile_image_url"] stringValue]];
  self.location = [[dictionary objectForKey:@"location"] stringValue];
}

@end
