//
// Created by giginet on 2013/5/15.
// Copyright (c) 2013 giginet. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

/**
* 問題一つ一つを管理するクラスです
*/
@interface QWQuiz : NSObject

@property (readonly, nonatomic) NSInteger limitTime;
@property (readonly, nonatomic) NSInteger score;
@property (readwrite, nonatomic) NSString *question;

- (id)initWithQuestion:(NSString *)question;
- (BOOL)isValidAnswer:(id)answer;
- (void)buildUI:(UIView *)view;

@end