//
// Created by giginet on 2013/5/15.
// Copyright (c) 2013 giginet. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "QWGame.h"


@implementation QWGame

- (id)initWithLevel:(QWGameLevel)level {
    self = [super init];
    if (self) {
        // ToDo 難易度による問題分岐
        _level = level;
    }
    return self;
}

@end