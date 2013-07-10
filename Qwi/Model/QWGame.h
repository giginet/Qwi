//
// Created by giginet on 2013/5/15.
// Copyright (c) 2013 giginet. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

typedef enum {
    kQWGameLevelEasy,
    kQWGameLevelNormal,
    kQWGameLevelHard
} QWGameLevel;

/**
* 1ゲームを管理するクラスです
*/
@interface QWGame : NSObject {
}

@property (readonly, nonatomic) NSInteger score;
@property (readonly, nonatomic) NSInteger maxScore;
@property (readonly, nonatomic) QWGameLevel level;
@property (readonly, nonatomic) NSArray *questions;

- (id)initWithLevel:(QWGameLevel)level;

@end