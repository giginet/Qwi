//
//  QWUser.h
//  Qwi
//
//  Created by giginet on 3/5/13.
//  Copyright (c) 2013 giginet. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 ユーザー一人一人をモデル化します
 */

@interface QWUser : NSObject {
}

@property(readonly) NSString* username;
@property(readonly) NSString* displayName;
@property(readonly) NSArray* following;
@property(readonly) NSArray* follower;
@property(readonly) NSArray* tweets;
@property(readonly) NSArray* favorites;
@property(readonly) UIImage* icon;
@property(readonly) NSString* location;
@property(readonly) NSURL* url;
@property(readonly) NSString* bio;

- (id)initWithJSON:(NSString*)jsonString;

@end
