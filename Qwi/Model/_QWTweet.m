// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to QWTweet.m instead.

#import "_QWTweet.h"

const struct QWTweetAttributes QWTweetAttributes = {
	.createdAt = @"createdAt",
	.pk = @"pk",
	.text = @"text",
};

const struct QWTweetRelationships QWTweetRelationships = {
	.author = @"author",
};

const struct QWTweetFetchedProperties QWTweetFetchedProperties = {
};

@implementation QWTweetID
@end

@implementation _QWTweet

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Tweet" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Tweet";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Tweet" inManagedObjectContext:moc_];
}

- (QWTweetID*)objectID {
	return (QWTweetID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"pkValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"pk"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic createdAt;






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





@dynamic text;






@dynamic author;

	






@end
