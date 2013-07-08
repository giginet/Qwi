// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to QWUser.m instead.

#import "_QWUser.h"

const struct QWUserAttributes QWUserAttributes = {
	.bio = @"bio",
	.favoritesCount = @"favoritesCount",
	.followersCount = @"followersCount",
	.friendsCount = @"friendsCount",
	.listedCount = @"listedCount",
	.location = @"location",
	.name = @"name",
	.pk = @"pk",
	.profileImage = @"profileImage",
	.profileImageURL = @"profileImageURL",
	.screenName = @"screenName",
	.statusesCount = @"statusesCount",
	.url = @"url",
};

const struct QWUserRelationships QWUserRelationships = {
	.favorites = @"favorites",
	.friends = @"friends",
	.statuses = @"statuses",
};

const struct QWUserFetchedProperties QWUserFetchedProperties = {
};

@implementation QWUserID
@end

@implementation _QWUser

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"User";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"User" inManagedObjectContext:moc_];
}

- (QWUserID*)objectID {
	return (QWUserID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"favoritesCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"favoritesCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"followersCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"followersCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"friendsCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"friendsCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"listedCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"listedCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"pkValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"pk"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"statusesCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"statusesCount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic bio;






@dynamic favoritesCount;



- (int32_t)favoritesCountValue {
	NSNumber *result = [self favoritesCount];
	return [result intValue];
}

- (void)setFavoritesCountValue:(int32_t)value_ {
	[self setFavoritesCount:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveFavoritesCountValue {
	NSNumber *result = [self primitiveFavoritesCount];
	return [result intValue];
}

- (void)setPrimitiveFavoritesCountValue:(int32_t)value_ {
	[self setPrimitiveFavoritesCount:[NSNumber numberWithInt:value_]];
}





@dynamic followersCount;



- (int32_t)followersCountValue {
	NSNumber *result = [self followersCount];
	return [result intValue];
}

- (void)setFollowersCountValue:(int32_t)value_ {
	[self setFollowersCount:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveFollowersCountValue {
	NSNumber *result = [self primitiveFollowersCount];
	return [result intValue];
}

- (void)setPrimitiveFollowersCountValue:(int32_t)value_ {
	[self setPrimitiveFollowersCount:[NSNumber numberWithInt:value_]];
}





@dynamic friendsCount;



- (int32_t)friendsCountValue {
	NSNumber *result = [self friendsCount];
	return [result intValue];
}

- (void)setFriendsCountValue:(int32_t)value_ {
	[self setFriendsCount:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveFriendsCountValue {
	NSNumber *result = [self primitiveFriendsCount];
	return [result intValue];
}

- (void)setPrimitiveFriendsCountValue:(int32_t)value_ {
	[self setPrimitiveFriendsCount:[NSNumber numberWithInt:value_]];
}





@dynamic listedCount;



- (int32_t)listedCountValue {
	NSNumber *result = [self listedCount];
	return [result intValue];
}

- (void)setListedCountValue:(int32_t)value_ {
	[self setListedCount:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveListedCountValue {
	NSNumber *result = [self primitiveListedCount];
	return [result intValue];
}

- (void)setPrimitiveListedCountValue:(int32_t)value_ {
	[self setPrimitiveListedCount:[NSNumber numberWithInt:value_]];
}





@dynamic location;






@dynamic name;






@dynamic pk;



- (int64_t)pkValue {
	NSNumber *result = [self pk];
	return [result longLongValue];
}

- (void)setPkValue:(int64_t)value_ {
	[self setPk:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitivePkValue {
	NSNumber *result = [self primitivePk];
	return [result longLongValue];
}

- (void)setPrimitivePkValue:(int64_t)value_ {
	[self setPrimitivePk:[NSNumber numberWithLongLong:value_]];
}





@dynamic profileImage;






@dynamic profileImageURL;






@dynamic screenName;






@dynamic statusesCount;



- (int32_t)statusesCountValue {
	NSNumber *result = [self statusesCount];
	return [result intValue];
}

- (void)setStatusesCountValue:(int32_t)value_ {
	[self setStatusesCount:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveStatusesCountValue {
	NSNumber *result = [self primitiveStatusesCount];
	return [result intValue];
}

- (void)setPrimitiveStatusesCountValue:(int32_t)value_ {
	[self setPrimitiveStatusesCount:[NSNumber numberWithInt:value_]];
}





@dynamic url;






@dynamic favorites;

	

@dynamic friends;

	
- (NSMutableSet*)friendsSet {
	[self willAccessValueForKey:@"friends"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"friends"];
  
	[self didAccessValueForKey:@"friends"];
	return result;
}
	

@dynamic statuses;

	






@end
