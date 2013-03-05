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

@property(readonly) NSString* name;
@property(readonly) NSString* screenName;
@property(readonly) NSString* description;
@property(readonly) NSUInteger friendsCount;
@property(readonly) NSUInteger favoritesCount;
@property(readonly) NSUInteger statusesCount;
@property(readonly) NSUInteger followersCount;
@property(readonly) NSUInteger listedCount;
@property(readonly) NSString* location;
@property(readonly) NSURL* URL;
@property(readonly) NSURL* profileImageURL;
@property(readonly) UIImage* profileImage;

- (id)initWithJSON:(NSString*)jsonString;

@end
