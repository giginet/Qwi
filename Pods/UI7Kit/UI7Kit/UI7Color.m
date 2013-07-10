//
//  UI7Color.m
//  UI7Kit
//
//  Created by Jeong YunWon on 13. 6. 29..
//  Copyright (c) 2013 youknowone.org. All rights reserved.
//

#import "UI7Color.h"


@implementation UIColor (UI7Kit)

- (UIColor *)highligtedColor {
    return [UIColor colorWithRed:0.75f + self.components.red / 4.0f
                           green:0.75f + self.components.green / 4.0f
                            blue:0.75f + self.components.blue / 4.0f
                           alpha:self.components.alpha];
}

@end


@implementation UI7Color

+ (UIColor *)defaultBarColor {
    return [UIColor colorWith8bitWhite:255 alpha:231];
}

+ (UIColor *)blackBarColor {
    return [UIColor colorWith8bitWhite:15 alpha:231];
}

+ (UIColor *)defaultBackgroundColor {
    return [UIColor colorWith8bitWhite:248 alpha:255];
}

+ (UIColor *)defaultTintColor {
    return [UIColor colorWith8bitRed:0 green:126 blue:245 alpha:255];
}

+ (UIColor *)defaultEmphasizedColor {
    return [UIColor colorWith8bitRed:255 green:69 blue:55 alpha:255];
}

+ (UIColor *)defaultTrackTintColor {
    return [UIColor colorWith8bitWhite:183 alpha:255];
}

+ (UIColor *)groupedTableViewSectionBackgroundColor {
    return [UIColor colorWith8bitWhite:229 alpha:255];
}

@end
