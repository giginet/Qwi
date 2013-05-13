//
//  QWUser.m
//  Qwi
//
//  Created by giginet on 3/5/13.
//  Copyright (c) 2013 giginet. All rights reserved.
//

#import "QWUser.h"
#import "QWTweet.h"

@implementation QWUser

@dynamic name;
@dynamic screenName;
@dynamic bio;
@dynamic friendsCount;
@dynamic favoritesCount;
@dynamic statusesCount;
@dynamic followersCount;
@dynamic listedCount;
@dynamic location;
@dynamic url;
@dynamic profileImageURL;
@dynamic profileImage;
@dynamic pk;
@dynamic friends;
@dynamic favorites;
@dynamic statuses;

- (id)initWithJSON:(NSString *)jsonString {
    self = [super init];
    if (self) {
    }
    return self;
}

- (UIImage *)profileImage {
    if (!self.profileImage) {
        NSData *imageData = [NSData dataWithContentsOfURL:self.profileImageURL];
        self.profileImage = [UIImage imageWithData:imageData];
    }
    return self.profileImage;
}

- (BOOL)isOwnAccount {
    return NO;
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[self class]]) {
        QWUser *user = (QWUser *)object;
        return [user.screenName isEqual:self.screenName];
    }
    return NO;
}

@end
