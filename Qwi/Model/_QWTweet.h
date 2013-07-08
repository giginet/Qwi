// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to QWTweet.h instead.

#import <CoreData/CoreData.h>


extern const struct QWTweetAttributes {
	__unsafe_unretained NSString *createdAt;
	__unsafe_unretained NSString *pk;
	__unsafe_unretained NSString *text;
} QWTweetAttributes;

extern const struct QWTweetRelationships {
	__unsafe_unretained NSString *author;
} QWTweetRelationships;

extern const struct QWTweetFetchedProperties {
} QWTweetFetchedProperties;

@class QWUser;





@interface QWTweetID : NSManagedObjectID {}
@end

@interface _QWTweet : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (QWTweetID*)objectID;





@property (nonatomic, strong) NSDate* createdAt;



//- (BOOL)validateCreatedAt:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* pk;



@property int64_t pkValue;
- (int64_t)pkValue;
- (void)setPkValue:(int64_t)value_;

//- (BOOL)validatePk:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* text;



//- (BOOL)validateText:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) QWUser *author;

//- (BOOL)validateAuthor:(id*)value_ error:(NSError**)error_;





@end

@interface _QWTweet (CoreDataGeneratedAccessors)

@end

@interface _QWTweet (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(NSDate*)value;




- (NSNumber*)primitivePk;
- (void)setPrimitivePk:(NSNumber*)value;

- (int64_t)primitivePkValue;
- (void)setPrimitivePkValue:(int64_t)value_;




- (NSString*)primitiveText;
- (void)setPrimitiveText:(NSString*)value;





- (QWUser*)primitiveAuthor;
- (void)setPrimitiveAuthor:(QWUser*)value;


@end
