//
//  QWUser.h
//  Qwi
//
//  Created by giginet on 3/5/13.
//  Copyright (c) 2013 giginet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QWTweet, QWUser;

/**
 ユーザー一人一人をモデル化します
 */

@interface QWUser : NSManagedObject

- (BOOL)isOwnAccount;

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * screenName;
@property (nonatomic, retain) NSString * bio;
@property (nonatomic, retain) NSNumber * friendsCount;
@property (nonatomic, retain) NSNumber * favoritesCount;
@property (nonatomic, retain) NSNumber * statusesCount;
@property (nonatomic, retain) NSNumber * followersCount;
@property (nonatomic, retain) NSNumber * listedCount;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * profileImageURL;
@property (nonatomic, retain) NSData * profileImage;
@property (nonatomic, retain) NSNumber * pk;
@property (nonatomic, retain) NSSet *friends;
@property (nonatomic, retain) QWTweet *favorites;
@property (nonatomic, retain) QWTweet *statuses;

- (id)initWithJSON:(NSString *)jsonString;

@end

@interface QWUser (CoreDataGeneratedAccessors)

- (void)addFriendsObject:(QWUser *)value;
- (void)removeFriendsObject:(QWUser *)value;
- (void)addFriends:(NSSet *)values;
- (void)removeFriends:(NSSet *)values;

@end
