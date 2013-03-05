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
  
  _name = dictionary[@"name"];
  _screenName = dictionary[@"screen_name"];
  _description = dictionary[@"description"];
  _friendsCount = [dictionary[@"friend_count"] integerValue];
  _favoritesCount = [dictionary[@"favorites_count"] integerValue];
  _statusesCount = [dictionary[@"statuses_count"] integerValue];
  _followersCount = [dictionary[@"followers_count"] integerValue];
  _listedCount = [dictionary[@"listed_count"] integerValue];
  if (dictionary[@"url"]) {
    NSString* urlString = dictionary[@"url"];
    _URL = [NSURL URLWithString:urlString];
  }
  
  _profileImageURL = dictionary[@"profile_image_url"];
  _location = dictionary[@"location"];
}

@end
