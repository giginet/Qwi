//
//  UI7SegmentedControl.m
//  UI7Kit
//
//  Created by Jeong YunWon on 13. 6. 17..
//
//
//  Original source comes from FlatUI by Piotr Bernad.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2013 Piotr Bernad
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import <QuartzCore/QuartzCore.h>

#import "UI7Font.h"
#import "UI7View.h"

#import "UI7SegmentedControl.h"

#import "UI7KitPrivate.h"

CGFloat UI7SegmentedControlHeight = 29.0f;

NSMutableDictionary *UI7SegmentedControlTintColors = nil;

@implementation UISegmentedControl (Patch)

- (void)awakeFromNib { [super awakeFromNib]; }

- (id)__initWithItems:(NSArray *)items { assert(NO); return nil; }
- (id)__initWithFrame:(CGRect)frame { assert(NO); return nil; }
- (void)__awakeFromNib { assert(NO); }
- (UIColor *)__tintColor { assert(NO); return nil; }
- (void)__setTintColor:(UIColor *)tintColor { assert(NO); }

- (void)_segmentedControlInit {
    self.layer.cornerRadius = UI7ControlRadius;
    self.layer.borderWidth = 1.0f;

    CGRect frame = self.frame;
    frame.size.height = UI7SegmentedControlHeight;
    self.frame = frame;

    [self _tintColorUpdated];
}

- (void)_tintColorUpdated {
    [super _tintColorUpdated];

    UIColor *tintColor = self.tintColor;
    // Set background images

    UIImage *backgroundImage = [UIColor clearColor].image;
    UIImage *selectedBackgroundImage = [UIImage roundedImageWithSize:CGSizeMake(10.0f, self.frame.size.height) color:tintColor radius:UI7ControlRadius];
    UIImage *highlightedBackgroundImage = [UIImage roundedImageWithSize:CGSizeMake(10.0f, self.frame.size.height) color:tintColor.highligtedColor radius:UI7ControlRadius];

    NSDictionary *attributes = @{
                                 UITextAttributeFont: [UI7Font systemFontOfSize:13.0 attribute:UI7FontAttributeMedium],
                                 UITextAttributeTextColor: tintColor,
                                 UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero],
                                 };
    [self setTitleTextAttributes:attributes forState:UIControlStateNormal];

    NSDictionary *highlightedAttributes = @{UITextAttributeTextColor: tintColor};
    [self setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];

    NSDictionary *selectedAttributes = @{UITextAttributeTextColor: [UIColor whiteColor]};
    [self setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];

    [self setBackgroundImage:backgroundImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self setBackgroundImage:highlightedBackgroundImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [self setBackgroundImage:selectedBackgroundImage forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];

    [self setDividerImage:tintColor.image forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

    self.layer.borderColor = tintColor.CGColor;
}

@end


@implementation UI7SegmentedControl

+ (void)initialize {
    if (self == [UI7SegmentedControl class]) {
        UI7SegmentedControlTintColors = [[NSMutableDictionary alloc] init];

        Class target = [UISegmentedControl class];

        [target copyToSelector:@selector(__initWithItems:) fromSelector:@selector(initWithItems:)];
        [target copyToSelector:@selector(__initWithFrame:) fromSelector:@selector(initWithFrame:)];
        [target copyToSelector:@selector(__awakeFromNib) fromSelector:@selector(awakeFromNib)];
        [target copyToSelector:@selector(__tintColor) fromSelector:@selector(tintColor)];
        [target copyToSelector:@selector(__setTintColor:) fromSelector:@selector(setTintColor:)];
    }
}

+ (void)patch {
    Class target = [UISegmentedControl class];

    [self exportSelector:@selector(initWithItems:) toClass:target];
    [self exportSelector:@selector(initWithFrame:) toClass:target];
    [self exportSelector:@selector(awakeFromNib) toClass:target];
    [self exportSelector:@selector(tintColor) toClass:target];
    [self exportSelector:@selector(setTintColor:) toClass:target];
}

- (void)awakeFromNib {
    [self __awakeFromNib];
    [self _segmentedControlInit];
}

- (id)initWithItems:(NSArray *)items {
    self = [self __initWithItems:items];
    if (self != nil) {
        [self _segmentedControlInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [self __initWithFrame:frame];
    if (self != nil) {
        [self _segmentedControlInit];
    }
    return self;
}

- (UIColor *)tintColor {
    UIColor *color = [self __tintColor];
    if (color == nil) {
        color = [self _tintColor];
    }
    return color;
}

- (void)setTintColor:(UIColor *)tintColor {
    [self __setTintColor:tintColor];
    [self _tintColorUpdated];
}

@end
