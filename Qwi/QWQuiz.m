//
// Created by giginet on 2013/5/15.
// Copyright (c) 2013 giginet. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "QWQuiz.h"


@implementation QWQuiz

- (id)initWithQuestion:(NSString *)question {
    self = [super init];
    if (self) {
        _question = question;
    }
    return self;
}

- (BOOL)isValidAnswer:(id)answer {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (void)buildUI:(UIView *)view {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

@end