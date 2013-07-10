//
// Created by giginet on 2013/5/16.
// Copyright (c) 2013 giginet. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "QWSelectQuiz.h"
#import "QWUser.h"

@implementation QWSelectQuiz

- (BOOL)isValidAnswer:(id)answer {
    if ([answer isKindOfClass:[QWUser class]]) {
        QWUser *user = (QWUser *)answer;
    }
    return NO;
}

@end