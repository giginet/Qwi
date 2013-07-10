#import "QWUser.h"


@interface QWUser ()

// Private interface goes here.

@end


@implementation QWUser

// Custom logic goes here.

- (id)updateFromJSON:(NSDictionary *)dictionary {
    self.pk = dictionary[@"id"];
    self.name = dictionary[@"name"];
    self.screenName = dictionary[@"screen_name"];
    if (![dictionary[@"description"] isEqual:[NSNull null]]) {
        self.bio = dictionary[@"description"];
    }
    self.friendsCount = dictionary[@"friends_count"];
    self.favoritesCount = dictionary[@"favorites_count"];
    self.statusesCount = dictionary[@"statuses_count"];
    self.followersCount = dictionary[@"followers_count"];
    self.listedCount = dictionary[@"listed_count"];
    if (![dictionary[@"url"] isEqual:[NSNull null]]) {
        self.url = dictionary[@"url"];
    }
    self.profileImageURL = dictionary[@"profile_image_url"];
    if (![dictionary[@"location"] isEqual:[NSNull null]]) {
        self.location = dictionary[@"location"];
    }
    if (self.profileImageURL != nil) {
        NSURL *imageURL = [[NSURL alloc] initWithString:self.profileImageURL];
        self.profileImage = [NSData dataWithContentsOfURL:imageURL];
    }
    return self;
}

@end
