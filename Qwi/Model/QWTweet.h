//
//  QWTweet.h
//  Qwi
//
//  Created by giginet on 2013/5/12.
//  Copyright (c) 2013 giginet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface QWTweet : NSManagedObject

@property (nonatomic, retain) NSNumber * pk;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSManagedObject *author;

@end
