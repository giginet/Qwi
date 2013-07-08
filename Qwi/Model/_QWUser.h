// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to QWUser.h instead.

#import <CoreData/CoreData.h>


extern const struct QWUserAttributes {
	__unsafe_unretained NSString *bio;
	__unsafe_unretained NSString *favoritesCount;
	__unsafe_unretained NSString *followersCount;
	__unsafe_unretained NSString *friendsCount;
	__unsafe_unretained NSString *listedCount;
	__unsafe_unretained NSString *location;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *pk;
	__unsafe_unretained NSString *profileImage;
	__unsafe_unretained NSString *profileImageURL;
	__unsafe_unretained NSString *screenName;
	__unsafe_unretained NSString *statusesCount;
	__unsafe_unretained NSString *url;
} QWUserAttributes;

extern const struct QWUserRelationships {
	__unsafe_unretained NSString *favorites;
	__unsafe_unretained NSString *friends;
	__unsafe_unretained NSString *statuses;
} QWUserRelationships;

extern const struct QWUserFetchedProperties {
} QWUserFetchedProperties;

@class QWTweet;
@class QWUser;
@class QWTweet;















@interface QWUserID : NSManagedObjectID {}
@end

@interface _QWUser : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (QWUserID*)objectID;





@property (nonatomic, strong) NSString* bio;



//- (BOOL)validateBio:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* favoritesCount;



@property int32_t favoritesCountValue;
- (int32_t)favoritesCountValue;
- (void)setFavoritesCountValue:(int32_t)value_;

//- (BOOL)validateFavoritesCount:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* followersCount;



@property int32_t followersCountValue;
- (int32_t)followersCountValue;
- (void)setFollowersCountValue:(int32_t)value_;

//- (BOOL)validateFollowersCount:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* friendsCount;



@property int32_t friendsCountValue;
- (int32_t)friendsCountValue;
- (void)setFriendsCountValue:(int32_t)value_;

//- (BOOL)validateFriendsCount:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* listedCount;



@property int32_t listedCountValue;
- (int32_t)listedCountValue;
- (void)setListedCountValue:(int32_t)value_;

//- (BOOL)validateListedCount:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* location;



//- (BOOL)validateLocation:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* pk;



@property int64_t pkValue;
- (int64_t)pkValue;
- (void)setPkValue:(int64_t)value_;

//- (BOOL)validatePk:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSData* profileImage;



//- (BOOL)validateProfileImage:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* profileImageURL;



//- (BOOL)validateProfileImageURL:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* screenName;



//- (BOOL)validateScreenName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* statusesCount;



@property int32_t statusesCountValue;
- (int32_t)statusesCountValue;
- (void)setStatusesCountValue:(int32_t)value_;

//- (BOOL)validateStatusesCount:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* url;



//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) QWTweet *favorites;

//- (BOOL)validateFavorites:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *friends;

- (NSMutableSet*)friendsSet;




@property (nonatomic, strong) QWTweet *statuses;

//- (BOOL)validateStatuses:(id*)value_ error:(NSError**)error_;





@end

@interface _QWUser (CoreDataGeneratedAccessors)

- (void)addFriends:(NSSet*)value_;
- (void)removeFriends:(NSSet*)value_;
- (void)addFriendsObject:(QWUser*)value_;
- (void)removeFriendsObject:(QWUser*)value_;

@end

@interface _QWUser (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveBio;
- (void)setPrimitiveBio:(NSString*)value;




- (NSNumber*)primitiveFavoritesCount;
- (void)setPrimitiveFavoritesCount:(NSNumber*)value;

- (int32_t)primitiveFavoritesCountValue;
- (void)setPrimitiveFavoritesCountValue:(int32_t)value_;




- (NSNumber*)primitiveFollowersCount;
- (void)setPrimitiveFollowersCount:(NSNumber*)value;

- (int32_t)primitiveFollowersCountValue;
- (void)setPrimitiveFollowersCountValue:(int32_t)value_;




- (NSNumber*)primitiveFriendsCount;
- (void)setPrimitiveFriendsCount:(NSNumber*)value;

- (int32_t)primitiveFriendsCountValue;
- (void)setPrimitiveFriendsCountValue:(int32_t)value_;




- (NSNumber*)primitiveListedCount;
- (void)setPrimitiveListedCount:(NSNumber*)value;

- (int32_t)primitiveListedCountValue;
- (void)setPrimitiveListedCountValue:(int32_t)value_;




- (NSString*)primitiveLocation;
- (void)setPrimitiveLocation:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSNumber*)primitivePk;
- (void)setPrimitivePk:(NSNumber*)value;

- (int64_t)primitivePkValue;
- (void)setPrimitivePkValue:(int64_t)value_;




- (NSData*)primitiveProfileImage;
- (void)setPrimitiveProfileImage:(NSData*)value;




- (NSString*)primitiveProfileImageURL;
- (void)setPrimitiveProfileImageURL:(NSString*)value;




- (NSString*)primitiveScreenName;
- (void)setPrimitiveScreenName:(NSString*)value;




- (NSNumber*)primitiveStatusesCount;
- (void)setPrimitiveStatusesCount:(NSNumber*)value;

- (int32_t)primitiveStatusesCountValue;
- (void)setPrimitiveStatusesCountValue:(int32_t)value_;




- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;





- (QWTweet*)primitiveFavorites;
- (void)setPrimitiveFavorites:(QWTweet*)value;



- (NSMutableSet*)primitiveFriends;
- (void)setPrimitiveFriends:(NSMutableSet*)value;



- (QWTweet*)primitiveStatuses;
- (void)setPrimitiveStatuses:(QWTweet*)value;


@end
